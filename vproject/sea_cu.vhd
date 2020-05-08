----------------------------------------------------------
-- CU
---------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity cu is
  port(
        mem0WEn,
        reg0WEn,
        alu0WEn,
        muxPCSel,
        muxMemASel,
        muxMemWSel,
        muxRegA0Sel,
        muxRegA1Sel,
        muxRegAWSel,
        muxRegWDSel,
        muxAluASel,
        pcWEn,
        memibufWEn,
        memdbufWEn,
        regR0dbufWEn,
        regR1dbufWEn : out std_logic;
        aluOp, flagOffset : out std_logic_vector(3 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        opcode : in std_logic_vector(15 downto 0)
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

architecture cu of cu is

signal controls : std_logic_vector(23 downto 0);
signal flagAddr : std_logic_vector(15 downto 0);
signal aluOp, flagOffset : std_logic_vector(3 downto 0);

begin


-- decode
process (clk, opcode)
begin
    case opcode is
      when "00000000" => controls <= "000000000000000000000000"; -- ADD
      when "00000001" => controls <= "000000000000000000000000"; -- AND
      when "00000010" => controls <= "000000000000000000000000"; -- SEQ
      when "00000011" => controls <= "000000000000000000000000"; -- SLT
      when "11111111" => controls <= "000000000000000000000000"; -- ADDI
      when "11111110" => controls <= "000000000000000000000000"; -- COPY
      when "11111101" => controls <= "000000000000000000000000"; -- TJMP
      when others => controls <= "000000000000000000000000"; -- JUMP is 11111100 
    end case;
end process;

mem0WEn => controls(23);
reg0WEn => controls(22);
alu0WEn => controls(21);
muxPCSel => controls(20);
muxMemASel => controls(19);
muxMemWSel => controls(18);
muxRegA0Sel => controls(17);
muxRegA1Sel => controls(16);
muxRegAWSel => controls(15);
muxRegWDSel => controls(14);
muxAluASel => controls(13);
pcWEn => controls(12);
memibufWEn => controls(11);
memdbufWEn => controls(10);
regR0dbufWEn => controls(9);
regR1dbufWEn => controls(8);
aluOp => controls(7 downto 4);
flagOffset => controls(3 downto 0);

end cu;
