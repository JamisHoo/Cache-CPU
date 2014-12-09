library IEEE;
use IEEE.STD_LOGIC_1164.all;

package rom is

constant ROM_SIZE : integer := 22;
TYPE ROM is array(0 to ROM_SIZE - 1) of std_logic_vector(31 downto 0);

constant boot_rom : ROM := (
X"241000be",
X"00108600",
X"8e110000",
X"8e120004",
X"00129400",
X"02328825",
X"26100008",
X"24120008",
X"00129700",
X"8e130000",
X"8e140004",
X"0014a400",
X"02749825",
X"ae530000",
X"26520004",
X"26100008",
X"2631ffff",
X"1e20fff7",
X"bf000000",
X"bf000000",
X"1210fffe",
X"bf000000"

    ); 

end rom;


