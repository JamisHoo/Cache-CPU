----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:05:43 10/19/2014 
-- Design Name: 
-- Module Name:    fsm - Behavioral 
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

entity fsm is
    Port ( clock: in  STD_LOGIC;
           reset: in  STD_LOGIC;
           input: in  STD_LOGIC_VECTOR (31 downto 0);
           output: out  STD_LOGIC_VECTOR (31 downto 0);
           step: out std_logic_vector(6 downto 0)
    );
end fsm;

architecture Behavioral of fsm is
component ALU
	port(A: in std_logic_vector(31 downto 0);
         B: in std_logic_vector(31 downto 0);
		 Sel: in std_logic_vector(3 downto 0);
	     Y: out std_logic_vector(31 downto 0)
	);
end component;

signal A: std_logic_vector(31 downto 0);
signal B: std_logic_vector(31 downto 0);
signal Sel: std_logic_vector(3 downto 0);
signal Y: std_logic_vector(31 downto 0);

begin
	u1: ALU port map(A => A, B => B, Sel => Sel, Y => Y);

	process (clock)
		variable state: integer := 0;
	begin
        -- output state indication
        case state is
            when 0 => step <= "0111111";
            when 1 => step <= "0000110";
            when 2 => step <= "1011011";
            when 3 => step <= "1001111";
            when others => step <= "1111111";
        end case;
        
        if (clock'event and clock = '1') then
            if (state = 0) then
                A <= input;
            end if;
            if (state = 1) then
                B <= input;
            end if;
            if (state = 2) then
                sel(3 downto 0) <= input(3 downto 0);
            end if;
            if (state = 3) then
                output <= Y;
            else 
                output <= "00000000000000000000000000000000";
            end if;
            
            state := state + 1;
            if (state = 4) then
                state := 0;
            end if;
        end if;
        
	end process;

end Behavioral;

