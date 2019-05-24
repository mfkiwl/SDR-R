# SDR-R
Software Defined Radio Receiver(SDR-R) for UMBC Computer Engineering Capstone FA18-SP19

The purpose of this repository will be for tracking of source code changes/additions and team collaboration for the development of this SDR-R. This will facilitate in project organization and documentation.

__Note__: [The home for this repository can be found here](https://github.com/carrera1/SDR-R)

## Directories

__fpga-src/__

Source code for any/all HDL written for the FPGA.

__hw__

Directory for all files related to hardware

__sw-src/__

Source code for any/all C/C++, Matlab/Simulink, or Python code generated.

__vm-info/__

Relevant documentation pertaining to the software development environment is kept here (i.e. list of needed packages). 
This directory also includes an important readme file for setting up important dependencies on your machine. The code 
provided in **sw-src** should function on unix/linux style machines (to include macOS), as long as the relevant dependencies 
are available (mainly pthreads, libftdi, and libusb).

## Set up and Installation

__FPGA__

For any future capstone groups looking back on this, we apologize that the **fpga-src** directory is one of the less organized 
of the bunch. Of the blocks utilized, all but the Xilinx IP cores are here in this repository. These IP cores include a 
clock generator (which should be simple to set up) and a FIFO for interfacing the Rader ("link") block with the FSM 
handling the interfacing with the FTDI chip. The FPGA->FTDI FIFO should have a write width of 16 and a read width of 8. 
The FTDI->FPGA FIFO is written by use for handling the messages sent from the host computer to the FPGA. It is **not** meant 
for interfacing with the Rader block.

__Software__

Instructions for setting up your development environment can be found in **vm-info**. Please, follow the instructions there 
for setting up many of the minor dependencies needed for this project before continuing here.

This project has 2 major dependencies (each with their own sub-dependencies) that are critical for functionality:

* GNU Radio
  - Instructions for setting up found in **vm-info** directory
* libftdi
  - Open source library for writing code the interact with the FT232H bridge we're utilizing
  - Requires **libusb 1.0**, please install this on your system prior to installing libftdi
  - Requires **libconfuse**, please install this on your system prior to installing libftdi


### Installing libftdi

```bash
git://developer.intra2net.com/libftdi
cd libftdi
# READ THE READMEs IN YOUR FAVORITE TEXT EDITOR
```

The libftdi developers included *verbose* instructions within the repository you just cloned. Please read them thoroughly. 
They also include numerous examples demonstrating the functionality of the library, where this project drew heavily from the **stream-test.c**.

The libftdi developers also have their documentation available online which you may find necessary to understand how each 
function works and what their return values may be. [To save you time, you may find it here!](https://www.intra2net.com/en/developer/libftdi/documentation/group__libftdi.html)

Once both GNU Radio and libftdi are installed, software side set up is done. If the FPGA is properly set up, then you're good 
to compile and run the code found in **sw-src**.

## Acknowledgements

This project wouldn't be what it is without the inspiration drawn from the following:
* [This blog post](https://digibird1.wordpress.com/adc-readout-and-usb2-0-data-transfer-with-an-fpga/) for inspiring us to try out an FTDI chip instead of terrible terrible UART.
* [This github repo](https://github.com/RandomReaper/pim-vhdl) for providing an open source FSM for interfacing with the FT232H. Many thanks to [Mssr. Marc Pignat](https://github.com/RandomReaper)!.
