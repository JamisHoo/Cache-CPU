library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity com2flash is
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
end com2flash;

architecture Behavioral of com2flash is
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

signal addr_start, addr_end : std_logic_vector(23 downto 0);
signal data_buf : std_logic_vector(15 downto 0);

begin
    u1: phy_mem port map(clk => clk, high_freq_clk => high_clk, busy => mem_busy,
                     addr => addr, data_in => data_in, data_out => data_out, write_enable => write_enable, read_enable => read_enable, serialport_data_ready => serialport_data_ready,
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
            if (clk_counter >= 1) then
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
    begin
        if (div_clk'event and div_clk = '1') then
            --led <= std_logic_vector(to_unsigned(state, 16));
            case (state) is
            -- wait for command from serial port
            when 0 =>
                if (serialport_data_ready = '1' and mem_busy = '0') then 
                    read_enable <= '1';
                    addr <= X"800000";
                    state := 1;
                end if;
            -- read command
            -- AA -- read
            -- BB -- write
            -- CC -- erase
            when 1 =>
                read_enable <= '0';
                case (data_out(7 downto 0)) is
                    when X"AA" =>
                        state := 10;
                    when X"BB" =>
                        state := 30;
                    when X"CC" =>
                        state := 50;
                    when others => 
                        led <= data_out(15 downto 0);
                        wrong_buf <= '1';
                end case;
            -- read start and end address
            when 10 | 30 | 50 | 12 | 32 | 52 | 14 | 34 | 54 | 16 | 36 | 56 | 18 | 38 | 58 | 20 | 40 | 60 =>
                if (serialport_data_ready = '1' and mem_busy = '0') then 
                    read_enable <= '1';
                    addr <= X"800000";
                    state := state + 1;
                end if;
            when 11 | 31 | 51 =>
                read_enable <= '0';
                addr_start(23 downto 16) <= data_out(7 downto 0);
                state := state + 1;
            when 13 | 33 | 53 =>
                read_enable <= '0';
                addr_start(15 downto 8) <= data_out(7 downto 0);
                state := state + 1;
            when 15 | 35 | 55 =>
                read_enable <= '0';
                addr_start(7 downto 0) <= data_out(7 downto 0);
                state := state + 1;
            when 17 | 37 | 57 =>
                read_enable <= '0';
                addr_end(23 downto 16) <= data_out(7 downto 0);
                state := state + 1;
            when 19 | 39 | 59 =>
                read_enable <= '0';
                addr_end(15 downto 8) <= data_out(7 downto 0);
                state := state + 1;
            when 21 | 41 | 61 =>
                read_enable <= '0';
                addr_end(7 downto 0) <= data_out(7 downto 0);
                num := 0;
                state := state + 1;
            -- read flash
            when 22 =>
                if (num = to_integer(unsigned(addr_end) - unsigned(addr_start))) then
                    state := 0;
                    num := 0;
                elsif (mem_busy = '0') then
                    addr <= std_logic_vector(to_unsigned(num, 24) + unsigned(addr_start));
                    read_enable <= '1';
                    state := 23;
                    num := num + 1;
                end if;
            -- read data from flash
            when 23 =>
                read_enable <= '0';
                if (mem_busy = '0') then
                    data_buf <= data_out(15 downto 0);
                    state := 24;
                end if;
            -- send data to serial port
            when 24 =>
                if (mem_busy = '0') then
                    write_enable <= '1';
                    addr <= X"800000";
                    data_in <=  X"000000" & data_buf(7 downto 0);
                    state := 25;
                end if;
            when 25 =>
                write_enable <= '0';
                state := 26;
            -- send data to serial port
            when 26 =>
                if (mem_busy = '0') then
                    write_enable <= '1';
                    addr <= X"800000";
                    data_in <= X"000000" & data_buf(15 downto 8);
                    state := 27;
                end if;
            -- read next data from flash
            when 27 =>
                write_enable <= '0';
                state := 22;
            when others => 
                state := 0;
            end case;
        end if;
    end process;

end Behavioral;

