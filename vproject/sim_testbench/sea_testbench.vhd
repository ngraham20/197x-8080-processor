library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity sea_testbench is
end;

architecture sea_testbench of sea_testbench is

    component sea_top is -- top-level design for testing
      port( 
           clk : in STD_LOGIC;
           reset: in STD_LOGIC
          --  out_port_1 : out STD_LOGIC_VECTOR(31 downto 0)
           );
    end component;

    signal clk : STD_LOGIC;
    signal reset : STD_LOGIC;
    -- signal out_port_1 : STD_LOGIC_VECTOR(31 downto 0);
    
begin
  
  -- Generate simulated mips clock with 10 ns period
  clkproc: process begin
    clk <= '1';
    wait for 10 ns; 
    clk <= '0';
    wait for 10 ns;
  end process;
  
  -- Generate reset for first few clock cycles
  reproc: process begin
    reset <= '1';
    wait for 22 ns;
    reset <= '0';
    wait;
  end process;
  
  -- instantiate device to be tested
  dut: sea_top port map( 
       clk => clk, 
       reset => reset);

end sea_testbench;