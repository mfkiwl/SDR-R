--FPGAtoUSB
--Paul Effingham
--3/4/19
--Purpose: Replace original USB_Block with a new component to interleave I and Q samples then send it to the FTDI chip. Updated State Machine
--Description:


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FPGAtoUSB is

          Port ( 
          data1 : in STD_LOGIC_VECTOR (7 downto 0);
          data2 : in STD_LOGIC_VECTOR (7 downto 0);
          clk : in STD_LOGIC;   --25 MHz
          reset_n : in STD_LOGIC;
          FT_clk : in STD_LOGIC;
          FT_TX : in STD_LOGIC;
          FT_RX : in STD_LOGIC;
          FT_RD : out STD_LOGIC;
          FT_OE : out STD_LOGIC;
          FT_WR : out STD_LOGIC;
          FT_inout : inout STD_LOGIC_VECTOR (7 downto 0);
          
          debug : out std_logic_vector( 10 downto 0);

          --Input/Output to keven
          CPUtoFPGA_read_clock : in std_logic;      --Keven gives us the clocking speed he can read the fifo from
          CPUtoFPGA_rd_en : in std_logic;            --Keven specifies when he is able to read
          CPUtoFPGA_dout  : out std_ulogic_vector(7 downto 0); --Output to keven to change the clocking overall
          CPUtoFPGA_empty : out std_logic --A signal keven will need to know when the buffer isnt full
          );
end FPGAtoUSB;
    
architecture Behavioral of FPGAtoUSB is

--Signal Declaration
-------------------------------------------------------------------------------
-- NOTE: Signals for interfacing all components go here
    signal iqstream     : std_logic_vector (15 downto 0) := x"0000";
    --signal FPGAtoCPU_write_clock  : std_logic; dont need
    --signal FPGAtoCPU_read_clock   : std_logic; dont need
    signal FPGAtoCPU_write_enable : std_logic;
    signal FPGAtoCPU_read_enable  : std_logic;
    signal iqsample     : std_ulogic_vector (7 downto 0) := x"00";
    signal FPGAtoCPU_fullfifo     : std_ulogic;
    signal FPGAtoCPU_emptyfifo    : std_ulogic; -- NOTE: This makes sense, no?
    
    
    signal unused_in_n  : std_ulogic := '1';
    signal unused_in    : std_ulogic := '0';
    signal unused_out_n : std_ulogic := '1';
    
    --Signals only for FTDI to the FPGA
    signal userbyte     : std_ulogic_vector (7 downto 0) := x"00";
    --signal CPUtoFPGA_write_clock  : std_logic; dont need
    signal CPUtoFPGA_write_enable : std_logic;
    signal CPUtoFPGA_fullfifo     : std_ulogic;
    --CPU to FPGA empty is an output signal of this chip
    --CPU to FPGA dout is an output signal of this chip
    --CPU to FPGA rd_clk is an input signal of this chip
    --CPU to FPGA rd_en is an input signal of this chip
    
--Interleave both I and Q to a 16 bit bus
component interleaver 
        port ( 
                 clk      : in std_logic;                      -- Local FPGA clock
                 reset_n  : in std_logic;                      -- Reset signal, active low
                 data1_in : in std_logic_vector(7 downto 0);   -- Either I or Q sample TODO Determine which
                 data2_in : in std_logic_vector(7 downto 0);   -- Either I or Q sample TODO Determine which
                 data_out : out std_logic_vector(15 downto 0));-- Interleaved IQ sample
end component;

--component inverter 
--  port (
--    invIn    : in  std_ulogic;
--    invOut   : out std_ulogic);
--end component;

    
component FPGAtoFTDI_fifo
        port (
                 wr_clk : in std_logic;                      -- from FIFO_USB_CONTROL
                 rd_clk : in std_logic;                      -- from FIFO_USB_CONTROL
                 din    : in std_logic_vector(15 downto 0);  -- from interleaver
                 wr_en  : in std_logic;                      -- from FIFO_USB_CONTROL
                 rd_en  : in std_logic;                      -- from FIFO_USB_CONTROL
                 dout   : out std_ulogic_vector(7 downto 0); -- to FIFO_USB_CONTROL
                 full   : out std_logic;                     -- to FIFO_USB_CONTROL
                 empty  : out std_logic);                    -- to FIFO_USB_CONTROL
