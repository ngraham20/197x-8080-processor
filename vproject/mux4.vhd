library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity mux4 is -- 4-input multiplexer
  generic(width: integer);
  port(d0, d1, d2, d3: in  STD_LOGIC_VECTOR(width-1 downto 0);
       s:      in  STD_LOGIC_VECTOR(1 downto 0);
       y:      out STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture behave of mux4 is
begin
    process (d0, d1, d2, d3, s, y)
    begin
        case s
        "00" => y <= d0;
        "01" => y <= d1;
        "10" => y <= d2;
        "11" => y <= d3;
    end process;
end;