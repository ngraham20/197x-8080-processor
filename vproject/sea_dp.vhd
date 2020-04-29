----------------------------------------------------------
-- DP
---------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity dp is -- top-level design for testing
  port(
    clk in : std_logic;
    reset in : std_logic;
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
    muxAluBSel,
    pcWEn,
    memibufWEn,
    memdbufWEn,
    regR0dbufWEn,
    regR1dbufWEn,
    aludbufWEn in : std_logic;
    opcode out : std_logic_vector(7 downto 0)
  );
end;



architecture dp of dp is

component buffer is
generic (N : integer);
port(clk        in : std_logic;
    w_enable    in : std_logic;
    data_in     in : std_logic_vector(N-1 downto 0);
    data_out    out : std_logic_vector(N-1 downto 0)
);
end component;

component mux2 is
port(d0, d1:    in  STD_LOGIC_VECTOR(width-1 downto 0);
       s:       in  STD_LOGIC;
       y:       out STD_LOGIC_VECTOR(width-1 downto 0));
end component;

component mux4 is
generic (width: integer);
port(d0, d1, d2, d3 :   in std_logic_vector(width-1 downto 0);
    s :                 in std_logic_vector(1 downto 0);
    y :                 out std_logic_Vector(width-1 downto 0));
end component;

component reg is
port(clk:       in  STD_LOGIC;
wEn:            in  STD_LOGIC;
ra0, ra1, wa:   in  STD_LOGIC_VECTOR(15 downto 0);
wd:             in  STD_LOGIC_VECTOR(15 downto 0);
rd0, rd1:       out STD_LOGIC_VECTOR(15 downto 0));
end component;

component mem is
generic(width: integer);
port(clk, wEn:  in STD_LOGIC;
        a, wd:  in STD_LOGIC_VECTOR((width-1) downto 0);
        rd:     out STD_LOGIC_VECTOR((width-1) downto 0));
end component;

component alu is
port(a, b :     in STD_LOGIC_VECTOR(15 downto 0);
      y :       out STD_LOGIC_VECTOR(15 downto 0);
      aluop :   in STD_LOGIC_VECTOR(3 downto 0);
      clk :     in STD_LOGIC;
      );
end component;

signal memR,
    regR0,
    regR1,
    aluY : std_logic_vector(15 downto 0); -- out of components
    
signal memibuf,
    memdbuf,
    regR0dbuf,
    regR1dbuf,
    aludbuf : std_logic_vector(15 downto 0); -- out of buffers

signal muxPC
    muxMemA,
    muxMemW, 
    muxRegA0,
    muxRegA1, 
    muxRegAW, 
    muxRegWD,
    muxAluA, 
    muxAluB : std_logic_vector(15 downto 0); -- out of muxes

-- signal memibuf_muxregA0,
--     memibuf_muxRegA1,
--     memibuf_muxRegAW,
--     memibuf_muxPC,
--     memibuf_muxMemA,
--     memibuf_muxAluB,
--     memdbuf_muxRegWD,
--     regR0dbuf_muxMemWD,
--     regR0dbuf_muxAluA,
--     regR1dbuf_muxAluB,
--     aludbuf_muxPC,
--     aludbuf_muxMemWD,
--     aludbuf_muxRegWD : std_logic_vector(15 downto 0); -- into muxes

-- signal muxPC_PC,
--     memR_ibuf,
--     memR_dbuf,
--     regR0_regR0dbuf,
--     regR1_regR1dbuf,
--     aluY_aludbuf : std_logic_vector(15 downto 0); -- into buffer

-- signal muxMemA_memA,
--     muxMemW_memW, 
--     muxRegA0_regA0,
--     muxRegA1_regA1, 
--     muxRegAW_regAW, 
--     muxRegWD_regWD,
--     muxAluA_aluA, 
--     muxAluB_aluB : std_logic_vector(15 downto 0); -- into components

signal alumuxBin4 : std_logic_vector(15 downto 0) := "0000000000000100"; -- 4

begin
    mem0:       mem generic map(16) port map ();
    reg0:       reg port map();
    alu0:       alu port map();

    muxPC:      mux2 generic map(16) port map();
    muxMemA:    mux2 generic map(16) port map();
    muxMemW:    mux2 generic map(16) port map();
    muxRegA0:   mux2 generic map(16) port map();
    muxRegA1:   mux2 generic map(16) port map();
    muxRegAW:   mux2 generic map(16) port map();
    muxRegWD:   mux2 generic map(16) port map();
    muxAluA:    mux2 generic map(16) port map();
    muxAluB:    mux2 generic map(16) port map();

    pc:         buffer generic map(16) port map(
        clk         => clk,
        w_enable    => pcWEn,
        data_in     => muxPC_PC,
        data_out    => 
    );
    memibuf:    buffer generic map(16) port map();
    memdbuf:    buffer generic map(16) port map();
    regR0dbuf:  buffer generic map(16) port map();
    regR1dbuf:  buffer generic map(16) port map();
    aludbuf:    buffer generic map(16) port map();



end dp;