end component;

component FTDItoFPGA_fifo
        port (
                 wr_clk : in std_logic;                      -- from FIFO_USB_CONTROL
                 rd_clk : in std_logic;                      -- from FIFO_USB_CONTROL
                 din    : in std_ulogic_vector(7 downto 0);  -- from interleaver
                 wr_en  : in std_logic;                      -- from FIFO_USB_CONTROL
                 rd_en  : in std_logic;                      -- from FIFO_USB_CONTROL
                 dout   : out std_ulogic_vector(7 downto 0); -- to FIFO_USB_CONTROL
                 full   : out std_logic;                     -- to FIFO_USB_CONTROL
                 empty  : out std_logic);                    -- to FIFO_USB_CONTROL
                 
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
                out_full         : in     std_ulogic;    
                
                --debug
                debug_out            : out std_logic_vector(10 downto 0));
end component;         

begin
  iqinterleave : interleaver 
  port map (
            clk => clk,             --CLK
            reset_n  => reset_n,    --Reset
            data1_in => data1,      --I coming in (1 byte)
            data2_in => data2,      --Q coming in (1 byte)
            data_out => iqstream);  --IQ leaving, 2 bytes

--wr_en is dependent on if the FIFO buffer is full.
 -- fullInv : inverter
  --port map(
    --    invIn => FPGAtoCPU_fullfifo,
    --    invOut => FPGAtoCPU_write_enable);

  fifo_FPGAtoFTDI : FPGAtoFTDI_fifo
  port map (
            wr_clk => clk,                    -- NEEDS TO BE 25 MHZ
            rd_clk => FT_clk,                 -- should be C5
            din    => iqstream,               -- Input data is the IQ bytes
            wr_en  => '1',--FPGAtoCPU_write_enable, -- Shall write when the fifo isnt full
            rd_en  => FPGAtoCPU_read_enable,  -- shall read when the State Machine in_read is high
            dout   => iqsample,               -- Outputs a byte to the SM (topmost byte of the fifo) 
            full   => FPGAtoCPU_fullfifo,     -- The fifo buffer is full, matters for this chips wr_en
            empty  => FPGAtoCPU_emptyfifo);   -- The fifo buffer is empty, send to SM in_empty
debug(10) <= FPGAtoCPU_emptyfifo;
--debug(11) <= FPGAtoCPU_fullfifo;
--FPGAtoCPU_write_enable <= (not FPGAtoCPU_fullfifo) or FPGAtoCPU_emptyfifo;
  fifo_FTDItoFPGA : FTDItoFPGA_fifo
  port map(
            wr_clk => FT_clk,                   -- Should be C5
            rd_clk => CPUtoFPGA_read_clock,     -- Input to this chip from Keven
            din =>    userbyte,                 -- Comes from the SM out_data output
            wr_en =>  CPUtoFPGA_write_enable,   -- Comes from the SM out_valid output
            rd_en =>  CPUtoFPGA_rd_en,          -- Input to this chip from Keven
            dout =>   CPUtoFPGA_dout,           -- Output to this chip to Keven
            full =>   CPUtoFPGA_fullfifo,       -- Needed by the SM for the out_full input
            empty =>  CPUtoFPGA_empty           -- Output to this chip to Keven
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
  siwu      => unused_out_n, -- Cbus4, output, unused
  reset_n   => unused_out_n, -- Cbus7? output, unused if indeed C7
  suspend_n => unused_in_n,  -- input, Doesn't exist on FT232H, but does on FT2232H
  
  debug_out => debug,
  

  -- Interface to the internal logic
  reset     => unused_in, -- input, active high
  
  -- FPGA -> FTDI
  in_data   => iqsample,    -- input, from FIFO
  in_empty  => FPGAtoCPU_emptyfifo,   -- input, from FIFO
  in_read   => FPGAtoCPU_read_enable, -- output, Assuming this read_en to FIFO
  
  -- FTDI -> FPGA
  out_data  => userbyte, -- output, to 2nd FIFO
  out_valid => CPUtoFPGA_write_enable,  -- output, Assuming this write_en to 2nd FIFO ( 2nd fifo is CPU to FPGA)
  out_full  => CPUtoFPGA_fullfifo          -- in, from 2nd FIFO
  );

end Behavioral;
