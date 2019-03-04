# Software Source Directory

Source code for anything software related belongs here.
Please keep arrangement neat and logical for the sake of other people's sanity

When convenient or necessary, document this readme to explain the organization of this subdirectory

__Interacting with SDR-R via USB__

The SDR-R is implemented on the Digilent cmod-a7 FPGA dev. board. Communication with host computer
is accomplished via an FTDI FIFO interface, specifically the FT232H in FT245 Synchronous FIFO mode.
 This project particularly uses the UM232H-B, however similar results could easily be had by using 
 any sort of FT232H based solution. The FT2232H would also be a viable alternative.

 Note that interacting with the SDR-R from the host computer will involve utilizing the open-source 
 libftdi libraries. Installation instructions may be provided in the future.
