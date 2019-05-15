-- NOTE FROM CC: MAY NEED TO MAKE SOME CHANGES AS THIS WAS DESIGNED FOR AN ALTERA/INTEL FIFO
--               SHOULD BE SIMPLE ENOUGH THOUGH. AS FAR AS I CAN TELL, RD/WR_REQ SIGNALS ARE
--               JUST THE RD/WR_EN SIGNALS

-----------------------------------------------------------------------------
-- Title           : Title
-----------------------------------------------------------------------------
-- Author          : Daniel Pelikan
-- Date Created    : 20-07-2014
-----------------------------------------------------------------------------
-- Description     : Controls the interplay between FiFo and FT245
--							
--
-----------------------------------------------------------------------------
-- Copyright 2014. All rights reserved
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity FIFO_USB_CONTROL is

    -- CC NOTE: I hate how this isn't organized in vs out
	port 
	(
      FT_CLK    : in std_logic; -- from GPIO            -- 60 MHz FT232H clock
      TXE       : in std_logic; -- from GPIO            -- Can TX
      RXF       : in std_logic; -- from GPIO            -- Can RX
      RD        : out std_logic;  -- to GPIO            -- Read 
                                                        -- low to be able to read
      OE        : out std_logic;  -- to GPIO            -- Output enable, high to write to USB
      WR        : out std_logic;  -- to GPIO            -- FIFO Buffer Write Enable, low to write to usb
      FT_INOUT  : inout std_logic_vector(7 downto 0);   -- Bidirectional FIFO data
                                                        -- to/from GPIO
      data_in	:	in std_logic_vector(7 downto 0);    -- from FIFO
      reset		: 	in std_logic;	-- low for reset

      rdclk    : out std_logic;     -- to FIFO
      rdreq    : out std_logic;     -- to FIFO read_en
      wrclk    : out std_logic;     -- to FIFO
      wrreq    : out std_logic;     -- to FIFO write_en
      wrclk_in : in std_logic;      -- local FPGA clock, from clock wizard
      rdempty  : in std_logic;      -- from FIFO
      wrfull   : in std_logic);     -- from FIFO

end entity;

architecture rtl of FIFO_USB_CONTROL is

signal read_data :  std_logic; -- put high if you want to read data
signal data_out	 :	std_logic_vector(7 downto 0);
signal data_av	 :	std_logic;	-- data is available to be written to USB
signal WR_int    :  std_logic;

component ft245_control 
	port 
	(
      FT_CLK   : in std_logic;                   -- 60 MHz FT232H clock
      TXE      : in std_logic;                   -- Can TX
      RXF      : in std_logic;                   -- Can RX
      RD       : out std_logic;                  -- Read -- low to be able to read
      OE       : out std_logic;                  -- Output enable, high to write to USB
      WR       : out std_logic;                  -- FIFO Buffer Write Enable, low to write to usb
      FT_INOUT      : inout std_logic_vector(7 downto 0);   -- Bidirectional FIFO data
		
	data_av	:	in std_logic;	-- data is available to be written to USB
	data_in	:	in std_logic_vector(7 downto 0);
	data_out	:	out std_logic_vector(7 downto 0);
	reset		: 	in std_logic;	-- low for reset
	read_data : in std_logic -- put high if you want to read data
		
	);
end component;

begin
-- CC NOTE: This is the State Machine
ft245_cnt : ft245_control 
   port map(
      FT_CLK     => FT_CLK,
      TXE        => TXE,
      RXF        => RXF,
      RD         => RD,
      OE         => OE,
      WR         => WR_int,
      FT_INOUT   => FT_INOUT,
      data_av    => data_av,
      data_in    => data_in,
      data_out   => data_out,
      reset      => reset,
      read_data  => read_data);


	--route some signal through
	read_data<='0';
	wrclk<=wrclk_in;
	rdclk<=FT_CLK;
	
	wrreq<='1' WHEN wrfull = '0' ELSE '0';
	rdreq<='1' when (WR_int = '0' and rdempty = '0') else '0';
	data_av<= '1' when rdempty = '0' else '0';
	
	WR<=WR_int;
	
end rtl;


