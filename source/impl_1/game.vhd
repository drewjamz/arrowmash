library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.arrows_pkg.all;
use work.states_pkg.all;


entity game is
	port(
		inclk : in std_logic;
		dataOne : in std_logic_vector(7 downto 0) := "00000000";
		dataTwo : in std_logic_vector(7 downto 0) := "00000000";
		arrow_enables : out std_logic_vector(0 to 7) := "00000000";
		arrow_types : out arrow_types_array(7 downto 0) := ("0001", "0010", "0100", "1000", "0001", "0010", "0100", "1000");
		arrow_y_poss : out arrow_y_pos_array(7 downto 0) := (10d"30", 10d"30", 10d"30", 10d"30", 10d"30", 10d"30", 10d"30", 10d"30");
		game_end : out std_logic := '0';
		reset_game : in std_logic := '0';
		current_state : in state_machine_states;
		livesOne : out unsigned (1 downto 0) := 2d"3";
		livesTwo : out unsigned (1 downto 0) := 2d"3"
	);
end game;

architecture synth of game is

component randomizer is
	port(
		masterClk : in std_logic;
		out_data : out std_logic_vector(3 downto 0)
	);
end component;

signal dropCounter : unsigned(19 downto 0) := "00000000000000000000";
signal newArrowCounter : unsigned(24 downto 0) := "0000000000000000000000000";
signal rand : std_logic_vector(3 downto 0) := "0000";
signal pressedArrowOne : std_logic_vector(3 downto 0) := "0000";
signal pressedArrowTwo : std_logic_vector(3 downto 0) := "0000";
signal guardOne : unsigned(23 downto 0) := 24x"0";
signal guardTwo : unsigned(23 downto 0) := 24x"0";
signal guardingOne : std_logic := '0';
signal guardingTwo : std_logic := '0';
signal checkFailOne : std_logic := '0';
signal checkFailTwo : std_logic := '0';
signal failOne : std_logic := '0';
signal failTwo : std_logic := '0';

begin

my_randomizer : randomizer port map(
	masterClk => inclk,
	out_data => rand
);

-- Set guards
guardingOne <= '0' when (guardOne = 24x"0") else '1';
guardingTwo <= '0' when (guardTwo = 24x"0") else '1';

