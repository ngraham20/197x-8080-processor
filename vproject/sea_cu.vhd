
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
        pcWEn,
        aludbufWEn,
        memibufWEn,
        memdbufWEn,
        regR0dbufWEn,
        regR1dbufWEn : out std_logic;
        regR0BottomBit : in std_logic;
        aluOp, flagOffset : out std_logic_vector(3 downto 0);
        muxAluBSel, muxAluASel, muxRegWDSel : out std_logic_vector(1 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        opcode : in std_logic_vector(7 downto 0)
  );
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------
architecture cu of cu is

signal controls : std_logic_vector(28 downto 0);
signal flagAddr : std_logic_vector(15 downto 0);
signal dotjump  : std_logic;

type stateType is (resetst, fetch, decode, getab,
  geta, add, sub, mul, andst, orst, xorst, srrst,
  srlst, sltst, seqst, addi, subi, pcinc, pcstor,
  copy, copi, alu_reg, imm_reg, jump, tjmp);
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
            when "1111" => state <= geta;     -- A alu imm
            when "1110" => state <= jump;
            -- when "1110" => state <= 
            when others => state <= fetch;    -- reset
          end case;
        when getab =>                         -- getab
          case opcode(3 downto 0) is
            when "0000" => state <= add;      -- a = a + b
            when "0001" => state <= sub;      -- a = a - b
            --TODO: mul 0010
            when "0011" => state <= andst;      -- a = a AND b
            when "0100" => state <= orst;       -- a = a OR b
            when "0101" => state <= xorst;      -- a = a XOR b
            when "0110" => state <= srrst;  -- Right_Shift
            when "0111" => state <= srlst;  -- Left_Shift
            when "1000" => state <= sltst;  -- a SLT b
            when "1001" => state <= seqst;  -- a SEQ b
            when "1010" => state <= copy;   -- copy dst <- a
            when others => state <= fetch;    -- reset
          end case;
        when geta =>
            case opcode (3 downto 0) is
              when "1111" => state <= addi;   -- a + imm
              when "1110" => state <= subi;   -- a - imm
              when "1101" => state <= copi;   -- copy dst <- imm
              when "1100" => state <= tjmp;   -- tjmp
              when others => state <= fetch;  -- reset
            end case;
        when tjmp =>
              if (regr0bottombit = '0') then
                state <= pcinc;
              else
                state <= fetch;
              end if; 
        when add => state <= alu_reg;
        when sub => state <= alu_reg;
        when andst => state <= alu_reg;
        when orst => state <= alu_reg;
        when xorst => state <= alu_reg;
        when srlst => state <= alu_reg;
        when srrst => state <= alu_reg;
        when sltst => state <= alu_reg;
        when seqst => state <= alu_reg;
        when addi => state <= alu_reg;
        when subi => state <= alu_reg;
        when copy => state <= pcinc;
        when copi => state <= pcinc;
        when alu_reg => state <= pcinc;
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
      when fetch  => controls <= "000" & "001000" & "0" & "00" & "00000" & "0000" & "0000" & "0000"; -- get instr
      when decode => controls <= "000" & "000000" & "0" & "00" & "00000" & "0000" & "0000" & "0000"; -- get instr

      when getab  => controls <= "000" & "000011" & "0" & "00" & "00000" & "0000" & "0000" & "0000"; -- select a and b
      when geta  => controls <= "000" & "000010" & "0" & "00" & "10000" & "0000" & "0000" & "0000"; -- select a and imm

      when add    => controls <= "000" & "100000" & "0" & "00" & "00000" & "0000" & "0000" & "0000"; -- a + b
      when sub    => controls <= "000" & "100000" & "0" & "00" & "00000" & "0000" & "0000" & "0001"; -- a - b
      when mul    => controls <= "000" & "100000" & "0" & "00" & "00000" & "0000" & "0000" & "0010"; -- a * b
      when andst  => controls <= "000" & "100000" & "0" & "00" & "00000" & "0000" & "0000" & "0011"; -- a AND b
      when orst   => controls <= "000" & "100000" & "0" & "00" & "00000" & "0000" & "0000" & "0100"; -- a OR b
      when xorst  => controls <= "000" & "100000" & "0" & "00" & "00000" & "0000" & "0000" & "0101"; -- a XOR b
      when srrst  => controls <= "000" & "100000" & "0" & "00" & "00000" & "0000" & "0000" & "0110"; -- a SRR b
      when srlst  => controls <= "000" & "100000" & "0" & "00" & "00000" & "0000" & "0000" & "0111"; -- a SRL b
      when sltst  => controls <= "000" & "100000" & "0" & "00" & "00000" & "0000" & "0000" & "1000"; -- a SLT b
      when seqst  => controls <= "000" & "100000" & "0" & "00" & "00000" & "0000" & "0000" & "1001"; -- a SEQ b

      when addi   => controls <= "000" & "100000" & "0" & "00" & "10000" & "0001" & "0000" & "0000"; -- a + imm
      when subi   => controls <= "000" & "100000" & "0" & "00" & "10000" & "0001" & "0000" & "0000"; -- a - imm

      when copy   => controls <= "010" & "000000" & "0" & "00" & "00010" & "0000" & "0000" & "0000"; -- a SEQ b
      when copi   => controls <= "010" & "000000" & "0" & "00" & "00011" & "0000" & "0000" & "0000"; -- a SEQ b
      
      when jump  => controls <= "000" & "010000" & "1" & "00" & "00000" & "0000" & "0000" & "0000"; -- jump
      when tjmp  => controls <= "000" & "010000" & regr0bottombit & "00" & "00000" & "0000" & "0000" & "0000"; -- jump

      when alu_reg  => controls <= "010" & "000000" & "0" & "00" & "00001" & "0000" & "0000" & "0000"; -- store result in reg
      when pcinc  => controls <= "000" & "100000" & "0" & "00" & "00000" & "1010" & "0000" & "0000"; -- store pc + 4
      when pcstor => controls <= "000" & "010000" & "0" & "00" & "00000" & "0000" & "0000" & "0000"; -- get instr 
      when others => controls <= "000" & "001000" & "0" & "00" & "00000" & "0000" & "0000" & "0000";
    end case;
  end process;

mem0WEn <= controls(28);
reg0WEn <= controls(27);
alu0WEn <= controls(26);

aludbufWEn <= controls(25);
pcWEn <= controls(24);
memibufWEn <= controls(23);
memdbufWEn <= controls(22);
regR0dbufWEn <= controls(21);
regR1dbufWEn <= controls(20);

muxPCSel <= controls(19);

muxMemASel <= controls(18);
muxMemWSel <= controls(17);

muxRegA0Sel <= controls(16);
muxRegA1Sel <= controls(15);
muxRegAWSel <= controls(14);
muxRegWDSel <= controls(13 downto 12);

muxAluASel <= controls(11 downto 10);
muxAluBSel <= controls(9 downto 8);

flagOffset <= controls(7 downto 4);

aluOp <= controls(3 downto 0);

end cu;
