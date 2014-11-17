----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:25:15 11/13/2014 
-- Design Name: 
-- Module Name:    IDecode - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.common.ALL;
use work.IDecode_const.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IDecode is
port(
	clk : in std_logic;
	state : in status;
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
	wb_op : out std_logic_vector(5 downto 0);
	cp0_op : out std_logic_vector(1 downto 0);
	
	tlbwi_enable : out std_logic
);
end IDecode;

architecture Behavioral of IDecode is
	
	signal ins_reg : std_logic_vector(31 downto 0);
	
	signal pc_op_reg : std_logic_vector(1 downto 0);
	signal eret_enable_reg : std_logic;
	signal comp_op_reg : std_logic_vector(2 downto 0);
	
	signal imme_reg : std_logic_vector(31 downto 0);
	signal alu_ops_reg : std_logic_vector(8 downto 0);		-- alu_srcA, alu_srcB, alu_op
	
	signal mem_op_reg : std_logic_vector(2 downto 0);		-- mem_read, mem_write, mem_value
	signal wb_op_reg : std_logic_vector(5 downto 0);		-- reg_dst, reg_value, reg_write
	signal cp0_op_reg : std_logic_vector(1 downto 0);		-- epc_value, cp0_write
	
	signal tlbwi_enable_reg : std_logic;
	
