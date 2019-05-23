# Software Source Directory

Source code for anything software related belongs here.
Please keep arrangement neat and logical for the sake of other people's sanity

When convenient or necessary, document this readme to explain the organization of this subdirectory

## About

__Interacting with SDR-R via USB__

The SDR-R is implemented on the Digilent cmod-a7 FPGA dev. board. Communication with host computer
is accomplished via an FTDI FIFO interface, specifically the FT232H in FT245 Synchronous FIFO mode.
 This project particularly uses the UM232H-B, however similar results could easily be had by using 
 any sort of FT232H based solution. The FT2232H would also be a viable alternative.

 Note that interacting with the SDR-R from the host computer will involve utilizing the open-source 
 libftdi libraries. Installation instructions may be provided in the future.
 Otherwise... google is a valuable tool.

## Directories

__demo-code__

The code contained here is effectively what was used for our final demo to 
Dr. LaBerge.

__maindriver__

The code contained here is what we consider our final driver code for this
project. Within this directory is the gnuradio flowgraph (.grc file) that
can be modified with added functionality by opening it in gnuradio-companion.
* compile.sh
  - idiot proof script for compiling the main driver code.
* flowgraph.grc
  - can be modified for added functionality by opening in gnuradio-companion
* INSTRUCTIONS.md
  - contains compilation instructions
* sdrdriver.c
  - main driver code. Requires libftdi, libusb, pthreads, among other things. 
  - Responsible for coordinating data transfer to/from the FTDI chip.
  - Creates a named pipe in /tmp/ during operation for holding IQ samples, this named pipe is removed when program closes.
  - **NOTE** There is a known race condition where the cleanup thread fails to terminate because the write operation which fills the named pipe is not successfully interrupted. Fortunately, if this occurs a simple Ctrl+C will send a second interrupt that will allow the program to close gracefully.
* top_block.py
  - This python script makes up the compiled gnuradio flowgraph. It is called as a child thread by the main driver.

