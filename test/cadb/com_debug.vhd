library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity com_debug is
    Port ( 
           -- debug tool start fetching data when clk is 1
           clk : in  STD_LOGIC;
           high_freq_clk : in  STD_LOGIC;
           -- upper level give data according to slc value
           slc : out  STD_LOGIC_VECTOR (15 downto 0);
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           -- communicate with serial port
           serialport_txd : out  STD_LOGIC;
           serialport_rxd : in  STD_LOGIC;
           
           -- set to 1 when data coming from serial port, reserve for 1 high_freq_clk cycle
           data_coming : out STD_LOGIC := '0';
           -- data coming from serial port, get ready when data_coming is set to 1
           -- reserve until when is not for sure.
           coming_data : out STD_LOGIC_VECTOR(135 downto 0);
           data_read : in STD_LOGIC
         );
end com_debug;

architecture Behavioral of com_debug is
component async_transmitter
    port(clk: in std_logic; TxD_start: in std_logic; TxD_data: in std_logic_vector(7 downto 0); TxD: out std_logic; TxD_busy: out std_logic);
end component;

component async_receiver
    port(clk: in std_logic; RxD: in std_logic; RxD_data_ready: out std_logic; RxD_data: out std_logic_vector(7 downto 0));
end component;


signal serialport_transmit_signal : std_logic := '0';
signal serialport_transmit_busy : std_logic := '0';
constant slc_max : std_logic_vector(15 downto 0) := X"0200";
signal slc_num : std_logic_vector(15 downto 0) := slc_max;

signal coming_data_buff : std_logic_vector(7 downto 0);
signal serialport_receive_signal : std_logic;
begin
    u1: async_transmitter port map(clk => high_freq_clk, Txd => serialport_txd, TxD_start => serialport_transmit_signal,TxD_data => data, Txd_busy => serialport_transmit_busy);
    u2: async_receiver port map(clk => high_freq_clk, Rxd => serialport_rxd, RxD_data_ready => serialport_receive_signal, RxD_data => coming_data_buff);
    
    slc <= slc_num;
    
    process (high_freq_clk) 
        variable count : integer := 0;
    begin
        if (rising_edge(high_freq_clk)) then
            if (serialport_receive_signal = '1') then
                case (count) is
                    when  0 => coming_data(  7 downto   0) <= coming_data_buff;
                    when  1 => coming_data( 15 downto   8) <= coming_data_buff;
                    when  2 => coming_data( 23 downto  16) <= coming_data_buff;
                    when  3 => coming_data( 31 downto  24) <= coming_data_buff;
                    when  4 => coming_data( 39 downto  32) <= coming_data_buff;
                    when  5 => coming_data( 47 downto  40) <= coming_data_buff;
                    when  6 => coming_data( 55 downto  48) <= coming_data_buff;
                    when  7 => coming_data( 63 downto  56) <= coming_data_buff;
                    when  8 => coming_data( 71 downto  64) <= coming_data_buff;
                    when  9 => coming_data( 79 downto  72) <= coming_data_buff;
                    when 10 => coming_data( 87 downto  80) <= coming_data_buff;
                    when 11 => coming_data( 95 downto  88) <= coming_data_buff;
                    when 12 => coming_data(103 downto  96) <= coming_data_buff;
                    when 13 => coming_data(111 downto 104) <= coming_data_buff;
                    when 14 => coming_data(119 downto 112) <= coming_data_buff;
                    when 15 => coming_data(127 downto 120) <= coming_data_buff;
                    when 16 => coming_data(135 downto 128) <= coming_data_buff;

                    when others => NULL;
                end case;
                count := count + 1;
                if (count = 17) then
                    count := 0;
                    data_coming <= '1';
                end if;
            end if;
            if (data_read = '1') then
                data_coming <= '0';
            end if;
        end if;
    end process;
    
    process (high_freq_clk) 
        variable state : integer := 0;
        variable after_falling_edge : std_logic := '1';
    begin
        if (rising_edge(high_freq_clk)) then
            if (clk = '1' and slc_num = slc_max and after_falling_edge = '1') then
                slc_num <= (others => '0');
                state := 0;
                after_falling_edge := '0';
            elsif (clk = '0') then
                after_falling_edge := '1';
            end if;
            
            case (state) is
                when 0 =>
                    state := state + 1;
                when 1 =>
                    if (serialport_transmit_busy = '0' and unsigned(slc_num) < unsigned(slc_max)) then
                        serialport_transmit_signal <= '1';
                        state := state + 1;
                    end if;
                when 2 =>
                    serialport_transmit_signal <= '0';
                    slc_num <= std_logic_vector(unsigned(slc_num) + 1);
                    state := 0;

                when others =>
                    state := 0;
            end case;
        end if;
    end process;
end Behavioral;

