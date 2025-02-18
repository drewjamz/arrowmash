library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Arrow_Selector is
    Port (
        addr       : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit address input
        arrow_type : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit 1-hot arrow type selector
        data_out   : out STD_LOGIC_VECTOR(2 downto 0)   -- 3-bit RGB data output
    );
end Arrow_Selector;

architecture Behavioral of Arrow_Selector is
    -- Component declarations for each arrow ROM
    component Up_Arrow_Rom is
        Port (
            addr    : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out: out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component Right_Arrow_Rom is
        Port (
            addr    : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out: out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component Down_Arrow_Rom is
        Port (
            addr    : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out: out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component Left_Arrow_Rom is
        Port (
            addr    : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out: out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Signal declarations for outputs of individual ROMs
    signal up_arrow_data     : STD_LOGIC_VECTOR(2 downto 0);
    signal right_arrow_data  : STD_LOGIC_VECTOR(2 downto 0);
    signal down_arrow_data   : STD_LOGIC_VECTOR(2 downto 0);
    signal left_arrow_data   : STD_LOGIC_VECTOR(2 downto 0);

begin
    -- Instantiate the Up Arrow ROM
    Up_Arrow_Rom_inst : Up_Arrow_Rom
        port map (
            addr => addr,
            data_out => up_arrow_data
        );

    -- Instantiate the Right Arrow ROM
    Right_Arrow_Rom_inst : Right_Arrow_Rom
        port map (
            addr => addr,
            data_out => right_arrow_data
        );

    -- Instantiate the Down Arrow ROM
    Down_Arrow_Rom_inst : Down_Arrow_Rom
        port map (
            addr => addr,
            data_out => down_arrow_data
        );

    -- Instantiate the Left Arrow ROM
    Left_Arrow_Rom_inst : Left_Arrow_Rom
        port map (
            addr => addr,
            data_out => left_arrow_data
        );

    -- Select the appropriate ROM output based on 1-hot arrow_type
    process(addr, arrow_type, up_arrow_data, right_arrow_data, down_arrow_data, left_arrow_data)
    begin
        case arrow_type is
            when "0001" =>  -- Up Arrow selected
                data_out <= up_arrow_data;
            when "0010" =>  -- Right Arrow selected
                data_out <= right_arrow_data;
            when "0100" =>  -- Down Arrow selected
                data_out <= down_arrow_data;
            when "1000" =>  -- Left Arrow selected
                data_out <= left_arrow_data;
            when others =>
                data_out <= (others => '0');  -- Default case for invalid input
        end case;
    end process;

end Behavioral;
