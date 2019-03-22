----------------------------------------------------------------------------------
-- Company:   UMBC - SDR-R Capstone Team
-- Engineer:  Chris Carreras, Paul Effingham
-- 
-- Create Date: 02/01/2019 10:34:23 AM
-- Revision Date: 03/04/2019 5:08 Pm
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


entity top_module is
    Port ( 
         --pio  : in    std_logic_vector (7 downto 0);  -- GPIO Bus 1
         --pio2 : in    std_logic_vector (7 downto 0);  -- GPIO Bus 2
           Dbus : inout STD_LOGIC_VECTOR (7 downto 0);  -- Data Bus on FT232H
           -- Control Signals on FT232H, C7 & C4 are unused, leave deasserted HIGH
           -- All of these control signals are active low (assert low)
           --debugging state machine
           debug : out std_logic_vector(10 downto 0);
           adc   : in std_logic_vector(7 downto 0);
           Cbus7 : out std_logic;
           Cbus6 : out std_logic;
           Cbus5 : in std_logic;
           Cbus4 : out std_logic;
           Cbus3 : out std_logic;
           Cbus2 : out std_logic;
           Cbus1 : in std_logic;
           Cbus0 : in std_logic;
           sysclk   : in STD_LOGIC;
           outClock : out std_logic); 
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
    signal fake_dout  : std_ulogic_vector(7 downto 0);   --Output to keven to change the clocking overall
    signal fake_empty : std_logic; 
    
    
    
    -- COMPONENT DECLARATIONS
 --   component doublecounter
 --       port (cout1   :out std_logic_vector (7 downto 0);
 --             cout2   :out std_logic_vector (7 downto 0);
 --             up_down : in std_logic;
 --             clk     : in std_logic;
 --             reset   : in std_logic
 --             );
 --   end component;
    
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
    
    component FPGAtoUSB 
    
       Port ( data1 : in STD_LOGIC_VECTOR (7 downto 0);
              --data2 : in STD_LOGIC_VECTOR (7 downto 0);
              clk : in STD_LOGIC;   --25 MHz
              reset_n : in STD_LOGIC;
              FT_clk : in STD_LOGIC;
              FT_TX : in STD_LOGIC;
              FT_RX : in STD_LOGIC;
              FT_RD : out STD_LOGIC;
              FT_OE : out STD_LOGIC;
              FT_WR : out STD_LOGIC;
              FT_inout : inout STD_LOGIC_VECTOR (7 downto 0);
                
              debug : out std_logic_vector(10 downto 0);
    
              --Input/Output to keven
              CPUtoFPGA_read_clock : in std_logic;                   --Keven gives us the clocking speed he can read the fifo from
              CPUtoFPGA_rd_en : in std_logic;                        --Keven specifies when he is able to read
              CPUtoFPGA_dout  : out std_ulogic_vector(7 downto 0);   --Output to keven to change the clocking overall
              CPUtoFPGA_empty : out std_logic);                      --A signal keven will need to know when the buffer isnt full
    end component;
    
   
    component clk_wiz_0 
        port (clk_out1 : out std_logic;
              reset : in std_logic;              
              clk_in1  : in std_logic);
    end component;

begin
    Cbus7 <= '1'; -- Signals are unused, leave deasserted high
    Cbus4 <= '1'; -- Signals are unused, leave deasserted high
    
    -- Clock Generator --
    clkgen : clk_wiz_0
    port map (
    clk_out1 => clk25,
    reset => '0',
    clk_in1 => sysclk
    );
    outClock <= clk25;

-- Counters for Sample Data
    --mixcounter: doublecounter
    --port map (
    --cout1  => upcount,
    --cout2  => downcount,
    --up_down => '1',
    --clk     => clk25,
    --reset   => '0');

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
    DATA => adc,
    CLK  => clk25,
    Q    => pre_i_samp);
    
    Istable : bitregister
    port map (
    DATA => pre_i_samp,
    CLK  => clk25,
    Q    => i_samp);
    
 -- Quadrature Bus --
    --Qmeta : bitregister
    --port map (
    --DATA => downcount,
    --CLK  => clk25,
   -- Q    => pre_q_samp);
    
    --Qstable : bitregister
    --port map (
    --DATA => pre_q_samp,
    --CLK  => clk25,
    --Q    => q_samp);

-- USB Block --
-- NOTE: Contains FSM that needs to be replaced with new pretty one. 
    USBtransfer : FPGAtoUSB
    port map (
    data1 => i_samp,
    --data2 => q_samp,
    clk => clk25,
    reset_n => '1',
    FT_clk => Cbus5, -- in
    FT_TX => Cbus1,  -- in
    FT_RX => Cbus0,  -- in
    FT_RD => Cbus2,  -- out
    FT_OE => Cbus6,  -- out
    FT_WR => Cbus3,  -- out
    
    debug => debug,
    
    FT_inout => Dbus,
    CPUtoFPGA_read_clock => '0',               --Keven gives us the clocking speed he can read the fifo from
    CPUtoFPGA_rd_en => '0',                    --Keven specifies when he is able to read
    CPUtoFPGA_dout  => fake_dout,                    --Output to keven to change the clocking overall
    CPUtoFPGA_empty => fake_empty);                    --A signal keven will need to know when the buffer isnt full
end Behavioral;
