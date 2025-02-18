library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package arrows_pkg is
        type arrow_types_array is array(natural range <>) of std_logic_vector(3 downto 0);
		type arrow_y_pos_array is array(natural range <>) of unsigned(9 downto 0);
end package;		