library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.all;

entity alu is
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
end alu;

architecture Behavioral of alu is
signal hi_lo: std_logic_vector(63 downto 0);
begin
	process(clk)
        variable srcA, srcB: std_logic_vector(31 downto 0);
	begin
        if (clk'event and clk = '1' and state = Exe) then
            case alu_srcA is
                -- rs_value
                when "00" =>
                    srcA := rs_value;
                -- immediate 
                when "01" =>
                    srcA := imme;
                -- cp0 value
                when "10" => 
                    srcA := cp0_value;
                -- 16bit immediat, from LUI instruction
                when "11" =>
                    srcA := "00000000000000000000000000010000";
                when others =>
                    NULL;
            end case;
            
            case alu_srcB is
                -- rt_value
                when "00" =>
                    srcB := rt_value;
                -- immediate 
                when "01" =>
                    srcB := imme;
                -- always zero
                when "10" => 
                    srcB := x"00000000";
                when others =>
                    NULL;
            end case;
            
            case alu_op is
                -- addition A + B
                when "00000" => 
                    alu_result <= std_logic_vector(unsigned(srcA) + unsigned(srcB));
                -- subtraction A - B
                when "00001" => 
                    alu_result <= std_logic_vector(unsigned(srcA) + unsigned((not srcB)) + 1);
                -- A == B? that is A - B
                when "00010" =>
                    alu_result <= std_logic_vector(unsigned(srcA) + unsigned((not srcB)) + 1);
                -- A & B
                when "00011" =>
                    alu_result <= srcA and srcB;
                -- A | B
                when "00100" => 
                    alu_result <= srcA or srcB;
                -- A ^ B
                when "00101" =>
                    alu_result <= srcA xor srcB;
                -- ~(A | B)
                when "00110" =>
                    alu_result <= not (srcA or srcB);
                -- B << A
                when "00111" => 
                    alu_result <= to_stdlogicvector(to_bitvector(srcB) sll to_integer(unsigned(srcA)));
                -- B >> A (arithmetic)
                when "01000" => 
                    alu_result <= to_stdlogicvector(to_bitvector(srcB) sra to_integer(unsigned(srcA)));
                -- B >> A (logical)
                when "01001" =>
                    alu_result <= to_stdlogicvector(to_bitvector(srcB) srl to_integer(unsigned(srcA)));
                -- A < B? signed
                when "01010" => 
                    if (signed(srcA) < signed(srcB)) then
                        alu_result <= (0 => '1', others => '0');
                    else
                        alu_result <= (others => '0');
                    end if;
                -- A < B? unsigned
                when "01011" =>
                    if (unsigned(srcA) < unsigned(srcB)) then
                        alu_result <= (0 => '1', others => '0');
                    else
                        alu_result <= (others => '0');
                    end if;
                    
                -- hi & lo = A * B
                when "10000" =>
                    hi_lo <= Std_logic_vector(signed(srcA) * signed(srcB));
                -- lo = A
                when "10011" =>
                    hi_lo(31 downto 0) <= srcA;
                -- hi = A
                when "10100" =>
                    hi_lo(63 downto 32) <= srcA;
                -- read lo register
                when "10001" =>
                    alu_result <= hi_lo(31 downto 0);
                -- read hi register
                when "10010" => 
                    alu_result <= hi_lo(63 downto 32);
                -- others, uncertain
                when others =>
                    alu_result <= "10101010101010101010101010101010";
            end case;
        end if;
	end process;

end Behavioral;

