library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity flash is
    Port ( clk : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (21 downto 0);
           data_in : in STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);
           
           read_enable: in std_logic;
           write_enable: in std_logic;
           erase_enable: in std_logic;
           
           flash_addr : out  STD_LOGIC_VECTOR (22 downto 0);
           flash_data : inout  STD_LOGIC_VECTOR (15 downto 0);
           flash_control_ce0: out std_logic;
           flash_control_ce1: out std_logic;
           flash_control_ce2: out std_logic;
           flash_control_byte: out std_logic;
           flash_control_vpen: out std_logic;
           flash_control_rp: out std_logic;
           flash_control_oe: out std_logic;
           flash_control_we: out std_logic
          );
end flash;

architecture Behavioral of flash is

begin
    flash_control_ce0 <= '0';
    flash_control_ce1 <= '0';
    flash_control_ce2 <= '0';
    flash_control_byte <= '1';
    flash_control_vpen <= '1';
    flash_control_rp <= '1';
    
    process (clk)
    variable state: integer := 0;
    begin
        if (clk'event and clk = '1') then
            case (state) is
                -- initial state
                -- priority: read > write > erase
                -- read states: 0x, write states: 1x, erase states: 2x, wait states: 3x
                when 0 =>
                    if (read_enable = '1') then
                    -- read state 0
                        flash_control_we <= '0';
                        flash_data <= X"00FF";
                        state := 1;
                    elsif (write_enable = '1') then
                    -- write state 0
                        flash_control_we <= '0';
                        flash_data <= X"0040";
                        state := 11;
                    elsif (erase_enable = '1') then 
                    -- erase state 0
                        flash_control_we <= '0';
                        flash_data <= X"0020";
                        state := 21;
                    else
                        state := 0;
                    end if;
                -- read state 1
                when 1 =>
                    flash_control_we <= '1';
                    state := 2;
                -- read state 2
                when 2 =>
                    flash_data <= (others => 'Z');
                    state := 3;
                -- read state 3
                when 3 =>
                    flash_control_oe <= '0';
                    flash_addr <= addr & '0';
                    state := 4;
                -- read state 4
                when 4 =>
                    data_out <= flash_data;
                    flash_control_oe <= '1';
                    state := 0;
                    
                -- write state 1
                when 11 =>
                    flash_control_we <= '1';
                    state := 12;
                -- write state 2
                when 12 =>
                    flash_control_we <= '0';
                    flash_data <= data_in;
                    flash_addr <= addr & '0';
                    state := 13;
                -- write state 3
                when 13 =>
                    flash_control_we <= '1';
                    state := 31;
                
                -- erase state 1
                when 21 =>
                    flash_control_we <= '1';
                    state := 22;
                -- erase state 2
                when 22 =>
                    flash_control_we <= '0';
                    flash_addr <= addr & '0';
                    flash_data <= X"00D0";
                    state := 23;
                -- erase state 3
                when 23 =>
                    flash_control_we <= '1';
                    state := 31;
                    
                    
                
                -- wait state 1
                when 31 => 
                    flash_data <= X"0070";
                    flash_control_we <= '0';
                    state := 32;
                -- wait state 2
                when 32 =>
                    flash_control_we <= '1';
                    state := 33;
                -- wait state 3
                when 33 =>
                    flash_data <= (others => 'Z');
                    flash_control_oe <= '0';
                    state := 34;
                -- wait state 4
                when 34 =>
                    flash_control_oe <= '1';
                    if (flash_data(7) = '1') then
                        state := 0;
                    else 
                        state := 31;
                    end if;
                when others =>
                    state := 0;
            end case;
        end if;
    end process;

end Behavioral;

