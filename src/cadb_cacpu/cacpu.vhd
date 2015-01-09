library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.IDecode_const.all;
use work.common.all;


entity cacpu is
	port(
		clk : in std_logic;
		e : in std_logic;
        
        -- debug tool output
		debug_out_datas : out std_logic_vector(4095 downto 0);
		-- debug tool breakpoint condition
        monitor : out std_logic_vector(63 downto 0);
     
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

		-- no serial port during test
      serialport_txd : out STD_LOGIC;
      serialport_rxd : in STD_LOGIC

		);
end cacpu;

architecture bhv of cacpu is
component CP0 is
	port(
		clk: in std_logic;
		state: in status;
		cp0_e : in std_logic;
		normal_cp0_in : in std_logic_vector(37 downto 0);
		bad_v_addr_in : in std_logic_vector(31 downto 0);
		entry_hi_in : in std_logic_vector(19 downto 0);
		interrupt_start_in : in std_logic;
		cause_in : in std_logic_vector(4 downto 0);
		interrupt_code_in : in std_logic_vector(5 downto 0);
		epc_in : in std_logic_vector(31 downto 0);
		eret_enable : in std_logic;
		compare_init: in std_logic;

		addr_value : out std_logic_vector(31 downto 0);
		all_regs : out std_logic_vector(1023 downto 0);
		compare_interrupt: out std_logic
		);
end component;
component Exception is
	port(
		clk : in std_logic;
		state : in status;
		exception_e : in std_logic;
		mmu_exc_code : in std_logic_vector(2 downto 0);
		serial_int : in std_logic;
		compare_interrupt : in std_logic;
		id_exc_code : in std_logic_vector(1 downto 0);
		pc_in : in std_logic_vector(31 downto 0);
		pcmmu_in : in std_logic_vector(31 downto 0);
		v_addr_in : in std_logic_vector(31 downto 0);
		old_entry_hi : in std_logic_vector(19 downto 0);
		old_interrupt_code : in std_logic_vector(5 downto 0);
		
		bad_v_addr_out : out std_logic_vector(31 downto 0);
		entry_hi_out : out std_logic_vector(19 downto 0);
		interrupt_start_out : out std_logic;
		cause_out : out std_logic_vector(4 downto 0);
		interrupt_code_out : out std_logic_vector(5 downto 0);
		epc_out : out std_logic_vector(31 downto 0);
		compare_recover : out std_logic;
		pc_sel0 : out std_logic
		);
end component;
component IDecode is
	port(
		clk : in std_logic;
		state : in status;
		rst : in std_logic;
		
		instruction : in std_logic_vector(31 downto 0);
		
		-- remain to next IDecode
		instr_out : out std_logic_vector(31 downto 0);
		
		-- combinatory logic
		rs_addr : out std_logic_vector(4 downto 0);
		rt_addr : out std_logic_vector(4 downto 0);
		rd_addr : out std_logic_vector(4 downto 0);
		
		-- sequential logic
		pc_op : out std_logic_vector(1 downto 0);		-- choose 1 from 4
		eret_enable : out std_logic;
		comp_op : out std_logic_vector(2 downto 0);
		
		imme : out std_logic_vector(31 downto 0);
		alu_ops : out std_logic_vector(8 downto 0);
		
		mem_op : out std_logic_vector(2 downto 0);
		align_type : out std_logic_vector(1 downto 0);
		tlbwi_enable : out std_logic;
		
		wb_op : out std_logic_vector(4 downto 0);
		
		cp0_op : out std_logic;
		
		exc_code : out std_logic_vector(1 downto 0)
	);
end component;
component IFetch is
	port(
		clk : in std_logic;
		state : in status;
		rst : in std_logic;
		mmu_ready : in std_logic;
		
		PCSrc : in std_logic_vector(31 downto 0);
		EBase : in std_logic_vector(31 downto 0);
		EPC : in std_logic_vector(31 downto 0);
		pc_sel : in std_logic_vector(1 downto 0);		-- eret_enable, pc_control
		
		PC : out std_logic_vector(31 downto 0);		-- register, with sequential logic
		PCmmu : out std_logic_vector(31 downto 0)		-- combinatory, for mmu
	);
