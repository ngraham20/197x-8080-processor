----------------------------------------------------------
-- Data Buffer
---------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity sea_buffer is
generic (width : integer := 16);
  port(
      clk : in std_logic;
      reset : in std_logic;
      w_enable : in std_logic;
      data_in : in std_logic_vector(width-1 downto 0);
      data_out : out std_logic_vector(width-1 downto 0)
  );
end;

architecture sea_buffer of sea_buffer is

  -- signal data_reg : std_logic_vector(width-1 downto 0);

begin

  process (clk, reset, w_enable, data_in)
  begin
    if (reset = '1') then
      data_out <= (others => '0');
    elsif (rising_edge(clk)) and (w_enable = '1') then
       -- data_reg <= data_in;
      data_out <= data_in;
    end if;
  end process;

end sea_buffer;
