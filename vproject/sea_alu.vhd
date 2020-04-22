----------------------------------------------------------
-- ALU
---------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ALU is -- top-level design for testing
  port(
      a, b : in STD_LOGIC_VECTOR(15 downto 0);
      y : out STD_LOGIC_VECTOR(15 downto 0);
      aluop : in STD_LOGIC_VECTOR(3 downto 0);
      clk : STD_LOGIC;
	   );
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------

architecture alu of alu is

    -- A will be the register
    -- B will be the offset
    signal flag : STD_LOGIC_VECTOR(15 downto 0);
    signal seq, slt : STD_LOGIC_VECTOR(15 downto 0);
 
    begin
       
    
    -- Read flag offset bit
    flag <= (a srl b) and "0000000000000001";

    -- SLT
    process (a, b, clk)
    begin
        if a < b
            slt <= "0000000000000001";
        else
            slt <= "0000000000000000";
        end if;
    end process;

    -- SEQ
    process (a, b, clk)
    begin
        if a = b
            seq <= "0000000000000001";
        else
            seq <= "0000000000000000";
        end if;
    end process;
  
    -- RESULT
    process (a, b, aluop, clk)
    begin
        case aluop
        "0000"  => y <= a + b;
        "0001"  => y <= a - b;
        "0010"  => y <= a * b;
        "0011"  => y <= a / b;
        "0100"  => y <= a and b;
        "0101"  => y <= a or b;
        "0110"  => y <= a xor b;
        "0111"  => y <= a sll b;
        "1000"  => y <= a srl b;
        "1001"  => y <= flag; -- TODO this may not function as intended
        others      => y <= -42069;
        end;
    end process;
	  
    end alu;
