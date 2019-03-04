__Top Module__

All component modules will be interfaced in *THIS* module. Keep it simple, and tidy.

What's expected:

* Module for sampling ADC
  - 8 bit samples in from outside
  - 8 bit samples out to next block
* Rader Block
  - 8 bit samples from ADC
  - 8 bit I, and 8 bit Q samples out to next block
* Interleaver (currently contained in USB Block)
  - Takes 8 bit I and 8 bit Q and interleaves
  - 16 bit interleaved I/Q sample (upper 8 is I, lower 8 is Q)
* USB Block
  - Very delicate mess. Takes I/Q and stuffs in FIFO
  - FSM controls to/fro between FPGA and FTDI device
