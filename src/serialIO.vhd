----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:37:48 10/30/2014 
-- Design Name: 
-- Module Name:    serialIO - Behavioral 
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

entity serialIO is
    Port ( clk : in  STD_LOGIC;
           rxd : in  STD_LOGIC;
           txd : out  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (7 downto 0);
           input : in  STD_LOGIC_VECTOR (7 downto 0)
          );
end serialIO;

architecture Behavioral of serialIO is
signal rxd_data_ready: std_logic;
signal rxd_data: std_logic_vector(7 downto 0);


component async_receiver
    port(clk: in std_logic;
         RxD: in std_logic;
         RxD_data_ready: out std_logic;
         RxD_data: out std_logic_vector(7 downto 0)
    );
end component;

component async_transmitter
    port(clk: in std_logic;
         TxD_start: in std_logic;
         TxD_data: in std_logic_vector(7 downto 0);
         TxD: out std_logic;
         TxD_busy: out std_logic
        );
end component;

begin
    u1: async_receiver port map(clk => clk, RxD => rxd, 
                                RxD_data_ready => rxd_data_ready,
                                RxD_data => rxd_data
                                );
    u2: async_transmitter port map(clk => clk, TxD => txd,
                                   TxD_start => rxd_data_ready, TxD_data => input
                                  );
    
    
    process (clk)
    begin
        if (rxd_data_ready = '1') then
            output <= rxd_data;
        end if;
    end process;
    
end Behavioral;

