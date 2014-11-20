----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:47:38 11/18/2014 
-- Design Name: 
-- Module Name:    tlb_test - Behavioral 
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
use work.common.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tlb_test is
port(
	clk : in std_logic;
	input : in std_logic_vector(31 downto 0);
	tlb_write_enable : in std_logic;
	tlb_write_struct : in std_logic_vector(tlb_write_struct_width-1 downto 0);
	output : out std_logic_vector(31 downto 0);
	dirty : out std_logic
);
end tlb_test;

architecture Behavioral of tlb_test is

	type tlb_mem_block is array(tlb_num_entry-1 downto 0) of std_logic_vector(tlb_entry_width-1 downto 0);
	signal tlb_mem : tlb_mem_block;
		
	signal tlb_which_equal : std_logic_vector(tlb_num_entry-1 downto 0);
	signal tlb_which_low : std_logic_vector(tlb_num_entry*2-1 downto 0);
	
	type tlb_low_temp_value_block is array(20 downto 0) of std_logic_vector(tlb_num_entry*2-1 downto 0);
	signal tlb_low_temp_value : tlb_low_temp_value_block;
	
	signal tlb_lookup_result : std_logic_vector(20 downto 0);
	
begin
	
	-- tlb_equal : for i in range tlb_num_entry-1 downto 0 generate
	--		tlb_which_equal <= (tlb_mem(0)(62 downto 44) = input(31 downto 13));
	--	end generate tlb_equal;
	
	-- tlbwi
	process(clk)
		variable tlb_index : integer range 15 downto 0 := 0;
	begin
		if clk'event and clk = '1' then
			if tlb_write_enable = '1' then
				tlb_index := conv_integer(tlb_write_struct(tlb_write_struct_width - 1 downto tlb_write_struct_width - tlb_index_width));
				tlb_mem(tlb_index) <= tlb_write_struct(tlb_write_struct_width - tlb_index_width - 1 downto 0);
			end if;
		end if;
	end process;
	
	-- tlb_equal
	process(clk)
	begin
	if clk'event and clk = '1' then
		if ( (tlb_mem(0)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(0) <= '1';
		else tlb_which_equal(0) <= '0';		end if;
		if ( (tlb_mem(1)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(1) <= '1';
		else tlb_which_equal(1) <= '0';		end if;
		if ( (tlb_mem(2)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(2) <= '1';
		else tlb_which_equal(2) <= '0';		end if;
		if ( (tlb_mem(3)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(3) <= '1';
		else tlb_which_equal(3) <= '0';		end if;
	
		if ( (tlb_mem(4)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(4) <= '1';
		else tlb_which_equal(4) <= '0';		end if;
		if ( (tlb_mem(5)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(5) <= '1';
		else tlb_which_equal(5) <= '0';		end if;
		if ( (tlb_mem(6)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(6) <= '1';
		else tlb_which_equal(6) <= '0';		end if;
		if ( (tlb_mem(7)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(7) <= '1';
		else tlb_which_equal(7) <= '0';		end if;
	
		if ( (tlb_mem(8)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(8) <= '1';
		else tlb_which_equal(8) <= '0';		end if;
		if ( (tlb_mem(9)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(9) <= '1';
		else tlb_which_equal(9) <= '0';		end if;
		if ( (tlb_mem(10)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(10) <= '1';
		else tlb_which_equal(10) <= '0';		end if;
		if ( (tlb_mem(11)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(11) <= '1';
		else tlb_which_equal(11) <= '0';		end if;
	
		if ( (tlb_mem(12)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(12) <= '1';
		else tlb_which_equal(12) <= '0';		end if;
		if ( (tlb_mem(13)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(13) <= '1';
		else tlb_which_equal(13) <= '0';		end if;
		if ( (tlb_mem(14)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(14) <= '1';
		else tlb_which_equal(14) <= '0';		end if;
		if ( (tlb_mem(15)(62 downto 44) = input(31 downto 13)) ) then tlb_which_equal(15) <= '1';
		else tlb_which_equal(15) <= '0';		end if;
	end if;
	end process;
	
	tlb_check : for i in tlb_num_entry-1 downto 0 generate
		tlb_which_low(i*2) <= tlb_which_equal(i) and tlb_mem(i)(0) and (not input(12));		-- which EntryLo is selected?
		tlb_which_low(i*2+1) <= tlb_which_equal(i) and tlb_mem(i)(22) and input(12);
	
		tlb_temp : for j in 20 downto 0 generate
			tlb_low_temp_value(j)(i*2) <= tlb_which_low(i*2) and tlb_mem(i)(j+1);
			tlb_low_temp_value(j)(i*2+1) <= tlb_which_low(i*2+1) and tlb_mem(i)(j+23);
		end generate tlb_temp;
	end generate tlb_check;
		
	tlb_result : for i in 20 downto 0 generate
		tlb_lookup_result(i) <= tlb_low_temp_value(i)(0) or tlb_low_temp_value(i)(1) or tlb_low_temp_value(i)(2) or tlb_low_temp_value(i)(3) or
										tlb_low_temp_value(i)(4) or tlb_low_temp_value(i)(5) or tlb_low_temp_value(i)(6) or tlb_low_temp_value(i)(7) or
										tlb_low_temp_value(i)(8) or tlb_low_temp_value(i)(9) or tlb_low_temp_value(i)(10) or tlb_low_temp_value(i)(11) or
										tlb_low_temp_value(i)(12) or tlb_low_temp_value(i)(13) or tlb_low_temp_value(i)(14) or tlb_low_temp_value(i)(15) or
										
										tlb_low_temp_value(i)(16) or tlb_low_temp_value(i)(17) or tlb_low_temp_value(i)(18) or tlb_low_temp_value(i)(19) or
										tlb_low_temp_value(i)(20) or tlb_low_temp_value(i)(21) or tlb_low_temp_value(i)(22) or tlb_low_temp_value(i)(23) or
										tlb_low_temp_value(i)(24) or tlb_low_temp_value(i)(25) or tlb_low_temp_value(i)(26) or tlb_low_temp_value(i)(27) or
										tlb_low_temp_value(i)(28) or tlb_low_temp_value(i)(29) or tlb_low_temp_value(i)(30) or tlb_low_temp_value(i)(31);
	end generate tlb_result;
		
		
	output(31 downto 12) <= tlb_lookup_result(20 downto 1);
	output(11 downto 0 ) <= input(11 downto 0);
	dirty <= tlb_lookup_result(0);
	
end Behavioral;
