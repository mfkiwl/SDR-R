--2 8 bit mux behavioral
--Mux.vhd
--Paul Effingham
--effing1

library IEEE;
use iee.std_logic_1164.all;

entity mux is
    port ( 
        SEL : in std_logic;
        A   : in std_logic_vector(7 downto 0);
        B   : in std_logic_vector(7 downto 0);
        X : out std_logic_vector(7 downto 0));
end mux;

architecture behavioral of mux is
begin 
    X <= A when (SEL = '1') else B;
end behavioral;