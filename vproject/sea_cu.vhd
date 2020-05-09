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

begin


----------------------------------     DECODE     ----------------------------------------------
process (clk, opcode)
begin
    case opcode is
      --    [OPCODE]                 [     miscelaneous control bits   ] [fofset] [aluop]
      ------------------------------------------------------------------------------------------
      when "00000000" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- ADD
      when "00000010" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "1010"; -- SEQ
      when "00000011" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "1001"; -- SLT
      when "00000001" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0100"; -- AND
      when "00000100" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0001"; -- SUB
      when "00000101" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0010"; -- MUL
      when "00000101" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "1001"; -- SLT
      when "00000101" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "1000"; -- SEQ
      when "00000101" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0101"; -- OR
      when "00000101" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0110"; -- XOR

      when "11111111" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- ADDI
      when "11111110" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- COPY
      when "11111101" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- TJMP
      when "11111100" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- JUMP
      when "11111011" => controls <= "1110" & "1111" & "0100" & "1111" & "0000" & "0000"; -- LW
      when "11111010" => controls <= "1110" & "1111" & "0100" & "1111" & "0000" & "0000"; -- SW
      when "11111001" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- LI
      when "11111000" => controls <= "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- SI
      when others => controls <= "000000000000000000000000"; -- JUMP is 11111100 
    end case;
end process;

mem0WEn <= controls(23);
reg0WEn <= controls(22);
alu0WEn <= controls(21);
muxPCSel <= controls(20);

muxMemASel <= controls(19);
muxMemWSel <= controls(18);
muxRegA0Sel <= controls(17);
muxRegA1Sel <= controls(16);

muxRegAWSel <= controls(15);
muxRegWDSel <= controls(14);
muxAluASel <= controls(13);
pcWEn <= controls(12);

memibufWEn <= controls(11);
memdbufWEn <= controls(10);
regR0dbufWEn <= controls(9);
regR1dbufWEn <= controls(8);

flagOffset <= controls(7 downto 4);

aluOp <= controls(3 downto 0);

end cu;
