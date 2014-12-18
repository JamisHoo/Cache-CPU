----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:59:19 11/16/2014 
-- Design Name: 
-- Module Name:    CP0 - bhv 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.common.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CP0 is
	port(
		clk: in std_logic;
		state: in status;
		cp0_e : in std_logic;
		normal_cp0_in : in std_logic_vector(37 downto 0);
		bad_v_addr_in : in std_logic_vector(31 downto 0);
		entry_hi_in : in std_logic_vector(19 downto 0);
		interrupt_start_in : in std_logic;
		cause_in : in std_logic_vector(4 downto 0);
		interrupt_code_in : in std_logic_vector(5 downto 0);
		epc_in : in std_logic_vector(31 downto 0);
		eret_enable : in std_logic;
		compare_init: in std_logic;

		addr_value : out std_logic_vector(31 downto 0);
		all_regs : out std_logic_vector(1023 downto 0);
		compare_interrupt: out std_logic
		);
end CP0;

architecture bhv of CP0 is

type register_bank is array (31 downto 0) of std_logic_vector(31 downto 0);
signal register_values : register_bank;
signal m_addr_value: std_logic_vector(31 downto 0);
signal m_compare_interrupt : std_logic;
signal m_rd_address : std_logic_vector(4 downto 0);
signal old_compare : std_logic_vector(31 downto 0);
constant num_one : std_logic_vector(31 downto 0) := x"00000001";

begin
	
	addr_value <= m_addr_value;
	compare_interrupt <= m_compare_interrupt;
	all_regs(31 downto 0) <= register_values(0);
	all_regs(63 downto 32) <= register_values(1);
	all_regs(95 downto 64) <= register_values(2);
	all_regs(127 downto 96) <= register_values(3);
	all_regs(159 downto 128) <= register_values(4);
	all_regs(191 downto 160) <= register_values(5);
	all_regs(223 downto 192) <= register_values(6);
	all_regs(255 downto 224) <= register_values(7);
	all_regs(287 downto 256) <= register_values(8);
	all_regs(319 downto 288) <= register_values(9);
	all_regs(351 downto 320) <= register_values(10);
	all_regs(383 downto 352) <= register_values(11);
	all_regs(415 downto 384) <= register_values(12);
	all_regs(447 downto 416) <= register_values(13);
	all_regs(479 downto 448) <= register_values(14);
	all_regs(511 downto 480) <= register_values(15);
	all_regs(543 downto 512) <= register_values(16);
	all_regs(575 downto 544) <= register_values(17);
	all_regs(607 downto 576) <= register_values(18);
	all_regs(639 downto 608) <= register_values(19);
	all_regs(671 downto 640) <= register_values(20);
	all_regs(703 downto 672) <= register_values(21);
	all_regs(735 downto 704) <= register_values(22);
	all_regs(767 downto 736) <= register_values(23);
	all_regs(799 downto 768) <= register_values(24);
	all_regs(831 downto 800) <= register_values(25);
	all_regs(863 downto 832) <= register_values(26);
	all_regs(895 downto 864) <= register_values(27);
	all_regs(927 downto 896) <= register_values(28);
	all_regs(959 downto 928) <= register_values(29);
	all_regs(991 downto 960) <= register_values(30);
	all_regs(1023 downto 992) <= register_values(31);
	
	process(clk)
	begin
		if cp0_e='0' then
			for i in 0 to 31 loop
				register_values(i) <= (others => '0');
			end loop;
			--Compare init
			register_values(11) <=x"11111111";
			for i in 13 to 17 loop
				register_values(i) <= (others => '0');
			end loop;
			--EBase init
         register_values(15) <= x"80000180";
         for i in 19 to 31 loop
				register_values(i) <= (others => '0');
			end loop;
			m_addr_value <= (others => '0');
			old_compare <= (others => '0');
			m_compare_interrupt <= '0';
			m_rd_address <= (others => '0');
		elsif rising_edge(clk) then
			if state = InsD then
				m_addr_value <= register_values(conv_integer(normal_cp0_in(36 downto 32)));
				m_rd_address <= normal_cp0_in(36 downto 32);
			end if;
			if state = Exe and eret_enable = '1' then
				register_values(12)(1) <= '0';
			elsif state = Exe and normal_cp0_in(37) = '1' then
				register_values(conv_integer(m_rd_address)) <= normal_cp0_in(31 downto 0);
			elsif state = InsF and interrupt_start_in = '1' then
				register_values(8) <= bad_v_addr_in;
				register_values(10)(31 downto 12) <= entry_hi_in;
				register_values(12)(1) <= '1';
				register_values(13)(6 downto 2) <= cause_in;
				register_values(13)(15 downto 10) <= interrupt_code_in;
				register_values(14) <= epc_in;
				if compare_init = '1' then
					register_values(9) <= (others => '0');
				end if;
			elsif register_values(11) /= old_compare then
				register_values(9) <= (others => '0');
			elsif state = WriteB and m_compare_interrupt = '0' then
				register_values(9) <= register_values(9) + num_one;
			end if;
			--question lack of compare_interrupt recover enable
			if register_values(11) /= old_compare then
				old_compare <= register_values(11);
				m_compare_interrupt <= '0';
			elsif compare_init = '1' then
				m_compare_interrupt <= '0';
			elsif register_values(11) <= register_values(9) then
				m_compare_interrupt <= '1';
			end if;
		end if;
	end process;


end bhv;

