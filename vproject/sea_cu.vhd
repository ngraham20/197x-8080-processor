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
        muxAluBSel : out std_logic_vector(1 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        opcode : in std_logic_vector(15 downto 0)
  );
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------
architecture cu of cu is

signal controls : std_logic_vector(23 downto 0);
signal flagAddr : std_logic_vector(15 downto 0);

type stateType is (fetch, aalub, add, sub);
signal state : stateType;

begin

  -- state machine
  process(clk, reset, opcode)
  begin
    if (rising_edge(clk)) then
      case state is
        when fetch =>
          if opcode(7 downto 4) = "0000" then -- A ALU B
            state <= aalub;
          else
            state <= fetch;
          end if; 
        when aalub =>
          case opcode(3 downto 0) is
            when "0000" => state <= add;
            when others => state <= fetch;
        when add =>
            
    end if;
  end process;

  -- state definition
  process(clk, reset, state)
  begin
    case state is
      when fetch => controls <= "00000000000000000000000000000"; -- get instr
      when aalub => controls <= "00000000000000000000000000000"; -- select a and b
      when stalu => controls <= "00000000000000000000000000000"; -- store result in reg
  end process;


----------------------------------     DECODE     ----------------------------------------------
process (clk, opcode)
begin
    case opcode is
      --    [OPCODE]                 [     miscelaneous control bits   ] [fofset] [aluop]
      ------------------------------------------------------------------------------------------
      when "00000000" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- ADD
      when "00000010" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "1010"; -- SEQ
      when "00000011" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "1001"; -- SLT
      when "00000001" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0100"; -- AND
      when "00000100" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0001"; -- SUB
      when "00000101" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0010"; -- MUL
      when "00000110" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0101"; -- OR
      when "00000111" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0110"; -- XOR
      
      when "11111111" => controls <= "00" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- ADDI
      when "11111110" => controls <= "00" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- COPY
      when "11111101" => controls <= "10" & "0110" & "0011" & "0100" & "1111" & "0000" & "1011"; -- TJMP
      when "11111100" => controls <= "00" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- JUMP
      when "11111011" => controls <= "00" & "1110" & "1111" & "0100" & "1111" & "0000" & "0000"; -- LW
      when "11111010" => controls <= "00" & "1110" & "1111" & "0100" & "1111" & "0000" & "0000"; -- SW
      when "11111001" => controls <= "00" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- LI
      when "11111000" => controls <= "00" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- SI
      when others => controls <= "000000000000000000000000";
    end case;
end process;

muxAluBSel <= controls(25 downto 24); 
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
