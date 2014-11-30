----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:01:12 11/29/2014 
-- Design Name: 
-- Module Name:    general_register - Behavioral 
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
use work.common.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity general_register is
port(
    clk : IN STD_LOGIC;
	 state : in status;
	 rst : in std_logic;
	 
	 rs_addr : in std_logic_vector(4 downto 0);
	 rt_addr : in std_logic_vector(4 downto 0);
	 
	 write_addr : in std_logic_vector(4 downto 0);
	 write_value : in std_logic_vector(31 downto 0);
	 write_enable : in std_logic;
	 
	 rs_value : out std_logic_vector(31 downto 0);
	 rt_value : out std_logic_vector(31 downto 0)
	 
);
end general_register;

architecture Behavioral of general_register is

	type register_block is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal reg : register_block;
	signal state_reg : status;
    
begin

	process(clk)
	begin
		if clk'event and clk = '1' then
			state_reg <= state;
		end if;
	end process;
    
	process(clk)
	begin
		if clk'event and clk = '1' and rst = '1' then
			if state = InsD then
				rs_value <= reg(conv_integer(rs_addr));
				rt_value <= reg(conv_integer(rt_addr));
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if clk'event and clk = '0' and state_reg = WriteB then
			if write_enable = '1' then
				reg(conv_integer(write_addr)) <= write_value;
			end if;
		end if;
	end process;
	
end Behavioral;

