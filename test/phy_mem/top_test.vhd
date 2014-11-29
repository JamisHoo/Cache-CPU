library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity top_test is
port (
    clk : in  STD_LOGIC;
    high_freq_clk : in  STD_LOGIC;  
    
    led: out std_logic_vector(15 downto 0) := X"f0f0";
    right: out std_logic := '1';
    wrong: out std_logic := '0';
    wrong2: out std_logic := '0';
    wrong3: out std_logic := '0';
    wrong4: out std_logic := '0';
    busy_flag: out std_logic := '0';

    -- ports connected with ram
    baseram_addr: out std_logic_vector(19 downto 0);
    baseram_data: inout std_logic_vector(31 downto 0);
    baseram_ce: out std_logic;
    baseram_oe: out std_logic;
    baseram_we: out std_logic;
    extrram_addr: out std_logic_vector(19 downto 0);
    extrram_data: inout std_logic_vector(31 downto 0);
    extrram_ce: out std_logic;
    extrram_oe: out std_logic;
    extrram_we: out std_logic;

    -- ports connected with flash
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
           
    -- ports connected with serial port
    serialport_txd : out STD_LOGIC;
    serialport_rxd : in STD_LOGIC
);
end top_test;

architecture Behavioral of top_test is
component phy_mem is
    Port ( clk : in  STD_LOGIC;
           high_freq_clk : in  STD_LOGIC;  
           addr : in  STD_LOGIC_VECTOR (23 downto 0);
           data_in : in  STD_LOGIC_VECTOR (31 downto 0);
           data_out : out  STD_LOGIC_VECTOR (31 downto 0) := X"FFFFFFFF";
           write_enable : in  STD_LOGIC;
           read_enable : in  STD_LOGIC;
           busy : out STD_LOGIC := '0';
           serialport_data_ready : out  STD_LOGIC;
           
           -- ports connected with ram
           baseram_addr: out std_logic_vector(19 downto 0);
           baseram_data: inout std_logic_vector(31 downto 0);
           baseram_ce: out std_logic;
           baseram_oe: out std_logic;
           baseram_we: out std_logic;
           extrram_addr: out std_logic_vector(19 downto 0);
           extrram_data: inout std_logic_vector(31 downto 0);
           extrram_ce: out std_logic;
           extrram_oe: out std_logic;
           extrram_we: out std_logic;

           -- ports connected with flash
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
           
           -- ports connected with serial port
           serialport_txd : out STD_LOGIC;
           serialport_rxd : in STD_LOGIC
          );
end component;


signal addr: std_logic_vector(23 downto 0);
signal data_in: std_logic_vector(31 downto 0);
signal data_out: std_logic_vector(31 downto 0);
signal write_enable: std_logic := '0';
signal read_enable: std_logic := '0';
signal mem_busy : std_logic := '0';
signal serialport_data_ready: std_logic;


signal wrong_buf: std_logic:= '0';
signal div_clk: std_logic := '0';
signal high_clk: std_logic := '0';

