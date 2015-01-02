--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package IDecode_const is

constant ZERO32 : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
constant ZERO27 : std_logic_vector(26 downto 0) := "000000000000000000000000000";
constant ZERO16 : std_logic_vector(15 downto 0) := "0000000000000000";
constant ZERO6 : std_logic_vector(5 downto 0) := "000000";

constant ONE16 : std_logic_vector(15 downto 0) := "1111111111111111";
constant ONE6 : std_logic_vector(5 downto 0) := "111111";

constant F_ZERO : std_logic_vector(5 downto 0) :=   "000000";
constant L_ADDU : std_logic_vector(5 downto 0) := 	"100001";
constant L_SLT : std_logic_vector(5 downto 0) := 	"101010";
constant L_SLTU : std_logic_vector(5 downto 0) := 	"101011";
constant L_SUBU : std_logic_vector(5 downto 0) := 	"100011";
constant L_MULT : std_logic_vector(5 downto 0) := 	"011000";
constant L_MFLO : std_logic_vector(5 downto 0) := 	"010010";
constant L_MFHI : std_logic_vector(5 downto 0) := 	"010000";
constant L_MTLO : std_logic_vector(5 downto 0) := 	"010011";
constant L_MTHI : std_logic_vector(5 downto 0) := 	"010001";
constant L_JALR : std_logic_vector(5 downto 0) := 	"001001";
constant L_JR : std_logic_vector(5 downto 0) := 	"001000";
constant L_AND : std_logic_vector(5 downto 0) := 	"100100";
constant L_NOR : std_logic_vector(5 downto 0) := 	"100111";
constant L_OR : std_logic_vector(5 downto 0) := 	"100101";
constant L_XOR : std_logic_vector(5 downto 0) := 	"100110";
constant L_SLL : std_logic_vector(5 downto 0) := 	"000000";
constant L_SLLV : std_logic_vector(5 downto 0) := 	"000100";
constant L_SRA : std_logic_vector(5 downto 0) := 	"000011";
constant L_SRAV : std_logic_vector(5 downto 0) := 	"000111";
constant L_SRL : std_logic_vector(5 downto 0) := 	"000010";
constant L_SRLV : std_logic_vector(5 downto 0) := 	"000110";
constant L_SYSCALL : std_logic_vector(5 downto 0) :="001100";
constant F_ADDIU : std_logic_vector(5 downto 0) := "001001";
constant F_SLTI : std_logic_vector(5 downto 0) := 	"001010";
constant F_SLTIU : std_logic_vector(5 downto 0) := "001011";
constant F_ANDI : std_logic_vector(5 downto 0) := 	"001100";
constant F_LUI : std_logic_vector(5 downto 0) := 	"001111";
constant F_ORI : std_logic_vector(5 downto 0) := 	"001101";
constant F_XORI : std_logic_vector(5 downto 0) := 	"001110";
constant F_BEQ : std_logic_vector(5 downto 0) := 	"000100";
constant F_BGEZ : std_logic_vector(5 downto 0) := 	"000001";
constant F_BGTZ : std_logic_vector(5 downto 0) := 	"000111";
constant F_BLEZ : std_logic_vector(5 downto 0) := 	"000110";
constant F_BLTZ : std_logic_vector(5 downto 0) := 	"000001";
constant F_BNE : std_logic_vector(5 downto 0) := 	"000101";
constant F_J : std_logic_vector(5 downto 0) := 		"000010";
constant F_JAL : std_logic_vector(5 downto 0) := 	"000011";
constant F_LW : std_logic_vector(5 downto 0) := 	"100011";
constant F_SW : std_logic_vector(5 downto 0) := 	"101011";
constant F_LB : std_logic_vector(5 downto 0) := 	"100000";
constant F_LBU : std_logic_vector(5 downto 0) := 	"100100";
constant F_SB : std_logic_vector(5 downto 0) := 	"101000";
constant F_CACHE : std_logic_vector(5 downto 0) := "101111";
constant F_ERET : std_logic_vector(5 downto 0) := 	"010000";
constant F_MFC0 : std_logic_vector(5 downto 0) := 	"010000";
constant F_MTC0 : std_logic_vector(5 downto 0) := 	"010000";
constant F_TLBWI : std_logic_vector(5 downto 0) := "010000";
constant F_LHU : std_logic_vector(5 downto 0) := 	"100101";
constant L_ERET : std_logic_vector(5 downto 0) := 	"011000";
constant L_MFC0 : std_logic_vector(5 downto 0) := 	"000000";
constant L_MTC0 : std_logic_vector(5 downto 0) := 	"000000";
constant L_TLBWI : std_logic_vector(5 downto 0) := "000010";

constant WB_DISABLE : std_logic_vector(4 downto 0) := "11000";
constant MEM_DISABLE : std_logic_vector(2 downto 0) := "000";
constant ALU_DISABLE : std_logic_vector(8 downto 0) := "000000000";

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end IDecode_const;

package body IDecode_const is


---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end IDecode_const;
