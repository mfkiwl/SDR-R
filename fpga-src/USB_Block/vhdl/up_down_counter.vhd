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

entity up_down_counter is
    port (
    cout    :out std_logic_vector (7 downto 0); 
    up_down :in  std_logic;                   -- up_down control for counter
    clk     :in  std_logic;                   -- Input clock
    reset   :in  std_logic                    -- Input reset
   );
 end entity;
 
--architecture rtl of up_down_counter is
architecture behavioral of up_down_counter is
 
    signal count :std_logic_vector (7 downto 0);
  --signal count :std_logic_vector (24 downto 0); -- Approx 1.4 second counter
begin
    process (clk, reset) begin
        if (reset = '1') then
            count <= (others=>'0');
         elsif (rising_edge(clk)) then
             if (up_down = '1') then
                 count <= count + 1;
             else
                 count <= count - 1;
            end if;
        end if;
    end process;
    cout <= count (7 downto 0);
end behavioral;
--end architecture;
