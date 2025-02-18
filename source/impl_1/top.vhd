library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.arrows_pkg.all;	
use work.states_pkg.all;

entity top is
	port(
		vgaclk    : in std_logic;
		dataNesOne : in std_logic;
		dataNesTwo : in std_logic;
		vgaclkout : out std_logic;
		hsync : out std_logic;
		vsync : out std_logic;
		rgb : out std_logic_vector(2 downto 0);
		latchNesOne : out std_logic;
		clkNesOne : out std_logic;
		--outNesOne : out std_logic_vector(7 downto 0);
		latchNesTwo : out std_logic;
		clkNesTwo : out std_logic
		--outNesTwo : out std_logic_vector(7 downto 0)
		
	);
end top;

architecture synth of top is

component mypll is
    port(
        ref_clk_i: in std_logic;
        rst_n_i: in std_logic;
        outcore_o: out std_logic;
        outglobal_o: out std_logic
    );
end component;

component vga is
	port(
		clk : in std_logic;
		valid : out std_logic;
		row : out unsigned(9 downto 0);
		col : out unsigned(9 downto 0);
		hsync : out std_logic;
		vsync : out std_logic
	);
end component;

component pattern_gen is
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
end component;

component NES_controller is
    port (
		data : in std_logic;
		inclk : in std_logic;
		latch : out std_logic;
        clock : out std_logic;
		out_data : out std_logic_vector(7 downto 0)
    );
end component;

component game is 
	port (
		inclk : in std_logic;
		dataOne : in std_logic_vector(7 downto 0);
		dataTwo : in std_logic_vector(7 downto 0);
		arrow_enables : out std_logic_vector(0 to 7);
		arrow_types : out arrow_types_array(7 downto 0);
		arrow_y_poss : out arrow_y_pos_array(7 downto 0);
		game_end : out std_logic := '0';
		reset_game : in std_logic := '0';
		current_state : in state_machine_states;
		livesOne : out unsigned (1 downto 0);
		livesTwo : out unsigned (1 downto 0)
	);
end component;

component states is 
	port(
		inclk : in std_logic;
		dataOne : in std_logic_vector(7 downto 0) := "00000000";
		dataTwo : in std_logic_vector(7 downto 0) := "00000000";
		game_end : in std_logic := '0';
		reset_game : out std_logic := '0';
		current_state : out state_machine_states
	);
end component;



--VGA
signal intclk : std_logic;
signal row : unsigned(9 downto 0);
signal col : unsigned(9 downto 0);
signal valid : std_logic;
signal intrgb : std_logic_vector(2 downto 0);

--NES output data
signal outDataNesOne : std_logic_vector(7 downto 0);
signal outDataNesTwo : std_logic_vector(7 downto 0);

--arrow rom output data
signal arrow_out : std_logic_vector(2 downto 0);

-- Arrows data
signal arrow_enables : std_logic_vector(0 to 7);
signal arrow_types : arrow_types_array(7 downto 0);
signal arrow_y_poss : arrow_y_pos_array(7 downto 0);

-- Lives data
signal livesOne : unsigned (1 downto 0) := 2d"3";
signal livesTwo : unsigned (1 downto 0) := 2d"3";

-- State data
signal game_end : std_logic := '0';
signal reset_game : std_logic := '0';
signal current_state : state_machine_states;

begin

	game1 : game port map (
		inclk => intclk,
		dataOne => outDataNesOne,
		dataTwo => outDataNesTwo,
		arrow_enables => arrow_enables,
		arrow_types => arrow_types,
		arrow_y_poss => arrow_y_poss,
		game_end => game_end,
		reset_game => reset_game,
		current_state => current_state,
		livesOne => livesOne,
		livesTwo => livesTwo
	);
	
	state_machine1 : states port map (
		inclk => intclk,
		dataOne => outDataNesOne,
		dataTwo => outDataNesTwo,
		game_end => game_end,
		reset_game => reset_game,
		current_state => current_state
	);

--vga
	pllinst : mypll port map(
		ref_clk_i => vgaclk,
		rst_n_i => '1',
		outcore_o => vgaclkout,
		outglobal_o => intclk
	);
	
	vga1 : vga port map (
		clk => intclk,
		hsync => hsync,
		vsync => vsync,
		row => row,
		col => col,
		valid => valid
	);
	
	mypattern : pattern_gen port map (
		--inclk => intclk,
		valid => valid,
		row => row,
		col => col,
		arrow_enables => arrow_enables,
		arrow_types => arrow_types,
		arrow_y_poss => arrow_y_poss,
		livesOne => livesOne,
		livesTwo => livesTwo,
		--game_end => game_end,
        --reset_game => reset_game,
        --current_state => current_state,
		rgb => intrgb
	);
	rgb <= intrgb when valid else "000";	
	--intrgb(0) <= outDataNesOne(0);
	--intrgb(1) <= outDataNesOne(1);
	--intrgb(2) <= outDataNesTwo(0);

--nes
	controllerOne : NES_controller port map(
		data => dataNesOne,
		inclk => intclk,
		latch => latchNesOne,
        clock => clkNesOne,
		out_data => outDataNesOne
    );	
	
	controllerTwo : NES_controller port map(
		data => dataNesTwo,
		inclk => intclk,
		latch => latchNesTwo,
        clock => clkNesTwo,
		out_data => outDataNesTwo
    );	


	
	
	
	

end;