library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.common.ALL;



entity general_register is
port(
    clk : IN STD_LOGIC;
	 state : in status;
	 rst : in std_logic;
	 
	 rs_addr : in std_logic_vector(4 downto 0);
	 rt_addr : in std_logic_vector(4 downto 0);
	 
	 write_addr : in std_logic_vector(4 downto 0);
	 write_value : in std_logic_vector(31 downto 0);
	 write_enable : in std_logic;
	 
	 rs_value : out std_logic_vector(31 downto 0);
	 rt_value : out std_logic_vector(31 downto 0);
	 regs : out std_logic_vector(1023 downto 0);
	 reg0 : out std_logic_vector(31 downto 0)
);
end general_register;

architecture Behavioral of general_register is

	type register_block is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal reg : register_block;
	signal state_reg : status;
    
begin
    
    regs(31 downto 0) <= reg(0);
    regs(63 downto 32) <= reg(1);
    regs(95 downto 64) <= reg(2);
    regs(127 downto 96) <= reg(3);
    regs(159 downto 128) <= reg(4);
    regs(191 downto 160) <= reg(5);
    regs(223 downto 192) <= reg(6);
    regs(255 downto 224) <= reg(7);
    regs(287 downto 256) <= reg(8);
    regs(319 downto 288) <= reg(9);
    regs(351 downto 320) <= reg(10);
    regs(383 downto 352) <= reg(11);
    regs(415 downto 384) <= reg(12);
    regs(447 downto 416) <= reg(13);
    regs(479 downto 448) <= reg(14);
    regs(511 downto 480) <= reg(15);
    regs(543 downto 512) <= reg(16);
    regs(575 downto 544) <= reg(17);
    regs(607 downto 576) <= reg(18);
    regs(639 downto 608) <= reg(19);
    regs(671 downto 640) <= reg(20);
    regs(703 downto 672) <= reg(21);
    regs(735 downto 704) <= reg(22);
    regs(767 downto 736) <= reg(23);
    regs(799 downto 768) <= reg(24);
    regs(831 downto 800) <= reg(25);
    regs(863 downto 832) <= reg(26);
    regs(895 downto 864) <= reg(27);
    regs(927 downto 896) <= reg(28);
    regs(959 downto 928) <= reg(29);
    regs(991 downto 960) <= reg(30);
    regs(1023 downto 992) <= reg(31);

    reg0 <= reg(0);
    
	process(clk, rst)
	begin
        -- changed Jan2
        if rst = '0' then
            state_reg <= state;
		elsif clk'event and clk = '1' then
			state_reg <= state;
		end if;
	end process;
    
	process(clk, rst)
	begin
		if rst = '0' then
			for i in 0 to 31 loop
				reg(i) <= (others => '0');
			end loop;
			
		elsif clk'event and clk = '1' and rst = '1' then
			if state = InsD then
				rs_value <= reg(conv_integer(rs_addr));
				rt_value <= reg(conv_integer(rt_addr));
			end if;
		
			if write_enable = '1' then
				reg(conv_integer(write_addr)) <= write_value;
			end if;
		end if;
	end process;
	
end Behavioral;