process(inclk)
begin
	

    if rising_edge(inclk) then
        dropCounter <= dropCounter + 1;
		newArrowCounter <= newArrowCounter + 1;
		
		-- Increment guards if they're active
		if guardingOne then
			guardOne <= guardOne + 1;
		end if;
		
		if guardingTwo then
			guardTwo <= guardTwo + 1;
		end if;
		
		--arrow_enables <= rand or arrow_enables;
		
		-- Enable and set a random arrow
		if (newArrowCounter = "0000000000000000000000000") then
			for i in 0 to 3 loop
				if (arrow_enables(i) = '0') then
					arrow_enables(i) <= '1';
					arrow_types(i) <= rand;
					arrow_y_poss(i) <= 10d"0";
					arrow_enables(i + 4) <= '1';
					arrow_types(i + 4) <= rand;
					arrow_y_poss(i + 4) <= 10d"0";
					exit;
				end if;
			end loop;
		end if;
		
		
		 --Check if a player input an arrow button and set up a failure condition if they did. 
		if (dataOne /= "11111111") then
			if (not guardingOne) then
				guardOne <= guardOne + 1;
				case dataOne is
					--!!!!!!!!! TODO: Replace these cases with the data outputs corresponding to the correct arrow !!!!!!!!!
					when "11110111" => 
						pressedArrowOne <= "0001";
						checkFailOne <= '1';
					when "11111011" => 
						pressedArrowOne <= "0100";
						checkFailOne <= '1';
					when "11111101" => 
						pressedArrowOne <= "1000";
						checkFailOne <= '1';
					when "11111110" => 
						pressedArrowOne <= "0010";
						checkFailOne <= '1';
					--!!!!!!!!! TODO: Add logic for other button presses (pause, continue, etc.) !!!!!!!!!
				when others => null;
			end case;
			end if;
		end if;
		
		if (dataTwo /= "11111111") then
			if (not guardingTwo) then
			guardTwo <= guardTwo + 1;
			case dataTwo is
				 --!!!!!!!!! TODO: Replace these cases with the data outputs corresponding to the correct arrow !!!!!!!!!
				when "11110111" => 
					pressedArrowTwo <= "0001";
					checkFailTwo <= '1';
				when "11111011" => 
					pressedArrowTwo <= "0100";
					checkFailTwo <= '1';
				when "11111101" => 
					pressedArrowTwo <= "1000";
					checkFailTwo <= '1';
				when "11111110" => 
					pressedArrowTwo <= "0010";
					checkFailTwo <= '1';
				 --!!!!!!!!! TODO: Add logic for other button presses (pause, continue, etc.) !!!!!!!!!
				when others => null;
			end case;
			end if;
		end if;

		
		 --Check if the arrow button either player input correctly corresponds to an arrow in the right area
		 --Remove their failure condition and reset the corresponding arrow if it is
		 
		if (checkFailOne = '1') then
			for i in 0 to 3 loop
				if (arrow_types(i) = pressedArrowOne) then
						
					if ((arrow_y_poss(i) > 330) and (arrow_y_poss(i) < 470)) then
						arrow_enables(i) <= '0';
						arrow_y_poss(i) <= 10d"0";
						arrow_types(i) <= "0000";
						pressedArrowOne <= "0000";
						checkFailOne <= '0';
						exit;
						
					end if;
				end if;
			end loop;
		end if;
		
		if (checkFailTwo = '1') then
			for i in 4 to 7 loop
				if (arrow_types(i) = pressedArrowTwo) then
					if ((arrow_y_poss(i) > 330) and (arrow_y_poss(i) < 470)) then
						checkFailTwo <= '0';
						arrow_enables(i) <= '0';
						arrow_y_poss(i) <= 10d"0";
						arrow_types(i) <= "0000";
						pressedArrowTwo <= "0000";
						exit;
					end if;
				end if;
			end loop;
		end if;
		
        
        -- Arrow Movement Logic:
        if (dropCounter = "00000000000000000000") then
			
            for i in 0 to 7 loop
				if (arrow_enables(i) = '1') then
					if arrow_y_poss(i) < 10d"470" then
						-- Move the arrow down the screen
						arrow_y_poss(i) <= arrow_y_poss(i) + 10;
					else
						-- Reset the arrow to the top once it reaches the bottom
						arrow_y_poss(i) <= 10d"0";
						arrow_enables(i) <= '0';
						arrow_types(i) <= "0000";
						
						-- Set the player to lose a life
						if (i < 4) then
							checkFailOne <= '1';
						else 
							checkFailTwo <= '1';
						end if;
						
					end if;
					
				end if;
            end loop;
        end if;
		
		-- Remove a life from a player if they failed by either pressing a wrong button or an arrow reached the bottom
		if (checkFailOne and (not guardingOne)) then
			livesOne <= livesOne - 1;
			checkFailOne <= '0';
		end if;
		
		if (checkFailTwo and (not guardingTwo)) then
			livesTwo <= livesTwo - 1;
			checkFailTwo <= '0';
		end if;
		
		if (guardOne = "000000000000000000001000") then
			pressedArrowOne <= "0000";
		end if;
		--pressedArrowTwo <= "0000";
		
		if (guardTwo = "000000000000000000001000") then
			pressedArrowTwo <= "0000";
		end if;
		
		-- End the game if either or both players lose all their lives
		-- !!!!!!!!! TODO: Implement logic if either player loses all their lives !!!!!!!!!
		if (livesOne = 0) then
			game_end <= '1';			
		elsif (livesTwo = 0) then
			game_end <= '1';
		else
			game_end <= '0';
		end if;
		
    end if;
end process;

end;