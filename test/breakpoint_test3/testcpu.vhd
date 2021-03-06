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
		manual_clk : in std_logic;
		e : in std_logic;
		in_data : in std_logic_vector(31 downto 0);
		check : out std_logic_vector(15 downto 0);
      
            	   -- ports connected with ram
	   baseram_addr: out std_logic_vector(19 downto 0);
	   baseram_data: inout std_logic_vector(31 downto 0);
	   baseram_ce: out std_logic;
	   baseram_oe: out std_logic;
	   baseram_we: out std_logic;
	   extrram_addr: out std_logic_vector(19 downto 0);
	   extrram_data: inout std_logic_vector(31 downto 0);
	   extrram_ce: out std_logic;
	   extrram_oe: out std_logic;
	   extrram_we: out std_logic;

	   -- ports connected with flash
	   flash_addr : out  STD_LOGIC_VECTOR (22 downto 0);
	   flash_data : inout  STD_LOGIC_VECTOR (15 downto 0);
	   flash_control_ce0 : out  STD_LOGIC;
	   flash_control_ce1 : out  STD_LOGIC;
	   flash_control_ce2 : out  STD_LOGIC;
	   flash_control_byte : out  STD_LOGIC;
	   flash_control_vpen : out  STD_LOGIC;
	   flash_control_rp : out  STD_LOGIC;
	   flash_control_oe : out  STD_LOGIC;
	   flash_control_we : out  STD_LOGIC;
   
   		-- ports connected with serial port
      serialport_txd : out  STD_LOGIC;
      serialport_rxd : in  STD_LOGIC;
      usb_serialport_txd : out std_logic;
      usb_serialport_rxd : in std_logic
		);
end testcpu;

architecture bhv of testcpu is
component cacpu is
	port(
		clk : in std_logic;
		e : in std_logic;
		in_data : in std_logic_vector(31 downto 0);
		select_data : in std_logic_vector(8 downto 0);
		out_data : out std_logic_vector(7 downto 0);
		monitor : out std_logic_vector(63 downto 0);
      
      	   -- ports connected with ram
	   baseram_addr: out std_logic_vector(19 downto 0);
	   baseram_data: inout std_logic_vector(31 downto 0);
	   baseram_ce: out std_logic;
	   baseram_oe: out std_logic;
	   baseram_we: out std_logic;
	   extrram_addr: out std_logic_vector(19 downto 0);
	   extrram_data: inout std_logic_vector(31 downto 0);
	   extrram_ce: out std_logic;
	   extrram_oe: out std_logic;
	   extrram_we: out std_logic;

	   -- ports connected with flash
	   flash_addr : out  STD_LOGIC_VECTOR (22 downto 0);
	   flash_data : inout  STD_LOGIC_VECTOR (15 downto 0);
	   flash_control_ce0 : out  STD_LOGIC;
	   flash_control_ce1 : out  STD_LOGIC;
	   flash_control_ce2 : out  STD_LOGIC;
	   flash_control_byte : out  STD_LOGIC;
	   flash_control_vpen : out  STD_LOGIC;
	   flash_control_rp : out  STD_LOGIC;
	   flash_control_oe : out  STD_LOGIC;
	   flash_control_we : out  STD_LOGIC;
		
      -- no serial port in cacpu during test
      serialport_txd : out STD_LOGIC;
      serialport_rxd : in STD_LOGIC

		);
end component;
component bp_debug is
	port(
		clk : in std_logic;
		start : in std_logic;
		clk_o : out std_logic;
		e : in std_logic;
		slc : out  STD_LOGIC_VECTOR (8 downto 0);
      data : in  STD_LOGIC_VECTOR (7 downto 0);
		monitor : in std_logic_vector(63 downto 0);
		bp_in : in std_logic_vector(31 downto 0);
		check : out std_logic_vector(15 downto 0);
      serialport_txd : out  STD_LOGIC;
      serialport_rxd : in  STD_LOGIC
	);
end component;

signal send_data : std_logic_vector(7 downto 0);
signal select_data : std_logic_vector(8 downto 0);
signal m_monitor : std_logic_vector(63 downto 0);
signal bp_clk : std_logic;

signal in_data_reg : std_logic_vector(31 downto 0);

begin
	u1: cacpu port map(clk=>bp_clk, e=>e,in_data=>in_data,
							select_data => select_data,out_data=>send_data,
                     monitor => m_monitor,
                     baseram_addr=>baseram_addr, baseram_data=>baseram_data,
								baseram_ce=>baseram_ce, baseram_oe=>baseram_oe,
								baseram_we=>baseram_we, extrram_addr=>extrram_addr,
								extrram_data=>extrram_data, extrram_ce=>extrram_ce,
								extrram_oe=>extrram_oe, extrram_we=>extrram_we,
								
								flash_addr=>flash_addr, flash_data=>flash_data,
								flash_control_ce0=>flash_control_ce0, flash_control_ce1=>flash_control_ce1,
								flash_control_ce2=>flash_control_ce2, flash_control_byte=>flash_control_byte,
								flash_control_vpen=>flash_control_vpen, flash_control_rp=>flash_control_rp,
								flash_control_oe=>flash_control_oe, flash_control_we=>flash_control_we,
                                
                                serialport_txd=>usb_serialport_txd,
                                serialport_rxd=>usb_serialport_rxd
                     );
                     
                 --in_data(31 downto 29) : status
                 --x"8001"&"0" : memory addr high
                 --
    in_data_reg <= in_data(2 downto 0) & "0000000000000" & in_data(31 downto 16);
    
	u2: bp_debug port map(clk => clk,start => manual_clk,
							clk_o => bp_clk, e => e,
							slc => select_data,data => send_data,
							monitor => m_monitor, bp_in => in_data_reg,
							check => check,
							serialport_txd => serialport_txd,
							serialport_rxd => serialport_rxd);							
	
end bhv;

