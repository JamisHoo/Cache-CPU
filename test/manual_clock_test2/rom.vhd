library IEEE;
use IEEE.STD_LOGIC_1164.all;

package rom is

constant ROM_SIZE : integer := 17;
TYPE ROM is array(0 to ROM_SIZE - 1) of std_logic_vector(31 downto 0);

constant boot_rom : ROM := (
        X"24160001",
        X"0016b7c0",
        X"2415003f",
        X"aed50000",
        X"8ed40000",
        X"26d60004",
        X"26b50001",
        X"aed50000",
        X"8ed40000",
        X"26d60004",
        X"26b50001",
        X"aed50000",
        X"8ed40000",
        X"26d60004",
        X"26b50001",
        X"aed50000",
        X"8ed40000"
    ); 

end rom;


