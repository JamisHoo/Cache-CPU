----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:24:59 11/24/2014 
-- Design Name: 
-- Module Name:    mmu_module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.common.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mmu_module is
port(
	clk : in std_logic;
	state : in status;
	rst : in std_logic;
	
	-- during instruction fetch time slice
	if_addr : in std_logic_vector(31 downto 0);
	instruction : out std_logic_vector(31 downto 0);
	
	-- during memory time slice
	virtual_addr : in std_logic_vector(31 downto 0);
	data_in : std_logic_vector(31 downto 0);
	read_enable : in std_logic;
	write_enable : in std_logic;
	
	data_out : out std_logic_vector(31 downto 0);
	ready : out std_logic;			-- memory access is ready ready
	
	-- about exception
	serial_int : out std_logic;		-- interrupt, send to the exception module
	-- "000": no exception	"001":TLB modified	"010":TLBL	"011":TLBS	"100":ADEL	"101":ADES
	exc_code : out std_logic_vector(2 downto 0);		-- exception code
	
	-- about tlbwi
	-- index(66 downto 63) EntryHi(62 downto 44) EntryLo0(43 downto 24) DV(23 downto 22) EntryLo1(21 downto 2) DV(1 downto 0)
	tlb_write_struct : in std_logic_vector(TLB_WRITE_STRUCT_WIDTH-1 downto 0);
	tlb_write_enable : in std_logic;
	
	-- which kind of alignment? from IDecode
	-- "00" 4byte		"01" 2byte		"10" 1byte
	align_type : in std_logic_vector(1 downto 0);
	
	-- send to physical level
	-- the address passed down to physical level of memory
	-- RAM:"00" + "0" + address(20 downto 0)    
	-- Flash:"01" + address(21 downto 0)
	-- Serial:"10" + "0000000000000000000000";
	to_physical_addr : out std_logic_vector(23 downto 0);
	to_physical_data : out std_logic_vector(31 downto 0);
	
	to_physical_read_enable : out std_logic;
	to_physical_write_enable : out std_logic;
	
	-- from physical level
	from_physical_data : in std_logic_vector(31 downto 0);
	from_physical_ready : in std_logic;
	from_physical_serial : in std_logic
);
end mmu_module;

architecture Behavioral of mmu_module is
	
	-- choose between instruction_addr and virtual_addr
	signal addr : std_logic_vector(31 downto 0);
	
	-- state register, prevent the input of state change
	signal state_reg : status := InsF;
	
	-- related to TLB
	-- EntryHi(62 downto 44) EntryLo0(43 downto 24) DV0(23 downto 22) EntryLo1(21 downto 2) DV1(1 downto 0)
	type tlb_mem_block is array(TLB_NUM_ENTRY-1 downto 0) of std_logic_vector(TLB_ENTRY_WIDTH-1 downto 0);
	signal tlb_mem : tlb_mem_block;
	-- a matrix (21*32) to store the temp value
	type tlb_low_temp_value_block is array(20 downto 0) of std_logic_vector(tlb_num_entry*2-1 downto 0);
	signal tlb_low_temp_value : tlb_low_temp_value_block;
	-- virtual_addr equal to which EntryHi
	signal tlb_which_equal : std_logic_vector(tlb_num_entry-1 downto 0);
	-- virtual_addr match which EntryLo
	signal tlb_which_low : std_logic_vector(tlb_num_entry*2-1 downto 0);
	-- result of tlb transfer : address(20 downto 1) and Dirty(0)
	signal tlb_lookup_result : std_logic_vector(20 downto 0);
	signal tlb_missing : std_logic;
	signal tlb_writable : std_logic;
	-- end of tlb signals
	
	
	signal not_use_mmu : std_logic;
	signal special_com1_status : std_logic := '0';
	
	-- physical address after TLB transform
	-- not the one that give to the physical level
	signal physical_addr : std_logic_vector(31 downto 0);
		
	-- related to serial port
		-- the value of (COM1 + 4)
	signal serial_status_reg : std_logic := '1';
	
	-- exception code
	signal no_exception_accur : std_logic := '1';
	signal exc_counter : std_logic := '0';
	
	-- to physical level registers
	signal to_physical_addr_reg : std_logic_vector(23 downto 0);
	signal to_physical_data_reg : std_logic_vector(31 downto 0);
	signal to_physical_read_enable_reg : std_logic := '0';
	signal to_physical_write_enable_reg : std_logic := '0';
	signal to_physical_counter : std_logic := '0';
	
begin

