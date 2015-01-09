library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


    
entity ram is
    Port(clock: in std_logic;
         reset: in std_logic;
         
         ope_addr: in std_logic_vector(19 downto 0);
         write_data: in std_logic_vector(31 downto 0);
         read_data: out std_logic_vector(31 downto 0);
         ope_we: in std_logic;
         ope_ce1: in std_logic;
         ope_ce2: in std_logic;
         
         baseram_addr: out std_logic_vector(19 downto 0);
         baseram_data: inout std_logic_vector(31 downto 0);
         baseram_ce: out std_logic;
         baseram_oe: out std_logic;
         baseram_we: out std_logic;
         
         extrram_addr: out std_logic_vector(19 downto 0);
         extrram_data: inout std_logic_vector(31 downto 0);
         extrram_ce: out std_logic;
         extrram_oe: out std_logic;
         extrram_we: out std_logic
         
    );
end ram;

architecture Behavioral of ram is
    signal state: std_logic_vector(4 downto 0);
    -- fsm: read ram 1: 00000 -> 00001 -> 00010 -> 00011 -> 00000
    --     write ram 1: 00000 -> 10000 -> 10010 -> 10011 -> 00000
    --      read ram 2: 00000 -> 01001 -> 01010 -> 01011 -> 00000
    --     write ram 2: 00000 -> 11000 -> 11010 -> 11011 -> 00000
begin
    process(clock, reset)
    begin
        if (reset = '0') then
            read_data <= (others => '0');
            baseram_addr <= (others => '0');
            extrram_addr <= (others => '0');
            state <= (others => '0');
            baseram_data <= (others => 'Z');
            extrram_data <= (others => 'Z');
            baseram_ce <= '1';
            extrram_ce <= '1';
            baseram_oe <= '1';
            extrram_oe <= '1';
            baseram_we <= '1';
            extrram_we <= '1';
        elsif (clock'event and clock = '1') then
            case state is
                when "00000" => baseram_data <= (others => 'Z');
                                extrram_data <= (others => 'Z');
                                if (ope_we = '1' and ope_ce1 = '1') then
                                    -- read base ram(ram1)
                                    state <= "00001";
                                elsif (ope_we = '0' and ope_ce1 = '1') then
                                    -- write base ram(ram1)
                                    state <= "10000";
                                elsif (ope_we = '1' and ope_ce2 = '1') then
                                    -- read extra ram(ram 2)
                                    state <= "01001";
                                elsif (ope_we = '0' and ope_ce2 = '1') then
                                    -- write extra ram(ram 2)
                                    state <= "11000";
                                else
                                    state <= "00000";
                                end if;
                -- read ram 1, stage 1, select ram, set read address
                when "00001" => baseram_ce <= '0';
                                baseram_oe <= '0';
                                baseram_addr <= ope_addr;
                                state <= "00010";
                -- read ram 1, stage 2, get read data
                when "00010" => read_data <= baseram_data;
                                state <= "00011";
                -- read ram 1, stage 3, unselect ram
                when "00011" => baseram_ce <= '1';
                                baseram_oe <= '1';
                                state <= "00000";
                -- write ram 1, stage 1, select ram, set write address and data
                when "10000" => baseram_oe <= '1';
                                baseram_ce <= '0';
                                baseram_we <= '1';
                                baseram_addr <= ope_addr;
                                baseram_data <= write_data;
                                state <= "10010";
                -- write ram 1, stage 2, write data
                when "10010" => baseram_we <= '0';
                                state <= "10011";
                -- write ram 1, stage 3, unselect ram
                when "10011" => baseram_we <= '1';
                                baseram_ce <= '1';
                                state <= "00000";
                -- read ram 2, stage 1, select ram, set read address
                when "01001" => extrram_ce <= '0';
                                extrram_oe <= '0';
                                extrram_addr <= ope_addr;
                                state <= "01010";
                -- read ram 2, stage 2, get read data
                when "01010" => read_data <= extrram_data;
                                state <= "01011";
                -- read ram 2, stage 3, unselect ram
                when "01011" => extrram_ce <= '1';
                                extrram_oe <= '1';
                                state <= "00000";
                -- write ram 2, stage 1, select ram, set write address and data
                when "11000" => extrram_oe <= '1';
                                extrram_ce <= '0';
                                extrram_we <= '1';
                                extrram_addr <= ope_addr;
                                extrram_data <= write_data;
                                state <= "11010";
                -- write ram 2, stage 2, write data
                when "11010" => extrram_we <= '0';
                                state <= "11011";
                -- write ram 2, stage 3, unselect ram
                when "11011" => extrram_we <= '1';
                                extrram_ce <= '1';
                                state <= "00000";
                when others =>  state <= (others => '0');
                                baseram_data <= (others => 'Z');
                                extrram_data <= (others => 'Z');
                                baseram_ce <= '1';
                                extrram_ce <= '1';
                                baseram_oe <= '1';
                                extrram_oe <= '1';
                                baseram_we <= '1';
                                extrram_we <= '1';
            end case;
        end if;
    end process;

end Behavioral;

