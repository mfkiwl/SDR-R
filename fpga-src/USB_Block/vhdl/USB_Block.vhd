----------------------------------------------------------------------------------
-- Company:   UMBC Capstone Team SDR-R1
-- Engineer:  Christopher M. Carreras
-- 
-- Create Date: 01/25/2019 05:03:12 PM
-- Design Name: 
-- Module Name: USB_Block - Dataflow
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Block for interfacing FPGA with FT232H device. This block includes
--              the interleaver submodule which will interleave the inphase and 
--              quadrature samples of a received signal. The FT232H device will
--              be utilized as a source block in GNU Radio utilizing the open-source
--              libftdi library.
-- 
-- Dependencies: Intended to interface with UM232H-B USB controller operating in 
--               synchronous FIFO mode. The following describes the operation of 
--               each of the FTDI pins. 
--               
--               NOTE: May be able to repurpose unused pins to drive TX/RX leds
--
----------------------------------------------------------------------------------------------------------
--               5V  - 500mA limit, protected by 750mA fuse                                             --
--               GND - Module Ground                                                                    --
--               C7  - PWRSAV_n **UNUSED**                                                              --
--               C6  - OE_n:   Output enable, active low. When LOW data will be                         --
--                             be driven onto D7-0. This should be low for one CC                       --
--                             before driving RD# low.                                                  --
--                             NOTE: May need to be two CCs when wanting to prevent IQ inversion...     --
--               C5  - CLKOUT: 60 Mhz clock signal.                                                     --
--               C4  - SIWU_n   **UNUSED**                                                              --
-- TODO _n?      C3  - WR:    Assuming active low, when LOW, enables the data byte                      --
--                            driven onto the data pins D7-0 to be written into                         --
--                            the FT232H's internal FIFO.                                               --
--               C2  - RD_n:  When LOW, enables current FT232H data byte to be                          --
--                            driven onto the data pins D7-0. The next data byte                        --
--                            will be fetched from the FT232H's internal FIFO every                     --
--                            CLKOUT period until this signal asserts HIGH.                             --
--               C1  - TXE_n: When HIGH, do NOT write data to FT232H. When LOW                          --
--                            data can be transferred by driving WR ?high/low?       TODO: May need to assume active low? Documentation may have typo
--                            Data will be transferred very rising edge while                           --
--                            both of these signals are asserted ?low?.                                 --
--               C0  - RXF_n: When HIGH, do NOT read data from FT232H. When LOW                         --
--                            There is data that can be transferred by driving RD_n LOW.                --
--                            Data will be transferred every rising edge while                          --
--                            RXF_n and RD_n are asserted low                                           --
--                            NOTE: OE_n must be low for one CC before asserting                        --
--                                  RD_n low.                                                           --
--               D7-0: Data pins. Bidirectional.                                                        --
----------------------------------------------------------------------------------------------------------
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

entity USB_Block is
    Port ( data1 : in STD_LOGIC_VECTOR (7 downto 0);
           data2 : in STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           FT_clk : in STD_LOGIC;
           FT_TX : in STD_LOGIC;
           FT_RX : in STD_LOGIC;
           FT_RD : out STD_LOGIC;
           FT_OE : out STD_LOGIC;
           FT_WR : out STD_LOGIC;
           FT_inout : inout STD_LOGIC_VECTOR (7 downto 0));
end USB_Block;

architecture Dataflow of USB_Block is
-- SIGNAL DECLARATIONS
-- NOTE: Signals for interfacing all components go here
    signal iqstream     : std_logic_vector (15 downto 0) := x"0000";
    signal write_clock  : std_logic := '0';
    signal read_clock   : std_logic := '0';
    signal write_enable : std_logic := '0';
    signal read_enable  : std_logic := '0';
    signal iqsample     : std_logic_vector (7 downto 0) := x"00";
    signal fullfifo     : std_logic := '0';
    signal emptyfifo    : std_logic := '1'; -- NOTE: This makes sense, no?

-- COMPONENT DELCARATIONS
-- Declare all components here, interleaver, FIFO, FIFO/USB Controller, etc.
    component interleaver 
        port ( 
                 clk      : in std_logic;                     -- Local FPGA clock
                 reset_n  : in std_logic;                     -- Reset signal, active low
                 data1_in : in std_logic_vector(7 downto 0);  -- Either I or Q sample TODO Determine which
                 data2_in : in std_logic_vector(7 downto 0);  -- Either I or Q sample TODO Determine which
                 data_out : out std_logic_vector(15 downto 0) -- Interleaved IQ sample
           );
    end component;

    component fifo_generator_0
        port (
                 wr_clk : in std_logic;                     -- from FIFO_USB_CONTROL
                 rd_clk : in std_logic;                     -- from FIFO_USB_CONTROL
                 din    : in std_logic_vector(15 downto 0); -- from interleaver
                 wr_en  : in std_logic;                     -- from FIFO_USB_CONTROL
                 rd_en  : in std_logic;                     -- from FIFO_USB_CONTROL
                 dout   : out std_logic_vector(7 downto 0); -- to FIFO_USB_CONTROL
                 full   : out std_logic;                    -- to FIFO_USB_CONTROL
                 empty  : out std_logic                     -- to FIFO_USB_CONTROL
             );
    end component;

    -- TODO: Reorganize the following here and within it's on source code
    component FIFO_USB_CONTROL
        port ( 
               FT_CLK   : in    std_logic; -- from GPIO -- 60Mhz? FT232H Clock 
               TXE      : in    std_logic; -- from GPIO -- Able to TX
               RXF      : in    std_logic; -- from GPIO -- Able to RX
               RD       : out   std_logic; -- to GPIO   -- Read
               OE       : out   std_logic; -- to GPIO   -- Output enable
               WR       : out   std_logic; -- to GPIO   -- Write
               FT_INOUT : inout std_logic_vector (7 downto 0); -- Bidirection FIFO data to/from GPIO
               data_in  : in    std_logic_vector (7 downto 0); -- from FIFO
               reset    : in    std_logic; -- active LOW
               rdclk    : out   std_logic; -- to FIFO
               rdreq    : out   std_logic; -- to FIFO read_en
               wrclk    : out   std_logic; -- to FIFO
               wrreq    : out   std_logic; -- to FIFO write_en
               wrclk_in : in    std_logic; -- local FPGA clock, from clock wiz
               rdempty  : in    std_logic; -- from FIFO
               wrfull   : in    std_logic  -- from FIFO
             );
    end component;

begin

    iqinterleave : interleaver 
    port map (
    clk => clk,
    reset_n  => reset_n,
    data1_in => data1,
    data2_in => data2,
    data_out => iqstream
    );


    FIFObuf : fifo_generator_0
    port map (
    wr_clk => write_clock, 
    rd_clk => read_clock, 
    din    => iqstream,  
    wr_en  => write_enable,
    rd_en  => read_enable,
    dout   => iqsample,  
    full   => fullfifo, 
    empty  => emptyfifo
             );
    
    controller : FIFO_USB_CONTROL
    port map (
    FT_CLK   => FT_clk,
    TXE      => FT_TX,
    RXF      => FT_RX,
    RD       => FT_RD,
    OE       => FT_OE,
    WR       => FT_WR,
    FT_INOUT => FT_inout,
    data_in  => iqsample,
    reset    => reset_n,
    rdclk    => read_clock,
    rdreq    => read_enable,
    wrclk    => write_clock,
    wrreq    => write_enable,
    wrclk_in => clk,
    rdempty  => emptyfifo,
    wrfull   => fullfifo
             );

end Dataflow;
