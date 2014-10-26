----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:44:03 10/19/2014 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
	port(A: in std_logic_vector(31 downto 0);
		  B: in std_logic_vector(31 downto 0);
		  Sel: in std_logic_vector(3 downto 0);
		  Y: out std_logic_vector(31 downto 0)
	);
end alu;

architecture Behavioral of alu is

begin
	process(A, B, Sel)
	begin
		case Sel is
			-- addition A + B
			when "0000" => 
				Y <= std_logic_vector(unsigned(A) + unsigned(B));
			-- subtraction A - B
			when "0001" => 
				Y <= std_logic_vector(unsigned(A) + unsigned((not B)) + 1);
			-- increment A
			when "0010" =>
				Y <= std_logic_vector(unsigned(A) + 1);
			-- decrement A
			when "0011" =>
				Y <= std_logic_vector(unsigned(A) - 1);
			-- increment B
			when "0100" => 
				Y <= std_logic_vector(unsigned(B) + 1);
			-- decrement B
			when "0101" =>
				Y <= std_logic_vector(unsigned(B) - 1);
			-- transfer A
			when "0110" =>
				Y <= A;
			-- transfer B
			when "0111" => 
				Y <= B;
			-- NOT A
			when "1000" => 
				Y <= not A;
			-- NOT B
			when "1001" =>
				Y <= not B;
			-- A AND B
			when "1010" => 
				Y <= A and B;
			-- A OR B
			when "1011" =>
				Y <= A or B;
			-- A NAND B
			when "1100" =>
				Y <= A nand B;
			-- A NOR B 
			when "1101" =>
				Y <= A nor B;
			-- A EX-OR B
			when "1110" =>
				Y <= A xor B;
			-- A EX-NOR B
			when "1111" =>
				Y <= not( A xor B);
			-- uncertain
			when others =>
				Y <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
		end case;
	end process;

end Behavioral;

