library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity cadb is
    port(
        clk : in std_logic;
        rst : in std_logic;
        led1: out std_logic_vector(6 downto 0);
        led2: out std_logic_vector(6 downto 0);
        serialport_txd : out std_logic;
        serialport_rxd : in std_logic
        );
end cadb;

architecture bhv of cadb is
component clock is
    port(clk: in std_logic;
         rst: in std_logic;
         led1: out std_logic_vector(6 downto 0);
         led2: out std_logic_vector(6 downto 0);
         out_datas: out STD_LOGIC_VECtOR(4095 downto 0);
         monitor: out STD_LOGIC_VECTOR(63 downto 0)
        );
end component;
component bp_debug is
    port(
        clk : in std_logic;
        clk_o : out std_logic;
        e : in std_logic;
        datas : in  STD_LOGIC_VECTOR (4095 downto 0);
        monitor : in std_logic_vector(63 downto 0);
        serialport_txd : out  STD_LOGIC;
        serialport_rxd : in  STD_LOGIC
    );
end component;

signal send_data : std_logic_vector(4095 downto 0);
signal m_monitor : std_logic_vector(63 downto 0);
signal bp_clk : std_logic;

begin
    u1: clock port map(clk => bp_clk, rst => rst, led1 => led1, led2 => led2,
                       out_datas => send_data, monitor => m_monitor
                      );

    u2: bp_debug port map(clk => clk, 
                          clk_o => bp_clk, e => rst,
                          datas => send_data,
                          monitor => m_monitor,
                          serialport_txd => serialport_txd,
                          serialport_rxd => serialport_rxd
                          );                            
    
end bhv;

