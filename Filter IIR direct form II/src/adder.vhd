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

begin
input1(N):=IN1(N-1);
input1 (N-1 downto 0):=IN1;
input2(N):=IN2(N-1);
input2(N-1 downto 0):=IN2;
if(OP = '1' ) THEN out_intermedio:=input1+input2;

ELSE out_intermedio:=input1-input2;

END IF;

if (out_intermedio = "01000000000000") then OUT_ADDER<="0111111111111";

else OUT_ADDER<=out_intermedio(N-1 downto 0);

end if;

end process;
end architecture;