-- serial logic
	-- choose addr on posedge
	process(clk)
	begin
		if clk'event and clk = '1' and (state = MEM1 or state = MEM2 or state = InsF) then
			if state = MEM1 or state = MEM2 then
				addr <= if_addr;
			else
				addr <= virtual_addr;
			end if;
		end if;
	end process;
	
	-- store state in this time slice
	process(clk)
	begin
		if clk'event and clk = '1' then
			if not(state = state_reg) then
				to_physical_counter <= '0';
			else
				to_physical_counter <= '1';
			end if;
			state_reg <= state;
		end if;
	end process;
	
	-- handle TLBWI
	process(clk)
		variable tlb_index : integer range 15 downto 0 := 0;
	begin
		if clk'event and clk = '1' and state = Exe then
			if tlb_write_enable = '1' then
				tlb_index := conv_integer(tlb_write_struct(tlb_write_struct_width - 1 downto tlb_write_struct_width - tlb_index_width));
				tlb_mem(tlb_index) <= tlb_write_struct(tlb_write_struct_width - tlb_index_width - 1 downto 0);
			end if;
		end if;
	end process;
	
	-- handle exception
	process(clk)
	begin
		-- generate and clean exception at negedge
		if clk'event and clk = '0' then
			if exc_counter = '1' then
				exc_counter <= '0';
				exc_code <= NO_MEM_EXC;
			
			else
				-- address alignment exception
				if( (align_type = ALIGN_TYPE_WORD and addr(0) = '1') or (align_type = ALIGN_TYPE_QUAD and addr(1 downto 0) /= "00") ) then
					if( (state_reg = MEM1 and read_enable = '1' ) or state_reg = InsF )then
						exc_code <= ADE_L;
						exc_counter <= '1';
					elsif( (state_reg = MEM1 and write_enable = '1' and read_enable = '0') or state_reg = MEM2 ) then
						exc_code <= ADE_S;
						exc_counter <= '1';
					end if;
			
				-- tlb missing
				elsif tlb_missing = '1' then
					if( (state_reg = MEM1 and read_enable = '1') or state_reg = InsF )then
						exc_code <= TLB_L;
						exc_counter <= '1';
					elsif( (state_reg = MEM1 and write_enable = '1' and read_enable = '0') or state_reg = MEM2) then
						exc_code <= TLB_S;
						exc_counter <= '1';
					end if;
			
				-- tlb modified
				elsif ( tlb_writable = '0') then
					if( (state_reg = MEM1 and write_enable = '1' and read_enable = '0') or state_reg = MEM2) then
						exc_code <= TLB_MODIFIED;
						exc_counter <= '1';
					end if;
				end if;
			end if;
		end if;
	end process;
	
	
	
	-- clear enable and data and addr on posedge
	-- send information to physical level on negedge
	process(clk)
	begin
		if rst = '0' then
			to_physical_read_enable <= '0';
			to_physical_write_enable <= '0';
			to_physical_addr <= x"000000";
			to_physical_data <= x"00000000";
		elsif clk'event and clk = '0' and from_physical_ready = '1' and to_physical_counter = '0' then
			to_physical_addr <= to_physical_addr_reg;
			to_physical_data <= to_physical_data_reg;
			to_physical_read_enable <= to_physical_read_enable_reg;
			to_physical_write_enable <= to_physical_write_enable_reg;
		end if;
	end process;
	
