----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/23/2019 02:13:06 PM
-- Design Name: 
-- Module Name: interleaver_tb - Behavioral
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

entity interleaver_tb is
--  Port ( );
end interleaver_tb;

architecture Behavioral of interleaver_tb is

component interleaver
port (clk               : in std_logic;
      reset_n           : in std_logic;
      data1_in,data2_in : in STD_LOGIC_VECTOR (7 downto 0);
      data_out          : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal CLOCK  : std_logic;
signal RESET_n: STD_LOGIC;
signal byte1  : std_logic_vector (7 downto 0);
signal byte2  : std_logic_vector (7 downto 0);
signal result : std_logic_vector (15 downto 0);

constant clk_period : time := 4 ns;
      
      
begin

UUT: interleaver 
port map (data1_in => byte1, 
          data2_in => byte2, 
          clk => CLOCK, 
          reset_n => RESET_n,
          data_out => result);
-- Start Clock
clk_proc: process
begin
    CLOCK <= '0';
    wait for clk_period/2;
    CLOCK <= '1';
    wait for clk_period/2;
end process;

-- Actual Testbench Stimulus
stimulus: process
begin
    RESET_n <= '0'; -- Give initial state
    byte1 <= x"aa"; -- Initial data
    byte2 <= x"ff"; -- Initial data
    wait for clk_period * 10;
    RESET_n <= '1';
    wait for clk_period * 1;
    byte1 <= x"bb";
    byte2 <= x"dd";
    wait for clk_period * 1;
    byte1 <= x"ab";
    byte2 <= x"cd";
    wait for clk_period * 5;
    RESET_n <= '0'; -- Reset
    wait for clk_period * 10;
    
    wait for 100 ns;
    std.env.finish;
end process;
end Behavioral;
