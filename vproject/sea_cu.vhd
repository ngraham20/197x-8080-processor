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
        pcWEn,
        aludbufWEn,
        memibufWEn,
        memdbufWEn,
        regR0dbufWEn,
        regR1dbufWEn : out std_logic;
        aluOp, flagOffset : out std_logic_vector(3 downto 0);
        muxAluBSel, muxAluASel : out std_logic_vector(1 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        opcode : in std_logic_vector(7 downto 0)
  );
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------
architecture cu of cu is

signal controls : std_logic_vector(27 downto 0);
signal flagAddr : std_logic_vector(15 downto 0);

type stateType is (resetst, fetch, decode, getab, getai, add, sub, addi, pcinc, pcstor, stalu);
signal state : stateType;

begin

  -- state machine
  process(clk, reset, opcode)
  begin
    if (reset = '1') then
      state <= fetch;
    elsif (rising_edge(clk)) then
      case state is
        -- when resetst => state <= fetch;
        when fetch => state <= decode; -- fetch
        when decode =>
          case opcode(7 downto 4) is
            when "0000" => state <= getab;    -- A alu B
            when "1111" => state <= getai;     -- A alu imm
            when others => state <= fetch;    -- reset
          end case;
        when getab =>                         -- getab
          case opcode(3 downto 0) is
            when "0000" => state <= add;      -- a = a + b
            when "0001" => state <= sub;      -- a = a - b
            when others => state <= fetch;    -- reset
          end case;
        when getai =>
            case opcode (3 downto 0) is
              when "1111" => state <= addi;   -- a + imm
              when others => state <= fetch;  -- reset
            end case;
        when add => state <= stalu;
        when addi => state <= stalu;
        when stalu => state <= pcinc;
        when pcinc => state <= pcstor;
        when others => state <= fetch;        -- reset   
      end case; 
    end if;
  end process;

  -- state definition
  process(clk, reset, state)
  begin
    case state is
      --                        [  write en   ] [pcsel] [mem]  [reg ]   [alu ]   [flag]  [aluop] 
     -- when resetst => controls <= "000" & "001000" & "0" & "00" & "0000" & "0000" & "0000" & "0000"; -- get instr  
      when fetch => controls <= "000" & "001000" & "0" & "00" & "0000" & "0000" & "0000" & "0000"; -- get instr
      when decode => controls <= "000" & "000000" & "0" & "00" & "0000" & "0000" & "0000" & "0000"; -- get instr 
      when getab => controls <= "000" & "000011" & "0" & "00" & "0000" & "0000" & "0000" & "0000"; -- select a and b
      when getai => controls <= "000" & "000010" & "0" & "00" & "0000" & "0000" & "0000" & "0000"; -- select a and imm
      when add   => controls <= "000" & "100000" & "0" & "00" & "0000" & "0000" & "0000" & "0000"; -- a + b
      when addi  => controls <= "000" & "100000" & "0" & "00" & "1000" & "0001" & "0000" & "0000"; -- a + imm
      when stalu => controls <= "010" & "000000" & "0" & "00" & "0001" & "0000" & "0000" & "0000"; -- store result in reg
      when pcinc => controls <= "000" & "100000" & "0" & "00" & "0000" & "1010" & "0000" & "0000"; -- store pc + 4
      when pcstor => controls <= "000" & "010000" & "0" & "00" & "0000" & "0000" & "0000" & "0000"; -- get instr 
      when others => controls <= "000" & "001000" & "0" & "00" & "0000" & "0000" & "0000" & "0000";
    end case;
  end process;


----------------------------------     DECODE     ----------------------------------------------
-- process (clk, opcode)
-- begin
--     case opcode is
--       --    [OPCODE]                 [     miscelaneous control bits   ] [fofset] [aluop]
--       ------------------------------------------------------------------------------------------
--       when "00000000" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- ADD
--       when "00000010" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "1010"; -- SEQ
--       when "00000011" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "1001"; -- SLT
--       when "00000001" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0100"; -- AND
--       when "00000100" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0001"; -- SUB
--       when "00000101" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0010"; -- MUL
--       when "00000110" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0101"; -- OR
--       when "00000111" => controls <= "01" & "0110" & "0011" & "0100" & "1111" & "0000" & "0110"; -- XOR
      
--       when "11111111" => controls <= "00" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- ADDI
--       when "11111110" => controls <= "00" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- COPY
--       when "11111101" => controls <= "10" & "0110" & "0011" & "0100" & "1111" & "0000" & "1011"; -- TJMP
--       when "11111100" => controls <= "00" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- JUMP
--       when "11111011" => controls <= "00" & "1110" & "1111" & "0100" & "1111" & "0000" & "0000"; -- LW
--       when "11111010" => controls <= "00" & "1110" & "1111" & "0100" & "1111" & "0000" & "0000"; -- SW
--       when "11111001" => controls <= "00" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- LI
--       when "11111000" => controls <= "00" & "0110" & "0011" & "0100" & "1111" & "0000" & "0000"; -- SI
--       when others => controls <= "000000000000000000000000";
--     end case;
-- end process;

mem0WEn <= controls(27);
reg0WEn <= controls(26);
alu0WEn <= controls(25);

aludbufWEn <= controls(24);
pcWEn <= controls(23);
memibufWEn <= controls(22);
memdbufWEn <= controls(21);
regR0dbufWEn <= controls(20);
regR1dbufWEn <= controls(19);

muxPCSel <= controls(18);

muxMemASel <= controls(17);
muxMemWSel <= controls(16);

muxRegA0Sel <= controls(15);
muxRegA1Sel <= controls(14);
muxRegAWSel <= controls(13);
muxRegWDSel <= controls(12);

muxAluASel <= controls(11 downto 10);
muxAluBSel <= controls(9 downto 8);

flagOffset <= controls(7 downto 4);

aluOp <= controls(3 downto 0);

end cu;
