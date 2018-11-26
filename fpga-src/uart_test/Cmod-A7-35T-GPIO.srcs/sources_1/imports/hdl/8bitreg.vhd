--Paul Effingham
--8 Bit register


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity bitregister is
    port (
        DATA    : in std_logic_vector(7 downto 0);
        CLK     : in std_logic;
        Q       : out std_logic_vector(7 downto 0)); 
end bitregister;

architecture Behavioral of bitregister is

begin
    process (CLK) begin
        if (rising_edge(CLK)) then
            Q <= DATA;
        end if;
    end process;
end Behavioral;