end component;
component alu is
	port(
		 clk:               in  std_logic;
         rs_value:          in  std_logic_vector(31 downto 0);
         rt_value:          in  std_logic_vector(31 downto 0);
         imme:              in  std_logic_vector(31 downto 0);
         cp0_value:         in  std_logic_vector(31 downto 0);
         state:             in  status;
         alu_op:            in  std_logic_vector(4 downto 0);
         alu_srcA:          in  std_logic_vector(1 downto 0);
         alu_srcB:          in  std_logic_vector(1 downto 0);
         alu_result:        out std_logic_vector(31 downto 0)
         
	);
end component;
component mem is
	port(
		-- clk : in std_logic;
		-- state : in status;
		
		rst : in std_logic;
		result : in std_logic_vector(31 downto 0);		-- address from alu
		
		rt_value : in std_logic_vector(31 downto 0);
		mmu_value : in std_logic_vector(31 downto 0);
		
		-- mem_read, mem_write, mem_value
		mem_op : in std_logic_vector(2 downto 0);
		
		addr_mmu : out std_logic_vector(31 downto 0);
		write_value : out std_logic_vector(31 downto 0);
		
		write_enable : out std_logic;
		read_enable : out std_logic
	);
end component;

component WB is
	port(
		clk : in std_logic;
		state : in status;
		WB_e : in std_logic;
		--PC + 4
		RPC : in std_logic_vector(31 downto 0);
		mmu_value : in std_logic_vector(31 downto 0);
		cp0_value : in std_logic_vector(31 downto 0);
		alu_result : in std_logic_vector(31 downto 0);
		wb_op : in std_logic_vector(4 downto 0);
		rd_addr : in std_logic_vector(4 downto 0);
		rt_addr : in std_logic_vector(4 downto 0);

		write_addr : out std_logic_vector(4 downto 0);
		write_value : out std_logic_vector(31 downto 0);
		write_enable : out std_logic;
 
		pc_op : in std_logic_vector(1 downto 0);
		comp_op : in std_logic_vector(2 downto 0);
		rs_value : in std_logic_vector(31 downto 0);
		rt_value : in std_logic_vector(31 downto 0);
		imme : in std_logic_vector(31 downto 0);

		PcSrc : out std_logic_vector(31 downto 0)
		);
end component;

component general_register is
port(
    clk : IN STD_LOGIC;
	 state : in status;
	 rst : in std_logic;
	 
	 rs_addr : in std_logic_vector(4 downto 0);
	 rt_addr : in std_logic_vector(4 downto 0);
	 
	 write_addr : in std_logic_vector(4 downto 0);
	 write_value : in std_logic_vector(31 downto 0);
	 write_enable : in std_logic;
	 
	 rs_value : out std_logic_vector(31 downto 0);
	 rt_value : out std_logic_vector(31 downto 0);
	 regs : out std_logic_vector(1023 downto 0);
	 
     reg0 : out std_logic_vector(31 downto 0)
);
end component;

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
	from_physical_serial : in std_logic
);
end component;

