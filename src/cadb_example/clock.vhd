library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock is
    Port (clk: in  STD_LOGIC;
          rst: in  STD_LOGIC;
          led1: out  STD_LOGIC_VECTOR (6 downto 0);
          led2: out  STD_LOGIC_VECTOR (6 downto 0);
          
          out_datas: out STD_LOGIC_VECtOR(4095 downto 0);
          monitor: out STD_LOGIC_VECTOR(63 downto 0)
         );
end clock;

architecture Behavioral of clock is
signal microsecond: std_logic_vector(9 downto 0);
signal millisecond: std_logic_vector(9 downto 0);
signal second: std_logic_vector(5 downto 0);
begin
    out_datas(9 downto 0) <= microsecond(9 downto 0);
    out_datas(15 downto 10) <= (others => '0');
    out_datas(25 downto 16) <= millisecond(9 downto 0);
    out_datas(31 downto 26) <= (others => '0');
    out_datas(37 downto 32) <= second(5 downto 0);
    out_datas(39 downto 38) <= (others => '0');
    out_datas(4095 downto 40) <= (others => '0');
    monitor <= X"0000" & "000000" & microsecond & "000000" & millisecond & "0000000000" & second;
    with to_integer(unsigned(second) / 10) select
        led2 <= 
            "1111110" when 0, "0110000" when 1, "1101101" when 2, "1111001" when 3, 
            "0110011" when 4, "1011011" when 5, "1011111" when 6, "1110000" when 7,
            "1111111" when 8, "1111011" when 9, "1001111" when others;
            
    with to_integer(unsigned(second) mod 10) select
        led1 <= 
            "1111110" when 0, "0110000" when 1, "1101101" when 2, "1111001" when 3, 
            "0110011" when 4, "1011011" when 5, "1011111" when 6, "1110000" when 7,
            "1111111" when 8, "1111011" when 9, "1001111" when others;  
            
    process(clk, rst)
        variable tick: integer;
    begin
        if (rst = '0') then
            tick := 0;
            microsecond <= (others => '0');
            millisecond <= (others => '0');
            second <= (others => '0');  
        elsif (rising_edge(clk)) then
            tick := tick + 1;
            if (tick = 50) then
                microsecond <= std_logic_vector(unsigned(microsecond) + 1);
                tick := 0;
                if (unsigned(microsecond) = 1000) then
                    millisecond <= std_logic_vector(unsigned(millisecond) + 1);
                    microsecond <= (others => '0');
                    if (unsigned(millisecond) = 1000) then
                        second <= std_logic_vector(unsigned(second) + 1);
                        millisecond <= (others => '0');
                        if (unsigned(second) = 60) then
                            second <= (others => '0');
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;