-- combination logic	
	-- control signal
	not_use_mmu <= '1' when addr(31 downto 29) = "100" or addr(31 downto 29) = "101"
						 else '0' ;
						 
	special_com1_status <= '1'	when addr(31 downto 0) = VIRTUAL_SERIAL_STATUS
									else '0';
									
	physical_addr <= "000" & addr(28 downto 0)
							when not_use_mmu = '1'
						  else tlb_lookup_result(20 downto 1) & addr(11 downto 0)
						   when not_use_mmu = '0' and tlb_missing = '0'
						  else x"FFFFFFFF";
						  
	no_exception_accur <= '1'
									when (not((align_type = ALIGN_TYPE_WORD and addr(0) = '1') or (align_type = ALIGN_TYPE_QUAD and addr(1 downto 0) /= "00")) )
											and tlb_missing = '0' and tlb_writable = '1'
								 else '0';
								 
	-- to physical_level
	to_physical_addr_reg <= "00" & physical_addr(23 downto 2)	-- Flash
										when physical_addr(31 downto 24) = x"1E"
									else	"010" & physical_addr(22 downto 2)		-- RAM
										when physical_addr(31 downto 23) = "000000000"
									else "1000" & x"00000"							-- serial
										when physical_addr(31 downto 0) = PHYSICAL_SERIAL_DATA
									else x"FFFFFF";
					
	to_physical_data_reg <= data_in;
	
	to_physical_read_enable_reg <= '1'
											when( special_com1_status = '0' and to_physical_counter = '0' and no_exception_accur = '1' and from_physical_ready = '1' and (state_reg = InsF or (state_reg = MEM1 and read_enable = '1')) )
										else '0';
									
	to_physical_write_enable_reg <= '1'
											when( special_com1_status = '0' and to_physical_counter = '0' and no_exception_accur = '1' and from_physical_ready = '1' and ((state_reg = MEM1 and write_enable = '1' and read_enable = '0') or (state_reg = MEM2)) )
										else '0';
	
	-- to instruction fetch
	instruction <= from_physical_data
						when (state_reg = InsF or state_reg = InsD)
						else INVALID_CONTENT;
	
	-- to top mem level
	data_out <= x"0000000" & "00" & serial_status_reg & "0"
					when (special_com1_status = '1')
					else from_physical_data;
	
	ready <= from_physical_ready;
	serial_int <= from_physical_serial;
	
	-- register of serial status, return this directly if you load serial status
	serial_status_reg <= '1' 
								when (from_physical_serial = '1')
								else '0';
	
	-- handle TLB check
	-- compare with EntryHi
	tlb_which_equal(0) <= '1' when (tlb_mem(0)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(1) <= '1' when (tlb_mem(1)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(2) <= '1' when (tlb_mem(2)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(3) <= '1' when (tlb_mem(3)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(4) <= '1' when (tlb_mem(4)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(5) <= '1' when (tlb_mem(5)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(6) <= '1' when (tlb_mem(6)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(7) <= '1' when (tlb_mem(7)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(8) <= '1' when (tlb_mem(8)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(9) <= '1' when (tlb_mem(9)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(10) <= '1' when (tlb_mem(10)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(11) <= '1' when (tlb_mem(11)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(12) <= '1' when (tlb_mem(12)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(13) <= '1' when (tlb_mem(13)(62 downto 44) = addr(31 downto 13))
									else '0';
	tlb_which_equal(14) <= '1' when (tlb_mem(14)(62 downto 44) = addr(31 downto 13))
									else '0';									
	tlb_which_equal(15) <= '1' when (tlb_mem(15)(62 downto 44) = addr(31 downto 13))
									else '0';
		
	-- which EntryLo is selected and generate tlb_temp
	tlb_check : for i in tlb_num_entry-1 downto 0 generate
		tlb_which_low(i*2) <= tlb_which_equal(i) and tlb_mem(i)(0) and (not addr(12));		
		tlb_which_low(i*2+1) <= tlb_which_equal(i) and tlb_mem(i)(22) and addr(12);
	
		tlb_temp : for j in 20 downto 0 generate
			tlb_low_temp_value(j)(i*2) <= tlb_which_low(i*2) and tlb_mem(i)(j+1);
			tlb_low_temp_value(j)(i*2+1) <= tlb_which_low(i*2+1) and tlb_mem(i)(j+23);
		end generate tlb_temp;
	end generate tlb_check;
	
	-- generate lookup result
	-- tlb_lookup_result can be generated with "or reduce" operator in Verilog, but in VHDL it is difficult
	tlb_result : for i in 20 downto 0 generate
		tlb_lookup_result(i) <= tlb_low_temp_value(i)(0) or tlb_low_temp_value(i)(1) or tlb_low_temp_value(i)(2) or tlb_low_temp_value(i)(3) or
										tlb_low_temp_value(i)(4) or tlb_low_temp_value(i)(5) or tlb_low_temp_value(i)(6) or tlb_low_temp_value(i)(7) or
										tlb_low_temp_value(i)(8) or tlb_low_temp_value(i)(9) or tlb_low_temp_value(i)(10) or tlb_low_temp_value(i)(11) or
										tlb_low_temp_value(i)(12) or tlb_low_temp_value(i)(13) or tlb_low_temp_value(i)(14) or tlb_low_temp_value(i)(15) or
										
										tlb_low_temp_value(i)(16) or tlb_low_temp_value(i)(17) or tlb_low_temp_value(i)(18) or tlb_low_temp_value(i)(19) or
										tlb_low_temp_value(i)(20) or tlb_low_temp_value(i)(21) or tlb_low_temp_value(i)(22) or tlb_low_temp_value(i)(23) or
										tlb_low_temp_value(i)(24) or tlb_low_temp_value(i)(25) or tlb_low_temp_value(i)(26) or tlb_low_temp_value(i)(27) or
										tlb_low_temp_value(i)(28) or tlb_low_temp_value(i)(29) or tlb_low_temp_value(i)(30) or tlb_low_temp_value(i)(31);
	end generate tlb_result;
	
	tlb_missing <= not(not_use_mmu or
								tlb_which_low(0) or tlb_which_low(1) or tlb_which_low(2) or tlb_which_low(3) or tlb_which_low(4) or tlb_which_low(5) or
								tlb_which_low(6) or tlb_which_low(7) or tlb_which_low(8) or tlb_which_low(9) or tlb_which_low(10) or tlb_which_low(11) or
								tlb_which_low(12) or tlb_which_low(13) or tlb_which_low(14) or tlb_which_low(15) or tlb_which_low(16) or tlb_which_low(17) or
								tlb_which_low(18) or tlb_which_low(19) or tlb_which_low(20) or tlb_which_low(21) or tlb_which_low(22) or tlb_which_low(23) or
								tlb_which_low(24) or tlb_which_low(25) or tlb_which_low(26) or tlb_which_low(27) or tlb_which_low(28) or tlb_which_low(29) or
								tlb_which_low(30) or tlb_which_low(31)
							);
	tlb_writable <= not_use_mmu or tlb_lookup_result(0);
	
end Behavioral;
