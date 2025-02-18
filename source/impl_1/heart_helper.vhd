library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity heart_helper is 
	port(
		heart_number : in unsigned(1 downto 0);
		heart_player : in std_logic;
		screen_x_pos : in unsigned(9 downto 0);
		screen_y_pos : in unsigned(9 downto 0);
		rom_coord : out unsigned(7 downto 0);
		return_enable : out std_logic
		);
end heart_helper;

architecture synth of heart_helper is

signal in_y_range : std_logic;
signal in_x_range : std_logic;
signal rom_x_coord : unsigned(4 downto 0);
signal rom_y_coord : unsigned(4 downto 0);
signal heart_x_pos : unsigned(9 downto 0);
signal heart_y_pos : unsigned(9 downto 0);
signal xdiff : unsigned(9 downto 0);
signal ydiff : unsigned(9 downto 0);


begin
	
	heart_x_pos <= 10d"250" when heart_number = "00"
			 else 10d"300" when heart_number = "01"
			 else 10d"350"; 
			 
	heart_y_pos <= 10d"100" when heart_player = '0'
			 else 10d"200";
	
	in_y_range <= '1' when screen_y_pos >= heart_y_pos and screen_y_pos < heart_y_pos + 32 else '0';
	in_x_range <= '1' when screen_x_pos >= heart_x_pos and screen_x_pos < heart_x_pos + 32 else '0';
	
	xdiff <= screen_x_pos - heart_x_pos;
	ydiff <= screen_y_pos - heart_y_pos;
	
	rom_x_coord <= xdiff (4 downto 0);
	rom_y_coord <= ydiff (4 downto 0);
	
	rom_coord(7 downto 4) <= rom_x_coord(4 downto 1);
	rom_coord(3 downto 0) <= rom_y_coord(4 downto 1);
	
	return_enable <= in_y_range and in_x_range;
	
end;