---------------------------------------------------------------------
-- three-port register file
---------------------------------------------------------------------

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity regfile is 
  port(clk:           in  STD_LOGIC;
       wEn:           in  STD_LOGIC;
       ra0, ra1, wa: in  STD_LOGIC_VECTOR(7 downto 0);
       wd:           in  STD_LOGIC_VECTOR(15 downto 0);
       rd0, rd1:      out STD_LOGIC_VECTOR(15 downto 0));
end;

architecture behave of regfile is
  type ramtype is array (255 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
  signal mem: ramtype;
begin
  -- three-ported register file
  
  -- write to the third port on rising edge of clock
  -- write address is in wa
  process(clk, wEn, wa, wd) begin
    if rising_edge(clk) then
      if wEn = '1' then 
        mem(to_integer(unsigned(wa))) <= wd;
      end if;
    end if;
  end process;
  
  -- read mem from two separate ports 1 and 2 
  -- addresses are in ra0 and ra1
  process(ra0, ra1, mem) begin
    if ( to_integer(unsigned(ra0)) = 0) then 
		rd0 <= (others => '0'); -- register 0 holds 0
    else 
		rd0 <= mem(to_integer(unsigned(ra0)));
    end if;
	
    if ( to_integer(unsigned(ra1)) = 0) then 
		rd1 <= (others => '0'); -- register 0 holds 0
    else 
		rd1 <= mem(to_integer( unsigned(ra1)));
    end if;
  end process;
end;