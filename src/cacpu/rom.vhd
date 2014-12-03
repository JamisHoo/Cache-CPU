library IEEE;
use IEEE.STD_LOGIC_1164.all;

package rom is

constant ROM_SIZE : integer := 3;
TYPE ROM is array(0 to ROM_SIZE - 1) of std_logic_vector(31 downto 0);

constant boot_rom : ROM := (X"12345678", X"abcdabcd", X"AAAAAAAA"); 

end rom;


