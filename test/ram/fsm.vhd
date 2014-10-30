----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:59:10 10/25/2014 
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
    Port ( clock : in  STD_LOGIC;
           cpu_clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ope : in  STD_LOGIC_VECTOR (31 downto 0);
           step: out std_logic_vector(6 downto 0);
          
           display: out std_logic_vector(15 downto 0);
           
           baseram_addr: out std_logic_vector(19 downto 0);
           baseram_data: inout std_logic_vector(31 downto 0);
           baseram_ce: out std_logic;
           baseram_oe: out std_logic;
           baseram_we: out std_logic
    );
end fsm;

architecture Behavioral of fsm is
component ram
    Port(clock: in std_logic;
         reset: in std_logic;
         
         ope_addr: in std_logic_vector(19 downto 0);
         write_data: in std_logic_vector(31 downto 0);
         read_data: out std_logic_vector(31 downto 0);
         ope_we: in std_logic;
         
         enable: in std_logic;
         
         baseram_addr: out std_logic_vector(19 downto 0);
         baseram_data: inout std_logic_vector(31 downto 0);
         baseram_ce: out std_logic;
         baseram_oe: out std_logic;
         baseram_we: out std_logic
    );
end component;

signal ope_addr: std_logic_vector(19 downto 0);
signal write_data: std_logic_vector(31 downto 0);
signal read_data: std_logic_vector(31 downto 0);
signal ope_we: std_logic;

signal ram_clk: std_logic := '1';

signal enable: std_logic := '0';

begin
    display <= read_data(15 downto 0);
    
    u1: ram port map(clock => cpu_clk, reset => reset, enable => enable,
                     ope_addr => ope_addr, write_data => write_data, 
                     read_data => read_data, ope_we => ope_we,
                     baseram_addr => baseram_addr, baseram_data => baseram_data,
                     baseram_ce => baseram_ce, baseram_oe => baseram_oe,
                     baseram_we => baseram_we);
                     

     
     process(clock, reset) 
        variable state: integer:= 0;
     begin
        case state is
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

        if (clock'event and clock = '1') then
            -- step 0, input write address
            if (state = 0) then
                ope_addr <= ope(19 downto 0);
            end if;
            -- step 1, input write data
            if (state = 1) then 
                write_data <= ope;
            end if;
            -- step 2, write data
            if (state = 2) then
                enable <= '1';
                ope_we <= '0';
            end if;
            -- step 3, remove write signal
            if (state = 3) then
                enable <= '0';
                ope_we <= '1';
            end if;
            -- step 4, input read address
            if (state = 4) then
                ope_addr <= ope(19 downto 0);
            end if;
            -- step 5, read data
            if (state = 5) then
                enable <= '1';
                ope_we <= '1';
            end if;
            -- step 6, remove read signal
            if (state = 6) then
                enable <= '0';
            end if;
            
            state := state + 1;
            if (state = 7) then
                state := 0;
            end if;
        end if;
        
        if (reset = '0' and (state = 0 or state = 4)) then
            state := 0;
        end if;
        
     end process;

end Behavioral;

