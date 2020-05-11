----------------------------------------------------------
-- SEA_TOP
---------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity sea_top is -- top-level design for testing
  port(clk, reset : in std_logic);
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------

architecture sea_top of sea_top is

  component cu is
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
  end component;

  component dp is
    port(
      clk : in std_logic;
      reset : in std_logic;
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
      regR1dbufWEn : in std_logic;
      muxAluBSel, muxAluASel : in std_logic_vector(1 downto 0);
      opcode : out std_logic_vector(7 downto 0);
      aluop : in std_logic_vector(3 downto 0)
    );
  end component;


    signal mem0WEn,
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
    regR1dbufWEn : std_logic;
    signal aluOp, flagOffset : std_logic_vector(3 downto 0);
    signal muxAluBSel, muxAluASel : std_logic_vector(1 downto 0);
    signal opcode : std_logic_vector(7 downto 0);

  begin

    cu0: cu port map(
        mem0WEn => mem0WEn,
        reg0WEn => reg0WEn,
        alu0WEn => alu0WEn,
        muxPCSel => muxPCSel,
        muxMemASel => muxMemASel,
        muxMemWSel => muxMemWSel,
        muxRegA0Sel => muxRegA0Sel,
        muxRegA1Sel => muxRegA1Sel,
        muxRegAWSel => muxRegAWSel,
        muxRegWDSel => muxRegWDSel,
        muxAluASel => muxAluASel,
        pcWEn => pcWEn,
        aludbufWEn => aludbufWEn,
        memibufWEn => memibufWEn,
        memdbufWEn => memdbufWEn,
        regR0dbufWEn => regR0dbufWEn,
        
        regR1dbufWEn => regR1dbufWEn,
        aluOp => aluop,
        flagOffset => flagOffset,
        muxAluBSel => muxAluBSel,
        clk => clk,
        reset => reset,
        opcode => opcode
    );


    dp0: dp port map(
      mem0WEn => mem0WEn,
      reg0WEn =>  reg0WEn,
      alu0WEn => alu0WEn,
      muxPCSel => muxPCSel,
      muxMemASel => muxMemASel,
      muxMemWSel => muxMemWSel,
      muxRegA0Sel => muxRegA0Sel,
      muxRegA1Sel => muxRegA1Sel,
      muxRegAWSel => muxRegAWSel,
      muxRegWDSel => muxRegWDSel,
      muxAluASel => muxAluASel,
      pcWEn => pcWEn,
      aludbufWEn => aludbufWEn,
      memibufWEn => memibufWEn,
      memdbufWEn => memdbufWEn,
      regR0dbufWEn => regR0dbufWEn,
      regR1dbufWEn => regR1dbufWEn,
      muxAluBSel => muxAluBSel,
      clk => clk,
      reset =>  reset,
      aluop => aluop,
      opcode => opcode
    );
 end sea_top;
    
    
-- TODO finish the top
-- TODO finish the CU
-- TODO bit stuff
-- TODO bug fixes
-- TODO create test sea program
