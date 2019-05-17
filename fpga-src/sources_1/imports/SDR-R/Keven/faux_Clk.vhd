library  IEEE;
use ieee.std_logic_1164.all;

entity faux_Clk is
    port(
        rader       : in std_logic;
        rader_Clk   : in std_logic;
        reset       : in std_logic;
        fake_Clk    : out std_logic
    );
end faux_Clk;

architecture Behavioral of faux_Clk is

signal Q, Qbar : std_logic;

begin

process(rader, rader_Clk, Q, Qbar, reset)
begin

    if reset = '1' then
        Q <= '0';    
    elsif rising_edge(rader_Clk) then
        Q <= rader;
    end if;
    Qbar <= not Q;
    fake_Clk <= rader and Qbar;
end process;



end Behavioral;
