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
use work.common.all;

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
		state : in status;
		exception_e : in std_logic;
		mmu_exc_code : in std_logic_vector(2 downto 0);
		serial_int : in std_logic;
		compare_interrupt : in std_logic;
		id_exc_code : in std_logic_vector(1 downto 0);
		pc_in : in std_logic_vector(31 downto 0);
		v_addr_in : in std_logic_vector(31 downto 0);
		old_entry_hi : in std_logic_vector(19 downto 0);
		old_interrupt_code : in std_logic_vector(5 downto 0);
		
		bad_v_addr_out : out std_logic_vector(31 downto 0);
		entry_hi_out : out std_logic_vector(19 downto 0);
		interrupt_start_out : out std_logic;
		cause_out : out std_logic_vector(4 downto 0);
		interrupt_code_out : out std_logic_vector(5 downto 0);
		epc_out : out std_logic_vector(31 downto 0);
		pc_sel0 : out std_logic
		);
end Exception;

architecture bhv of Exception is
signal m_bad_v_addr : std_logic_vector(31 downto 0);
signal m_entry_hi : std_logic_vector(19 downto 0);
signal m_interrupt_start : std_logic;
signal m_cause : std_logic_vector(4 downto 0);
signal m_interrupt_code : std_logic_vector(5 downto 0);
signal m_epc : std_logic_vector(31 downto 0);
signal m_pc_sel0 : std_logic;
begin
	bad_v_addr_out <= m_bad_v_addr;
	entry_hi_out <= m_entry_hi;
	interrupt_start_out <= m_interrupt_start;
	cause_out <= m_cause;
	interrupt_code_out <= m_interrupt_code;
	epc_out <= m_epc;
	pc_sel0 <= m_pc_sel0;
	
	process(clk)
	begin
		if exception_e = '0' then
			m_interrupt_start <= '0';
			m_pc_sel0 <= '0';
		elsif rising_edge(clk) then
			if state = Exc then
				m_interrupt_start <= '1';
				m_pc_sel0 <= '1';
				m_epc <= pc_in;
				if mmu_exc_code = "000" then
					m_bad_v_addr <= pc_in;
				else
					m_bad_v_addr <= v_addr_in;
				end if;
				if mmu_exc_code = "010" or mmu_exc_code = "011" then
					m_entry_hi <= v_addr_in ( 31 downto 12);
				else
					m_entry_hi <= old_entry_hi;
				end if;
			else
				m_interrupt_start <= '0';
				m_pc_sel0 <= '0';
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if rising_edge(clk) and exception_e = '1' then
			if mmu_exc_code = "000" then
				if id_exc_code = "00" then
					if serial_int = '0' then
						if compare_interrupt = '1' then
							m_cause <= "00000";
							m_interrupt_code <= "100000";
						end if;
					elsif serial_int = '1' then
						m_cause <= "00000";
						m_interrupt_code <= "000100";
					end if;
				elsif id_exc_code = "01" then
					m_interrupt_code <= old_interrupt_code;
					m_cause <= "01000";
				elsif id_exc_code = "10" then
					m_interrupt_code <= old_interrupt_code;
					m_cause <= "01010";
				end if;
			else
				m_interrupt_code <= old_interrupt_code;
				case mmu_exc_code is
					when "001" =>
						m_cause <= "00001";
					when "010" =>
						m_cause <= "00010";
					when "011" =>
						m_cause <= "00011";
					when "100" =>
						m_cause <= "00100";
					when "101" =>
						m_cause <= "00101";
					when others =>
				end case;
			end if;
		end if;
	end process;
	
end bhv;

