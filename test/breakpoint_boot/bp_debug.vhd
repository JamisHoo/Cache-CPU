----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:46:29 12/08/2014 
-- Design Name: 
-- Module Name:    bp_debug - bhv 
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

entity bp_debug is
	port(
		clk : in std_logic;
		start : in std_logic;
		clk_o : out std_logic;
		e : in std_logic;
		slc : out  STD_LOGIC_VECTOR (7 downto 0);
      data : in  STD_LOGIC_VECTOR (7 downto 0);
		monitor : in std_logic_vector(63 downto 0);
		bp_in : in std_logic_vector(31 downto 0);
		check : out std_logic_vector(15 downto 0);
      serialport_txd : out  STD_LOGIC;
      serialport_rxd : in  STD_LOGIC
	);
end bp_debug;

architecture bhv of bp_debug is
component com_debug is
    Port ( clk : in  STD_LOGIC;
           high_freq_clk : in  STD_LOGIC;
           slc : out  STD_LOGIC_VECTOR (7 downto 0);
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           serialport_txd : out  STD_LOGIC;
           serialport_rxd : in  STD_LOGIC
			 );
end component;

signal com_debug_clk : std_logic;
signal m_clk_o : std_logic;
signal breakpoint : std_logic_vector(63 downto 0);
signal state : std_logic_vector(2 downto 0);
signal start_check : std_logic;
signal start_check_old : std_logic;
signal slc_debug : std_logic_vector(7 downto 0);
begin
	u_com_debug : com_debug port map( clk => com_debug_clk, high_freq_clk => clk,
									slc => slc_debug, data => data, serialport_txd => serialport_txd,
									serialport_rxd => serialport_rxd);
	check(2 downto 0) <= state;
	check (3) <= start_check;
	check (4) <= start_check_old;
	check (5) <= m_clk_o;
	check (6) <= com_debug_clk;
	check (14 downto 7) <= slc_debug;
	check (15) <= '0';
	clk_o <= m_clk_o;
	slc <= slc_debug;
	process(clk, e)
	begin
		if e = '0' then
			breakpoint <= (others => '0');
			m_clk_o <= '0';
			com_debug_clk <= '0';
			state <= (others => '0');
			start_check_old <= '0';
		elsif rising_edge(clk) then
			case state is
				when "000" =>
					com_debug_clk <= '1';
					state <= "001";
				when "001" =>
					if slc_debug = X"80" then
						start_check_old <= start_check;
						state <= "010";
						com_debug_clk <= '0';
					end if;
				when "010" =>
					if start_check /= start_check_old then
						state <= "011";
						breakpoint(31 downto 0) <= bp_in;
					end if;
				when "011" =>
					if monitor = breakpoint and m_clk_o = '0' then
						state <= "000";
					else
						m_clk_o <= not m_clk_o;
					end if;
				when others =>
			end case;
		end if;
	end process;

	process(start ,e)
	begin
		if e = '0' then
			start_check <= '0';
		elsif rising_edge(start) then
			start_check <= not start_check;
		end if;
	end process;

end bhv;

