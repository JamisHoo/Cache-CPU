----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:45:17 11/13/2014 
-- Design Name: 
-- Module Name:    IFetch - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.common.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
port(
	clk : in std_logic;
	state : in status;
	rst : in std_logic;
	mmu_ready : in std_logic;
	
	PCSrc : in std_logic_vector(31 downto 0);
	EBase : in std_logic_vector(31 downto 0);
	EPC : in std_logic_vector(31 downto 0);
	pc_sel : in std_logic_vector(1 downto 0);		-- eret_enable, pc_control
	
	PC : out std_logic_vector(31 downto 0);		-- register, with sequential logic
	PCmmu : out std_logic_vector(31 downto 0)		-- combinatory, for mmu
);
end IFetch;

architecture Behavioral of IFetch is
	signal PCReg : std_logic_vector(31 downto 0) := x"00000000";
	
begin
	-- always
	PC <= PCReg;
	
   -- set original pc as the beginning of ROM
	PCmmu <= x"90000000"
					when rst = '0'
            else EPC
					when pc_sel(1) = '1' and rst = '1'
            else EBase
					when pc_sel(1 downto 0) = "01" and rst = '1'
				else PCSrc;
				
	-- sequential logic
	process(clk, rst)
	begin
		if rst = '0' then
         -- set original pc as the beginning of ROM
			PCReg <= x"90000000";
			
		elsif clk'event and clk = '1' then
			if state = InsF and mmu_ready = '1' then
				if pc_sel(1) = '0' then				-- eret_enable
					if pc_sel(0) = '1' then			-- pc_control
						PCReg <= EBase;
					else
						PCReg <= PCSrc;
					end if;
				else
					PCReg <= EPC;
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;
