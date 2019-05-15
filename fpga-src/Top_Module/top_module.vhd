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
           debug : out std_logic_vector(7 downto 0);
           ADC   : in std_logic_vector(7 downto 0);
           Cbus7 : out std_logic;
           Cbus6 : out std_logic;
           Cbus5 : in std_logic;
           Cbus4 : out std_logic;
           Cbus3 : out std_logic;
           Cbus2 : out std_logic;
           Cbus1 : in std_logic;
           Cbus0 : in std_logic;
           
           --Reset button
           BTNreset : in std_logic;
           fifo_reset : in std_logic;
           --RADER STUFF
           --rader     : in std_logic;
           --rader_clk : in std_logic;
           --
           sysclk   : in STD_LOGIC;
           outClock : out std_logic); 
end top_module;


architecture Behavioral of top_module is
    -- SIGNAL DECLARATIONS
    signal resetsig_n : std_logic := '1'; -- TODO: Have all signals have reset input (active low)
  --  signal upcount    : std_logic_vector (7 downto 0) := x"00"; -- TODO: Remove in Final Design
   -- signal downcount  : std_logic_vector (7 downto 0) := x"FF"; -- TODO: Remove in Final Design
    --signal pre_i_samp : std_logic_vector (15 downto 0) := x"0000";
    --signal pre_q_samp : std_logic_vector (15 downto 0) := x"0000";
    --signal i_samp     : std_logic_vector (15 downto 0) := x"0000";
   -- signal q_samp     : std_logic_vector (15 downto 0) := x"0000";
  --signal clk120     : std_logic; -- NOTE: Note, left over, can delete
    signal clk25      : std_logic; -- NOTE: 25 MHz clock for USB block transfer stage
    signal fake_dout  : std_ulogic_vector(31 downto 0);   --Output to keven to change the clocking overall
    signal fake_empty, notfake_empty : std_logic; 
    signal IandQ      : std_logic_vector(15 downto 0);
    signal InvBTNreset: std_logic;
    signal rader_out  : std_logic;
    signal fpga_ftdi_wr_en : std_logic;
    signal testingReceive : std_logic_vector(31 downto 0);
    signal CM_pulse, Clk_ADC : std_logic;
    signal temp_full : std_logic;
    signal clk400 : std_logic;
    signal NC_clk, clk100 : std_logic;
--Keven to me
component link_rader_FSM is
    port (
        ADC       : in std_logic_vector(7 downto 0);
        rader     : in std_logic;
        rader_clk : in std_logic;
        reset     : in std_logic;
        pulse_clk   : in std_logic;
        even_odd_out : out std_logic_vector(15 downto 0);
        fifo_wr_en   : out std_logic
    );
end component;

--component div_manager is
--    Port ( clk : in STD_LOGIC;              --Clocking manager 25 Mhz
--           div : in STD_LOGIC_VECTOR (2 downto 0); -- '000'
--           reset: in STD_LOGIC;                     -- btnrest
--           rader : out STD_LOGIC;                   --low freq rader signal goes to link_rader_fsm rader
--           adc_clk : out STD_LOGIC);                    --clock out for ADC
--end component;  

    component bitregister
        port (DATA : in  std_logic_vector(31 downto 0);
              CE   : in std_logic;
              CLK  : in  std_logic;
              reset: in std_logic;
              Q    : out std_logic_vector(31 downto 0));
    end component;
    
    component FPGAtoUSB 
    
       Port ( data1 : in STD_LOGIC_VECTOR (15 downto 0);
              --data2 : in STD_LOGIC_VECTOR (7 downto 0);
              clk : in STD_LOGIC;   --25 MHz
              reset_n : in STD_LOGIC;
              FT_clk : in STD_LOGIC;
              FT_TX : in STD_LOGIC;
              FT_RX : in STD_LOGIC;
              fifo_wr_en : in std_logic;
              FT_RD : out STD_LOGIC;
              FT_OE : out STD_LOGIC;
              FT_WR : out STD_LOGIC;
              FT_inout : inout STD_LOGIC_VECTOR (7 downto 0);
                
            --  debug : out std_logic_vector(10 downto 0);
              rd_rst    : in std_logic;
              wr_rst    : in std_logic;
              --Input/Output to keven
              CPUtoFPGA_read_clock : in std_logic;                   --Keven gives us the clocking speed he can read the fifo from
              CPUtoFPGA_rd_en : in std_logic;                        --Keven specifies when he is able to read
              CPUtoFPGA_dout  : out std_ulogic_vector(31 downto 0);   --Output to keven to change the clocking overall
              CPUtoFPGA_empty : out std_logic;
              CPUtoFPGA_FIFO_Full : out std_logic);                      --A signal keven will need to know when the buffer isnt full
    end component;
   
   component clk_div_dsp
    port(
        clk_4x : in std_logic; 
        clk : in std_logic;
        div : in std_logic_vector(9 downto 0);
        div_frac : in std_logic_vector(21 downto 0);
--        new_data : in std_logic;
        rst : in std_logic;
        rader_pulse : out std_logic;
        ADC_out : out std_logic);
        end component;
        
    component clk_wiz_0 
        port (clk_out1 : out std_logic;
              clk_out2 : out std_logic;
              reset : in std_logic;              
              clk_in1  : in std_logic);
    end component;

