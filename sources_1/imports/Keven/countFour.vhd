library  IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity countFour is
    port (
        rader_Clk   : in std_logic;
        fake_Clk    : in std_logic;
        reset       : in std_logic;
        max_count   : out std_logic;
        min_count   : out std_logic;
        even_en     : out std_logic;
        odd_en      : out std_logic
    );
end countFour;

architecture Behavioral of countFour is

signal count : std_logic_vector(1 downto 0) := "00";

begin
    process(rader_Clk, fake_Clk, reset, count) 
    begin
    if reset = '1' then
        count <= "00";
        max_count <= '0';
        
    elsif (rising_edge(rader_Clk)) then
        if (fake_Clk = '1') then
            count <= count + 1; 
        end if;
    end if;
   
   --Need to and with clock to get correct pulse, not stay on for 16 cycles
    if (count = "11" and fake_Clk = '1') then
        max_count <= '1';
    else 
        max_count <= '0';
    end if;
    if (count = "00" and fake_Clk = '1') then
        min_count <= '1';
    else
        min_count <= '0';
    end if;
    if (count(0) = '1' and fake_Clk ='1') then
        even_en <= '1';
        odd_en <= '0';
        
    elsif (count(0) = '0' and fake_Clk = '1') then
        odd_en <= '1';
        even_en <= '0';
        
    else
        even_en <= '0';
        odd_en <= '0';
    end if;
end process;

end Behavioral;
