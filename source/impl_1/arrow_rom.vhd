library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity rom is
port(
	leds : out std_logic_vector(1 downto 0); -- 0 is digit1 1 is digit 2
	digit : out std_logic_vector(6 downto 0)
);
end rom;
architecture synth of rom is
component HSOSC is
	generic (
		CLKHF_DIV : String := "0b00"); -- Divide 48 MHz by 2^n
	port (
		CLKHFPU : in std_logic := 'X'; -- Set to 1 to enable power
		CLKHFEN : in std_logic := 'X'; -- Set to 1 to enable output
		CLKHF : out std_logic := 'X'); -- Clock output
	end component;
signal counter : unsigned(25 downto 0);
signal clk : std_logic;
signal addr : unsigned(2 downto 0);
signal digit2 : std_logic_vector(6 downto 0);
begin
	osc : HSOSC generic map ( CLKHF_DIV => "0b00")
port map (CLKHFPU => '1',
 CLKHFEN => '1',
 CLKHF => clk);
process (clk) begin
	if rising_edge(clk) then
			counter <= counter + 26d"1";
		case addr is
			when "000" => digit2 <= "0111111";
			when "001" => digit2 <= "1011111";
			when "010" => digit2 <= "1111110";
			when "011" => digit2 <= "1111011";
			when "100" => digit2 <= "1110111";
			when "101" => digit2 <= "1101111";
			when "110" => digit2 <= "1111110";
			when "111" => digit2 <= "1111101";
			when others => digit2 <= "0000000";
		end case;
	end if;
end process;
leds(0) <= counter(12);
leds(1) <= not counter(12);
digit <= digit2 when leds(0) = '1' else "0000000";
addr <= counter(25 downto 23);
end;