begin
    InvBTNreset <= not BTNreset;
    Cbus7 <= '1'; -- Signals are unused, leave deasserted high
    Cbus4 <= '1'; -- Signals are unused, leave deasserted high
    
    -- Clock Generator --
    clkgen : clk_wiz_0
    port map (
    clk_out1 => clk25,
    clk_out2 => NC_clk,
    reset => BTNreset,
    clk_in1 => sysclk
    );
    
    clkgenStepUp : clk_wiz_0
    port map (
    clk_out1 => clk400,
    clk_out2 => clk100,
    reset => BTNreset,
    clk_in1 => clk25
    );
    --outClock <= clk25;

    link : link_rader_FSM
    port map(
        ADC       => ADC, 
        rader     => rader_out,
        rader_clk => clk100, 
        reset     => BTNreset,
        pulse_clk => CM_pulse, 
        even_odd_out => IandQ,
        fifo_wr_en => fpga_ftdi_wr_en
    );
    
    --divider : div_manager
    --port map(
    --clk => clk100,
    --div => "000",
    --reset => BTNreset,
    --rader => rader_out,
    --adc_clk => outClock
    --);

   clk_manager : clk_div_dsp
    port map(
        clk_4x    => clk400, --one of these clocks needs to be different
        clk       => clk100,
        div       => std_logic_vector(fake_dout(31 downto 22)),
        div_frac  => std_logic_vector(fake_dout(21 downto 0)),
        --new_data  => temp_full, --needs to be the full tag on the FIFO
        rst     => BTNreset, 
        rader_pulse => CM_pulse,
        ADC_out   => outClock );
        


-- GPIO Sample Registers --
-- Inphase Bus --
   -- Imeta : bitregister
   -- port map (
   -- DATA => IandQ,
   -- CLK  => clk25,
   -- reset => BTNreset,
   -- Q    => pre_i_samp);
    
    readDebug : bitregister
    port map (
    DATA => std_logic_vector(fake_dout),
    CE   => notfake_empty,
    CLK  => clk100,
    reset => BTNreset,
    Q    =>  testingReceive);
    
notfake_empty <= not(fake_empty);
debug <= testingReceive(7 downto 0);
-- USB Block --
-- NOTE: Contains FSM that needs to be replaced with new pretty one. 
    USBtransfer : FPGAtoUSB
    port map (
    data1 => IandQ,
    --data2 => q_samp,
    clk => clk100,
    reset_n => InvBTNreset,
    FT_clk => Cbus5, -- in
    FT_TX => Cbus1,  -- in
    FT_RX => Cbus0,  -- in
    fifo_wr_en => fpga_ftdi_wr_en,   -- in
    FT_RD => Cbus2,  -- out
    FT_OE => Cbus6,  -- out
    FT_WR => Cbus3,  -- out
    
   -- debug => debug,
    rd_rst  => fifo_reset,
    wr_rst  => fifo_reset,
    FT_inout => Dbus,
    CPUtoFPGA_read_clock => Cbus5,               --Keven gives us the clocking speed he can read the fifo from
    CPUtoFPGA_rd_en => notfake_empty,            --Keven specifies when he is able to read
    CPUtoFPGA_dout  => fake_dout,                --Output to keven to change the clocking overall
    CPUtoFPGA_empty => fake_empty,
    CPUtoFPGA_FIFO_Full => temp_full);              --A signal keven will need to know when the buffer isnt full
end Behavioral;
