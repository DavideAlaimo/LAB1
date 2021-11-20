
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MULTIPLIER is
generic ( N : integer);
port (IN1,IN2 : in signed (N-1 downto 0);
      OUT_MULT : out signed (N-6 downto 0));
end entity;

architecture beh of MULTIPLIER is
signal out_not_tronc: signed(2*N-1 downto 0);
begin
out_not_tronc<=IN1*IN2;

OUT_MULT <= out_not_tronc(2*N-1 downto N+5);
end architecture;