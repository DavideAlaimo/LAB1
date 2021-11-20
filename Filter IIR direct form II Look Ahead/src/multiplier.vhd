library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MULTIPLIERR is
generic ( N : integer);
port (IN1,IN2 : in signed (N-1 downto 0);
      OUT_MULT : out signed (N-1 downto 0));
end entity;

architecture beh of MULTIPLIERR is
signal out_not_tronc_signal: signed(2*N-1 downto 0);
begin
process(IN1,IN2)

variable out_not_tronc: signed(2*N-1 downto 0);
begin
out_not_tronc:=IN1*IN2;
out_not_tronc_signal<=out_not_tronc;

OUT_MULT <= out_not_tronc(2*N-1 downto N);

end process;
end architecture;
