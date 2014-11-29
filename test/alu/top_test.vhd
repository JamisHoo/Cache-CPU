library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.common.all;

entity top_test is
port (
    clk : in  STD_LOGIC;
    high_freq_clk : in  STD_LOGIC;  
    
    led: out std_logic_vector(15 downto 0) := X"f0f0";

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

component alu is
	port(clk:               in  std_logic;
         rs_value:          in  std_logic_vector(31 downto 0);
         rt_value:          in  std_logic_vector(31 downto 0);
         imme:              in  std_logic_vector(31 downto 0);
         cp0_value:         in  std_logic_vector(31 downto 0);
         state:             in  status;
         alu_op:            in  std_logic_vector(4 downto 0);
         alu_srcA:          in  std_logic_vector(1 downto 0);
         alu_srcB:          in  std_logic_vector(1 downto 0);
         alu_result:        out std_logic_vector(31 downto 0)
	);
end component;

signal alu_rs : std_logic_vector(31 downto 0);
signal alu_rt : std_logic_vector(31 downto 0);
signal alu_imme : std_logic_vector(31 downto 0);
signal alu_cp0 : std_logic_vector(31 downto 0);
signal state : status;
signal alu_op : std_logic_vector(4 downto 0);
signal alu_srcA : std_logic_vector(1 downto 0);
signal alu_srcB : std_logic_vector(1 downto 0);
signal alu_result :std_logic_vector(31 downto 0);

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


signal div_clk: std_logic := '0';
signal high_clk: std_logic := '0';


signal srcA, srcB : std_logic_vector(31 downto 0);
signal op : std_logic_vector(4 downto 0);
signal result, result2 : std_logic_vector(31 downto 0);

begin
    u2: alu port map(clk => div_clk, rs_value => alu_rs, rt_value => alu_rt, imme => alu_imme, cp0_value => alu_cp0, state => state, alu_op => alu_op, alu_srcA => alu_srcA, alu_srcB => alu_srcB, alu_result => alu_result);
    
    u1: phy_mem port map(clk => clk, high_freq_clk => high_clk, busy => mem_busy,
                     addr => addr, data_in => data_in, data_out => data_out, write_enable => write_enable, read_enable => read_enable, serialport_data_ready => serialport_data_ready,
                     baseram_addr => baseram_addr, baseram_data => baseram_data, baseram_ce => baseram_ce, baseram_oe => baseram_oe, baseram_we => baseram_we, 
                     extrram_addr => extrram_addr, extrram_data => extrram_data, extrram_ce => extrram_ce, extrram_oe => extrram_oe, extrram_we => extrram_we, 
                     flash_addr => flash_addr, flash_data => flash_data, flash_control_ce0 => flash_control_ce0, flash_control_ce1 => flash_control_ce1, flash_control_ce2 => flash_control_ce2, flash_control_byte => flash_control_byte, flash_control_vpen => flash_control_vpen, flash_control_rp => flash_control_rp, flash_control_oe => flash_control_oe, flash_control_we => flash_control_we,
                     serialport_rxd => serialport_rxd, serialport_txd => serialport_txd
                    );
    
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
    
    -- multiplifier speed test
    process (div_clk) 
        variable step : integer := 0;
        variable fsm_state : integer := 0;
    begin
        if (div_clk'event and div_clk = '1') then
            case (fsm_state) is
                -- read serial port
                when 0 =>
                    if (serialport_data_ready = '1') then
                        fsm_state := 1;
                    end if;
                -- read serial port
                when 1 =>
                    read_enable <= '1';
                    addr <= X"800000";
                    fsm_state := 2;
                -- read serial port
                when 2 =>
                    read_enable <= '0';
                    case (step) is
                        when 0 => srcA(31 downto 24) <= data_out(7 downto 0); step := step + 1;
                        when 1 => srcA(23 downto 16) <= data_out(7 downto 0); step := step + 1;
                        when 2 => srcA(15 downto 8) <= data_out(7 downto 0); step := step + 1;
                        when 3 => srcA(7 downto 0) <= data_out(7 downto 0); step := step + 1;
                        when 4 => srcB(31 downto 24) <= data_out(7 downto 0); step := step + 1;
                        when 5 => srcB(23 downto 16) <= data_out(7 downto 0); step := step + 1;
                        when 6 => srcB(15 downto 8) <= data_out(7 downto 0); step := step + 1;
                        when 7 => srcB(7 downto 0) <= data_out(7 downto 0); step := step + 1;
                        when others => NULL;
                    end case;
                    fsm_state := 0;
                    if (step = 8) then
                        fsm_state := 3;
                        step := 0;
                    end if;
                -- input multiplicand and multiplier
                when 3 =>
                    alu_rs <= srcA;
                    alu_rt <= srcB;
                    alu_imme <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
                    alu_cp0 <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
                    state <= Exe;
                    alu_srcA <= "00";
                    alu_srcB <= "00";
                    alu_op <= "10000";
                    fsm_state := 4;
                -- alu start multiplying
                -- input fetch lo instruction
                when 4 =>
                    alu_op <= "10001";
                    fsm_state := 5;
                -- alu start fetching lo reg
                -- input fetch hi instruction
                when 5 =>
                    alu_op <= "10010";
                    fsm_state := 6;
                -- alu output lo reg
                -- alu start fetching hi reg
                when 6 =>
                    result <= alu_result;
                    fsm_state := 7;
                    state <= Mem1;
                    alu_op <= "11111";
                -- alu output hi reg
                when 7 =>
                    result2 <= alu_result;
                    fsm_state := 8;
                
                -- write result to serial port
                when 8 =>
                    if (mem_busy = '0') then
                        write_enable <= '1';
                        addr <= X"800000";
                        case (step) is 
                            when 0 => data_in <= X"000000" & result2(31 downto 24); step := step + 1;
                            when 1 => data_in <= X"000000" & result2(23 downto 16); step := step + 1;
                            when 2 => data_in <= X"000000" & result2(15 downto 8); step := step + 1;
                            when 3 => data_in <= X"000000" & result2(7 downto 0); step := step + 1;
                            when 4 => data_in <= X"000000" & result(31 downto 24); step := step + 1;
                            when 5 => data_in <= X"000000" & result(23 downto 16); step := step + 1;
                            when 6 => data_in <= X"000000" & result(15 downto 8); step := step + 1;
                            when 7 => data_in <= X"000000" & result(7 downto 0); step := step + 1;
                            when others => NULL;
                        end case;
                        fsm_state := 9;
                    end if;
                when 9 =>
                    write_enable <= '0';
                    if (step = 8) then
                        fsm_state := 0;
                        step := 0;
                    else
                        fsm_state := 10;
                    end if;
                when 10 to 20000 =>
                    fsm_state := fsm_state + 1;
                when 20001 =>
                    fsm_state := 8;
                when others =>
                    fsm_state := 0;
            end case;
        end if;
    end process;
    
    -- alu function test
--    process (div_clk) 
--        variable step : integer := 0;
--        variable fsm_state : integer := 0;
--    begin
--        if (div_clk'event and div_clk = '1') then
--            case (fsm_state) is
--                -- read serial port
--                when 0 =>
--                    if (serialport_data_ready = '1') then
--                        fsm_state := 1;
--                    end if;
--                -- read serial port
--                when 1 =>
--                    read_enable <= '1';
--                    addr <= X"800000";
--                    fsm_state := 2;
--                -- read serial port
--                when 2 =>
--                    read_enable <= '0';
--                    case (step) is
--                        when 0 => srcA(31 downto 24) <= data_out(7 downto 0); step := step + 1;
--                        when 1 => srcA(23 downto 16) <= data_out(7 downto 0); step := step + 1;
--                        when 2 => srcA(15 downto 8) <= data_out(7 downto 0); step := step + 1;
--                        when 3 => srcA(7 downto 0) <= data_out(7 downto 0); step := step + 1;
--                        when 4 => srcB(31 downto 24) <= data_out(7 downto 0); step := step + 1;
--                        when 5 => srcB(23 downto 16) <= data_out(7 downto 0); step := step + 1;
--                        when 6 => srcB(15 downto 8) <= data_out(7 downto 0); step := step + 1;
--                        when 7 => srcB(7 downto 0) <= data_out(7 downto 0); step := step + 1;
--                        when 8 => op <= data_out(4 downto 0); step := step + 1; 
--                        when others => NULL;
--                    end case;
--                    fsm_state := 0;
--                    if (step = 9) then
--                        fsm_state := 3;
--                        step := 0;
--                    end if;
--                -- alu
--                when 3 =>
--                    alu_rs <= srcA;
--                    alu_rt <= srcB;
--                    alu_imme <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
--                    alu_cp0 <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
--                    state <= Exe;
--                    alu_srcA <= "00";
--                    alu_srcB <= "00";
--                    alu_op <= op;
--                    fsm_state := 4;
--                when 4 =>
--                    fsm_state := 5;
--                -- fetch result from alu
--                when 5 =>
--                    alu_rs <= X"AAAAAAAA";
--                    alu_rt <= X"BBBBBBBB";
--                    alu_imme <= X"CCCCCCCC";
--                    alu_cp0 <= X"DDDDDDDD";
--                    state <= Mem1;
--                    alu_srcA <= "01";
--                    alu_srcB <= "10";
--                    alu_op <= "11111";
--                    result <= alu_result;
--                    fsm_state := 6;
--                    led <= alu_result(15 downto 0);
--                -- write result to serial port
--                when 6 =>
--                    if (mem_busy = '0') then
--                        write_enable <= '1';
--                        addr <= X"800000";
--                        case (step) is 
--                            when 0 => data_in <= X"000000" & result(31 downto 24); step := step + 1;
--                            when 1 => data_in <= X"000000" & result(23 downto 16); step := step + 1;
--                            when 2 => data_in <= X"000000" & result(15 downto 8); step := step + 1;
--                            when 3 => data_in <= X"000000" & result(7 downto 0); step := step + 1;
--                            when others => NULL;
--                        end case;
--                        fsm_state := 7;
--                    end if;
--                when 7 =>
--                    write_enable <= '0';
--                    if (step = 4) then
--                        fsm_state := 0;
--                        step := 0;
--                    else
--                        fsm_state := 8;
--                    end if;
--                -- when clk frequency is relatively high, you have to wait for pc fetching data from serial port
--                -- but this isn't necessary with 12.5M or lower frequency
--                when 8 to 20000 =>
--                    fsm_state := fsm_state + 1;
--                when 20001 =>
--                    fsm_state := 6;
--                when others =>
--                    fsm_state := 0;
--            end case;
--        end if;
--    end process;

end Behavioral;