begin
	
	-- input to output
	-- make sure these will be ready before InsD clk
	rs_addr <= instruction(25 downto 21);
	rt_addr <= instruction(20 downto 16);
	rd_addr <= instruction(15 downto 11);
	
	-- register to output
	instr_out <= ins_reg;
	
	pc_op <= pc_op_reg;
	eret_enable <= eret_enable_reg;
	comp_op <= comp_op_reg;
	
	imme <= imme_reg;
	alu_ops <= alu_ops_reg;
	
	mem_op <= mem_op_reg;
	wb_op <= wb_op_reg;
	cp0_op <= cp0_op_reg;
	
	tlbwi_enable <= tlbwi_enable_reg;
	
	-- decode special control sequences
	process(clk)
		variable First : std_logic_vector(5 downto 0);
		variable Last : std_logic_vector(5 downto 0);
		variable Ins23 : std_logic;
	begin
		First := instruction(31 downto 26);
		Last := instruction(5 downto 0);
		Ins23 := instruction(23);		-- mfc0 & mtc0
		
		if clk'event and clk = '1' then
			if state = InsD then
			
				ins_reg <= instruction;
				
				-- generate eret_enable
				if First = F_ERET and Last = L_ERET then
					eret_enable_reg <= '1';
				else
					eret_enable_reg <= '0';
				end if;
				
				-- generate tlbwi_enable
				if First = F_TLBWI and Last = L_TLBWI then
					tlbwi_enable_reg <= '1';
				else
					tlbwi_enable_reg <= '0';
				end if;
				
				-- generate comp_op
				case First is
					when F_BEQ => comp_op_reg <= "000";
					when F_BGEZ => 
											if instruction(16) = '1' then		-- bgez
												comp_op_reg <= "001";
											else								-- bltz
												comp_op_reg <= "100";
											end if;
					when F_BGTZ => comp_op_reg <= "010";
					when F_BLEZ => comp_op_reg <= "011";
					when F_BNE => comp_op_reg <= "101";
					when others => comp_op_reg <= "000";
				end case;
				
				-- generate cp0_op
				if First = F_ZERO and Last = L_SYSCALL then
					cp0_op_reg <= "10";
				elsif First = F_MTC0 and Last = L_MTC0 and Ins23 = '1' then		-- mtc0
					cp0_op_reg <= "01";
				else
					cp0_op_reg <= "00";
				end if;
			
			end if;
		end if;
	end process;


	-- decode other control sequences
	process(clk)
		variable First : std_logic_vector(5 downto 0);
		variable Last : std_logic_vector(5 downto 0);
	begin
		First := instruction(31 downto 26);
		Last := instruction(5 downto 0);
		
		if clk'event and clk = '1' then
			if state = InsD then
			
			-- generate pc_op
			case First is
				when F_ZERO =>  case Last is
											when L_JALR => pc_op_reg <= "11";
											when L_JR => pc_op_reg <= "11";
											when others => pc_op_reg <= "00";
										end case;
				when F_BEQ => pc_op_reg <= "01";
				when F_BGEZ => pc_op_reg <= "01";       -- bgez & bltz
				when F_BGTZ => pc_op_reg <= "01";
				when F_BLEZ => pc_op_reg <= "01";
				when F_BNE => pc_op_reg <= "01";
				when F_J => pc_op_reg <= "10";
				when F_JAL => pc_op_reg <= "10";
				when others => pc_op_reg <= "00";
			end case;
			
			-- generate immediate
			if First = F_ZERO then
				if Last = L_SLL or Last = L_SRA or Last = L_SRL then        -- shift extend
					imme_reg(31 downto 5) <= ZERO27;
					imme_reg(4 downto 0) <= instruction(10 downto 6);
				else
					imme_reg <= ZERO32;
				end if;
			elsif First = F_SLTIU or First = F_ANDI or First = F_ORI or First = F_XORI then
				imme_reg(31 downto 16) <= ZERO16;							-- zero extend
				imme_reg(15 downto 0) <= instruction(15 downto 0);
			elsif First = F_J or First = F_JAL then
				imme_reg(25 downto 0) <= instruction(25 downto 0);          -- jump extend
				if instruction(25) = '1' then
					imme_reg(31 downto 26) <= ONE6;
				elsif instruction(25) = '0' then
					imme_reg(31 downto 26) <= ZERO6;
				end if;
			else
				imme_reg(15 downto 0) <= instruction(15 downto 0);		-- signed extend
				if instruction(15) = '1' then
					imme_reg(31 downto 16) <= ONE16;
				else
					imme_reg(31 downto 16) <= ZERO16;
				end if;
			end if;
			
			-- generate mem_op
			case First is
				when F_ZERO => mem_op_reg <= MEM_DISABLE;
				when F_LW => mem_op_reg <= "100";
				when F_LB => mem_op_reg <= "100";
				when F_LBU => mem_op_reg <= "100";
				when F_LHU => mem_op_reg <= "100";
				when F_SW => mem_op_reg <= "010";
				when F_SB => mem_op_reg <= "111";
				when others => mem_op_reg <= MEM_DISABLE;
			end case;
			
			-- generate wb_op
			case First is
				when F_ZERO =>  case Last is
											when L_JALR => wb_op_reg <= "100101";
											when L_JR => wb_op_reg <= WB_DISABLE;
											when L_MULT => wb_op_reg <= WB_DISABLE;
											when L_MTLO => wb_op_reg <= WB_DISABLE;
											when L_MTHI => wb_op_reg <= WB_DISABLE;
											when others => wb_op_reg <= "010001";
										end case;
				-- addiu, slti, sltiu, andi, lui, ori, xori
				when F_ADDIU => wb_op_reg <= "000001";
				when F_SLTI => wb_op_reg <= "000001";
				when F_SLTIU => wb_op_reg <= "000001";
				when F_ANDI => wb_op_reg <= "000001";
				when F_LUI => wb_op_reg <= "000001";
				when F_ORI => wb_op_reg <= "000001";
				when F_XORI => wb_op_reg <= "000001";
				
				when F_JAL => wb_op_reg <= "100101";
				when F_LW => wb_op_reg <= "000011";
				when F_LB => wb_op_reg <= "001001";
				when F_LBU => wb_op_reg <= "000111";
				when F_SB => wb_op_reg <= "001000";
				when F_LHU => wb_op_reg <= "001011";
				when F_MFC0 => 	if instruction(23) = '0' then		-- mfc0
											wb_op_reg <= "001101";
										else						-- mtc0
											wb_op_reg <= WB_DISABLE;
										end if;
				-- beq, bgez, bgtz, blez, bltz, bne, j, sw, cache, eret, mtc0, tlbwi
				when others => wb_op_reg <= WB_DISABLE;
			end case;
			
			
			-- generate alu_ops
			case First is
				when F_ZERO => 
										case Last is
											when L_ADDU => alu_ops_reg <= "000000000";
											when L_SLT => alu_ops_reg <= "000001010";
											when L_SLTU => alu_ops_reg <= "000001011";
											when L_SUBU => alu_ops_reg <= "000000001";
											when L_MULT => alu_ops_reg <= "000010000";
											when L_MFLO => alu_ops_reg <= "000010001";
											when L_MFHI => alu_ops_reg <= "000010010";
											when L_MTLO => alu_ops_reg <= "000010011";
											when L_MTHI => alu_ops_reg <= "000010100";
											when L_JALR => alu_ops_reg <= "001000000";
											when L_JR => alu_ops_reg <= "001000000";
											when L_AND => alu_ops_reg <= "000000011";
											when L_NOR => alu_ops_reg <= "000000110";
											when L_OR => alu_ops_reg <= "000000100";
											when L_XOR => alu_ops_reg <= "000000101";
											when L_SLL => alu_ops_reg <= "010000111";
											when L_SLLV => alu_ops_reg <= "000000111";
											when L_SRA => alu_ops_reg <= "010001000";
											when L_SRAV => alu_ops_reg <= "000001000";
											when L_SRL => alu_ops_reg <= "010001001";
											when L_SRLV => alu_ops_reg <= "000001001";
				
											when L_SYSCALL => alu_ops_reg <= ALU_DISABLE;
                                            
											when others => alu_ops_reg <= ALU_DISABLE;			-- not defined, cause exception
										end case;
			
				when F_ADDIU => alu_ops_reg <= "000100000";
				when F_SLTI => alu_ops_reg <= "000101010";
				when F_SLTIU => alu_ops_reg <= "000101011";
				when F_ANDI => alu_ops_reg <= "000100011";
				when F_LUI => alu_ops_reg <= "110000111";
				when F_ORI => alu_ops_reg <= "000100100";
				when F_XORI => alu_ops_reg <= "000100101";
				when F_BEQ => alu_ops_reg <= "000000010";
				when F_BNE => alu_ops_reg <= "000000010";
				when F_BGEZ => alu_ops_reg <= "001000001";
				when F_BGTZ => alu_ops_reg <= "001000001";
				when F_BLEZ => alu_ops_reg <= "001000001";
				when F_LW => alu_ops_reg <= "000100000";
				when F_SW => alu_ops_reg <= "000100000";
				when F_LB => alu_ops_reg <= "000100000";
				when F_LBU => alu_ops_reg <= "000100000";
				when F_SB => alu_ops_reg <= "000100000";
				when F_LHU => alu_ops_reg <= "000100000";
				
				when F_J => alu_ops_reg <= ALU_DISABLE;
				when F_JAL => alu_ops_reg <= ALU_DISABLE;
				when F_CACHE => alu_ops_reg <= ALU_DISABLE;
				when F_ERET => alu_ops_reg <= ALU_DISABLE; 	-- eret, mfc0, mtc0, tlbwi
				
				when others => alu_ops_reg <= ALU_DISABLE; 		-- not defined, cause exception
			end case;
			
			end if;
		end if;
	end process;
	
end Behavioral;
