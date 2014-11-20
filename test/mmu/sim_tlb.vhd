--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:19:49 11/20/2014
-- Design Name:   
-- Module Name:   E:/MIPS/tlb_test/sim_tlb_test.vhd
-- Project Name:  tlb_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: tlb_test
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.common.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY sim_tlb_test IS
END sim_tlb_test;
 
ARCHITECTURE behavior OF sim_tlb_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT tlb_test
    PORT(
         clk : IN  std_logic;
         input : IN  std_logic_vector(31 downto 0);
         tlb_write_enable : IN  std_logic;
         tlb_write_struct : IN  std_logic_vector(66 downto 0);
         output : OUT  std_logic_vector(31 downto 0);
         dirty : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal input : std_logic_vector(31 downto 0) := (others => '0');
   signal tlb_write_enable : std_logic := '0';
   signal tlb_write_struct : std_logic_vector(66 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(31 downto 0);
   signal dirty : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: tlb_test PORT MAP (
          clk => clk,
          input => input,
          tlb_write_enable => tlb_write_enable,
          tlb_write_struct => tlb_write_struct,
          output => output,
          dirty => dirty
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      tlb_write_enable <= '0';
		wait for clk_period * 20;
		tlb_write_enable <= '1';
		wait for clk_period;
   end process;

END;
