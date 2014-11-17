library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.common.ALL;

entity IFetch_on_board is
    Port ( clock: in  STD_LOGIC;
           input: in  STD_LOGIC_VECTOR (31 downto 0);
           output: out  STD_LOGIC_VECTOR (31 downto 0);
           step: out std_logic_vector(6 downto 0)
    );
end IFetch_on_board;

architecture Behavioral of IFetch_on_board is

component IFetch
port(
	clk : in std_logic;
	state : in status;
	
	PCSrc : in std_logic_vector(31 downto 0);
	EBase : in std_logic_vector(31 downto 0);
	EPC : in std_logic_vector(31 downto 0);
	pc_sel : in std_logic_vector(1 downto 0);		-- eret_enable, pc_control
	
	PC : out std_logic_vector(31 downto 0);		-- register, with sequential logic
	PCmmu : out std_logic_vector(31 downto 0)		-- combinatory, for mmu
);
end component;

signal state : status := InsF;

signal PCSrc : std_logic_vector(31 downto 0);
signal EBase : std_logic_vector(31 downto 0);
signal EPC : std_logic_vector(31 downto 0);
signal pc_sel : std_logic_vector(1 downto 0);
	
signal PC : std_logic_vector(31 downto 0);
signal PCmmu : std_logic_vector(31 downto 0);

signal st : integer := 0;

signal latch_PCSrc : std_logic_vector(31 downto 0);
signal latch_EBase : std_logic_vector(31 downto 0);
signal latch_EPC : std_logic_vector(31 downto 0);
signal latch_pc_sel : std_logic_vector(1 downto 0);

begin
	
	u1: IFetch port map(clk => clock, state => state, PCSrc => PCSrc, 
							EBase => EBase, EPC => EPC, pc_sel => pc_sel, 
								PC => PC, PCmmu => PCmmu);
	
	process (clock)
	begin
        -- output state indication
        case st is
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
		if st = 0 then
			latch_PCSrc <= input;
		end if;
		
		if st = 1 then
			latch_EBase <= input;
		end if;
		
		if st = 2 then
			latch_EPC <= input;
		end if;
		
		if st = 3 then
			latch_pc_sel <= input(1 downto 0);
		end if;
		
		if st = 4 then
			PCSrc <= latch_PCSrc;
			EBase <= latch_EBase;
			EPC <= latch_EPC;
			pc_sel <= latch_pc_sel;
			state <= InsF;
		end if;
		
		if st = 5 then
			output <= PCmmu;
		end if;
		
		if st = 6 then
			output <= PC;
		end if;
		
		st <= st + 1;
      if (st = 6) then
			st <= 0;
      end if;

    end if;
        
	end process;

end Behavioral;

