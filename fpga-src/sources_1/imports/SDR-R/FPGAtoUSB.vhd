--FPGAtoUSB
--Paul Effingham
--Ben Mogren
--3/4/19
--Purpose: Replace original USB_Block with a new component to interleave I and Q samples then send it to the FTDI chip. Updated State Machine
--Description:

--TODO: Fix reset for frequency_set
--      Add constraints file
--      Verify Clock connections
--      Trim excess connections

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FPGAtoUSB is

          Port ( 
          data1 : in STD_LOGIC_VECTOR (15 downto 0);
          clk : in STD_LOGIC;   --25 MHz
          reset : in STD_LOGIC;
          FT_clk : in STD_LOGIC;
          FT_TX : in STD_LOGIC;
          FT_RX : in STD_LOGIC;
          fifo_wr_en : in std_logic;
          FT_RD : out STD_LOGIC;
          FT_OE : out STD_LOGIC;
          FT_WR : out STD_LOGIC;
          FT_inout : inout STD_LOGIC_VECTOR (7 downto 0);
          
          fifo_rst    : in std_logic;
          
          --Input/Output to keven
          div  : out std_logic_vector(9 downto 0); --Output to keven to change the clocking overall
          div_frac : out std_logic_vector(21 downto 0)
          );
end FPGAtoUSB;
    
architecture Behavioral of FPGAtoUSB is

--Signal Declaration
-------------------------------------------------------------------------------
-- NOTE: Signals for interfacing all components go here
    signal FPGAtoCPU_write_enable : std_logic;
    signal FPGAtoCPU_read_enable  : std_logic;
    signal iqsample     : std_ulogic_vector (7 downto 0);-- := x"00";
    signal FPGAtoCPU_fullfifo     : std_ulogic;
    signal FPGAtoCPU_emptyfifo    : std_ulogic; -- NOTE: This makes sense, no?
    
    --Signals only for FTDI to the FPGA
    signal userbyte     : std_ulogic_vector (7 downto 0);-- := x"00";
    --signal CPUtoFPGA_write_clock  : std_logic; dont need
    signal CPUtoFPGA_write_enable : std_logic;
    signal CPUtoFPGA_fullfifo     : std_ulogic;
    --CPU to FPGA empty is an output signal of this chip
    --CPU to FPGA dout is an output signal of this chip
    --CPU to FPGA rd_clk is an input signal of this chip
    --CPU to FPGA rd_en is an input signal of this chip

component FPGAtoFTDI_fifo
        PORT (
            rst : IN STD_LOGIC;
            wr_clk : IN STD_LOGIC;
            rd_clk : IN STD_LOGIC;
            din : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            wr_en : IN STD_LOGIC;
            rd_en : IN STD_LOGIC;
            dout : OUT STD_ULOGIC_VECTOR(7 DOWNTO 0);
            full : OUT STD_LOGIC;
            empty : OUT STD_LOGIC
          );
end component;

component div_fifo
        port (
               clk_FPGA : in STD_LOGIC;
               clk_FTDI : in STD_LOGIC;
               rd_en    : in STD_LOGIC;
               din      : in STD_ULOGIC_VECTOR (7 downto 0);
               reset    : in STD_LOGIC;
               div      : out STD_LOGIC_VECTOR (9 downto 0);
               div_frac : out STD_LOGIC_VECTOR (21 downto 0));
end component;

component ft245_sync_if
        port (
                -- Interface to the ftdi chip
                adbus            : inout    std_logic_vector(7 downto 0);
                rxf_n            : in    std_ulogic;
                txe_n            : in    std_ulogic;
                rd_n             : out    std_ulogic := '1';
                wr_n             : out    std_ulogic := '1';
                clock            : in    std_ulogic;
                oe_n             : out    std_ulogic := '1';
                siwu             : out    std_ulogic;
                reset_n          : out    std_ulogic;
                suspend_n        : in    std_ulogic;
                
                -- Interface to the internal logic
                reset            : in    std_ulogic;
    
                -- FPGA -> FTDI
                in_data          : in    std_ulogic_vector(7 downto 0);
                in_empty         : in    std_ulogic;
                in_read          : out    std_ulogic;
    
                -- FTDI -> FPGA
                out_data         : out    std_ulogic_vector(7 downto 0);
                out_valid        : out    std_ulogic;
                out_full         : in     std_ulogic);  
end component;         

--signal fake_debug : std_logic_vector(10 downto 0);
begin

  fifo_FPGAtoFTDI : FPGAtoFTDI_fifo
  port map (
            rst => fifo_rst,
            wr_clk => clk,                    -- 100MHz
            rd_clk => FT_clk,                 -- should be C5
            din    => data1,               -- Input data is the IQ bytes
            wr_en  => fifo_wr_en,           --FPGAtoCPU_write_enable, -- Shall trigger every 4th input from rader
            rd_en  => FPGAtoCPU_read_enable,  -- shall read when the State Machine in_read is high
            dout   => iqsample,               -- Outputs a byte to the SM (topmost byte of the fifo) 
            full   => FPGAtoCPU_fullfifo,     -- The fifo buffer is full, matters for this chips wr_en
            empty  => FPGAtoCPU_emptyfifo   -- The fifo buffer is empty, send to SM in_empty
        );
        
    frequency_set : div_fifo
    port map (
            clk_FPGA=> clk,
            clk_FTDI=> FT_clk,
            rd_en   => CPUtoFPGA_write_enable,
            din     => userbyte,
            reset   => fifo_rst,
            div     => div,
            div_frac=> div_frac
        );
           
  FTcontroller : ft245_sync_if
  port map (
          -- Interface to the ftdi chip
          adbus     => FT_inout,     -- Dbus[7:0], inout
          rxf_n     => FT_RX,        -- Cbus0, input
          txe_n     => FT_TX,        -- Cbus1, input
          rd_n      => FT_RD,        -- Cbus2, output
          wr_n      => FT_WR,        -- Cbus3, output
          clock     => FT_clk,       -- Cbus5, input
          oe_n      => FT_OE,        -- Cbus6, output
          siwu      => open, -- Cbus4, output, unused
          reset_n   => open, -- Cbus7? output, unused if indeed C7
          suspend_n => '1',  -- input, Doesn't exist on FT232H, but does on FT2232H
          
          -- Interface to the internal logic
          reset     => reset, -- input, active high
          
          -- FPGA -> FTDI
          in_data   => iqsample,    -- input, from FIFO
          in_empty  => FPGAtoCPU_emptyfifo,   -- input, from FIFO
          in_read   => FPGAtoCPU_read_enable, -- output, Assuming this read_en to FIFO
          
          -- FTDI -> FPGA
          out_data  => userbyte, -- output, to 2nd FIFO
          out_valid => CPUtoFPGA_write_enable,  -- output, Assuming this write_en to 2nd FIFO ( 2nd fifo is CPU to FPGA)
          out_full  => '0' --CPUtoFPGA_fullfifo          -- in, from 2nd FIFO Always accept new data
          );

end Behavioral;
