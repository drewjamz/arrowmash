library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity vga is
	port(
		clk : in std_logic;
		valid : out std_logic;
		row : out unsigned(9 downto 0);
		col : out unsigned(9 downto 0);
		hsync : out std_logic;
		vsync : out std_logic
	);
end vga;

architecture synth of vga is


--component Arrow_Selector is
    --Port (
        --addr       : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit address input
        --arrow_type : in  STD_LOGIC_VECTOR(3 downto 0);  -- 2-bit arrow type selector
        --data_out   : out STD_LOGIC_VECTOR(2 downto 0)   -- 3-bit RGB data output
    --);
--end Arrow_Selector;



signal colcount : unsigned(9 downto 0);
signal rowcount : unsigned(9 downto 0);
signal hs : std_logic;
signal vs : std_logic;
signal colcountgreater : std_logic;

begin	
--arrow rom
	--Arrow_selector_inst : Arrow_Selector port map(
		--addr => "00000000";
		--arrow_type => "0001";
		--data_out => arrow_out;
	--);

colcountgreater <= '1' when colcount > 10d"655" else '0';

hs <= '1' when (colcount > 10d"655") and (colcount < 10d"752") else '0'; -- 656 752
vs <= '1' when (rowcount > 10d"489") and (rowcount < 10d"493") else '0'; --490 492

process (clk) is 
begin
	if rising_edge(clk) then
		if (colcount >= 10d"799") then
			colcount <= "0000000000";
		else
			colcount <= colcount + 10d"1";
		end if;
	end if;
end process;

process (clk) is
begin
	if rising_edge(clk) then
		if (colcount = 10d"799") then
			if (rowcount >= 10d"524") then
				rowcount <= "0000000000";
			else
				rowcount <= rowcount + 10d"1";
			end if;	
	end if;
	end if;
end process;

valid <= '1' when (colcount < 10d"640") and (rowcount < 10d"480") else '0';
hsync <= not hs;
vsync <= not vs;
row <= rowcount;
col <= colcount;

end;