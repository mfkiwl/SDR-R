------------------------------------------------------
-- Design Name : up_down_counter
-- File Name   : up_down_counter.vhd
-- Function    : Up down counter
-- Coder       : Deepak Kumar Tala (Verilog)
-- Translator  : Alexander H Pham (VHDL)
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity doublecounter is
    port (
    cout1    :out std_logic_vector (7 downto 0);
    cout2    : out std_logic_vector (7 downto 0); 
    up_down :in  std_logic;                   -- if 1, both up, if 0 one up one down
    clk     :in  std_logic;                   -- Input clock
    reset   :in  std_logic                    -- Input reset
   );
 end entity;
 
--architecture rtl of up_down_counter is
architecture behavioral of doublecounter is
 
    signal count1 :std_logic_vector (15 downto 0) := x"0000";
    signal count2 :std_logic_vector (15 downto 0) := x"0000";
  --signal count :std_logic_vector (24 downto 0); -- Approx 1.4 second counter
begin
    process (clk, reset) begin
        if (reset = '1') then
            count1 <= (others=>'0');
            count2 <= (others=>'0');
         elsif (rising_edge(clk)) then
             if (up_down = '1') then
                 count1 <= count1 + 1;
                 count2 <= count2 + 1;
             else
                 count1 <= count1 + 1;
                 count2 <= count2 - 1;
            end if;
        end if;
    end process;
    cout1 <= count1  (7 downto 0);
    cout2 <= count2 (8 downto 1);
end behavioral;
--end architecture;
