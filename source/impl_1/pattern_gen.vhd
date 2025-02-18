library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.arrows_pkg.all;
use work.states_pkg.all;

entity pattern_gen is
	port(
		--inclk : in std_logic;
		valid : in std_logic;
		row : in unsigned(9 downto 0);
		col : in unsigned(9 downto 0);
		arrow_enables : in std_logic_vector(0 to 7);
		arrow_types : in arrow_types_array(7 downto 0);
		arrow_y_poss : in arrow_y_pos_array(7 downto 0);
		livesOne : in unsigned (1 downto 0);
		livesTwo : in unsigned (1 downto 0);
		--game_end     : in std_logic;
        --reset_game   : in std_logic;
        --current_state: in state_machine_states;
		rgb : out std_logic_vector(2 downto 0)
	);
end pattern_gen;

architecture synth of pattern_gen is

component arrow_selector is
	Port (
        addr       : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit address input
        arrow_type : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit 1-hot arrow type selector
        data_out   : out STD_LOGIC_VECTOR(2 downto 0)   -- 3-bit RGB data output
    );
end component;

component blank_arrow_selector is
	Port (
        addr       : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit address input
        arrow_type : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit 1-hot arrow type selector
        data_out   : out STD_LOGIC_VECTOR(2 downto 0)   -- 3-bit RGB data output
    );
end component;

component heart_selector is
	Port (
        addr       : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit address input
        heart_color : in STD_LOGIC; -- 0 for blue, 1 for red
		heart_filled : in STD_LOGIC; -- 0 for black, 1 for color
        data_out   : out STD_LOGIC_VECTOR(2 downto 0)   -- 3-bit RGB data output
    );

end component;

component Start_Screen_Rom is
    Port (
        addr    : in  STD_LOGIC_VECTOR(13 downto 0); -- 14-bit address input
        data_out: out STD_LOGIC_VECTOR(2 downto 0)   -- 3-bit data output
    );
end component;

component Red_Win_Rom is
    Port (
        addr    : in  STD_LOGIC_VECTOR(13 downto 0); -- 14-bit address input
        data_out: out STD_LOGIC_VECTOR(2 downto 0)   -- 3-bit data output
    );
end component;

component Blue_Win_Rom is
    Port (
        addr    : in  STD_LOGIC_VECTOR(13 downto 0); -- 14-bit address input
        data_out: out STD_LOGIC_VECTOR(2 downto 0)   -- 3-bit data output
    );
end component;

component pattern_gen_helper is
	port(
		arrow_enable : in std_logic;
		arrow_type : in std_logic_vector(3 downto 0);
		arrow_y_pos : in unsigned(9 downto 0);
		screen_x_pos : in unsigned(9 downto 0);
		screen_y_pos : in unsigned(9 downto 0);
		rom_coord : out unsigned(7 downto 0);
		return_enable : out std_logic
		);
end component;

component pattern_gen_helper2 is
	port(
		arrow_enable : in std_logic;
		arrow_type : in std_logic_vector(3 downto 0);
		arrow_y_pos : in unsigned(9 downto 0);
		screen_x_pos : in unsigned(9 downto 0);
		screen_y_pos : in unsigned(9 downto 0);
		rom_coord2 : out unsigned(7 downto 0);
		return_enable : out std_logic
		);
end component;

component blank_helper is 
	port(
		arrow_enable : in std_logic;
		arrow_type : in std_logic_vector(3 downto 0);
		screen_x_pos : in unsigned(9 downto 0);
		screen_y_pos : in unsigned(9 downto 0);
		rom_coord3 : out unsigned(7 downto 0);
		return_enable : out std_logic
		);
end component;

component blank_helper2 is 
	port(
		arrow_enable : in std_logic;
		arrow_type : in std_logic_vector(3 downto 0);
		screen_x_pos : in unsigned(9 downto 0);
		screen_y_pos : in unsigned(9 downto 0);
		rom_coord3 : out unsigned(7 downto 0);
		return_enable : out std_logic
		);
end component;

component heart_helper is
	port(
		heart_number : in unsigned(1 downto 0);
		heart_player : in std_logic;
		screen_x_pos : in unsigned(9 downto 0);
		screen_y_pos : in unsigned(9 downto 0);
		rom_coord : out unsigned(7 downto 0);
		return_enable : out std_logic
		);
end component;

--component fullscreen_helper is
	--port (
		--mode : in std_logic_vector(1 downto 0); -- 00 for start, 01 for blue, 10 for red]
		--row : in unsigned(9 downto 0);
		--col : in unsigned(9 downto 0);
		--rgb : out std_logic_vector(2 downto 0);
	--);
--end component;


--component randomizer is
	--port(
		--masterClk : in std_logic;
		--out_data : out std_logic_vector(3 downto 0)
	--);
--end component;

