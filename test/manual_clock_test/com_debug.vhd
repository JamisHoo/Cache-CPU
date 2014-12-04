library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity com_debug is
    Port ( clk : in  STD_LOGIC;
           high_freq_clk : in  STD_LOGIC;
           slc : out  STD_LOGIC_VECTOR (7 downto 0);
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           serialport_txd : out  STD_LOGIC;
           serialport_rxd : in  STD_LOGIC);
end com_debug;

architecture Behavioral of com_debug is
component async_transmitter
    port(clk: in std_logic; TxD_start: in std_logic; TxD_data: in std_logic_vector(7 downto 0); TxD: out std_logic; TxD_busy: out std_logic);
end component;

signal serialport_transmit_signal : std_logic := '0';
signal serialport_transmit_busy : std_logic := '0';
constant slc_max : std_logic_vector(7 downto 0) := X"0C";
signal slc_num : std_logic_vector(7 downto 0) := slc_max;

begin
    u1: async_transmitter port map(clk => high_freq_clk, Txd => serialport_txd, TxD_start => serialport_transmit_signal,TxD_data => data, Txd_busy => serialport_transmit_busy);
    
    slc <= slc_num;
    
    process (high_freq_clk) 
        variable state : integer := 0;
    begin
        if (rising_edge(high_freq_clk)) then
            if (clk = '0' and slc_num = slc_max) then
                slc_num <= X"00";
                -- goto wait 
                state := 2;
            end if;
            
            case (state) is
                when 0 =>
                    if (serialport_transmit_busy = '0' and unsigned(slc_num) < unsigned(slc_max)) then
                        serialport_transmit_signal <= '1';
                        state := 1;
                    end if;
                when 1 =>
                    serialport_transmit_signal <= '0';
                    slc_num <= std_logic_vector(unsigned(slc_num) + 1);
                    state := 0;
                -- wait for a certain num of cycles
                when 2 to 20000000 =>
                    state := state + 1;
                when others =>
                    state := 0;
            end case;
        end if;
    end process;
end Behavioral;

