library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    Port ( clock: in  STD_LOGIC;
           reset: in  STD_LOGIC;
           input: in  STD_LOGIC_VECTOR (31 downto 0);
           output: out  STD_LOGIC_VECTOR (31 downto 0);
           step: out std_logic_vector(6 downto 0)
    );
end fsm;

architecture Behavioral of fsm is
component ALU
	port(clk:               in  std_logic;
         rs_value:          in  std_logic_vector(31 downto 0);
         rt_value:          in  std_logic_vector(31 downto 0);
         imme:              in  std_logic_vector(31 downto 0);
         cp0_value:         in  std_logic_vector(31 downto 0);
         state:             in  std_logic_vector(3 downto 0);
         alu_op:            in  std_logic_vector(4 downto 0);
         alu_srcA:          in  std_logic_vector(1 downto 0);
         alu_srcB:          in  std_logic_vector(1 downto 0);
         hi_lo_enable:      in  std_logic;
         alu_result:        out std_logic_vector(31 downto 0)
         
	);
end component;

signal A: std_logic_vector(31 downto 0);
signal B: std_logic_vector(31 downto 0);
signal imme, cp0_value: std_logic_vector(31 downto 0);
signal state: std_logic_vector(3 downto 0);
signal alu_op: std_logic_vector(4 downto 0);
signal Y: std_logic_vector(31 downto 0);
signal hi_lo_enable: std_logic;
signal alu_srcA, alu_srcB: std_logic_vector(1 downto 0);


signal latch_a: std_logic_vector(31 downto 0);
signal latch_b: std_logic_vector(31 downto 0);
signal latch_op: std_logic_vector(4 downto 0);

begin
	u1: ALU port map(clk => clock,rs_value => A, rt_value => B, alu_op => alu_op, 
                     imme => imme, cp0_value => cp0_value, state => state,
                     alu_srcA => alu_srcA, alu_srcB => alu_srcB, 
                     hi_lo_enable => hi_lo_enable,
                     alu_result => Y);
    alu_srcA <= "00";
    alu_srcB <= "00";

	process (clock)
		variable state: integer := 0;
	begin
        -- output state indication
        case state is
            when 0 => step <= "0111111";
            when 1 => step <= "0000110";
            when 2 => step <= "1011011";
            when 3 => step <= "1001111";
            when 4 => step <= "1100110";
            when 5 => step <= "1101101";
            when 6 => step <= "1111101";
            when 7 => step <= "0000111";
            when 8 => step <= "1111111";
            when 9 => step <= "1101111";
            when others => step <= "0000000";
        end case;
        
        if (clock'event and clock = '1') then
            if (state = 0) then
                latch_a <= input;
            end if;
            if (state = 1) then
                latch_b <= input;
            end if;
            if (state = 2) then
                latch_op <= input(4 downto 0);
            end if;
            if (state = 3) then
                A <= latch_a;
                B <= latch_b;
                alu_op <= latch_op;
                hi_lo_enable <= '1';
            end if;
            if (state = 4) then
                output <= Y;
                hi_lo_enable <= '0';
            else 
                output <= "00000000000000000000000000000000";
            end if;
            
            state := state + 1;
            if (state = 5) then
                state := 0;
            end if;
        end if;
        
	end process;

end Behavioral;

