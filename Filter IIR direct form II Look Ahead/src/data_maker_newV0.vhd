library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_maker1 is  
  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
    VOUT    : out std_logic;
    DOUT    : out signed(13 downto 0);
    H0      : out signed(13 downto 0);
    H1      : out signed(13 downto 0);
--    H2      : out std_logic_vector(7 downto 0);
--    H3      : out std_logic_vector(7 downto 0);
    END_SIM : out std_logic);
end data_maker1;

architecture beh of data_maker1 is

  constant tco : time := 1 ns;

  signal sEndSim : std_logic;
  signal END_SIM_i : std_logic_vector(0 to 10);  
  signal var :std_logic;
begin  -- beh

  H0 <= signed( conv_std_logic_vector(1723,14));
  H1 <= signed( conv_std_logic_vector(-649,14));
--  H2 <= conv_std_logic_vector(5374,8);
--  H3 <= conv_std_logic_vector(9151,8);  

  process (CLK, RST_n)
    file fp_in : text open READ_MODE is "./samples.txt";
    variable line_in : line;
    variable x : integer;
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      DOUT <= (others => '0') after tco;      
      VOUT <= '0' after tco;--
      sEndSim <= '0' after tco;
	
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if ((not endfile(fp_in)) and var='0') then
        readline(fp_in, line_in);
        read(line_in, x);
        DOUT <= signed(conv_std_logic_vector(x, 14)) after tco;

        VOUT <= '1' after tco;--
        sEndSim <= '0' after tco;  
      ELSIF(VAR='1') then
	VOUT<='0' AFTER TCO;
      else
        VOUT <= '0' after tco;  --      
        sEndSim <= '1' after tco;
      end if;
    end if;
  end process;

Var <='0','1' after 100 ns, '0' after 150 ns;
  process (CLK, RST_n)
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      END_SIM_i <= (others => '0') after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      END_SIM_i(0) <= sEndSim after tco;
      END_SIM_i(1 to 10) <= END_SIM_i(0 to 9) after tco;
    end if;
  end process;

  END_SIM <= END_SIM_i(10);  

end beh;
