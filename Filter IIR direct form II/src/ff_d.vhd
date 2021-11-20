library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FF_D is
generic ( N: integer:= 8);
port (CLK, RST_n : in std_logic;
      EN: IN STD_LOGIC;
      DATA_IN : IN SIGNED (N-1 DOWNTO 0);
      DATA_OUT : OUT SIGNED (N-1 DOWNTO 0));
end entity;

architecture beh of FF_D is
begin
process (CLK, RST_n)
variable  data: SIGNED (N-1  downto  0);
begin
IF(RST_n='0') then data:= (others => '0') ;DATA_OUT<= (OTHERS => '0');

ELSIF(CLK'event  and  CLK='1') then 
	IF (EN ='1') THEN
		DATA_OUT <= DATA_IN;
		data:= DATA_IN; 
	ELSE DATA_OUT<=data;
	end if;


end if;
end  process;
end architecture;
