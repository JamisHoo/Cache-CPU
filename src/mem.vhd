----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:01:03 11/18/2014 
-- Design Name: 
-- Module Name:    mem - Behavioral 
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
use work.common.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem is
port(
	-- clk : in std_logic;
	-- state : in status;
	
	rst : in std_logic;
		
	result : in std_logic_vector(31 downto 0);		-- address from alu
	
	rt_value : in std_logic_vector(31 downto 0);
	mmu_value : in std_logic_vector(31 downto 0);
	
	-- mem_read, mem_write, mem_value
	mem_op : in std_logic_vector(2 downto 0);
	
	addr_mmu : out std_logic_vector(31 downto 0);
	write_value : out std_logic_vector(31 downto 0);
	
	write_enable : out std_logic;
	read_enable : out std_logic
);

end mem;

architecture Behavioral of mem is

begin
	
	write_enable <= mem_op(1);
	read_enable <= mem_op(2);
	addr_mmu <= result;
	
	write_value <= rt_value
						when mem_op(0) = '0'
						else mmu_value;

end Behavioral;
