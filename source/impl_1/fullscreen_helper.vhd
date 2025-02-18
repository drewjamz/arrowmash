--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

--entity fullscreen_helper is

	--port (
		--mode : in std_logic_vector(1 downto 0); -- 00 for start, 01 for blue, 10 for red]
		--row : in unsigned(9 downto 0);
		--col : in unsigned(9 downto 0);
		--rgb : out std_logic_vector(2 downto 0);
	--);
--end fullscreen_helper;

--architecture synth of fullscreen_helper is

--component start_screen_rom is
	--Port (
        --addr    : in  STD_LOGIC_VECTOR(13 downto 0); -- 14-bit address input
        --data_out: out STD_LOGIC_VECTOR(2 downto 0)  -- 3-bit data output
    --);
--end component;

--component red_win_rom is
	--Port (
        --addr    : in  STD_LOGIC_VECTOR(13 downto 0); -- 14-bit address input
        --data_out: out STD_LOGIC_VECTOR(2 downto 0)  -- 3-bit data output
    --);
--end component;

--component blue_win_rom is
	--Port (
        --addr    : in  STD_LOGIC_VECTOR(13 downto 0); -- 14-bit address input
        --data_out: out STD_LOGIC_VECTOR(2 downto 0)  -- 3-bit data output
    --);
--end component;

--signal addr : std_logic_vector(13 downto 0);
--signal redout : std_logic_vector(2 downto 0);
--signal bluout : std_logic_vector(2 downto 0);
--signal startout : std_logic_vector(2 downto 0);
--signal introw : std_logic_vector(9 downto 0);
--signal intcol : std_logic_vector(9 downto 0);

--begin

--introw <= std_logic_vector(row - 10d"64");
--intcol <= std_logic_vector(col + 10d"16");
--addr(13 downto 7) <= introw(7 downto 1)
--addr(6 downto 0) <= intcol(7 downto 1)


--my_b_rom : blue_win_rom port map(
	--addr => addr,
	--data_out => bluout
--);

--my_r_rom : red_win_rom port map(
	--addr => addr,
	--data_out => redout
--);

--my_s_rom : start_screen_rom port map(
	--addr => addr,
	--data_out => startout
--);

--rgb <= startout when mode = "00"
	--else startblu when mode = "01"
	--else startred;

--end;