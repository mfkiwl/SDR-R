----------------------------------------------------------------------------------
-- Company: UMBC
-- Engineer: Ben Mogren
-- Capstone Spring 19'
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity div_manager is
    Port ( clk : in STD_LOGIC;
           div : in STD_LOGIC_VECTOR (2 downto 0);
           reset: in STD_LOGIC;
           rader : out STD_LOGIC;
           adc_clk : out STD_LOGIC);
end div_manager;

architecture Behavioral of div_manager is
    signal count :std_logic_vector(3 downto 0);
begin
    
    rader <= count(3);
    
    process(clk,reset)
    begin
        if(reset = '1') then
            count <= "0000";
        else if rising_edge(clk) then
            count <= count + 1;
            end if;
        end if;
    end process;
    
    process(div, count, clk)
    begin
        case div is
            when "000" =>
                adc_clk <= clk;
            when "001" =>
                adc_clk <= count(0);
            when "010" =>
                adc_clk <= count(1);
            when "011" =>
                adc_clk <= count(2);
            when others =>
                adc_clk <= count(3);
        end case;
    end process;
    
end Behavioral;
