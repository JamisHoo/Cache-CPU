----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:42:31 11/27/2014 
-- Design Name: 
-- Module Name:    Exception - bhv 
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

entity Exception is
	port(
		clk : in std_logic;
		state : in std_logic_vector( 3 downto 0 );
		exception_e : in std_logic;
		bad_v_addr_in : in std_logic_vector(31 downto 0);
		entry_hi_in : in std_logic_vector(19 downto 0);
		cause_in : in std_logic_vector(4 downto 0);
		interrupt_cause_in : in std_logic_vector(5 downto 0);
		epc_in : in std_logic_vector(31 downto 0);
		
		bad_v_addr_out : out std_logic_vector(31 downto 0);
		entry_hi_out : out std_logic_vector(19 downto 0);
		interrupt_start_out : out std_logic;
		cause_out : out std_logic_vector(4 downto 0);
		interrupt_cause_out : out std_logic_vector(5 downto 0);
		epc_out : out std_logic_vector(31 downto 0);
		pc_sel0 : out std_logic
		);
end Exception;

architecture bhv of Exception is
signal m_bad_v_addr : std_logic_vector(31 downto 0);
signal m_entry_hi : std_logic_vector(19 downto 0);
signal m_interrupt_start : std_logic;
signal m_cause : std_logic_vector(4 downto 0);
signal m_interrupt_cause : std_logic_vector(5 downto 0);
signal m_epc : std_logic_vector(31 downto 0);
signal m_pc_sel0 : std_logic;
begin
	bad_v_addr_out <= m_bad_v_addr;
	entry_hi_out <= m_entry_hi;
	interrupt_start_out <= m_interrupt_start;
	cause_out <= m_cause;
	interrupt_cause_out <= m_interrupt_cause;
	epc_out <= m_epc;
	pc_sel0 <= m_pc_sel0;
	
	process(clk)
	begin
		if exception_e = '0' then
			m_interrupt_start <= '0';
			m_pc_sel0 <= '0';
		elsif rising_edge(clk) then
			--question state number for exception
			if state = "1100" then
				m_interrupt_start <= '1';
				m_pc_sel0 <= '1';
				m_bad_v_addr <= bad_v_addr_in;
				m_entry_hi <= entry_hi_in;
				m_cause <= cause_in;
				m_interrupt_cause <= interrupt_cause_in;
				m_epc <= epc_in;
			else
				m_pc_sel0 <= '0';
			end if;
		end if;
	end process;
	
end bhv;

