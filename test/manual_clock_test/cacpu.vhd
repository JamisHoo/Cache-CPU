----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:31:37 11/28/2014 
-- Design Name: 
-- Module Name:    cacpu - bhv 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.IDecode_const.all;
use work.common.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cacpu is
	port(
		clk : in std_logic;
		e : in std_logic;
		in_data : in std_logic_vector(31 downto 0);
		select_data : in std_logic_vector(7 downto 0);
		out_data : out std_logic_vector(7 downto 0)
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
	 
     reg0 : out std_logic_vector(31 downto 0)
);
end component;

signal clks 						: std_logic_vector(2 downto 0);
signal cpu_clk						: std_logic;
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

type outdatatype is array (63 downto 0) of std_logic_vector(15 downto 0);
signal out_datas : outdatatype;

begin
	process(clk,e)
	begin
		if e = '0' then
			clks <= (others => '0');
		elsif rising_edge(clk) then
			clks <= clks - 1;
		end if;
	end process;
	cpu_clk <= clk;

	with select_data(0) select
		out_data <= out_datas(conv_integer(select_data(6 downto 1)))(15 downto 8) when '0',
						out_datas(conv_integer(select_data(6 downto 1)))(7 downto 0) when '1',
						(others => '0') when others;
		
	with state select
		out_datas(0)(15 downto 13) <= 	"000" when InsF,
								"001" when InsD,
								"010" when Exe,
								"011" when Mem1,
								"100" when Mem2,
								"101" when WriteB,
								"110" when Exc,
								"111" when others;
	with old_state select
		out_datas(0)(12 downto 10) <= 	"000" when InsF,
								"001" when InsD,
								"010" when Exe,
								"011" when Mem1,
								"100" when Mem2,
								"101" when WriteB,
								"110" when Exc,
								"111" when others;
	with next_state select
		out_datas(0)(9 downto 7) <= 	"000" when InsF,
								"001" when InsD,
								"010" when Exe,
								"011" when Mem1,
								"100" when Mem2,
								"101" when WriteB,
								"110" when Exc,
								"111" when others;
	out_datas(0)(6 downto 0) <= clks & cpu_clk & pc_sel & '0';
	out_datas(1) <= state_select & clock_inter_to_excep &
			serial_inter_to_excep & excep &
			serial_int & compare_int &
			mmu_ready & id_exc_code & mmu_exc_code &
			"000";
	out_datas(2) <= this_PC(31 downto 16);
	out_datas(3) <= this_PC(15 downto 0);
	out_datas(4) <= PC_to_mmu(31 downto 16);
	out_datas(5) <= PC_to_mmu(15 downto 0);
	out_datas(6) <= PCSrc(31 downto 16);
	out_datas(7) <= PCSrc(15 downto 0);
	out_datas(8) <= EPC(31 downto 16);
	out_datas(9) <= EPC(15 downto 0);
	out_datas(10) <= EBase(31 downto 16);
	out_datas(11) <= EBase(15 downto 0);
	out_datas(12) <= this_instr(31 downto 16);
	out_datas(13) <= this_instr(15 downto 0);
	out_datas(14) <= rs_addr & rt_addr & rd_addr & '0';
	out_datas(15) <= pc_op & comp_op & alu_ops & align_type;
	out_datas(16) <= immediate(31 downto 16);
	out_datas(17) <= immediate(15 downto 0);
	out_datas(30) <= mem_op & wb_op & cp0_op & tlbwi_enable &
					mem_write_enable & mem_read_enable & "0000";
	out_datas(18) <= rs_value(31 downto 16);
	out_datas(19) <= rs_value(15 downto 0);
	out_datas(20) <= rt_value(31 downto 16);
	out_datas(21) <= rt_value(15 downto 0);
	out_datas(22) <= alu_result(31 downto 16);
	out_datas(23) <= alu_result(15 downto 0);
	out_datas(24) <= addr_from_mem(31 downto 16);
	out_datas(25) <= addr_from_mem(15 downto 0);
	out_datas(26) <= write_value_from_mem(31 downto 16);
	out_datas(27) <= write_value_from_mem(15 downto 0);
	out_datas(28) <= RPC(31 downto 16);
	out_datas(29) <= RPC(15 downto 0);
	out_datas(31) <= write_addr_from_wb & write_enable_from_wb & normal_cp0_in(37 downto 32) & "0000";
	out_datas(32) <= write_value_from_wb(31 downto 16);
	out_datas(33) <= write_value_from_wb(15 downto 0);

	out_datas(34) <= normal_cp0_in(31 downto 16);
	out_datas(35) <= normal_cp0_in(15 downto 0);
	out_datas(36) <= from_exception_bad_v_addr(31 downto 16);
	out_datas(37) <= from_exception_bad_v_addr(15 downto 0);
	out_datas(38)(15 downto 12) <= from_exception_entry_hi(19 downto 16);
	out_datas(39)(11 downto 0) <= (others => '0');
	out_datas(40) <= from_exception_entry_hi(15 downto 0);
	out_datas(41) <= from_exception_cause &
					from_exception_intcode &
					compare_recover & "0000";
	out_datas(42) <= from_exception_epc(31 downto 16);
	out_datas(43) <= from_exception_epc(15 downto 0);
	out_datas(44) <= cp0_normal_value(31 downto 16);
	out_datas(45) <= cp0_normal_value(15 downto 0);
	out_datas(46) <= to_exception_bad_v_addr (31 downto 16);
	out_datas(47) <= to_exception_bad_v_addr (15 downto 0);
	out_datas(49)(15 downto 13) <= tlb_write_value (66 downto 64);
	out_datas(49)(12 downto 0) <= (others => '0');
	out_datas(50) <= tlb_write_value(63 downto 48);
	out_datas(51) <= tlb_write_value(47 downto 32);
	out_datas(52) <= tlb_write_value(31 downto 16);
	out_datas(53) <= tlb_write_value(15 downto 0);
	out_datas(48) <= (others => '0');
	out_datas(54) <= (others => '0');
	out_datas(55) <= (others => '0');
	out_datas(56) <= (others => '0');
	out_datas(57) <= (others => '0');
	out_datas(58) <= (others => '0');
	out_datas(59) <= (others => '0');
	out_datas(60) <= (others => '0');
	out_datas(61) <= (others => '0');
	out_datas(62) <= (others => '0');
	out_datas(63) <= (others => '0');


