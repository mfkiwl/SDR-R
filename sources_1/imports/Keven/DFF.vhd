library  IEEE;
use ieee.std_logic_1164.all;

entity DFF is
    port(
        D   : in std_logic_vector(7 downto 0);
        CE  : in std_logic;
        CLK : in std_logic;
        reset : in std_logic;
        Q   : out std_logic_vector(7 downto 0)
    );
end DFF;

architecture Behavioral of DFF is

begin
process (CLK, CE, reset)
begin
    if reset = '1' then
        Q <= "00000000"; 
    elsif rising_edge(CLK) then
        if (CE = '1') then
            Q <= D;
        end if;
    end if;
end process;

end Behavioral;