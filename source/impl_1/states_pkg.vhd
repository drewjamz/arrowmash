library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package states_pkg is
        type state_machine_states is (Start_Screen, In_Game, Red_Win, Blue_Win);
end package;		