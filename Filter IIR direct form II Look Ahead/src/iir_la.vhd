library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library std;
use std.textio.all;

entity iir_la is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    b_0   : in signed(13 downto 0);
    a_0   : in signed(13 downto 0);
    VIN   : in std_logic ;
    DIN   : in signed (13 downto 0);
    DOUT  : out signed(13 downto 0);
    VOUT  : out std_logic );                         
    
    
end iir_la;

architecture beh of iir_la is

component FF_D is
generic ( N: integer:= 8);
port (CLK, RST_n : in std_logic;
      EN: IN STD_LOGIC;
      DATA_IN : IN SIGNED (N-1 DOWNTO 0);
      DATA_OUT : OUT SIGNED (N-1 DOWNTO 0));
end component;

component FF_D_LOGIC is
port (CLK, RST_n : in std_logic;
      EN: IN STD_LOGIC;
      DATA_IN : IN STD_LOGIC;
      DATA_OUT : OUT STD_LOGIC);
end component;

component SUB_ADDER is
generic ( N : integer:=8);
port (OP : IN STD_LOGIC;
      IN1,IN2 : in signed (N-1 downto 0);
      OUT_ADDER : out signed (N-1 downto 0));
end component;


component MULTIPLIERR is
generic ( N : integer);
port (IN1,IN2 : in signed (N-1 downto 0);
      OUT_MULT : out signed (N-1 downto 0));
end component;

signal a2, ab, a, b: signed (13 downto 0);

--output adder
signal out_adder1, out_adder2, out_adder3, out_adder4: signed (13 downto 0);
--output multiplier
signal out_mult1, out_mult2, out_mult3, out_mult4, out_mult5 : signed (13 downto 0);
--output register pipe
signal out_regpipe1, out_regpipe2, out_regpipe3, out_regpipe4, out_regpipe5, out_regpipe6, out_regpipe7,
       out_regpipe8, out_regpipe9 : signed (13 downto 0);
-- output register
signal out_reg1, out_reg2 : signed (13 downto 0);
--output register DIN VIN
signal out_regDIN : signed (13 downto 0);
signal out_regVIN : std_logic;
signal out_regVIN1 : std_logic;
signal out_regVIN2 : std_logic;
signal out_regVIN3 : std_logic;
signal out_regVIN4 : std_logic;


signal out_shifted: signed (13 downto 0);
begin 
--

a2 <= "00000000110011";
ab <= "11111101110111";
a <=  "11110101110111";
b <=  "00011010111011";


Adder1 : SUB_ADDER generic map (14) port map ('1', out_regDIN, out_mult1, out_adder1);
Adder2 : SUB_ADDER generic map (14) port map ('1', out_mult2, out_mult3, out_adder2);
Adder3 : SUB_ADDER generic map (14) port map ('0', out_regpipe5, out_mult4, out_adder3);
Adder4 : SUB_ADDER generic map (14) port map ('0', out_regpipe8, out_mult5, out_adder4);

Mult1 : MULTIPLIERR generic map (14) port map (a2, out_reg2,out_mult1);
Mult2 : MULTIPLIERR generic map (14) port map (b, out_regpipe1, out_mult2);
Mult3 : MULTIPLIERR generic map (14) port map (b, out_regpipe2, out_mult3);
Mult4 : MULTIPLIERR generic map (14) port map (ab, out_regpipe6, out_mult4);
Mult5 : MULTIPLIERR generic map (14) port map (ab, out_regpipe9, out_mult5);


RegDIN : FF_D generic map (14) port map (CLK, RST_n,'1' ,DIN, out_regDIN);
RegDOUT : FF_D generic map (14) port map (CLK, RST_n, out_regVIN3, out_shifted, DOUT);

RegVIN : FF_D_LOGIC port map (CLK, RST_n , '1', VIN, out_regVIN);
RegVIN1 : FF_D_LOGIC  port map (CLK,RST_n,'1', out_regVIN, out_regVIN1);
RegVIN2 : FF_D_LOGIC  port map (CLK,RST_n,'1', out_regVIN1, out_regVIN2);
RegVIN3 : FF_D_LOGIC  port map (CLK,RST_n,'1', out_regVIN2,out_regVIN3);
RegVIN4 : FF_D_LOGIC  port map (CLK,RST_n,'1', out_regVIN3,out_regVIN4);
Vout<=out_regVIN4;


RegPIPE1 : FF_D generic map (14) port map (CLK,RST_n,out_regVIN, out_adder1,out_regpipe1);
RegPIPE2 : FF_D generic map (14) port map (CLK,RST_n,out_regVIN, out_reg1,out_regpipe2);
RegPIPE3 : FF_D generic map (14) port map (CLK,RST_n,out_regVIN, out_reg1,out_regpipe3);
RegPIPE4 : FF_D generic map (14) port map (CLK,RST_n,out_regVIN, out_reg2,out_regpipe4);
RegPIPE5 : FF_D generic map (14) port map (CLK,RST_n,out_regVIN1, out_adder2,out_regpipe5);
RegPIPE6 : FF_D generic map (14) port map (CLK,RST_n,out_regVIN1, out_regpipe3,out_regpipe6);
RegPIPE7 : FF_D generic map (14) port map (CLK,RST_n,out_regVIN1, out_regpipe4,out_regpipe7);
RegPIPE8 : FF_D generic map (14) port map (CLK,RST_n,out_regVIN2, out_adder3,out_regpipe8);
RegPIPE9 : FF_D generic map (14) port map (CLK,RST_n,out_regVIN2, out_regpipe7,out_regpipe9);
Reg1 : FF_D generic map (14) port map (CLK,RST_n, out_regVIN, out_adder1, out_reg1);
Reg2 : FF_D generic map (14) port map (CLK, RST_n, out_regVIN, out_reg1, out_reg2);
--
out_shifted <= shift_right(out_adder4,5);

end beh;
-------------