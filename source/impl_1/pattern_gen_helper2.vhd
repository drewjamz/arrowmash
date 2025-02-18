library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen_helper2 is 
	port(
		arrow_enable : in std_logic;
		arrow_type : in std_logic_vector(3 downto 0);
		arrow_y_pos : in unsigned(9 downto 0);
		screen_x_pos : in unsigned(9 downto 0);
		screen_y_pos : in unsigned(9 downto 0);
		rom_coord2 : out unsigned(7 downto 0);
		return_enable : out std_logic
		);
end pattern_gen_helper2;

architecture synth of pattern_gen_helper2 is

signal in_y_range : std_logic;
signal in_x_range : std_logic;
signal rom_x_coord : unsigned(4 downto 0);
signal rom_y_coord : unsigned(4 downto 0);
signal arrow_x_pos : unsigned(9 downto 0);
signal xdiff : unsigned(9 downto 0);
signal ydiff : unsigned(9 downto 0);


begin
	
	arrow_x_pos <= 10d"416" when arrow_type = "0001"
			 else 10d"480" when arrow_type = "0010"
			 else 10d"544" when arrow_type = "0100"
			 else 10d"608"; --when arrow_type = "1000";
	
	
	in_y_range <= '1' when screen_y_pos >= arrow_y_pos and screen_y_pos < arrow_y_pos + 32 else '0';
	in_x_range <= '1' when screen_x_pos >= arrow_x_pos and screen_x_pos < arrow_x_pos + 32 else '0';
	
	xdiff <= screen_x_pos - arrow_x_pos;
	ydiff <= screen_y_pos - arrow_y_pos;
	
	rom_x_coord <= xdiff (4 downto 0);
	rom_y_coord <= ydiff (4 downto 0);
	
	rom_coord2(7 downto 4) <= rom_x_coord(4 downto 1);
	rom_coord2(3 downto 0) <= rom_y_coord(4 downto 1);
	
	return_enable <= in_y_range and in_x_range;
	
end;