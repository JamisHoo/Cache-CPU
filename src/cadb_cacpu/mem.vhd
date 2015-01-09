library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.common.ALL;



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
	signal select_byte : std_logic_vector(31 downto 0);
	
begin
	
	write_enable <= mem_op(1)
							when rst = '1'
						 else '0'
							when rst = '0';
							
	read_enable <= mem_op(2)
							when rst = '1'
						 else '0'
							when rst = '0';
						 
	addr_mmu <= result;
	
	with result(1 downto 0) select
		select_byte <= mmu_value(31 downto 8) & rt_value(7 downto 0) 
								when "00",
							mmu_value(31 downto 16) & rt_value(7 downto 0) & mmu_value(7 downto 0)
								when "01",
							mmu_value(31 downto 24) & rt_value(7 downto 0) & mmu_value(15 downto 0)
								when "10",
							rt_value(7 downto 0) & mmu_value(23 downto 0)
								when "11";
							
	write_value <= rt_value
							when mem_op(0) = '0'
						else select_byte;
end Behavioral;
