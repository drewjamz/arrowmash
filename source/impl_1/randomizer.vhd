library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity randomizer is
    Port (
		masterClk : in std_logic;
        out_data : out std_logic_vector(3 downto 0)
    );
end randomizer;

architecture synth of randomizer is
    component HSOSC is
        generic (
            CLKHF_DIV : String := "0b00");
        port(
            CLKHFPU : in std_logic := 'X';
            CLKHFEN : in std_logic := 'X';
            CLKHF : out std_logic := 'X');
    end component;
 
    signal clk : std_logic;
    signal counter : unsigned(1 downto 0) := "00";
	signal countSlow : unsigned(23 downto 0) := "000000000000000000000000";
begin
    osc : HSOSC generic map ( CLKHF_DIV => "0b11")
            port map (CLKHFPU => '1',
                    CLKHFEN => '1',
                    CLKHF => clk);
    process(clk)
    begin
        if rising_edge(clk) then
			counter <= counter + 1;
        end if;
    end process;
	
	process(masterClk)
	begin
		if rising_edge(masterClk) then
			countSlow <= countSlow + 1;
			if countSlow = "00000000000000000000000" then
				if counter = "00" then
					out_data <= "0001";
				elsif counter = "01" then
					out_data <= "0010";
				elsif counter = "10" then
					out_data <= "0100";
				else
					out_data <= "1000";
				end if;
			end if;
		end if;
	end process;
	
end synth;