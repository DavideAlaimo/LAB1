library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library std;
use std.textio.all;

entity FILTER_IIR is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    b_0   : in signed(12 downto 0);
    a_0   : in signed(12 downto 0);
    VIN   : in std_logic;
    DIN   : in signed (12 downto 0);
    DOUT  : out signed(12 downto 0);
    VOUT  : out signed(0 downto 0));
    
    
end FILTER_IIR;

architecture beh of FILTER_IIR is

component FF_D is
generic ( N: integer:= 8);
port (CLK, RST_n : in std_logic;
      EN: IN STD_LOGIC;
      DATA_IN : IN SIGNED (N-1 DOWNTO 0);
      DATA_OUT : OUT SIGNED (N-1 DOWNTO 0));
end component;

component SUB_ADDER is
generic ( N : integer:=8);
port (OP : IN STD_LOGIC;
      IN1,IN2 : in signed (N-1 downto 0);
      OUT_ADDER : out signed (N-1 downto 0));
end component;

component MULTIPLIER is
generic ( N : integer);
port (IN1,IN2 : in signed (N-1 downto 0);
      OUT_MULT : out signed (N-6 downto 0));
end component;



signal out_add_in: signed (12 downto 0);
signal outreg_inter: signed(12 downto 0);

signal outmpy_left: signed (7 downto 0);
signal outmpy_left_fill: signed (12 downto 0);
signal outmpy_center: signed (7 downto 0);
signal outmpy_right: signed (7 downto 0);
signal out_add_out: signed (7 downto 0);

signal w_din:signed (12 downto 0);


signal out_reg_dout:signed(12 downto 0);
signal w_vin:signed(0 downto 0);
signal w_vin_slv:signed(0 downto 0);
signal w_out_add_out:signed (12 downto 0);


begin 
w_vin_slv(0) <= VIN;
outmpy_left_fill<=outmpy_left(7) & outmpy_left(7) & outmpy_left(7) & outmpy_left(7) & outmpy_left(7) & outmpy_left;

REG_Din: FF_D generic map (13) port map (CLK, RST_n,VIN,DIN, w_din);  

ADD_in: SUB_ADDER generic map (13) port map('0', w_din ,outmpy_left_fill, out_add_in);


REG_INTERMEDIATE: FF_D generic map (13) port map (CLK, RST_n,'1',out_add_in, outreg_inter);

MPY_LEFT: MULTIPLIER generic map (13) port map (outreg_inter, a_0, outmpy_left);
MPY_Center: MULTIPLIER generic map (13) port map (outreg_inter, b_0, outmpy_center);
MPY_RIGHT: MULTIPLIER generic map (13) port map(out_add_in, b_0, outmpy_right);

ADD_RIGHT: SUB_ADDER generic map (8) port map('1',outmpy_right,outmpy_center, out_add_out);

w_out_add_out<= out_add_out(7) & out_add_out(7) & out_add_out(7) & out_add_out(7) & out_add_out(7) & out_add_out;
REG_DOUT: FF_D generic map (13) port map (CLK, RST_n,'1',w_out_add_out,DOUT);  


REG_Vin: FF_D generic map (1) port map (CLK, RST_n,'1',w_vin_slv, w_vin);

REG_VOUT: FF_D generic map (1) port map (CLK, RST_n,'1',w_vin, VOUT);
end beh;
