----------------------------------------------------------
-- CU
---------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity cu is -- top-level design for testing
  port(
      clk in : std_logic;
      reset in : std_logic;
      opcode in : std_logic_vector(15 downto 0)
  );
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------

-- Commands

-- LW mem reg

-- SW reg mem

-- ADD src tgt dst

-- JUMP addr

-- TJMP F0 addr

-- COPY src dst

-- ADDI src imm

-- SLT src tgt

-- SEQ src tgt

-- AND src tgt dst

signal control : std_logic_vector(50 downto 0);
signal flagAddr : std_logic_vector(15 downto 0);
signal aluOp, flagOffset : std_logic_vector(3 downto 0);
signal pcEn, memASel, memWsel, memWEn, regA0Sel, regAWSel, regWsel, regWEn, aluASel, aluBSel, tJump : std_logic;

architecture cu of cu is

    process (clk, opcode)
    begin
        case opcode
        "00000000" => "" -- 
        end
    end process;



    end cu;
