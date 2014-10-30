----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:27:42 10/30/2014 
-- Design Name: 
-- Module Name:    cpld - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpld is
    -- TODO: clk useful?
    Port ( --clk : in  STD_LOGIC;
           rxd : in  STD_LOGIC;
           txd : out  STD_LOGIC;
           pass_rxd : out  STD_LOGIC;
           pass_txd : in  STD_LOGIC);
end cpld;

architecture Behavioral of cpld is

begin
pass_rxd <= rxd;
txd <= pass_txd;

end Behavioral;

