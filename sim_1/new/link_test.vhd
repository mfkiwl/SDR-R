----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2019 03:20:10 PM
-- Design Name: 
-- Module Name: link_test - Behavioral
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


library  IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity link_test is
  --Port (     );
end link_test;

architecture Behavioral of link_test is

component link_rader_FSM is
    port (
    ADC       : in std_logic_vector(7 downto 0);
    rader     : in std_logic;
    rader_clk : in std_logic;
    reset     : in std_logic;
    even_odd_out : out std_logic_vector(15 downto 0);
    fake_rader_Clk    : out std_logic;
    is_fourth       : out std_logic;
    even_data_out   : out std_logic_vector(7 downto 0);
    odd_data_out    : out std_logic_vector(7 downto 0);
    rader_input     : out std_logic_vector(7 downto 0);
    is_even_en      : out std_logic;
    is_odd_en       : out std_logic
    );
end component;
--Inputs:
signal ADC : std_logic_vector(7 downto 0) := "00000000";
signal rader : std_logic := '0';
signal rader_clk : std_logic := '0';
signal reset     : std_logic := '0';
--Outputs:
signal even_odd_out: std_logic_vector(15 downto 0);
signal fake_rader_Clk : std_logic;
signal is_fourth : std_logic;
signal even_data_out : std_logic_vector(7 downto 0);
signal odd_data_out : std_logic_vector(7 downto 0);
signal rader_input : std_logic_vector(7 downto 0);
signal is_even_en, is_odd_en   : std_logic;
--internal
signal counter : std_logic_vector(2 downto 0):= "000";


--clk periods
--constant rader_period : time := 1us;
constant rader_clk_period : time := 1us;
constant rader_period : time := 16us;
begin

uut : link_rader_FSM
    port map(
        ADC       => ADC, 
        rader     => rader,
        rader_clk => rader_clk, 
        reset     => reset,
        even_odd_out => even_odd_out,
        fake_rader_Clk => fake_rader_Clk,
        is_fourth => is_fourth,
        even_data_out => even_data_out,
        odd_data_out => odd_data_out,
        rader_input => rader_input,
        is_even_en  => is_even_en,
        is_odd_en   => is_odd_en
    );
rader_clk_process : process
begin
    rader_clk <= '1';
    wait for rader_clk_period/2;
    rader_clk <='0';
    wait for rader_clk_period/2;
end process;
rader_sixteen_process: process
begin
    rader <= '1';
    counter <= counter+1;
    case counter is
        when "000" => ADC <= "10000000";
        when "001" => ADC <= "11111111";
        when "010" => ADC <= "10000000";
        when "011" => ADC <= "00000000";
        when "100" => ADC <= "10000000";
        when "101" => ADC <= "11111111";
        when "110" => ADC <= "10000000";
        when "111" => ADC <= "00000000";
        when others => ADC <="00000000";
    end case;
    wait for rader_period/2;
    rader <= '0';
    wait for rader_period/2;
end process;

reset_process : process
begin
    wait for 2us;
    reset <= '1';
    wait for 1us;
    reset <= '0';
    wait;
end process;

--adc_process : process
--begin
--case counter is
 --   when "00" => ADC <= "10000000";
 --   when "01" => ADC <= "11111111";
 --  when "10" => ADC <= "10000000";
 --   when "11" => ADC <= "00000000";
 --   when others => ADC <= "00000000";
--end case;
--end process;
    
end Behavioral;