--signal arrow_enables : std_logic_vector(0 to 3) := "0000";
signal blank_enables : std_logic_vector(0 to 7) := "11111111";
type t_arrow_types is array(0 to 7) of std_logic_vector(3 downto 0);
--signal arrow_types : t_arrow_types := ("0001", "0010", "0100", "1000");
--type t_arrow_y_poss is array(0 to 3) of unsigned(9 downto 0);
--signal arrow_y_poss : t_arrow_y_poss := (10d"30", 10d"30", 10d"30", 10d"30");
signal displaying : std_logic_vector(0 to 7) := "00000000";
--signal displaying2 : std_logic_vector(0 to 3) := "0000";
signal displaying3 : std_logic_vector(0 to 7) := "11111111";
signal current_displaying : unsigned(2 downto 0) := 3d"0";
type t_rom_coords is array(0 to 7) of unsigned(7 downto 0);
signal blank_arrow_types : t_arrow_types := ("0001", "0010", "0100", "1000", "0001", "0010", "0100", "1000");
signal rom_coords : t_rom_coords;
--signal rom_coords2 : t_rom_coords;
signal rom_coords3 : t_rom_coords;
signal show_arrow : std_logic;
--signal show_arrow2 : std_logic;
signal show_arrow3 : std_logic;
signal arrow_to_show : unsigned(2 downto 0);
signal blank_to_show : unsigned(2 downto 0);
signal rgb_from_rom : std_logic_vector(2 downto 0);
signal rgb_from_blank : std_logic_vector(2 downto 0);
signal temp : std_logic_vector(7 downto 0);
--signal dropCounter : unsigned(19 downto 0) := "00000000000000000000";
--signal rand : std_logic_vector(3 downto 0);
signal newArrow : std_logic := '1';
--signal checkRand : std_logic_vector (3 downto 0);


signal heart_rom_coords : t_rom_coords;
signal heart_displaying : std_logic_vector(0 to 5);
signal heart_color : std_logic_vector(0 to 5) := "000111";
signal heart_filled : std_logic_vector(0 to 5);
signal heart_to_show : unsigned(2 downto 0);
signal show_heart : std_logic;
signal heart_rom_rgb : std_logic_vector(2 downto 0);

signal start_screen_rgb : std_logic_vector(2 downto 0);
signal red_win_rgb      : std_logic_vector(2 downto 0);
signal blue_win_rgb     : std_logic_vector(2 downto 0);
signal rom_addr : std_logic_vector(13 downto 0);

begin

-- rgb <= std_logic_vector(col(7 downto 2)) when valid else "000000";





my_arrow_selector : arrow_selector port map(
	addr => std_logic_vector(rom_coords(to_integer(current_displaying))),
	arrow_type => arrow_types(to_integer(current_displaying)),
	data_out => rgb_from_rom
);

my_blank_selector : blank_arrow_selector port map(
	addr => std_logic_vector(rom_coords3(to_integer(blank_to_show))),
	arrow_type => blank_arrow_types(to_integer(blank_to_show)),
	data_out => rgb_from_blank
);

my_heart_selector : heart_selector port map(
	
	addr => std_logic_vector(heart_rom_coords(to_integer(heart_to_show))),
	heart_color => heart_color(to_integer(heart_to_show)),
	heart_filled => heart_filled(to_integer(heart_to_show)),
	data_out => heart_rom_rgb

);

--my_randomizer : randomizer port map(
	--masterClk => inclk,
	--out_data => rand
--);


temp(7 downto 4) <= std_logic_vector(col(3 downto 0));
temp(3 downto 0) <= std_logic_vector(row(3 downto 0));
--my_arrow_selector : arrow_selector port map(
	--addr => temp,
	--arrow_type => rand,
	--data_out => rgb_from_rom
--);

gen_helper : for i in 0 to 3 generate

	helper : pattern_gen_helper port map(
		arrow_enable => arrow_enables(i),
		arrow_type => arrow_types(i),
		arrow_y_pos => arrow_y_poss(i),
		screen_x_pos => col,
		screen_y_pos => row,
		rom_coord => rom_coords(i),
		return_enable => displaying(i)
	);
	
	--helper2 : pattern_gen_helper2 port map(
		--arrow_enable => arrow_enables(i),
		--arrow_type => arrow_types(i),
		--arrow_y_pos => arrow_y_poss(i),
		--screen_x_pos => col,
		--screen_y_pos => row,
		--rom_coord2 => rom_coords(i),
		--return_enable => displaying(i)
	--);
	
	blank :  blank_helper port map(
		arrow_enable => blank_enables(i),
		arrow_type => blank_arrow_types(i),
		screen_x_pos => col,
		screen_y_pos => row,
		rom_coord3 => rom_coords3(i),
		return_enable => displaying3(i)
	);
	


end generate gen_helper;

gen_helper2 : for i in 4 to 7 generate

	helper2 : pattern_gen_helper2 port map(
		arrow_enable => arrow_enables(i),
		arrow_type => arrow_types(i),
		arrow_y_pos => arrow_y_poss(i),
		screen_x_pos => col,
		screen_y_pos => row,
		rom_coord2 => rom_coords(i),
		return_enable => displaying(i)
	);
	
	blank :  blank_helper2 port map(
		arrow_enable => blank_enables(i),
		arrow_type => blank_arrow_types(i),
		screen_x_pos => col,
		screen_y_pos => row,
		rom_coord3 => rom_coords3(i),
		return_enable => displaying3(i)
	);
	
