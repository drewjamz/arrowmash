library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Heart_Selector is
    Port (
        addr       : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit address input
        heart_color : in STD_LOGIC; -- 0 for blue, 1 for red
		heart_filled : in STD_LOGIC; -- 0 for black, 1 for color
        data_out   : out STD_LOGIC_VECTOR(2 downto 0)   -- 3-bit RGB data output
    );
end Heart_Selector;

architecture Behavioral of Heart_Selector is
    -- Component declarations for each arrow ROM
    component Blue_Heart_Rom is
        Port (
            addr    : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out: out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component Red_Heart_Rom is
        Port (
            addr    : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out: out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component Blank_Heart_Rom is
        Port (
            addr    : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out: out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Signal declarations for outputs of individual ROMs
    signal blue_heart_data     : STD_LOGIC_VECTOR(2 downto 0);
    signal red_heart_data  : STD_LOGIC_VECTOR(2 downto 0);
    signal blank_heart_data   : STD_LOGIC_VECTOR(2 downto 0);

begin
    -- Instantiate the Blue Heart ROM
    Blue_Heart_Rom_inst : Blue_Heart_Rom
        port map (
            addr => addr,
            data_out => blue_heart_data
        );

    -- Instantiate the Red Heart ROM
   Red_Heart_Rom_inst : Red_Heart_Rom
        port map (
            addr => addr,
            data_out => red_heart_data
        );

    -- Instantiate the Blank Heart ROM
    Blank_Heart_Rom_inst : Blank_Heart_Rom
        port map (
            addr => addr,
            data_out => blank_heart_data
        );

    -- Select the appropriate ROM output based on 1-hot heart_type
	
    --process(addr, heart_type, blue_heart_data, red_heart_data, blank_heart_data)
    --begin
        --case heart_type is
            --when "001" =>  -- Up Arrow selected
                --data_out <= blue_heart_data;
            --when "010" =>  -- Right Arrow selected
                --data_out <= red_heart_data;
            --when "100" =>  -- Down Arrow selected
                --data_out <= blank_heart_data;
            --when others =>
                --data_out <= (others => '0');  -- Default case for invalid input
        --end case;
    --end process;
	data_out <= blank_heart_data when not heart_filled
		else red_heart_data when heart_color
		else blue_heart_data;
end Behavioral;
