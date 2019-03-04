----------------------------------------------------------------------------------
-- Company:   UMBC - SDR-R Capstone Team
-- Engineer:  Chris Carreras
-- 
-- Create Date: 02/01/2019 10:34:23 AM
-- Design Name: Software Defined Radio; Top Module
-- Module Name: top_module - Behavioral
-- Project Name:  Software Defined Radio - Receiver
-- 
-- Dependencies: Host operating system capable of interacting w/ FPGA via 
--               FTDI232H IC
-- 
-- Additional Comments: This is where we interface all components of FPGA portion
--                      of our SDR-R
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

entity top_module is
    Port ( 
         --pio  : in    std_logic_vector (7 downto 0);  -- GPIO Bus 1
         --pio2 : in    std_logic_vector (7 downto 0);  -- GPIO Bus 2
           Dbus : inout STD_LOGIC_VECTOR (7 downto 0);  -- Data Bus on FT232H
           -- Control Signals on FT232H, C7 & C4 are unused, leave deasserted HIGH
           -- All of these control signals are active low (assert low)
           Cbus7 : out std_logic;
           Cbus6 : out std_logic;
           Cbus5 : in std_logic;
           Cbus4 : out std_logic;
           Cbus3 : out std_logic;
           Cbus2 : out std_logic;
           Cbus1 : in std_logic;
           Cbus0 : in std_logic;
           sysclk   : in STD_LOGIC); 
end top_module;

architecture Behavioral of top_module is
    -- SIGNAL DECLARATIONS
    signal resetsig_n : std_logic := '1'; -- TODO: Have all signals have reset input (active low)
    signal upcount    : std_logic_vector (7 downto 0) := x"00"; -- TODO: Remove in Final Design
    signal downcount  : std_logic_vector (7 downto 0) := x"FF"; -- TODO: Remove in Final Design
    signal pre_i_samp : std_logic_vector (7 downto 0) := x"00";
    signal pre_q_samp : std_logic_vector (7 downto 0) := x"00";
    signal i_samp     : std_logic_vector (7 downto 0) := x"00";
    signal q_samp     : std_logic_vector (7 downto 0) := x"00";
  --signal clk120     : std_logic; -- NOTE: Note, left over, can delete
    signal clk25      : std_logic; -- NOTE: 25 MHz clock for USB block transfer stage
    
    -- COMPONENT DECLARATIONS
    component doublecounter
        port (cout1   :out std_logic_vector (7 downto 0);
              cout2   :out std_logic_vector (7 downto 0);
              up_down : in std_logic;
              clk     : in std_logic;
              reset   : in std_logic
              );
    end component;
    
--    component up_down_counter
--        port (cout    :out std_logic_vector (7 downto 0); 
--              up_down :in  std_logic;                   -- up_down control for counter
--              clk     :in  std_logic;                   -- Input clock
--              reset   :in  std_logic                    -- Input reset
--              );
--    end component;

    component bitregister
        port (DATA : in  std_logic_vector(7 downto 0);
              CLK  : in  std_logic;
              Q    : out std_logic_vector(7 downto 0));
    end component;

    component USB_BLOCK
        port (data1    : in STD_LOGIC_VECTOR (7 downto 0);
              data2    : in STD_LOGIC_VECTOR (7 downto 0);
               clk      : in STD_LOGIC;
               reset_n  : in STD_LOGIC;
               FT_clk   : in STD_LOGIC;
               FT_TX    : in STD_LOGIC;
               FT_RX    : in STD_LOGIC;
               FT_RD    : out STD_LOGIC;
               FT_OE    : out STD_LOGIC;
               FT_WR    : out STD_LOGIC;
               FT_inout : inout STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component clk_wiz_0 
        port (clk_out1 : out std_logic;
              resetn : in std_logic;              clk_in1  : in std_logic);
    end component;

begin
    Cbus7 <= '1'; -- Signals are unused, leave deasserted high
    Cbus4 <= '1'; -- Signals are unused, leave deasserted high
    
    -- Clock Generator --
    clkgen : clk_wiz_0
    port map (
    clk_out1 => clk25,
    resetn => '1',
    clk_in1 => sysclk
    );
    
-- Counters for Sample Data
    mixcounter: doublecounter
    port map (
    cout1  => upcount,
    cout2  => downcount,
    up_down => '1',
    clk     => clk25,
    reset   => '0');

--    upcounter : up_down_counter
--    port map (
--    cout    => upcount,
--    up_down => '1',
--    clk   => clk25,
--    reset => '0');
    
--    downcounter : up_down_counter
--    port map (
--    cout    => downcount,
--    up_down => '0',
--    clk => clk25,
--    reset => '0');

-- GPIO Sample Registers --
-- Inphase Bus --
    Imeta : bitregister
    port map (
    DATA => upcount,
    CLK  => clk25,
    Q    => pre_i_samp);
    
    Istable : bitregister
    port map (
    DATA => pre_i_samp,
    CLK  => clk25,
    Q    => i_samp);
    
 -- Quadrature Bus --
    Qmeta : bitregister
    port map (
    DATA => downcount,
    CLK  => clk25,
    Q    => pre_q_samp);
    
    Qstable : bitregister
    port map (
    DATA => pre_q_samp,
    CLK  => clk25,
    Q    => q_samp);

-- USB Block --
-- NOTE: Contains FSM that needs to be replaced with new pretty one. 
    USBtransfer : USB_BLOCK
    port map (
    data1 => i_samp,
    data2 => q_samp,
    clk => clk25,
    reset_n => '1',
    FT_clk => Cbus5, -- in
    FT_TX => Cbus1,  -- in
    FT_RX => Cbus0,  -- in
    FT_RD => Cbus2,  -- out
    FT_OE => Cbus6,  -- out
    FT_WR => Cbus3,  -- out
    FT_inout => Dbus);



end Behavioral;
