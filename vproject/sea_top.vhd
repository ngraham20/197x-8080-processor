----------------------------------------------------------
-- SEA_TOP
---------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity sea_top is -- top-level design for testing
  port();
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
      muxAluASel,
      pcWEn,
      memibufWEn,
      memdbufWEn,
      regR0dbufWEn,
      regR1dbufWEn : in std_logic;
      muxAluBSel : in std_logic_vector(1 downto 0);
      opcode : out std_logic_vector(7 downto 0);
      aluop : in std_logic_vector(3 downto 0)
    );
  end component;

  begin

    cu0: cu port map(
mem0WEn,
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
        memibufWEn => memibufWEn,
        memdbufWEn => memdbufWEn,
        regR0dbufWEn => regR0dbufWEn,
        
        regR1dbufWEn : out std_logic;
        aluOp, flagOffset : out std_logic_vector(3 downto 0);
        muxAluBSel : out std_logic_vector(1 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        opcode : in std_logic_vector(15 downto 0)

    );


    dp0: dp port map(
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
      memibufWEn => memibufWEn,
      memdbufWEn => memdbufWEn,
      regR0dbufWEn => regR0dbufWEn,

      regR1dbufWEn : out std_logic;
      muxAluBSel : out std_logic_vector(1 downto 0);
      opcode : in std_logic_vector(7 downto 0);
      aluop, flagOffset : out std_logic_vector(3 downto 0)
    );



  end sea_top;
    
    
-- TODO finish the top
-- TODO finish the CU
-- TODO bit stuff
-- TODO bug fixes
-- TODO create test sea program
