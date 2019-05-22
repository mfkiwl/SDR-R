----------------------------------------------------------------------------------
-- UMBC
-- Ben Mogren
-- Spring 19'
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity div_fifo is
    Port ( clk_FPGA : in STD_LOGIC; --FPGA clock, 100MHz
           clk_FTDI : in STD_LOGIC; --FTDI clock, 60 MHz
           rd_en    : in STD_LOGIC; --Data is ready from FTDI state machine
           din      : in STD_LOGIC_VECTOR (7 downto 0); --Data from FTDI state machine
           reset    : in STD_LOGIC; --Resets output data to 20MHz, ready to load first byte.
           div      : out STD_LOGIC_VECTOR (9 downto 0); --Data presented to clock divider module
           div_frac : out STD_LOGIC_VECTOR (21 downto 0)); --Data presented to clock divider module
end div_fifo;

architecture Behavioral of div_fifo is

    signal byte0 : STD_LOGIC_VECTOR (7 downto 0);
    signal byte1 : STD_LOGIC_VECTOR (7 downto 0);
    signal byte2 : STD_LOGIC_VECTOR (7 downto 0);
    signal byte3 : STD_LOGIC_VECTOR (7 downto 0);
    signal load_byte : STD_LOGIC_VECTOR (1 downto 0); --Select which byte is being loaded
    
begin
    --Reset counter on rd_en
    --Reset load_byte on MSB of counter.
    
    --Reset all valuse on reset
    
    --Increment load_byte on every rd_en
    --Latch selected byte on rd_en
    
    --Update div and div_frac on posedge FPGA_clk when rd_en is low and load_byte is 0
    
    FPGA_Clock : process (clk_fpga, reset)
    begin
        if reset = '1' then
            div <= "1111101000"; -- div 1000
            div_frac <= (others => '0');
        elsif (rising_edge(clk_fpga) and (load_byte = "00") and (rd_en = '0')) then
            div <= (byte0 & byte1(7 downto 6));
            div_frac <= (byte1(5 downto 0) & byte2 & byte3);
        end if;
    end process;

    FTDI_Clock : process(reset, clk_ftdi)
    begin
        if reset = '1' then
            load_byte <= (others => '0');
        elsif rising_edge(clk_ftdi) and rd_en = '1' then
            load_byte <= load_byte + '1';
        end if;
        
        if reset = '1' then
            byte0 <= "11111010"; -- div 1000
            byte1 <= "00000000";
            byte2 <= "00000000";
            byte3 <= "00000000";
        elsif rising_edge(clk_ftdi) then-- rd_en = '1' then
            case load_byte & rd_en is
                when "001"   => 
                    byte0 <= din;
                    byte1 <= byte1;
                    byte2 <= byte2;
                    byte3 <= byte3;
                when "011"   =>
                    byte1 <= din;
                    byte0 <= byte0;
                    byte2 <= byte2;
                    byte3 <= byte3;
                when "101"   =>
                    byte2 <= din;
                    byte0 <= byte0;
                    byte1 <= byte1;
                    byte3 <= byte3;
                when "111"   =>
                    byte3 <= din;
                    byte0 <= byte0;
                    byte1 <= byte1;
                    byte2 <= byte2;
                when others => 
                   byte0 <= byte0;
                   byte1 <= byte1;
                   byte2 <= byte2;
                   byte3 <= byte3;
            end case;
        end if;
    end process;
    
end Behavioral;
