library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.arrows_pkg.all;use work.states_pkg.all;



entity states is
	port(
		inclk : in std_logic;
		dataOne : in std_logic_vector(7 downto 0) := "00000000";
		dataTwo : in std_logic_vector(7 downto 0) := "00000000";
		game_end : in std_logic := '0';
		reset_game : out std_logic := '0';
		current_state : out state_machine_states
	);
end states;

architecture synth of states is

signal state_machine : state_machine_states := Start_Screen;

signal button_pressed : unsigned(1 downto 0); -- 2d"0" is none, 2d"1" is start", 2d"2" is select 
signal rom_addr : std_logic_vector(13 downto 0); -- ROM address

component Start_Screen_Rom
        Port (
            addr    : in  std_logic_vector(13 downto 0);
            data_out: out std_logic_vector(2 downto 0)
        );
    end component;

begin

process(inclk)
begin

	-- Check if a player input a button to change state
	if (dataOne /= 8d"0") then
		case dataOne is
			when "10000000" => button_pressed <= 2d"1"; 
			when "01000000" => button_pressed <= 2d"2"; 
			when others => button_pressed <= 2d"0";
		end case;
	end if;
		
	if (dataTwo /= 8d"0") then
		case dataTwo is
			when "10000000" => button_pressed <= 2d"1"; 
			when "01000000" => button_pressed <= 2d"2"; 
			when others => button_pressed <= 2d"0";
		end case;
	end if;
	

    if rising_edge(inclk) then
		case state_machine is
			when Start_Screen =>
				if button_pressed = 2d"1" then
					state_machine <= In_Game;
					reset_game <= '1';
				else
					state_machine <= Start_Screen;
					reset_game <= '0';
				end if;

			when In_Game =>
				if game_end then
					state_machine <= Blue_Win;
				else
					state_machine <= In_Game;
				end if;

			when Blue_Win =>
				if button_pressed = 2d"1" then
					state_machine <= In_Game;
					reset_game <= '1';
				elsif button_pressed = 2d"2" then
					state_machine <= Start_Screen;
				else
					state_machine <= Blue_Win;
				end if;

			when Red_Win =>
				if button_pressed = 2d"1" then
					state_machine <= In_Game;
					reset_game <= '1';
				elsif button_pressed = 2d"2" then
					state_machine <= Start_Screen;
				else
					state_machine <= Red_Win;
				end if;

			when others =>
				state_machine <= Start_Screen;
		end case;
	end if;
end process;

end;
					
		
		
		
		