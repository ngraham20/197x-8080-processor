----------------------------------------------------------
-- ALU
---------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
--use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity ALU is -- top-level design for testing
  port(
      a, b : in STD_LOGIC_VECTOR(15 downto 0);
      y : out STD_LOGIC_VECTOR(15 downto 0);
      aluop : in STD_LOGIC_VECTOR(3 downto 0);
      clk : STD_LOGIC
	   );
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------

architecture alu of alu is

    -- A will be the register
    -- B will be the offset
    signal flag : STD_LOGIC_VECTOR(15 downto 0);
    signal low, seq, slt, r_shift, l_shift : STD_LOGIC_VECTOR(15 downto 0);

    component shift_left is
        generic (N : integer := 32);
        Port (  a   : in STD_LOGIC_VECTOR(N-1 downto 0);
                shmt: in STD_LOGIC_VECTOR(3 downto 0);
                c   : out STD_LOGIC_VECTOR(N-1 downto 0) );
    end component;

    component shift_right is
        generic (N : integer := 32);
        Port (  a   : in STD_LOGIC_VECTOR(N-1 downto 0);
                shmt: in STD_LOGIC_VECTOR(3 downto 0);
                c   : out STD_LOGIC_VECTOR(N-1 downto 0) );
    end component;
 
    begin

    sl0: shift_left generic map(16) port map(
        a => a, shmt => b(3 downto 0), c => l_shift
    );

    sr0: shift_right generic map (16) port map(
        a => a, shmt => b(3 downto 0), c => r_shift
    );
       
    
    -- Read flag offset bit
    -- flag <= r_shift and "0000000000000001";
    low <= (others => '0');


    -- SLT
    process (a, b, clk)
    begin
        if a < b then
            slt <= "0000000000000001";
        else
            slt <= "0000000000000000";
        end if;
    end process;

    -- SEQ
    process (a, b, clk)
    begin
        if a = b then
            seq <= "0000000000000001";
        else
            seq <= "0000000000000000";
        end if;
    end process;
  
    -- RESULT
    process (a, b, aluop, clk)
    begin
        case aluop is
        when "0000"  => y <= a + b;
        when "0001"  => y <= a - b;
        --when "0010"  => y <= a * b;
        -- when "0011"  => y <= a / b;
        when "0011"  => y <= a and b;
        when "0100"  => y <= a or b;
        when "0101"  => y <= a xor b;
        when "0111"  => y <= l_shift;
        when "0110"  => y <= r_shift;
        when "1000"  => y <= slt;
        when "1001"  => y <= seq;
        when others  => y <= low;
        end case;
    end process;
	  
    end alu;
