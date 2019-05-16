// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2.2 (win64) Build 2348494 Mon Oct  1 18:25:44 MDT 2018
// Date        : Wed May 15 18:44:14 2019
// Host        : DESKTOP-4O36AQC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/Guy/Desktop/UMBC/2019_Spring/451/SDRR_FINAL/SDRR_FINAL.srcs/sources_1/ip/c_counter_binary_0/c_counter_binary_0_sim_netlist.v
// Design      : c_counter_binary_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a15tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c_counter_binary_0,c_counter_binary_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_counter_binary_v12_0_12,Vivado 2018.2.2" *) 
(* NotValidForBitStream *)
module c_counter_binary_0
   (CLK,
    SCLR,
    Q);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF q_intf:thresh0_intf:l_intf:load_intf:up_intf:sinit_intf:sset_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 10000000, PHASE 0.000" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 q_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME q_intf, LAYERED_METADATA undef" *) output [9:0]Q;

  wire CLK;
  wire [9:0]Q;
  wire SCLR;
  wire NLW_U0_THRESH0_UNCONNECTED;

  (* C_AINIT_VAL = "0" *) 
  (* C_CE_OVERRIDES_SYNC = "0" *) 
  (* C_COUNT_BY = "1" *) 
  (* C_COUNT_MODE = "0" *) 
  (* C_COUNT_TO = "1" *) 
  (* C_FB_LATENCY = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_LOAD = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_HAS_THRESH0 = "0" *) 
  (* C_IMPLEMENTATION = "1" *) 
  (* C_LATENCY = "1" *) 
  (* C_LOAD_LOW = "0" *) 
  (* C_RESTRICT_COUNT = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_THRESH0_VALUE = "1" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_WIDTH = "10" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  c_counter_binary_0_c_counter_binary_v12_0_12 U0
       (.CE(1'b1),
        .CLK(CLK),
        .L({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .LOAD(1'b0),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0),
        .THRESH0(NLW_U0_THRESH0_UNCONNECTED),
        .UP(1'b1));
endmodule

(* C_AINIT_VAL = "0" *) (* C_CE_OVERRIDES_SYNC = "0" *) (* C_COUNT_BY = "1" *) 
(* C_COUNT_MODE = "0" *) (* C_COUNT_TO = "1" *) (* C_FB_LATENCY = "0" *) 
(* C_HAS_CE = "0" *) (* C_HAS_LOAD = "0" *) (* C_HAS_SCLR = "1" *) 
(* C_HAS_SINIT = "0" *) (* C_HAS_SSET = "0" *) (* C_HAS_THRESH0 = "0" *) 
(* C_IMPLEMENTATION = "1" *) (* C_LATENCY = "1" *) (* C_LOAD_LOW = "0" *) 
(* C_RESTRICT_COUNT = "0" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_THRESH0_VALUE = "1" *) (* C_VERBOSITY = "0" *) (* C_WIDTH = "10" *) 
(* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_counter_binary_v12_0_12" *) (* downgradeipidentifiedwarnings = "yes" *) 
module c_counter_binary_0_c_counter_binary_v12_0_12
   (CLK,
    CE,
    SCLR,
    SSET,
    SINIT,
    UP,
    LOAD,
    L,
    THRESH0,
    Q);
  input CLK;
  input CE;
  input SCLR;
  input SSET;
  input SINIT;
  input UP;
  input LOAD;
  input [9:0]L;
  output THRESH0;
  output [9:0]Q;

  wire \<const1> ;
  wire CLK;
  wire [9:0]L;
  wire [9:0]Q;
  wire SCLR;
  wire NLW_i_synth_THRESH0_UNCONNECTED;

  assign THRESH0 = \<const1> ;
  VCC VCC
       (.P(\<const1> ));
  (* C_AINIT_VAL = "0" *) 
  (* C_CE_OVERRIDES_SYNC = "0" *) 
  (* C_COUNT_BY = "1" *) 
  (* C_COUNT_MODE = "0" *) 
  (* C_COUNT_TO = "1" *) 
  (* C_FB_LATENCY = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_LOAD = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_HAS_THRESH0 = "0" *) 
  (* C_IMPLEMENTATION = "1" *) 
  (* C_LATENCY = "1" *) 
  (* C_LOAD_LOW = "0" *) 
  (* C_RESTRICT_COUNT = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_THRESH0_VALUE = "1" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_WIDTH = "10" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  c_counter_binary_0_c_counter_binary_v12_0_12_viv i_synth
       (.CE(1'b0),
        .CLK(CLK),
        .L(L),
        .LOAD(1'b0),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0),
        .THRESH0(NLW_i_synth_THRESH0_UNCONNECTED),
        .UP(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
kfi029mOwVaAexw2bRh3FaYGJRTc5bG/7m5UbBrHjD+cYKYlNVTn+xX1sqkCm+iSza4kZ+TkPquh
v/Bl3NP8IQ==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
JxCFWcdXC3xLmRSmBA3FzGUlrmxUZneu/utMrbWHF36ASvctamIyzdarXyNgv0aZPklDBnhFgNu+
rdUqubRvo+ChN8q464n/cn/OU8M9vhhlwPdWZuqfiDinHD0UZUTfUoBcHYK1TxMor2VStyPA4AT5
yZZlFdfP/MAFfHFkTKY=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
1yWdSHPSFnMeKQJoCTsGuiLL0ZHvrx1TrwVn0GWHe6Acr1Dx0P7P8ZYIxWtkfF1YuxD50E3pCXXP
7QdnFTeGdJSUHyC7340PMORTAhBZoHhmb1fKB7K8GCXnsL2BM5oQqDrLA2DfJJ2U1gWog/H7QLp5
23bfkZacfT7XCkhb4b/bYUUxbA88Bk9rpZF/eDHEYhhgxbpyUW5JuOkws7SVQwT2ldD6g3rnjgix
XGErVwYQhLYKRraQj1N02cdafgj94EqbnxC3TnoW9TLvKxHS3/8wGdcpMngZ7fY6LuDAxlNazfRI
CO20GeeomnBj4pBNxWG9oWIUXTZdqCsb62Y5Nw==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
g7hlFmGTS+XVOdK+WtfQGihndYfR5S97YIvDLXzeoj/KHE8qyLpZqQ7at9cNHuOHC+xVk4OCpmjx
HZTFiDMP83uOCtl/lM5jOKsvEwC05dPzn2c6D3KUVvFGx7P00w40S43lOeC6rWCkMF2mLxI+9z2n
26CjxvSDukMD4/zqgbl2EkTKMuQ2ck/INBmCs1MHkkQjQbUhBiIlcrbVxiQGl3jOp66u17H8VKDz
dpRHj+MgrB/q7qVU+71D2TJjseYxT7oWGUJeYjvGK6aH11dpVelnEpWcWLlvPbogWRHar1oaSZPD
hjDPwujxH6eLiDIPzMtcO3Aud4nhKF1DRH021Q==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qDVS8yp0Hz/d9umzgDI4Qy4tfjNqsAx55hcL0bayLQwhE0tUYxkdob1ZpMAQjZUMOG+33AUE7bcv
EmEgmNzSFvgtePKWmartlwQV8c4AVZLs1m+ZzKHDdke4zWmAYj2OD32a3IfANsmnZ5iM8i+n0iK8
RgC94/l9aM08szmMx5rprkKlS+0gty7OBKWhkPHXsfcyo+DX2Bfscrp9wdC/wA6IVm/DcFO7bNlu
zX6F3GZ0r3b7q8M4IqtCUV0qkvl75pvGiGQjH2jWAZHjDoo+BQe6vqOmyiYDfTWpWY+AphRGxkB9
tKiNbKOOr0iABX9g/QQhnwmmMp896DCuXISbtA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
FKcUrAaKeh7vQMZ5PAkg8M2YlwpOs68g8WGncL2egAQF3KwczRSEzhYOmfvGUXBHW3mh2pquNEb2
OooUhLgw8alMYDIvNIwGRpVKO7l64Y+JA9que0oKXpoeW6ElFdIqEcD2dOE5BzDNqAIzOPDuXN9M
ngjt5qGrMHaw5yTYMfQ=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
URYhWe83nVILty6DlJMXGIlVnsNR+u6saIMUTTGmEX44dK8vZ6MGokTk0vsAoq+SxuPxmwI/y3/D
VfBFq6zKSSwJYV8gi80EPec0zA18G+GNqag0J8wB931PwddtFMYcdKT9gjIM9iPUsyZpkPHZ4BaM
SsBY71714eyb4JbLYTB6brsK81Xf1lAsGueALMp4TfGhhJX+dYFpexZPyXlq8rYRFZcUCN/SDO2A
R7AVZHQ1OQ988E2wTPfkwkOkaMjae5jh2nFh1llipaEYmhWxIY5Pl+hzADlELU5DtAh7Q6xUbL/2
aByFdbrnDGm3vuDP9q62FRO7aUagiRBVt6fXPA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
NcvhnlM6SJF9a3c0ITFidXLoJoB37BNuzBzRuH0byeljlP0FljU3VSNPVHJAd009s9GKaYhF58u6
Lh0jD2zbg7K4MZYK4db1QHawROq+NIxtjM7nV+O9bYuy6favHZjg88nAv4MVRrZdOxesvP6Y8K4u
hDdaQHn3tm1ZXpfpQoGnWw5jNGRXZwaIWt1oF6s1EvZEJanpi9sXMXCtL8KP7zEBPDd++raSZXPH
uA1zP+xe4ElW72ZnkQl6cOaHHRQxbOSn6XJW9L0G7qXxj8cMAJ5RVJry0HbJ6i4m8x2D2sWloz/J
T8DNVBu3W9m+/S6TG8oIPdMs6VT3kuMhdB5RVg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LFKIrkY7boUrLyBSUIsn4jR6WFWzLd+Q+Q6qh/Vzzr00zrqS6+7xuFL4UnR5mST3ftO+n4jAqLXh
dn4V5viZNE7phP61ojN5GciObj1kceenzzCBAHHr7nR0HTu3k7i2sbYf8FYUQJ43/qliZDWn4wvS
A8oV8eG+iSeJdOJp+EZW1sc6djQWAMxR7efYr+1X1aEK+QPe5klrXJNmr48RMRLQAha2hTxxSp/E
BTvbtb3m0fqT+FQv6pcDkH4o0PLm76Al5+rZYKjaQnITRVP7/Wd77zXnwvlT68y2kzptC1ajTy/X
9/eP3EPVOusL2LS4bfLlcfhtnp4q2WrkTvPkKQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 11696)
`pragma protect data_block
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
12cv4tUYp8L7ap0=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
