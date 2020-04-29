----------------------------------------------------------
-- Data Buffer
---------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity bufer is
generic (width : integer := 16);
  port(
      clk in : std_logic;
      w_enable in : std_logic;
      data_in in : std_logic_vector(width-1 downto 0);
      data_out out : std_logic_vector(width-1 downto 0)
  );
end;

architecture buffer of buffer is

  signal data_reg : std_logic_vector(width-1 downto 0);

begin

  process (clk, w_enable, data)
  begin
    if rising_edge(clk) && w_enable == 1
      data_reg <= data_in;
      data_out <= data_reg;
    end if
  end process

end buffer;
