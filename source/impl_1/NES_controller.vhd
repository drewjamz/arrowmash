library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity NES_controller is
    port (
		data : in std_logic;
		inclk : in std_logic;
		latch : out std_logic;
        clock : out std_logic;
		out_data : out std_logic_vector(7 downto 0)
    );
end NES_controller;

architecture synth of NES_controller is

    --component HSOSC is
        --generic (
            --CLKHF_DIV : String := "0b00");
        --port(
            --CLKHFPU : in std_logic := 'X'; 
            --CLKHFEN : in std_logic := 'X'; 
            --CLKHF : out std_logic := 'X');
    --end component;

    --signal clk : std_logic;
    signal counter : unsigned(19 downto 0) := "00000000000000000000";
	
	signal NESclk : std_logic;
	signal NEScount : unsigned(10 downto 0) := "00000000000";
	
	signal shift : std_logic_vector(7 downto 0);
	signal shift2 : std_logic_vector(7 downto 0);
	
	signal outlatch : std_logic;
    signal outclock : std_logic;

begin
    --osc : HSOSC generic map ( CLKHF_DIV => "0b00")
            --port map (CLKHFPU => '1',
                    --CLKHFEN => '1',
                    --CLKHF => clk);
  
    process(inclk)
    begin
        if rising_edge(inclk) then
            counter <= counter + 1;
        end if;
    
    end process;
	
	NESclk <= counter(8);
	NEScount <= counter(19 downto 9);
	
	outlatch <= '1' when NEScount = 0 else '0';
	outclock <= '0' when NEScount <= 0 or NEScount > 8 else NESclk;
	
	process(outclock)
	begin
		if rising_edge(outclock) then 
			
				shift(7) <= shift(6);
				shift(6) <= shift(5);
				shift(5) <= shift(4);
				shift(4) <= shift(3);
				shift(3) <= shift(2);
				shift(2) <= shift(1);
				shift(1) <= shift(0);
				shift(0) <= data;
		end if;
	end process;
	
	
	shift2 <= shift when outlatch = '1';
	out_data <= shift2;
	clock <= outclock;
	latch <= outlatch;
	
end synth;
