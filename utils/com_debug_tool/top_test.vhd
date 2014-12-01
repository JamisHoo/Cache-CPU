
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_test is
    Port ( low_freq_clk : in  STD_LOGIC;
           high_freq_clk : in  STD_LOGIC;
           led : out STD_LOGIC_VECTOR(7 downto 0);
           dailing_switch : in std_logic_vector(31 downto 0);
           serialport_rxd : in  STD_LOGIC;
           serialport_txd : out  STD_LOGIC);
end top_test;

architecture Behavioral of top_test is
component com_debug is
    Port ( clk : in  STD_LOGIC;
           high_freq_clk : in  STD_LOGIC;
           slc : out  STD_LOGIC_VECTOR (7 downto 0);
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           serialport_txd : out  STD_LOGIC;
           serialport_rxd : in  STD_LOGIC);
end component;

signal slc: std_logic_vector(7 downto 0);
signal regs: std_logic_vector(63 downto 0) := X"fedcba9876543210";
signal transmit_data : std_logic_vector(7 downto 0);

begin
    u1: com_debug port map(clk => low_freq_clk, high_freq_clk => high_freq_clk, 
                           slc => slc, data => transmit_data,
                           serialport_txd => serialport_txd, serialport_rxd => serialport_rxd);
    with (slc(7 downto 0)) select
    transmit_data <= regs(7 downto 0)   when X"00",
                     regs(15 downto 8)  when X"01",
                     regs(23 downto 16) when X"02",
                     regs(31 downto 24) when X"03",
                     regs(39 downto 32) when X"04",
                     regs(47 downto 40) when X"05",
                     regs(55 downto 48) when X"06",
                     regs(63 downto 56) when X"07",
                     dailing_switch(7 downto 0)   when X"08",
                     dailing_switch(15 downto 8)  when X"09",
                     dailing_switch(23 downto 16) when X"0A",
                     dailing_switch(31 downto 24) when X"0B",
                     X"F0" when others;
    led <= slc;
    
    
end Behavioral;