begin
    u1: phy_mem port map(clk => clk, high_freq_clk => high_clk, busy => mem_busy,
                     addr => addr, data_in => data_in, data_out => data_out, write_enable => write_enable, read_enable => read_enable, serialport_data_ready => serialport_data_ready,
                     baseram_addr => baseram_addr, baseram_data => baseram_data, baseram_ce => baseram_ce, baseram_oe => baseram_oe, baseram_we => baseram_we, 
                     extrram_addr => extrram_addr, extrram_data => extrram_data, extrram_ce => extrram_ce, extrram_oe => extrram_oe, extrram_we => extrram_we, 
                     flash_addr => flash_addr, flash_data => flash_data, flash_control_ce0 => flash_control_ce0, flash_control_ce1 => flash_control_ce1, flash_control_ce2 => flash_control_ce2, flash_control_byte => flash_control_byte, flash_control_vpen => flash_control_vpen, flash_control_rp => flash_control_rp, flash_control_oe => flash_control_oe, flash_control_we => flash_control_we,
                     serialport_rxd => serialport_rxd, serialport_txd => serialport_txd
                    );
                    
    
    busy_flag <= mem_busy;

    wrong <= wrong_buf;
    
    high_clk <= high_freq_clk;
    
    process (high_freq_clk)
        variable clk_counter: integer := 0;
    begin 
        if (high_freq_clk'event and high_freq_clk = '1') then
            if (clk_counter >= 0) then
                clk_counter := 0;
                div_clk <= not div_clk;
            else
                clk_counter := clk_counter + 1;
            end if;
        end if;
    end process;
    
    process (div_clk) 
        variable num: integer := 0;
        variable state : integer := 0;
        variable serialport_sum : std_logic_vector(15 downto 0) := X"0000";
    begin
        if (div_clk'event and div_clk = '1') then
            case (state) is
                when 0 =>
                    -- check serial port
                    if (serialport_data_ready = '1') then
                        led <= X"0ff0";
                        state := 101;
                    else 
                        --led <= X"f00f";
                        
                        -- read flash
                        if (mem_busy = '0' and wrong_buf = '0') then
                            addr <= "00" & std_logic_vector(to_unsigned(num + 65536, 22));
                            read_enable <= '1';
                            state := 1;
                        end if;
                    end if;
                when 1 =>
                    read_enable <= '0';
                    state := 2;
                when 2 =>
                    -- chek data from flash
                    if (mem_busy = '0') then
                        --led <= std_logic_vector(to_unsigned(2 * num + 1, 8)) & std_logic_vector(to_unsigned(2 * num, 8));
                        --led <= std_logic_vector(to_unsigned(num, 16));
                        --led <= data_out(15 downto 0);
                        if (data_out /= X"0000" & std_logic_vector(to_unsigned(2 * num + 1, 8)) & std_logic_vector(to_unsigned(2 * num, 8))) then
                            wrong_buf <= '1';
                            wrong2 <= '1';
                            right <= '0';
                        else
                            right <= '1';
                            state := 3;
                        end if;
                    end if;
                when 3 =>
                    -- write ram
                    if (mem_busy = '0') then
                        write_enable <= '1';
                        addr <= "010" & std_logic_vector(to_unsigned(num, 21));
                        data_in <= data_out xor X"A0A0A0A0";
                        state := 4;
                    else
                        wrong_buf <= '1';
                        wrong3 <= '1';
                    end if;
                when 4 =>
                    write_enable <= '0';
                    state := 5;
                when 5 =>
                    -- read ram
                    if (mem_busy = '0') then
                        read_enable <= '1';
                        addr <= "010" & std_logic_vector(to_unsigned(num, 21));
                        state := 6;
                    end if;
                when 6 =>
                    read_enable <= '0';
                    state := 7;
                when 7 =>
                    -- check data from ram
                    if (mem_busy = '0') then
                        --led <= data_out(15 downto 0);
                        --led <= std_logic_vector(to_unsigned(num, 16));
                        if (data_out /= (X"A0A0A0A0" xor (X"0000" & std_logic_vector(to_unsigned(2 * num + 1, 8)) & std_logic_vector(to_unsigned(2 * num, 8))))) then
                            wrong_buf <= '1';
                            wrong4 <= '1';
                            right <= '0';
                        else
                            right <= '1';
                            state := 3;
                            num := num + 1;
                            if (num = 2048) then
                                num := 0;
                            end if;
                        end if;
                        state := 0;
                    end if;
                -- read serial port
                when 101 =>
                    read_enable <= '1';
                    addr <= X"800000";
                    state := 102;
                when 102 =>
                    read_enable <= '0';
                    serialport_sum := std_logic_vector(unsigned(serialport_sum) + unsigned(data_out(15 downto 0)));
                    --led <= serialport_sum;
                    led <= data_out(15 downto 0);
                    state := 103;
                -- write serial port
                when 103 =>
                    if (mem_busy = '0') then
                        write_enable <= '1';
                        addr <= X"800000";
                        data_in <= X"0000" & serialport_sum;
                        state := 104;
                    end if;
                when 104 =>
                    write_enable <= '0';
                    state := 0;
                when others => 
                    wrong_buf <= '1';
                    state := 0;
            end case;
            

        end if;
    end process;

end Behavioral;