end generate gen_helper2;

gen_heart_helper : for i in 0 to 2 generate

	helper_p1 : heart_helper port map(
		heart_number => to_unsigned(i, 2),
		heart_player => '0',
		screen_x_pos => col,
		screen_y_pos => row,
		rom_coord => heart_rom_coords(i),
		return_enable => heart_displaying(i)
	);
	
	helper_p2 : heart_helper port map(
		heart_number => to_unsigned(i, 2),
		heart_player => '1',
		screen_x_pos => col,
		screen_y_pos => row,
		rom_coord => heart_rom_coords(i + 3),
		return_enable => heart_displaying(i + 3)
	);
	
end generate gen_heart_helper;

--my_fs_helper : fullscreen_helper

--helper0 : pattern_gen_helper port map(
		--arrow_enable => arrow_enables(0),
		--arrow_type => arrow_types(0),
		--arrow_y_pos => arrow_y_poss(0),
		--screen_x_pos => col,
		--screen_y_pos => row,
		--rom_coord => rom_coords(0),
		--return_enable => displaying(0)
	--);


--process(inclk)
--begin
    --if rising_edge(inclk) then
        --dropCounter <= dropCounter + 1;
		--arrow_enables <= rand or arrow_enables;
        
         --Arrow Movement Logic:
        --if (dropCounter = "00000000000000000000") then
            --for i in 0 to 3 loop
				--if (arrow_enables(i) = '1') then
					--if arrow_y_poss(i) < 10d"470" then
						 --Move the arrow down the screen
						--arrow_y_poss(i) <= arrow_y_poss(i) + 10;
					--else
						 --Reset the arrow to the top once it reaches the bottom
						--arrow_y_poss(i) <= 10d"0";
						--arrow_enables(i) <= '0';
					--end if;
					
				--end if;
            --end loop;
        --end if;
    --end if;
--end process;
--displaying <= arrow_enables(0 to 3);
	
show_arrow <= or displaying;
--show_arrow2 <= or displaying2;
show_arrow3 <= or displaying3;
--arrow_to_show <= 3d"0" when displaying(0) or displaying2(0)
				 --else 3d"1" when displaying(1) or displaying2(1)
				 --else 3d"2" when displaying(2) or displaying2(2)
				 --else 3d"3";
				 
show_heart <= or heart_displaying;
-- Find which arrow we are currently looking at so we can select the correct arrow
current_displaying <= 3d"0" when displaying(0) else
					  3d"1" when displaying(1) else
					  3d"2" when displaying(2) else
					  3d"3" when displaying(3) else
					  3d"4" when displaying(4) else
					  3d"5" when displaying(5) else
					  3d"6" when displaying(6) else
					  3d"7" when displaying(7);
					  
-- Based on the arrow we are currently looking at, take the pixel from the correct arrow selector
--arrow_to_show <= 3d"0" when arrow_types(to_integer(current_displaying)) = "1000"
				 --else 3d"1" when arrow_types(to_integer(current_displaying)) = "0100"
				 --else 3d"2" when arrow_types(to_integer(current_displaying)) = "0010"
				 --else 3d"3";

-- Check for blank arrows too
blank_to_show <= 3d"0" when displaying3(0)
				else 3d"1" when displaying3(1)
				else 3d"2" when displaying3(2)
				else 3d"3" when displaying3(3)
				else 3d"4" when displaying3(4)
				else 3d"5" when displaying3(5)
				else 3d"6" when displaying3(6)
				else 3d"7";
				
heart_to_show <= 3d"0" when heart_displaying(0)
				else 3d"1" when heart_displaying(1)
				else 3d"2" when heart_displaying(2)
				else 3d"3" when heart_displaying(3)
				else 3d"4" when heart_displaying(4)
				else 3d"5";

heart_filled(0) <= '1' when livesOne >=2d"1" else '0';
heart_filled(1) <= '1' when livesOne >=2d"2" else '0';
heart_filled(2) <= '1' when livesOne >=2d"3" else '0';
heart_filled(3) <= '1' when livesTwo >=2d"1" else '0';
heart_filled(4) <= '1' when livesTwo >=2d"2" else '0';
heart_filled(5) <= '1' when livesTwo >=2d"3" else '0';



--rgb(0) <= rom_coords(to_integer(col(6 downto 4)))(to_integer(row(7 downto 0)));
rgb <= heart_rom_rgb when show_heart else
       rgb_from_rom when show_arrow else
       rgb_from_blank when show_arrow3 else

       "000"; -- Default
	   
	   --start_screen_rgb when current_state = Start_Screen else
       --red_win_rgb when current_state = Red_Win else
       --blue_win_rgb when current_state = Blue_Win else


end;