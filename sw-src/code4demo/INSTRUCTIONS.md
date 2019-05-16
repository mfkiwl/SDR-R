# Introduction

The code contained here is intended for the Final Demo.

## Files

* flowgraph.grc
  - This may be edited via gnuradio-companion. When compiled in gnuradio-companion, it will generate top_block.py
* sdrdriver.c
  - This is **the** driver code for this demo.
* top_block.py
  - This is the gnuradio flowgraph that is invoked by sdrdriver

## Compilation Instructions

```bash
gcc -Wall sdrdriver.c -lftdi1 -pthread -o runme.out
```
