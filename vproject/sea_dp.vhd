----------------------------------------------------------
-- DP
---------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity dp is
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
end;

architecture dp of dp is

component sea_buffer is
generic (N : integer);
port(clk        : in std_logic;
    w_enable    : in std_logic;
    data_in     : in std_logic_vector(N-1 downto 0);
    data_out    : out std_logic_vector(N-1 downto 0)
);
end component;

component mux2 is
generic (width: integer);
port(d0, d1     : in STD_LOGIC_VECTOR(width-1 downto 0);
       s        : in  STD_LOGIC;
       y        : out STD_LOGIC_VECTOR(width-1 downto 0));
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
      clk :     in STD_LOGIC
      );
end component;

signal memRBus,
    regR0Bus,
    regR1Bus,
    aluYBus : std_logic_vector(15 downto 0); -- out of components

signal PCBus,
    memibufBus,
    memdbufBus,
    regR0dbufBus,
    regR1dbufBus,
    aludbufBus : std_logic_vector(15 downto 0); -- out of buffers

signal muxPCBus,
    muxMemABus,
    muxMemWBus, 
    muxRegA0Bus,
    muxRegA1Bus, 
    muxRegAWBus, 
    muxRegWDBus,
    muxAluABus, 
    muxAluBBus : std_logic_vector(15 downto 0); -- out of muxes

signal alumuxBin4 : std_logic_vector(15 downto 0) := "0000000000000100"; -- 4
signal low : std_logic_vector(15 downto 0) := "0000000000000000"; -- 0

begin
    mem0: mem generic map(32) port map (
        clk => clk, wEn => mem0WEn, a => muxMemABus,
        wd => muxMemWBus, rd => memRBus
    );
    reg0:       reg port map(
        clk => clk, wEn => reg0WEn, ra0 => muxRegA0Bus,
        ra1 => muxRegA1Bus, wa => muxRegAWBus, wd => muxRegWDBus,
        rd0 => regR0Bus, rd1 => regR1Bus
    );
    alu0: alu port map(
        a => muxAluABus, b => muxAluBBus, y => AluYBus,
        aluop => aluop, clk => clk
    );

    muxPC:      mux2 generic map(16) port map(
        d0      => aludbufBus,
        d1      => memibufBus,
        s       => muxPCSel,
        y       => muxPCBus
    );
    muxMemA:    mux2 generic map(16) port map(
        d0      => PCBus,
        d1      => memibufBus,
        s       => muxMemASel,
        y       => muxMemABus
    );
    muxMemW:    mux2 generic map(16) port map(
        d0      => memibufBus,
        d1      => regR0dbufBus,
        s       => muxMemWSel,
        y       => muxMemWBus
    );
    muxRegWD:   mux2 generic map(16) port map(
        d0      => memdbufBus,
        d1      => aludbufBus,
        s       => muxRegWDSel,
        y       => muxregWDBus
    );
    muxAluA:    mux2 generic map(16) port map(
        d0      => regR0dbufBus,
        d1      => memibufBus,
        s       => muxAluASel,
        y       => muxAluABus
    );
    muxAluB:    mux4 generic map(16) port map(
        d0      => regR1dbufBus,
        d1      => memibufBus,
        d2      => aluMuxBIn4,
        d3      => low,
        s       => muxAluBSel,
        y       => muxAluBBus
    );
    pc:         sea_buffer generic map(16) port map(
        clk         => clk,
        w_enable    => pcWEn,
        data_in     => muxPCBus,
        data_out    => PCBus
    );
    memibuf:    sea_buffer generic map(16) port map(
        clk         => clk,
        w_enable    => memibufWEn,
        data_in     => memRBus,
        data_out    => memibufBus
    );
    memdbuf:    sea_buffer generic map(16) port map(
        clk         => clk,
        w_enable    => memdbufWEn,
        data_in     => memRBus,
        data_out    => memdbufBus
    );
    regR0dbuf:  sea_buffer generic map(16) port map(
        clk         => clk,
        w_enable    => pcWEn,
        data_in     => regR0Bus,
        data_out    => regR0dbufBus
    );
    regR1dbuf:  sea_buffer generic map(16) port map(
        clk         => clk,
        w_enable    => regR1dbufWEn,
        data_in     => regR1Bus,
        data_out    => regR1dbufBus
    );
    aludbuf:    sea_buffer generic map(16) port map(
        clk         => clk,
        w_enable    => pcWEn,
        data_in     => aluYBus,
        data_out    => aludbufBus
    );

end dp;
