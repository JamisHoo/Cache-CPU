----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:51:51 11/30/2014 
-- Design Name: 
-- Module Name:    test_load - Behavioral 
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
use work.common.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_load is
port(
	clk : in std_logic;
	high_freq_clk : in std_logic;
	e : in std_logic;
	input_test : in std_logic_vector(31 downto 0);
	output_test : out std_logic_vector(31 downto 0);
	step : out std_logic_vector(6 downto 0);
	
		-- ports connected with ram
	   baseram_addr: out std_logic_vector(19 downto 0);
	   baseram_data: inout std_logic_vector(31 downto 0);
	   baseram_ce: out std_logic;
	   baseram_oe: out std_logic;
	   baseram_we: out std_logic;
	   extrram_addr: out std_logic_vector(19 downto 0);
	   extrram_data: inout std_logic_vector(31 downto 0);
	   extrram_ce: out std_logic;
	   extrram_oe: out std_logic;
	   extrram_we: out std_logic;

	   -- ports connected with flash
	   flash_addr : out  STD_LOGIC_VECTOR (22 downto 0);
	   flash_data : inout  STD_LOGIC_VECTOR (15 downto 0);
	   flash_control_ce0 : out  STD_LOGIC;
	   flash_control_ce1 : out  STD_LOGIC;
	   flash_control_ce2 : out  STD_LOGIC;
	   flash_control_byte : out  STD_LOGIC;
	   flash_control_vpen : out  STD_LOGIC;
	   flash_control_rp : out  STD_LOGIC;
	   flash_control_oe : out  STD_LOGIC;
	   flash_control_we : out  STD_LOGIC;

		-- ports connected with serial port
      serialport_txd : out STD_LOGIC;
      serialport_rxd : in STD_LOGIC
);
end test_load;

architecture Behavioral of test_load is

component mmu_module is
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
	from_physical_serial : in std_logic;
   
   no_exception : out std_logic
);
end component;

component phy_mem is 
port(
	high_freq_clk : in  STD_LOGIC;  
	addr : in  STD_LOGIC_VECTOR (23 downto 0);
	data_in : in  STD_LOGIC_VECTOR (31 downto 0);
	data_out : out  STD_LOGIC_VECTOR (31 downto 0) := X"FFFFFFFF";
	write_enable : in  STD_LOGIC;
	read_enable : in  STD_LOGIC;
	busy: out STD_LOGIC := '0';
	serialport_data_ready : out  STD_LOGIC;

	-- ports connected with ram
	baseram_addr: out std_logic_vector(19 downto 0);
	baseram_data: inout std_logic_vector(31 downto 0);
	baseram_ce: out std_logic;
	baseram_oe: out std_logic;
	baseram_we: out std_logic;
	extrram_addr: out std_logic_vector(19 downto 0);
	extrram_data: inout std_logic_vector(31 downto 0);
	extrram_ce: out std_logic;
	extrram_oe: out std_logic;
	extrram_we: out std_logic;
           
	-- ports connected with flash
	flash_addr : out  STD_LOGIC_VECTOR (22 downto 0);
	flash_data : inout  STD_LOGIC_VECTOR (15 downto 0);
	flash_control_ce0 : out  STD_LOGIC;
	flash_control_ce1 : out  STD_LOGIC;
	flash_control_ce2 : out  STD_LOGIC;
	flash_control_byte : out  STD_LOGIC;
	flash_control_vpen : out  STD_LOGIC;
	flash_control_rp : out  STD_LOGIC;
	flash_control_oe : out  STD_LOGIC;
	flash_control_we : out  STD_LOGIC;
           
	-- ports connected with serial port
	serialport_txd : out STD_LOGIC;
	serialport_rxd : in STD_LOGIC
);
end component;

	signal to_physical_addr_reg : std_logic_vector(23 downto 0);
	signal to_physical_data_reg : std_logic_vector(31 downto 0);
	signal to_physical_write_enable_reg : std_logic;
	signal to_physical_read_enable_reg : std_logic;
	signal from_physical_data_reg : std_logic_vector(31 downto 0);
	signal from_physical_ready_reg : std_logic;
	signal from_physical_serial_reg : std_logic;
	
	signal temp_not : std_logic;
	
	signal tlb_write_struct_reg : std_logic_vector(66 downto 0) := (others => '0');
	signal tlb_write_enable_reg : std_logic := '0';
	
	signal if_addr_reg : std_logic_vector(31 downto 0);
	signal instruction_reg : std_logic_vector(31 downto 0);
	
	signal virtual_addr_reg : std_logic_vector(31 downto 0);
	signal data_in_reg : std_logic_vector(31 downto 0);
	signal read_enable_reg : std_logic := '0';
	signal write_enable_reg : std_logic := '0';
	
	signal data_out_reg : std_logic_vector(31 downto 0);
	signal ready_reg : std_logic;
	signal serial_int_reg : std_logic;
	signal exc_code_reg : std_logic_vector(2 downto 0);
	
	signal align_type_reg : std_logic_vector(1 downto 0);
	
	signal state_reg : status := InsD;
	signal next_state : status;
	signal old_state : status;
	
