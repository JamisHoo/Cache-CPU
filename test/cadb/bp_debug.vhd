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
		slc : out  STD_LOGIC_VECTOR (15 downto 0);
      data : in  STD_LOGIC_VECTOR (7 downto 0);
		monitor : in std_logic_vector(63 downto 0);
		check : out std_logic_vector(15 downto 0);
      serialport_txd : out  STD_LOGIC;
      serialport_rxd : in  STD_LOGIC
	);
end bp_debug;

architecture bhv of bp_debug is
component com_debug is
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
           data_coming : out STD_LOGIC;
           -- data coming from serial port, get ready when data_coming is set to 1
           -- reserve until when is not for sure.
           coming_data : out STD_LOGIC_VECTOR(135 downto 0);
           data_read : in STD_LOGIC
         );
end component;

signal com_debug_clk : std_logic;
signal m_clk_o : std_logic;
signal m_clk_o1 : std_logic;
signal m_clk_o2 : std_logic;
signal breakpoint : std_logic_vector(63 downto 0);
signal compare : std_logic_vector(63 downto 0);
signal state : std_logic_vector(2 downto 0);
signal debug_slc : std_logic_vector(15 downto 0);
signal debug_data_coming : std_logic;
signal debug_data_in : std_logic_vector(135 downto 0);
signal debug_data_read : std_logic;
signal run_step : std_logic_vector(63 downto 0);
begin
	u_com_debug : com_debug port map( clk => com_debug_clk, high_freq_clk => clk,
									slc => debug_slc, data => data, serialport_txd => serialport_txd,
									serialport_rxd => serialport_rxd,data_coming => debug_data_coming,
									coming_data => debug_data_in, data_read => debug_data_read);
	check(2 downto 0) <= state;
    check(3) <= '0';
    check(7 downto 4) <= breakpoint(3 downto 0);
    check(11 downto 8) <= compare(3 downto 0);
    check(15 downto 12) <= monitor(3 downto 0);
	clk_o <= m_clk_o;
	m_clk_o <= m_clk_o1 xor m_clk_o2;
	slc <= debug_slc;
	process(clk, e)
	begin
		if e = '0' then
			breakpoint <= (others => '0');
			compare <= (others => '1');
			m_clk_o1 <= '0';
			com_debug_clk <= '0';
			state <= (others => '0');
			run_step <= (others => '0');
		elsif rising_edge(clk) then
			case state is
				when "000" =>
					debug_data_read <= '0';
					com_debug_clk <= '1';
					state <= "001";
				when "001" =>
					debug_data_read <= '0';
					if debug_slc(2) = '1' then
						com_debug_clk <= '0';
					end if;
					if com_debug_clk = '0' and debug_data_coming = '1' then
						state <= "010";
					end if;
				when "010" =>
					debug_data_read <= '1';
					case debug_data_in(7 downto 0) is
						when x"01" =>
							state <= "011";
						when x"02" =>
							state <= "001";
							breakpoint <= debug_data_in(71 downto 8);
							compare <= debug_data_in(135 downto 72);
						when x"03" =>
							state <= "100";
						when x"04" =>
							state <= "101";
							run_step <= debug_data_in(71 downto 8);
						when others =>
							state <= "000";
					end case;
				when "011" =>
					if m_clk_o = '0' then
						if ((monitor xor breakpoint) and compare)= x"00000000" then
							state <= "000";
						else
							m_clk_o1 <= not m_clk_o1;
						end if;
					end if;
				when "100" =>
					if m_clk_o = '0' then
						m_clk_o1 <= not m_clk_o1;
						state <= "011";
					end if;
				when "101" =>
					if m_clk_o = '0' then
						if run_step= x"00000000" then
							state <= "000";
						else
							run_step <= run_step - 1;
							m_clk_o1 <= not m_clk_o1;
						end if;
					end if;
				when others =>
			end case;
		end if;
	end process;
	
	process(clk, e)
	begin
		if e = '0' then
			m_clk_o2 <= '0';
		elsif falling_edge(clk) then
			if (state = "011" or state = "101") and m_clk_o = '1' then
				m_clk_o2 <= not m_clk_o2;
			end if;
		end if;
	end process;

end bhv;

