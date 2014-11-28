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

package common is
type status is (InsF, InsD, Exe, Mem1, Mem2, WriteB, Exc);

constant TLB_ENTRY_WIDTH :	integer := 63;
constant TLB_NUM_ENTRY : integer := 16;
constant TLB_INDEX_WIDTH : integer := 4;
constant TLB_WRITE_STRUCT_WIDTH : integer := TLB_ENTRY_WIDTH + TLB_INDEX_WIDTH;

constant VIRTUAL_SERIAL_DATA : std_logic_vector(31 downto 0) := x"bFD003F8";
constant VIRTUAL_SERIAL_STATUS : std_logic_vector(31 downto 0) := x"bFD003FC";
constant PHYSICAL_SERIAL_DATA : std_logic_vector(31 downto 0) := x"1FD003F8";
constant PHYSICAL_SERIAL_STATUS : std_logic_vector(31 downto 0) := x"1FD003FC";

constant NO_MEM_EXC : std_logic_vector(2 downto 0) := "000";
constant TLB_MODIFIED : std_logic_vector(2 downto 0) := "001";
constant TLB_L : std_logic_vector(2 downto 0) := "010";
constant TLB_S : std_logic_vector(2 downto 0) := "011";
constant ADE_L : std_logic_vector(2 downto 0) := "100";
constant ADE_S : std_logic_vector(2 downto 0) := "101";

constant ALIGN_TYPE_QUAD : std_logic_vector(1 downto 0) := "00";
constant ALIGN_TYPE_WORD : std_logic_vector(1 downto 0) := "01";
constant ALIGN_TYPE_BYTE : std_logic_vector(1 downto 0) := "10";

constant INVALID_CONTENT : std_logic_vector(31 downto 0) := x"FFFFFFFF";

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

end common;

package body common is

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
 
end common;
