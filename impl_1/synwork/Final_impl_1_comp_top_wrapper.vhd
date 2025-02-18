--
-- Synopsys
-- Vhdl wrapper for top level design, written on Tue Dec 10 13:36:11 2024
--
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.arrows_pkg.all;
use work.states_pkg.all;
use ieee.numeric_std.all;

entity wrapper_for_top is
   port (
      vgaclk : in std_logic;
      dataNesOne : in std_logic;
      dataNesTwo : in std_logic;
      vgaclkout : out std_logic;
      hsync : out std_logic;
      vsync : out std_logic;
      rgb : out std_logic_vector(2 downto 0);
      latchNesOne : out std_logic;
      clkNesOne : out std_logic;
      latchNesTwo : out std_logic;
      clkNesTwo : out std_logic
   );
end wrapper_for_top;

architecture synth of wrapper_for_top is

component top
 port (
   vgaclk : in std_logic;
   dataNesOne : in std_logic;
   dataNesTwo : in std_logic;
   vgaclkout : out std_logic;
   hsync : out std_logic;
   vsync : out std_logic;
   rgb : out std_logic_vector (2 downto 0);
   latchNesOne : out std_logic;
   clkNesOne : out std_logic;
   latchNesTwo : out std_logic;
   clkNesTwo : out std_logic
 );
end component;

signal tmp_vgaclk : std_logic;
signal tmp_dataNesOne : std_logic;
signal tmp_dataNesTwo : std_logic;
signal tmp_vgaclkout : std_logic;
signal tmp_hsync : std_logic;
signal tmp_vsync : std_logic;
signal tmp_rgb : std_logic_vector (2 downto 0);
signal tmp_latchNesOne : std_logic;
signal tmp_clkNesOne : std_logic;
signal tmp_latchNesTwo : std_logic;
signal tmp_clkNesTwo : std_logic;

begin

tmp_vgaclk <= vgaclk;

tmp_dataNesOne <= dataNesOne;

tmp_dataNesTwo <= dataNesTwo;

vgaclkout <= tmp_vgaclkout;

hsync <= tmp_hsync;

vsync <= tmp_vsync;

rgb <= tmp_rgb;

latchNesOne <= tmp_latchNesOne;

clkNesOne <= tmp_clkNesOne;

latchNesTwo <= tmp_latchNesTwo;

clkNesTwo <= tmp_clkNesTwo;



u1:   top port map (
		vgaclk => tmp_vgaclk,
		dataNesOne => tmp_dataNesOne,
		dataNesTwo => tmp_dataNesTwo,
		vgaclkout => tmp_vgaclkout,
		hsync => tmp_hsync,
		vsync => tmp_vsync,
		rgb => tmp_rgb,
		latchNesOne => tmp_latchNesOne,
		clkNesOne => tmp_clkNesOne,
		latchNesTwo => tmp_latchNesTwo,
		clkNesTwo => tmp_clkNesTwo
       );
end synth;
