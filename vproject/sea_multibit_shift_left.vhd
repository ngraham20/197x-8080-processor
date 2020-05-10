library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;


entity shift_left is
    generic (N : integer := 32);
    Port (  a   : in STD_LOGIC_VECTOR(N-1 downto 0);
            shmt: in STD_LOGIC_VECTOR(integer(ceil(log2(real(N))))-1 downto 0);
            c   : out STD_LOGIC_VECTOR(N-1 downto 0) );

end shift_left;

architecture Behavioral of shift_left is
begin
    process(a, shmt)
    begin
        for i in 0 to N-1 loop
            if shmt = STD_LOGIC_VECTOR(to_unsigned(i, N)) then
                c <= STD_LOGIC_VECTOR(unsigned(a) sll i);
            end if;
        end loop;
    end process;
end Behavioral;