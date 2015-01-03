library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.common.all;



entity WB is
	port(
		clk : in std_logic;
		state : in status;
		WB_e : in std_logic;
		--PC + 4
		RPC : in std_logic_vector(31 downto 0);
		mmu_value : in std_logic_vector(31 downto 0);
		cp0_value : in std_logic_vector(31 downto 0);
		alu_result : in std_logic_vector(31 downto 0);
		wb_op : in std_logic_vector(4 downto 0);
		rd_addr : in std_logic_vector(4 downto 0);
		rt_addr : in std_logic_vector(4 downto 0);

		write_addr : out std_logic_vector(4 downto 0);
		write_value : out std_logic_vector(31 downto 0);
		write_enable : out std_logic;
 
		pc_op : in std_logic_vector(1 downto 0);
		comp_op : in std_logic_vector(2 downto 0);
		rs_value : in std_logic_vector(31 downto 0);
		rt_value : in std_logic_vector(31 downto 0);
		imme : in std_logic_vector(31 downto 0);

		PcSrc : out std_logic_vector(31 downto 0)
		);

end WB;

architecture bhv of WB is
signal m_write_addr : std_logic_vector(4 downto 0);
signal m_write_value : std_logic_vector(31 downto 0);
signal m_write_enable : std_logic;
signal m_PcSrc : std_logic_vector(31 downto 0);
constant zeros : std_logic_vector(31 downto 0) := (others => '0');
signal m_compare : std_logic;
begin

	write_addr <= m_write_addr;
	write_value <= m_write_value;
	write_enable <= m_write_enable;
	PcSrc <= m_PcSrc;
	
	process(clk)
	begin
		if WB_e = '0' then
			m_write_enable <= '0';
			m_write_addr <= (others => '0');
			m_write_value <= (others => '0');
		elsif rising_edge(clk) then
			if state =WriteB then
				case wb_op(4 downto 3) is
					when "00" =>
						if rt_addr /= "00000" then
							m_write_addr <= rt_addr;
							m_write_enable <= '1';
						else
							m_write_enable <= '0';
						end if;
					when "01" =>
						if rd_addr /= "000000" then
							m_write_addr <= rd_addr;
							m_write_enable <= '1';
						else
							m_write_enable <= '0';
						end if;
					when "10" =>
						m_write_addr <= "11111";
						m_write_enable <= '1';
					when others =>
						m_write_enable <= '0';
				end case;
			else
				m_write_enable <= '0';
			end if;

			if state =WriteB then
				case wb_op(2 downto 0) is
					when "000" =>
						m_write_value <= alu_result;
					when "001" =>
						m_write_value <= mmu_value;
					when "010" =>
						m_write_value <= RPC;
					when "011" =>
						m_write_value(31 downto 8) <= zeros(23 downto 0);
						case alu_result(1 downto 0) is
							when "00" =>
								m_write_value(7 downto 0) <= mmu_value(7 downto 0);
							when "01" =>
								m_write_value(7 downto 0) <= mmu_value(15 downto 8);
							when "10" =>
								m_write_value(7 downto 0) <= mmu_value(23 downto 16);
							when "11" =>
								m_write_value(7 downto 0) <= mmu_value(31 downto 24);
							when others =>
						end case;
					when "100" =>
						case alu_result(1 downto 0) is
							when "00" =>
								m_write_value(7 downto 0) <= mmu_value(7 downto 0);
								if (mmu_value(7) = '1') then
									m_write_value(31 downto 8) <= (others => '1');
								elsif (mmu_value(7) = '0') then
									m_write_value(31 downto 8) <= (others => '0');
								end if;
							when "01" =>
								m_write_value(7 downto 0) <= mmu_value(15 downto 8);
								if (mmu_value(15) = '1') then
									m_write_value(31 downto 8) <= (others => '1');
								elsif (mmu_value(15) = '0') then
									m_write_value(31 downto 8) <= (others => '0');
								end if;
							when "10" =>
								m_write_value(7 downto 0) <= mmu_value(23 downto 16);
								if (mmu_value(23) = '1') then
									m_write_value(31 downto 8) <= (others => '1');
								elsif (mmu_value(23) = '0') then
									m_write_value(31 downto 8) <= (others => '0');
								end if;
							when "11" =>
								m_write_value(7 downto 0) <= mmu_value(31 downto 24);
								if (mmu_value(31) = '1') then
									m_write_value(31 downto 8) <= (others => '1');
								elsif (mmu_value(31) = '0') then
									m_write_value(31 downto 8) <= (others => '0');
								end if;
							when others =>
						end case;
					when "101" =>
						m_write_value(31 downto 16) <= zeros(15 downto 0);
						case alu_result(1) is
							when '0' =>
								m_write_value(15 downto 0) <= mmu_value(15 downto 0);
							when '1' =>
								m_write_value(15 downto 0) <= mmu_value(31 downto 16);
							when others =>
						end case;
					when "110" =>
						m_write_value <= cp0_value;
					when others =>
				end case;
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if WB_e = '0' then
         -- change for test, pointed to the first address of ROM
			m_PcSrc <= x"90000000";
			m_compare <= '0';
		elsif rising_edge(clk) then
			case state is
				when Exe =>
					case comp_op is
						when "000" =>
							if rs_value = rt_value then
								m_compare <= '1';
							elsif rs_value /= rt_value then
								m_compare <= '0';
							end if;
						when "001" =>
							if rs_value(31) = '0' then
								m_compare <= '1';
							elsif rs_value(31) /= '0' then
								m_compare <= '0';
							end if;
						when "010" =>
							if rs_value(31) = '0' and rs_value /= zeros then
								m_compare <= '1';
							else
								m_compare <= '0';
							end if;
						when "011" =>
							if rs_value(31) = '1' or rs_value = zeros then
								m_compare <= '1';
							else
								m_compare <= '0';
							end if;
						when "100" =>
							if rs_value(31) = '1' then
								m_compare <= '1';
							else
								m_compare <= '0';
							end if;
						when "101" =>
							if rs_value /= rt_value then
								m_compare <= '1';
							elsif rs_value = rt_value then
								m_compare <= '0';
							end if;
						when others =>
							m_compare <= '0';
					end case;
				when WriteB =>
					case pc_op is
						--question 2bit or 3bit?
						when "00" =>
							m_PcSrc <= RPC;
						when "01" =>
							if m_compare = '1' then
								m_PcSrc(31 downto 2) <= RPC(31 downto 2) + imme(29 downto 0);
							else
								m_PcSrc <= RPC;
							end if;
						when "10" =>
							m_PcSrc <= RPC(31 downto 28) & imme(25 downto 0) & "00";
						when "11" =>
							m_PcSrc <= alu_result;
						when others =>
							m_PcSrc <= RPC;
					end case;
				when others =>
			end case;
		end if;
	end process;

end bhv;
