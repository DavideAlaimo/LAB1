library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SUB_ADDER is
generic ( N : integer:=8);
port (OP : IN STD_LOGIC;
      IN1,IN2 : in signed (N-1 downto 0);
      OUT_ADDER : out signed (N-1 downto 0));
end entity;

architecture beh of SUB_ADDER is

begin

process(IN1,IN2, OP) 
variable out_intermedio, input1,input2:signed (N downto 0); 
variable up_saturated, down_saturated : signed (N-1 downto 0);

begin
input1(N):=IN1(N-1);
input1 (N-1 downto 0):=IN1;
input2(N):=IN2(N-1);
input2(N-1 downto 0):=IN2;
up_saturated(N-1):='1'; up_saturated(N-2 downto 0) := (others =>'0'); --estremo negativo 100..00
down_saturated(N-1):='0'; down_saturated(N-2 downto 0) := (others =>'1'); --estremo positivo 011..11

if(OP = '1' ) THEN out_intermedio:=input1+input2;
ELSE out_intermedio:=input1-input2;
END IF;

if (to_integer(out_intermedio) < to_integer(up_saturated) ) then OUT_ADDER<= up_saturated;
elsif (to_integer(out_intermedio) > to_integer(down_saturated)) then OUT_ADDER <= down_saturated;
else OUT_ADDER <= out_intermedio(N-1 downto 0);
end if;

end process;
end architecture;
