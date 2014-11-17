----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:53:47 11/17/2014 
-- Design Name: 
-- Module Name:    ram_test - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram_test is
port(
	clka : IN STD_LOGIC;
   input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
   output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	step : out std_logic_vector(6 downto 0)
);
end ram_test;

architecture Behavioral of ram_test is

component insideRAM
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);			-- '1' write_enable, '0' read_enable
    addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);			-- address
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);			-- data in
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)		-- data out
  );
END component;

signal st : integer := 0;
signal wea : std_logic_vector(0 downto 0) := "1";
signal addra : std_logic_vector(3 downto 0) := "0000";

begin

	u1 : insideRAM port map (clka => clka, wea => wea, addra => addra, dina => input, douta => output);
		
	process(clka)
	begin
		case st is
            when 0 => step <= "0111111";
            when 1 => step <= "0000110";
            when 2 => step <= "1011011";
            when 3 => step <= "1001111";
            when 4 => step <= "1100110";
            when 5 => step <= "1101101";
            when 6 => step <= "1111101";
            when 7 => step <= "0000111";
            when 8 => step <= "1111111";
            when 9 => step <= "1101111";
            when others => step <= "0000000";
       end case;
       
		if clka'event and clka = '1' then
			if st = 0 then
				wea <= "1";
				addra <= "0001";				
			end if;
			
			if st = 1 then
				wea <= "1";
				addra <= "0010";				
			end if;
			
			if st = 2 then
				wea <= "0";
				addra <= "0010";				
			end if;
			
			if st = 3 then
				wea <= "0";
				addra <= "0001";
			end if;
			
			if st = 4 then
				wea <= "0";
				addra <= "0000";
			end if;
			
			if st = 5 then
				wea <= "1";
				addra <= "0000";
			end if;
			
			st <= st + 1;
			if st = 5 then
				st <= 0;
			end if;
			
		end if;
	end process;
	
end Behavioral;
