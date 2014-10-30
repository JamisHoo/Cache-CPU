----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:52:28 10/25/2014 
-- Design Name: 
-- Module Name:    ram - Behavioral 
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

    
    
entity ram is
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
end ram;

architecture Behavioral of ram is
    signal state: std_logic_vector(4 downto 0);
    -- fsm: read: 00000 -> 00001 -> 00010 -> 00011 -> 00000
    --     write: 00000 -> 10000 -> 10010 -> 10011 -> 00000
begin
    process(clock, reset)
    begin
        if (reset = '0') then
            read_data <= (others => '0');
            baseram_addr <= (others => '0');
            state <= (others => '0');
            baseram_data <= (others => 'Z');
            baseram_ce <= '1';
            baseram_oe <= '1';
            baseram_we <= '1';
        elsif (clock'event and clock = '1') then
            case state is
                when "00000" => baseram_data <= (others => 'Z');
                                if (ope_we = '1' and enable = '1') then
                                    -- read
                                    state <= "00001";
                                elsif (ope_we = '0' and enable = '1') then
                                    -- write
                                    state <= "10000";
                                else
                                    state <= "00000";
                                end if;
                -- read stage 1, select ram, set read address
                when "00001" => baseram_ce <= '0';
                                baseram_oe <= '0';
                                baseram_addr <= ope_addr;
                                state <= "00010";
                -- read stage 2, get read data
                when "00010" => read_data <= baseram_data;
                                state <= "00011";
                -- read stage 3, unselect ram
                when "00011" => baseram_ce <= '1';
                                baseram_oe <= '1';
                                state <= "00000";
                -- write stage 1, select ram, set write address and data
                when "10000" => baseram_oe <= '1';
                                baseram_ce <= '0';
                                baseram_we <= '1';
                                baseram_addr <= ope_addr;
                                baseram_data <= write_data;
                                state <= "10010";
                -- write stage 2, write data
                when "10010" => baseram_we <= '0';
                                state <= "10011";
                -- write stage 3, unselect ram
                when "10011" => baseram_we <= '1';
                                baseram_ce <= '1';
                                state <= "00000";
                when others =>  state <= (others => '0');
                                baseram_data <= (others => 'Z');
                                baseram_ce <= '1';
                                baseram_oe <= '1';
                                baseram_we <= '1';
            end case;
        end if;
    end process;

end Behavioral;

