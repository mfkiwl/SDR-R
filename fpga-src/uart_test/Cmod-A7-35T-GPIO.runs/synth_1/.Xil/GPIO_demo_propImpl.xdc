set_property SRC_FILE_INFO {cfile:d:/Github/releases/Cmod-A7/Cmod-A7-35T-GPIO/src/ip/clk_wiz_0/clk_wiz_0.xdc rfile:../../../../src/ip/clk_wiz_0/clk_wiz_0.xdc id:1 order:EARLY scoped_inst:inst_clk/inst} [current_design]
set_property SRC_FILE_INFO {cfile:D:/Github/releases/Cmod-A7/Cmod-A7-35T-GPIO/src/constraints/CmodA7_Master.xdc rfile:../../../../src/constraints/CmodA7_Master.xdc id:2} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.83333
set_property src_info {type:XDC file:2 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN L17   IOSTANDARD LVCMOS33 } [get_ports { CLK }]; #IO_L12P_T1_MRCC_14 Sch=gclk
set_property src_info {type:XDC file:2 line:12 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A17   IOSTANDARD LVCMOS33 } [get_ports { LED[0] }]; #IO_L12N_T1_MRCC_16 Sch=led[1]
set_property src_info {type:XDC file:2 line:13 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS33 } [get_ports { LED[1] }]; #IO_L13P_T2_MRCC_16 Sch=led[2]
set_property src_info {type:XDC file:2 line:15 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33 } [get_ports { RGB0_Red }]; #IO_L14N_T2_SRCC_16 Sch=led0_b
set_property src_info {type:XDC file:2 line:16 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33 } [get_ports { RGB0_Green }]; #IO_L13N_T2_MRCC_16 Sch=led0_g
set_property src_info {type:XDC file:2 line:17 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { RGB0_Blue }]; #IO_L14P_T2_SRCC_16 Sch=led0_r
set_property src_info {type:XDC file:2 line:21 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { BTN[0] }]; #IO_L19N_T3_VREF_16 Sch=btn[0]
set_property src_info {type:XDC file:2 line:22 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { BTN[1] }]; #IO_L19P_T3_16 Sch=btn[1]
set_property src_info {type:XDC file:2 line:93 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { UART_TXD }]; #IO_L7N_T1_D10_14 Sch=uart_rxd_out
