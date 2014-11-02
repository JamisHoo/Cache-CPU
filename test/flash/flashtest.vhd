library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity flashtest is
    Port ( clk : in  STD_LOGIC;
           cpu_clk: in STD_LOGIC;
           ope : in  STD_LOGIC_VECTOR (21 downto 0);
           data_out: out std_logic_vector(15 downto 0);
           
           read_enable: in std_logic;
           write_enable: in std_logic;
           erase_enable: in std_logic;
           
           flash_addr : out  STD_LOGIC_VECTOR (22 downto 0);
           flash_data : inout  STD_LOGIC_VECTOR (15 downto 0);
           flash_control_ce0 : out  STD_LOGIC;
           flash_control_ce1 : out  STD_LOGIC;
           flash_control_ce2 : out  STD_LOGIC;
           flash_control_byte : out  STD_LOGIC;
           flash_control_vpen : out  STD_LOGIC;
           flash_control_rp : out  STD_LOGIC;
           flash_control_oe : out  STD_LOGIC;
           flash_control_we : out  STD_LOGIC;
           
           step_display : out std_logic_vector(6 downto 0)
          );
end flashtest;

architecture Behavioral of flashtest is
component flash is
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
end component;

signal read_signal: std_logic := '0';
signal write_signal: std_logic := '0';
signal erase_signal: std_logic := '0';

signal input_data: std_logic_vector(15 downto 0);
signal input_address: std_logic_vector(21 downto 0);

begin
    u1: flash port map(clk => cpu_clk, 
                      addr => input_address, data_in => input_data,
                      data_out => data_out, 
                      flash_addr => flash_addr, flash_data => flash_data,
                      read_enable => read_signal, write_enable => write_signal, erase_enable => erase_signal,
                      flash_control_ce0 => flash_control_ce0, flash_control_ce1 => flash_control_ce1,
                      flash_control_ce2 => flash_control_ce2, flash_control_byte => flash_control_byte,
                      flash_control_vpen => flash_control_vpen, flash_control_rp => flash_control_rp,
                      flash_control_oe => flash_control_oe, flash_control_we => flash_control_we);
    
    process(clk) 
    variable state : integer := 0;
    begin
        case (state) is
            when 0 => step_display <= "0111111";
            when 1 => step_display <= "0000110";
            when 2 => step_display <= "1011011";
            when 3 => step_display <= "1001111";
            when 4 => step_display <= "1100110";
            when 5 => step_display <= "1101101";
            when 6 => step_display <= "1111101";
            when 7 => step_display <= "0000111";
            when 8 => step_display <= "1111111";
            when 9 => step_display <= "1101111";
            when others => step_display <= "0000000";
        end case;
        if (clk'event and clk = '1') then
            case (state) is
                when 0 => 
                    if (read_enable = '1') then
                        read_signal <= '1';
                        write_signal <= '0';
                        erase_signal <= '0';
                        input_address <= ope;
                        state := 1;
                    elsif (write_enable = '1') then
                        read_signal <= '0';
                        write_signal <= '0';
                        erase_signal <= '0';
                        input_address <= ope;
                        state := 2;
                    elsif (erase_enable = '1') then
                        erase_signal <= '1';
                        read_signal <= '0';
                        write_signal <= '0';
                        input_address <= ope;
                        state := 4;
                    else 
                        read_signal <= '0';
                        write_signal <= '0';
                        erase_signal <= '0';
                        state := 0;
                    end if;
                -- read state 1
                when 1 =>
                    read_signal <= '0';
                    state := 0;
                    
                -- write state 1
                when 2 => 
                    input_data <= ope(15 downto 0);
                    write_signal <= '1';
                    state := 3;
                -- write state 2
                when 3 => 
                    write_signal <= '0';
                    state := 0;
                
                -- erase state 1
                when 4 =>
                    erase_signal <= '0';
                    state := 0;
                
                when others => 
                    state := 0;
            end case;
        end if;
                
    end process;

                

end Behavioral;