begin
	
	if_addr_reg <= input_test;
		
	read_enable_reg <= '1';
	write_enable_reg <= '0';
	tlb_write_enable_reg <= '0';
	virtual_addr_reg <= (others=>'0');
	data_in_reg <= (others=>'0');
	align_type_reg <= "10";
	
	state_reg <= next_state
						when ready_reg = '1'
					 else old_state
						when ready_reg = '0';
	
	process(clk, e)
	begin
		if e = '0' then
			old_state <= InsD;
			next_state <= InsD;
			
		elsif clk'event and clk = '1' then
			old_state <= state_reg;
			if state_reg = InsD then
				next_state <= InsF;
			elsif state_reg = InsF then 
				next_state <= InsD;
			end if;
		end if;
	end process;
	
	with state_reg select
		step <= "0111111" when InsD,
				  "0000110" when InsF,
				  "1011011" when Exc,
				  "0000000" when others;
	
	output_test(15) <= ready_reg;
	output_test(13 downto 0) <= instruction_reg(13 downto 0);
	
	u_mmu : mmu_module port map(clk=>clk, state=>state_reg, rst=>e, if_addr=>if_addr_reg, instruction=>instruction_reg,
							virtual_addr=>virtual_addr_reg, data_in=>data_in_reg, read_enable=>read_enable_reg,
							write_enable=>write_enable_reg, data_out=>data_out_reg, ready=>ready_reg, 
							serial_int=>serial_int_reg, exc_code=>exc_code_reg, align_type=>align_type_reg,
							tlb_write_struct=>tlb_write_struct_reg, tlb_write_enable=>tlb_write_enable_reg,
							to_physical_addr=>to_physical_addr_reg, to_physical_data=>to_physical_data_reg,
							to_physical_read_enable=>to_physical_read_enable_reg, to_physical_write_enable=>to_physical_write_enable_reg,
							from_physical_data=>from_physical_data_reg, from_physical_ready=>from_physical_ready_reg,
							from_physical_serial=>from_physical_serial_reg, 
                     no_exception=>output_test(14));
							
	from_physical_ready_reg <= not( temp_not );
	
	u_physical : phy_mem port map(high_freq_clk=>high_freq_clk, addr=>to_physical_addr_reg,
							data_in=>to_physical_data_reg, data_out=>from_physical_data_reg,
							write_enable=>to_physical_write_enable_reg, read_enable=>to_physical_read_enable_reg,
							busy=>temp_not, serialport_data_ready=>from_physical_serial_reg,
							
							baseram_addr=>baseram_addr, baseram_data=>baseram_data,
							baseram_ce=>baseram_ce, baseram_oe=>baseram_oe,
							baseram_we=>baseram_we, extrram_addr=>extrram_addr,
							extrram_data=>extrram_data, extrram_ce=>extrram_ce,
							extrram_oe=>extrram_oe, extrram_we=>extrram_we,
								
							flash_addr=>flash_addr, flash_data=>flash_data,
							flash_control_ce0=>flash_control_ce0, flash_control_ce1=>flash_control_ce1,
							flash_control_ce2=>flash_control_ce2, flash_control_byte=>flash_control_byte,
							flash_control_vpen=>flash_control_vpen, flash_control_rp=>flash_control_rp,
							flash_control_oe=>flash_control_oe, flash_control_we=>flash_control_we,
								
                       
							serialport_txd=>serialport_txd, serialport_rxd=>serialport_rxd
							);
	
end Behavioral;

