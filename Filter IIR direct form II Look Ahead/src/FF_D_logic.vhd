library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FF_D_LOGIC is
port (CLK, RST_n : in std_logic;
      EN: IN STD_LOGIC;
      DATA_IN : IN STD_LOGIC;
      DATA_OUT : OUT STD_LOGIC);
end entity;

architecture beh of FF_D_LOGIC is
begin
process (CLK, RST_n)
variable  data: STD_LOGIC;
begin
IF(RST_n='0') then data:= '0' ;
DATA_OUT<='0';

ELSIF(CLK'event  and  CLK='1') then 
	IF (EN ='1') THEN
		DATA_OUT <= DATA_IN;
		data:= DATA_IN; 
	ELSE 
		
 		DATA_OUT<=data;
	end if;


end if;
end  process;
end architecture;
