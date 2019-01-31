----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/23/2019 08:43:02 PM
-- Design Name: 
-- Module Name: fifo_tb - Behavioral
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

entity fifo_tb is
--  Port ( );
end fifo_tb;

architecture Behavioral of fifo_tb is

    component fifo_generator_0
        port (wr_clk    : in std_logic;
              rd_clk    : in std_logic;
              din       : in std_logic_vector (15 downto 0);
              wr_en     : in std_logic;
              rd_en     : in std_logic;
              dout      : out std_logic_vector (7 downto 0);
              full      : out std_logic;
              empty     : out std_logic);
    end component;

    signal clk_wr     : std_logic;
    signal clk_rd     : std_logic;
    signal word_in    : std_logic_vector (15 downto 0);
    signal enable_wr  : std_logic;
    signal enable_rd  : std_logic;
    signal byte_out   : std_logic_vector (7 downto 0);
    signal fifo_full  : std_logic;
    signal fifo_empty : std_logic; 

    constant write_period : time := 8 ns;
    constant read_period  : time := 4 ns;


begin

    UUT: fifo_generator_0
    port map(wr_clk => clk_wr,
             rd_clk => clk_rd,
             din    => word_in,
             wr_en  => enable_wr,
             rd_en  => enable_rd,
             dout   => byte_out,
             full   => fifo_full,
             empty  => fifo_empty);

    -- Start Read clock
    read_clock_process: process
    begin
        clk_rd <= '0';
        wait for read_period/2;
        clk_rd <= '1';
        wait for read_period/2;
    end process;

    -- Start Write clock
    write_clock_process: process
    begin
        clk_wr <= '0';
        wait for write_period/2;
        clk_wr <= '1';
        wait for write_period/2;
    end process;


    -- Actual Testbench Stimulus goes here
    stimulus: process
    begin
        -- Load data into FIFO until full
        loadfifo: loop
            word_in <= x"a1b2";
            enable_wr <= '1';
            enable_rd <= '0';
            wait for 16 ns;
            word_in <= x"ffee";
            wait for 16 ns;
            exit when (fifo_full = '1');
        end loop;

        enable_wr <= '0';
        enable_rd <= '1';
        

        -- Empty FIFO until empty
        emptyfifo: loop
            enable_rd <= '1';
            exit when (fifo_empty = '1');
            wait for 8 ns;
        end loop;
        
        wait for 100 ns;
        std.env.finish;        

    end process;


end Behavioral;
