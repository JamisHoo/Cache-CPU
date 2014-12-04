----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:58:57 11/30/2014 
-- Design Name: 
-- Module Name:    testcpu - bhv 
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testcpu is
	port(
		clk : in std_logic;
		e : in std_logic;
		in_data : in std_logic_vector(31 downto 0);
		out_data : out std_logic_vector(15 downto 0)
		);
end testcpu;

architecture bhv of testcpu is
component cacpu is
	port(
		clk : in std_logic;
		e : in std_logic;
		in_data : in std_logic_vector(31 downto 0);
		select_data : in std_logic_vector(31 downto 0);
		out_data : out std_logic_vector(15 downto 0)
		);
end component;
component com_debug is
    Port ( clk : in  STD_LOGIC;
           high_freq_clk : in  STD_LOGIC;
           slc : out  STD_LOGIC_VECTOR (7 downto 0);
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           serialport_txd : out  STD_LOGIC;
           serialport_rxd : in  STD_LOGIC);
end component;

begin
	u1: cacpu port map(clk=>clk,e=>e,in_data=>in_data,
							select_data => in_data,out_data=>out_data);
	
end bhv;

