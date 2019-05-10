----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/23/2019 01:28:55 PM
-- Design Name: 
-- Module Name: interleaver - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity interleaver is
    Port ( clk : in STD_LOGIC;
           reset_n  : in STD_LOGIC;                        -- Reset Signal, Active Low
           data1_in : in STD_LOGIC_VECTOR (7 downto 0);    -- Byte1, received
           data2_in : in STD_LOGIC_VECTOR (7 downto 0);    -- Byte2, received
           data_out : out STD_LOGIC_VECTOR (15 downto 0)); -- Word, sent
end interleaver;

architecture Behavioral of interleaver is

    signal pre_data_out : STD_LOGIC_VECTOR (15 downto 0);
    
begin
    -- Interleave the two input bytes
    -- NOTE: Not explicitly necessary, but seemed nice in my head
  --pre_data_out <= data1_in & data2_in; -- concatenating

    -- Every rising edge, output the interleaved word
    process (clk,reset_n) begin
        if (reset_n = '0') then
            data_out <= x"0000";
        elsif (rising_edge(clk)) then
          --data_out <= pre_data_out;
            data_out <= data1_in & data2_in;
        end if;
    end process;
end Behavioral;