component phy_mem is
    Port (
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

signal clks 						: std_logic_vector(3 downto 0);
signal cpu_clk						: std_logic;
signal high_clk					: std_logic;
signal state,next_state,old_state	: status;
signal state_select					: std_logic_vector(1 downto 0);
signal PCSrc 						: std_logic_vector(31 downto 0);
signal EPC,EBase 					: std_logic_vector(31 downto 0);
signal pc_sel 						: std_logic_vector(1 downto 0);
signal this_PC,PC_to_mmu 			: std_logic_vector(31 downto 0);
signal data_from_mmu 				: std_logic_vector(31 downto 0);
signal instr_from_mmu 				: std_logic_vector(31 downto 0);
signal this_instr					: std_logic_vector(31 downto 0);
signal rs_addr,rt_addr,rd_addr		: std_logic_vector(4 downto 0);
signal pc_op 						: std_logic_vector(1 downto 0);
signal comp_op						: std_logic_vector(2 downto 0);
signal immediate					: std_logic_vector(31 downto 0);
signal alu_ops						: std_logic_vector(8 downto 0);
signal mem_op						: std_logic_vector(2 downto 0);
signal align_type					: std_logic_vector(1 downto 0);
signal tlbwi_enable 				: std_logic;
signal wb_op 						: std_logic_vector(4 downto 0);
signal cp0_op 						: std_logic;
signal id_exc_code 					: std_logic_vector(1 downto 0);
signal rs_value,rt_value	: std_logic_vector(31 downto 0);
signal alu_result					: std_logic_vector(31 downto 0);
signal addr_from_mem				: std_logic_vector(31 downto 0);
signal write_value_from_mem			: std_logic_vector(31 downto 0);
signal mem_write_enable				: std_logic;
signal mem_read_enable				: std_logic;
signal RPC							: std_logic_vector(31 downto 0);
signal write_addr_from_wb			: std_logic_vector(4 downto 0);
signal write_value_from_wb			: std_logic_vector(31 downto 0);
signal write_enable_from_wb			: std_logic;
signal normal_cp0_in				: std_logic_vector(37 downto 0);
signal from_exception_bad_v_addr	: std_logic_vector(31 downto 0);
signal from_exception_entry_hi 		: std_logic_vector(19 downto 0);
signal interrupt_start 				: std_logic;
signal from_exception_cause 		: std_logic_vector(4 downto 0);
signal from_exception_intcode		: std_logic_vector(5 downto 0);
signal from_exception_epc 			: std_logic_vector(31 downto 0);
signal compare_recover				: std_logic;
signal cp0_normal_value				: std_logic_vector(31 downto 0);
signal cp0_values					: std_logic_vector(1023 downto 0);
signal general_values			: std_logic_vector(1023 downto 0);
signal compare_int 					: std_logic;
signal mmu_exc_code					: std_logic_vector(2 downto 0);
signal serial_int					: std_logic;
signal to_exception_bad_v_addr		: std_logic_vector(31 downto 0);
signal mmu_ready					: std_logic;
signal tlb_write_value				: std_logic_vector(66 downto 0);

signal to_physical_addr 			: std_logic_vector(23 downto 0);
signal to_physical_data 			: std_logic_vector(31 downto 0);
signal to_physical_read_enable 		: std_logic;
signal to_physical_write_enable 	: std_logic;
signal from_physical_data 			: std_logic_vector(31 downto 0);
signal from_physical_ready  		: std_logic;
signal from_physical_serial 		: std_logic;
signal phy_busy						: std_logic;

signal clock_inter_to_excep			: std_logic;
signal serial_inter_to_excep		: std_logic;
signal excep 						: std_logic;

-- control the state change
signal has_mem1 : std_logic := '0';
signal has_mem2 : std_logic := '0';

signal reg0 : std_logic_vector(31 downto 0);


signal state_bin : std_logic_vector(2 downto 0);
signal next_state_bin : std_logic_vector(2 downto 0);
signal old_state_bin : std_logic_vector(2 downto 0);

signal out_datas : std_logic_vector(4095 downto 0);


begin

	process(clk,e)
	begin
		if e = '0' then
			clks <= (others => '0');
		elsif rising_edge(clk) then
			clks <= clks - 1;
		end if;
	end process;
	cpu_clk <= clks(2);
	high_clk <= clks(0);




-- what should be changed after adding memory module
   -- serial is always 0
   --serialport_rxd_in_reg <= '0';
	
	RPC <= this_PC+4;
	normal_cp0_in <= cp0_op & instr_from_mmu(15 downto 11) & rt_value;
	-- index(66 downto 63) EntryHi(62 downto 44) EntryLo0(43 downto 24) DV(23 downto 22) EntryLo1(21 downto 2) DV(1 downto 0)
	--(0)(3 downto 0),(10)(31 downto 13),(2)(25 downto 6)(2 downto 1),(3)(25 downto 6)(2 downto 1)
	tlb_write_value <= cp0_values(3 downto 0) & cp0_values(351 downto 333) 
						& cp0_values(89 downto 70) & cp0_values(66 downto 65)
						& cp0_values(121 downto 102) & cp0_values(98 downto 97);
	EPC <= cp0_values(479 downto 448);
	EBase <= cp0_values(511 downto 480);

	with old_state select
		--status:EXL(12)(1)=12*32+1=385
		clock_inter_to_excep <= compare_int and not cp0_values(385) and cp0_values(384) when WriteB,
								'0' when others;
	with old_state select
		--status:EXL(12)(1)=12*32+1=385
		serial_inter_to_excep <= serial_int and not cp0_values(385) and cp0_values(384) when WriteB,
								'0' when others;
	excep <= clock_inter_to_excep or serial_inter_to_excep or mmu_exc_code(0)
				or mmu_exc_code(1) or mmu_exc_code(2) or id_exc_code(0)
				or id_exc_code(1);
	state_select <= excep & mmu_ready;
	with state_select select
		state <= old_state when "00",
					next_state when "01",
					old_state when "10",
					Exc when "11",
					next_state when others;

	process(cpu_clk,e)
	begin
		if e = '0' then
			old_state <= InsF;
			next_state <= InsF;
		elsif rising_edge(cpu_clk) then
			old_state <= state;
			case state is
				when InsF =>
					next_state <= InsD;
				when InsD =>
					next_state <= Exe;
				when Exe =>
					if has_mem1 = '1' then
						next_state <= Mem1;
               else
						next_state <= WriteB;
					end if;
				when Mem1 =>
					if has_mem2 = '1' then
						next_state <= Mem2;
					else
						next_state <= WriteB;
					end if;
				when Mem2 =>
					next_state <= WriteB;
				when WriteB =>
					next_state <= InsF;
				when Exc =>
					next_state <= InsF;
				when others =>
			end case;
		end if;
	end process;

    	-- control state change
	process(cpu_clk , e)
		variable First : std_logic_vector(5 downto 0);
	begin
			First := instr_from_mmu(31 downto 26);
        
			if cpu_clk'event and cpu_clk = '1' and state = InsD and e = '1' then
				case First is 
					when F_LW | F_LB | F_LBU | F_LHU | F_SW | F_SB => has_mem1 <= '1';
					when others => has_mem1 <= '0';
				end case;
            
            case First is 
					when F_SB => has_mem2 <= '1';
					when others => has_mem2 <= '0';
            end case;            
			end if;
	end process;

	process(cpu_clk,e)
	begin
		if e = '0' then
			to_exception_bad_v_addr <= (others => '0');
		elsif rising_edge(cpu_clk) then
			if state = InsF then
				to_exception_bad_v_addr <= PC_to_mmu;
			elsif state = Mem1 or state = Mem2 then
				to_exception_bad_v_addr <= addr_from_mem;
			end if;
		end if;
	end process;

	u_IF : IFetch port map(clk => cpu_clk,state => state,rst => e,
				mmu_ready => mmu_ready,
				PCSrc => PCSrc,EBase => EBase,EPC=>EPC,
				pc_sel => pc_sel,PC => this_PC,PCmmu => PC_to_mmu);
	u_ID : IDecode port map(clk => cpu_clk,state => state,rst => e,
				instruction => instr_from_mmu,instr_out => this_instr,
				rs_addr => rs_addr,rt_addr => rt_addr,rd_addr => rd_addr,
				pc_op => pc_op,eret_enable => pc_sel(1),comp_op => comp_op,
				imme => immediate, alu_ops => alu_ops,mem_op => mem_op,
				align_type => align_type,tlbwi_enable => tlbwi_enable,
				wb_op => wb_op,cp0_op => cp0_op,exc_code => id_exc_code);
	u_ALU : alu port map(clk => cpu_clk,rs_value => rs_value,
				rt_value => rt_value,imme => immediate,cp0_value => cp0_normal_value,
				state => state,alu_op => alu_ops(4 downto 0),
				alu_srcA => alu_ops(8 downto 7),alu_srcB => alu_ops(6 downto 5),
				alu_result => alu_result);
	u_MEM : mem port map(rst => e,result => alu_result,rt_value => rt_value,
				mmu_value => data_from_mmu,mem_op => mem_op,
				addr_mmu => addr_from_mem,write_value => write_value_from_mem,
				write_enable => mem_write_enable,read_enable => mem_read_enable);
	u_WB : WB port map(clk => cpu_clk,state => state,WB_e => e,RPC => RPC,
				mmu_value => data_from_mmu,cp0_value => cp0_normal_value,
				alu_result => alu_result,wb_op => wb_op,
				rd_addr => rd_addr,rt_addr => rt_addr,
				write_addr => write_addr_from_wb,
				write_value => write_value_from_wb,
				write_enable => write_enable_from_wb,pc_op => pc_op,
				comp_op => comp_op,rs_value => rs_value,rt_value => rt_value,
				imme => immediate,PcSrc => PcSrc);
	u_CP0 : CP0 port map(clk => cpu_clk,state => state,cp0_e => e,
				normal_cp0_in => normal_cp0_in,
				bad_v_addr_in => from_exception_bad_v_addr,
				entry_hi_in => from_exception_entry_hi,
				interrupt_start_in => interrupt_start,
				cause_in => from_exception_cause,
				interrupt_code_in => from_exception_intcode,
				epc_in => from_exception_epc,
				eret_enable => pc_sel(1),compare_init => compare_recover,
				addr_value => cp0_normal_value,all_regs => cp0_values,
				compare_interrupt => compare_int);
	u_Exception : Exception port map(clk => cpu_clk, state => state,
				exception_e => e,mmu_exc_code => mmu_exc_code,
				serial_int => serial_inter_to_excep,
				compare_interrupt => clock_inter_to_excep,
				id_exc_code => id_exc_code,pc_in => this_pc,
				pcmmu_in => pc_to_mmu,
				v_addr_in => to_exception_bad_v_addr,
				--(10)(31 downto 12), 10*32+31=351, 10*32+12=332
				old_entry_hi => cp0_values(351 downto 332),
				--(13)(15 downto 10), 13*32+15=431, 13*32+10=426
				old_interrupt_code => cp0_values(431 downto 426),
				bad_v_addr_out => from_exception_bad_v_addr,
				entry_hi_out => from_exception_entry_hi,
				interrupt_start_out => interrupt_start,
				cause_out => from_exception_cause,
				compare_recover => compare_recover,
				interrupt_code_out => from_exception_intcode,
				epc_out => from_exception_epc,pc_sel0 => pc_sel(0));

	u_register : general_register port map(clk=>cpu_clk, state=>state, rst=>e,
				rs_addr=>instr_from_mmu(25 downto 21), rt_addr=>instr_from_mmu(20 downto 16), 
				write_enable=>write_enable_from_wb, write_addr=>write_addr_from_wb,
				write_value=>write_value_from_wb, rs_value=>rs_value, rt_value=>rt_value,
				regs => general_values,
                reg0=>reg0
                );
                
   u_MMU : mmu_module port map(clk => cpu_clk, state => state, rst => e,
				if_addr => PC_to_mmu,instruction => instr_from_mmu,
				virtual_addr => addr_from_mem,data_in => write_value_from_mem,
				read_enable => mem_read_enable,
				write_enable => mem_write_enable,
				data_out => data_from_mmu,ready => mmu_ready,
				serial_int => serial_int,exc_code => mmu_exc_code,
				tlb_write_struct => tlb_write_value,
				tlb_write_enable => tlbwi_enable,align_type => align_type,
				to_physical_addr => to_physical_addr,
				to_physical_data => to_physical_data,
				to_physical_read_enable => to_physical_read_enable,
				to_physical_write_enable => to_physical_write_enable,
				from_physical_data => from_physical_data,
				from_physical_ready => from_physical_ready,
				from_physical_serial => from_physical_serial);
	
   from_physical_ready <= not(phy_busy);
   
   u_physical : phy_mem port map(high_freq_clk => high_clk,
				addr => to_physical_addr,data_in => to_physical_data,
				data_out => from_physical_data,
				write_enable => to_physical_write_enable,
				read_enable => to_physical_read_enable,busy => phy_busy,
				serialport_data_ready => from_physical_serial,
				baseram_addr => baseram_addr,
				baseram_data => baseram_data,
				baseram_ce => baseram_ce,
				baseram_oe => baseram_oe,
				baseram_we => baseram_we, 
				extrram_addr => extrram_addr, 
				extrram_data => extrram_data, 
				extrram_ce => extrram_ce, extrram_oe => extrram_oe, 
				extrram_we => extrram_we, flash_addr => flash_addr, 
				flash_data => flash_data, 
				flash_control_ce0 => flash_control_ce0, 
				flash_control_ce1 => flash_control_ce1, 
				flash_control_ce2 => flash_control_ce2, 
				flash_control_byte => flash_control_byte, 
				flash_control_vpen => flash_control_vpen, 
				flash_control_rp => flash_control_rp, 
				flash_control_oe => flash_control_oe, 
				flash_control_we => flash_control_we,
            
            -- change for test
				serialport_txd => serialport_txd,
				serialport_rxd => serialport_rxd
				);
            
    debug_out_datas <= out_datas;
   
    
	with state select
		state_bin <= "000" when InsF,
                     "001" when InsD,
                     "010" when Exe,
                     "011" when Mem1,
                     "100" when Mem2,
                     "101" when WriteB,
                     "110" when Exc,
                     "111" when others;
	with old_state select
		old_state_bin <= 	"000" when InsF,
							"001" when InsD,
							"010" when Exe,
							"011" when Mem1,
							"100" when Mem2,
							"101" when WriteB,
							"110" when Exc,
							"111" when others;
	with next_state select
		next_state_bin <= 	"000" when InsF,
							"001" when InsD,
							"010" when Exe,
							"011" when Mem1,
							"100" when Mem2,
							"101" when WriteB,
							"110" when Exc,
							"111" when others;
                            
                            
out_datas(2 downto 0) <= state_bin(2 downto 0);
out_datas(7 downto 3) <= (others => '0');
out_datas(10 downto 8) <= old_state_bin(2 downto 0);
out_datas(15 downto 11) <= (others => '0');
out_datas(18 downto 16) <= next_state_bin(2 downto 0);
out_datas(23 downto 19) <= (others => '0');
out_datas(27 downto 24) <= clks(3 downto 0);
out_datas(31 downto 28) <= (others => '0');
out_datas(32) <= cpu_clk;
out_datas(39 downto 33) <= (others => '0');
out_datas(41 downto 40) <= pc_sel(1 downto 0);
out_datas(47 downto 42) <= (others => '0');
out_datas(49 downto 48) <= state_select(1 downto 0);
out_datas(55 downto 50) <= (others => '0');
out_datas(87 downto 56) <= this_PC(31 downto 0);
out_datas(119 downto 88) <= PC_to_mmu(31 downto 0);
out_datas(151 downto 120) <= PCSrc(31 downto 0);
out_datas(183 downto 152) <= EPC(31 downto 0);
out_datas(215 downto 184) <= EBase(31 downto 0);
out_datas(247 downto 216) <= this_instr(31 downto 0);
out_datas(252 downto 248) <= rs_addr(4 downto 0);
out_datas(255 downto 253) <= (others => '0');
out_datas(260 downto 256) <= rt_addr(4 downto 0);
out_datas(263 downto 261) <= (others => '0');
out_datas(268 downto 264) <= rd_addr(4 downto 0);
out_datas(271 downto 269) <= (others => '0');
out_datas(273 downto 272) <= pc_op(1 downto 0);
out_datas(279 downto 274) <= (others => '0');
out_datas(282 downto 280) <= comp_op(2 downto 0);
out_datas(287 downto 283) <= (others => '0');
out_datas(319 downto 288) <= immediate(31 downto 0);
out_datas(328 downto 320) <= alu_ops(8 downto 0);
out_datas(335 downto 329) <= (others => '0');
out_datas(338 downto 336) <= mem_op(2 downto 0);
out_datas(343 downto 339) <= (others => '0');
out_datas(344) <= tlbwi_enable;
out_datas(351 downto 345) <= (others => '0');
out_datas(383 downto 352) <= rs_value(31 downto 0);
out_datas(415 downto 384) <= rt_value(31 downto 0);
out_datas(447 downto 416) <= alu_result(31 downto 0);
out_datas(448) <= mem_read_enable;
out_datas(455 downto 449) <= (others => '0');
out_datas(456) <= mem_write_enable;
out_datas(463 downto 457) <= (others => '0');
out_datas(495 downto 464) <= general_values(31 downto 0);
out_datas(527 downto 496) <= general_values(63 downto 32);
out_datas(559 downto 528) <= general_values(95 downto 64);
out_datas(591 downto 560) <= general_values(127 downto 96);
out_datas(623 downto 592) <= general_values(159 downto 128);
out_datas(655 downto 624) <= general_values(191 downto 160);
out_datas(687 downto 656) <= general_values(223 downto 192);
out_datas(719 downto 688) <= general_values(255 downto 224);
out_datas(751 downto 720) <= general_values(287 downto 256);
out_datas(783 downto 752) <= general_values(319 downto 288);
out_datas(815 downto 784) <= general_values(351 downto 320);
out_datas(847 downto 816) <= general_values(383 downto 352);
out_datas(879 downto 848) <= general_values(415 downto 384);
out_datas(911 downto 880) <= general_values(447 downto 416);
out_datas(943 downto 912) <= general_values(479 downto 448);
out_datas(975 downto 944) <= general_values(511 downto 480);
out_datas(1007 downto 976) <= general_values(543 downto 512);
out_datas(1039 downto 1008) <= general_values(575 downto 544);
out_datas(1071 downto 1040) <= general_values(607 downto 576);
out_datas(1103 downto 1072) <= general_values(639 downto 608);
out_datas(1135 downto 1104) <= general_values(671 downto 640);
out_datas(1167 downto 1136) <= general_values(703 downto 672);
out_datas(1199 downto 1168) <= general_values(735 downto 704);
out_datas(1231 downto 1200) <= general_values(767 downto 736);
out_datas(1263 downto 1232) <= general_values(799 downto 768);
out_datas(1295 downto 1264) <= general_values(831 downto 800);
out_datas(1327 downto 1296) <= general_values(863 downto 832);
out_datas(1359 downto 1328) <= general_values(895 downto 864);
out_datas(1391 downto 1360) <= general_values(927 downto 896);
out_datas(1423 downto 1392) <= general_values(959 downto 928);
out_datas(1455 downto 1424) <= general_values(991 downto 960);
out_datas(1487 downto 1456) <= general_values(1023 downto 992);
out_datas(1519 downto 1488) <= cp0_values(31 downto 0);
out_datas(1551 downto 1520) <= cp0_values(63 downto 32);
out_datas(1583 downto 1552) <= cp0_values(95 downto 64);
out_datas(1615 downto 1584) <= cp0_values(127 downto 96);
out_datas(1647 downto 1616) <= cp0_values(159 downto 128);
out_datas(1679 downto 1648) <= cp0_values(191 downto 160);
out_datas(1711 downto 1680) <= cp0_values(223 downto 192);
out_datas(1743 downto 1712) <= cp0_values(255 downto 224);
out_datas(1775 downto 1744) <= cp0_values(287 downto 256);
out_datas(1807 downto 1776) <= cp0_values(319 downto 288);
out_datas(1839 downto 1808) <= cp0_values(351 downto 320);
out_datas(1871 downto 1840) <= cp0_values(383 downto 352);
out_datas(1903 downto 1872) <= cp0_values(415 downto 384);
out_datas(1935 downto 1904) <= cp0_values(447 downto 416);
out_datas(1967 downto 1936) <= cp0_values(479 downto 448);
out_datas(1999 downto 1968) <= cp0_values(511 downto 480);
out_datas(2031 downto 2000) <= cp0_values(543 downto 512);
out_datas(2063 downto 2032) <= cp0_values(575 downto 544);
out_datas(2095 downto 2064) <= cp0_values(607 downto 576);
out_datas(2127 downto 2096) <= cp0_values(639 downto 608);
out_datas(2159 downto 2128) <= cp0_values(767 downto 736);
out_datas(2191 downto 2160) <= cp0_values(799 downto 768);
out_datas(2223 downto 2192) <= cp0_values(831 downto 800);
out_datas(2255 downto 2224) <= cp0_values(863 downto 832);
out_datas(2287 downto 2256) <= cp0_values(895 downto 864);
out_datas(2319 downto 2288) <= cp0_values(927 downto 896);
out_datas(2351 downto 2320) <= cp0_values(959 downto 928);
out_datas(2383 downto 2352) <= cp0_values(991 downto 960);
out_datas(2415 downto 2384) <= cp0_values(1023 downto 992);
out_datas(4095 downto 2416) <= (others => '0');



	monitor(63 downto 39) <= (others => '0');
    monitor(38 downto 35) <= clks;
    monitor(34 downto 32) <= state_bin;
    with state_bin & mmu_ready select
		monitor (31 downto 0) <= PC_to_mmu when "0001",
										this_PC when others;

end bhv;