-- what should be changed after adding memory module
	instr_from_mmu <= in_data;
	data_from_mmu <= in_data;
	mmu_ready <= '1';
	serial_int <= '0';
	mmu_exc_code <= "000";

	
	RPC <= this_PC+4;
	normal_cp0_in <= cp0_op & instr_from_mmu(15 downto 11) & rt_value;
	-- index(66 downto 63) EntryHi(62 downto 44) EntryLo0(43 downto 24) DV(23 downto 22) EntryLo1(21 downto 2) DV(1 downto 0)
	--(0)(3 downto 0),(11)(31 downto 13),(2)(25 downto 6)(2 downto 1),(3)(25 downto 6)(2 downto 1)
	tlb_write_value <= cp0_values(3 downto 0) & cp0_values(383 downto 365) &
						cp0_values(89 downto 70) & cp0_values(66 downto 65) &
						cp0_values(121 downto 102) & cp0_values(98 downto 97);
	EPC <= cp0_values(543 downto 512);
	EBase <= cp0_values(607 downto 576);

	with old_state select
		--status:EXL(13)(1)=13*32+1=417
		clock_inter_to_excep <= compare_int and not cp0_values(417) when WriteB,
								'0' when others;
	with old_state select
		--status:EXL(13)(1)=13*32+1=417
		serial_inter_to_excep <= serial_int and not cp0_values(417) when WriteB,
								'0' when others;
	excep <= clock_inter_to_excep or serial_inter_to_excep or mmu_exc_code(0)
				or mmu_exc_code(1) or mmu_exc_code(2) or id_exc_code(0)
				or id_exc_code(1);
	state_select <= excep & mmu_ready;
	with state_select select
		state <= old_state when "00",
					next_state when "01",
					Exc when "10",
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
				--(11)(31 downto 12), 11*32+31=383, 11*32+12=364
				old_entry_hi => cp0_values(383 downto 364),
				--(15)(15 downto 10), 15*32+15=495, 15*32+10=490
				old_interrupt_code => cp0_values(495 downto 490),
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
                reg0=>reg0
                );
end bhv;

