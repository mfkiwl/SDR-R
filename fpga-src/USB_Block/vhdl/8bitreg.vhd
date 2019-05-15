--Paul Effingham
--8 Bit register


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity bitregister is
    port (
        DATA    : in std_logic_vector(31 downto 0);
        CE      : in std_logic;
        CLK     : in std_logic;
        reset   : in std_logic;
        Q       : out std_logic_vector(31 downto 0)); 
end bitregister;

architecture Behavioral of bitregister is

begin
    process (CLK, reset) begin
        if reset = '1' then
            Q <= (others=> '0');
        elsif (rising_edge(CLK)) then
            if CE = '1' then
                Q <= DATA;
            end if;
        end if;
    end process;
end Behavioral;