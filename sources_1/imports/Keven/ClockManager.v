`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2019 09:14:50 PM
// Design Name: 
// Module Name: ClockManager
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ClockManager(
    input sysclk,
    input reset,
    input [43:0] FreqData_in,
    input NewDataReady_in,
    output varclk,
    output NewDataReady_out
    );
    
    wire [43:0] FreqData_in_1;
    wire NewDataReady_in_1;
    wire varclk_1;
    wire NewDataReady_out_1;
    wire [31:0] Frequency_Manager_FreqData_out_1;
    wire [10:0] Frequency_Manager_FreqAddr_out_1;
    wire Frequency_Manager_DataReady_out_1;
    wire Frequency_Manager_AddrReady_out_1;
    wire [3:0] Frequency_Manager_strbEnable_out_1;
    wire Clk_Wiz_s_axi_awready_1;
    wire Clk_Wiz_s_axi_wready_1;
    wire Pull_Low;
    wire Pull_High;
    wire subclk_1;
    wire subclk_2;
    
    assign FreqData_in_1 = FreqData_in;
    assign NewDataReady_in_1 = NewDataReady_in;
    assign varclk_1 = varclk;
    assign NewDataReady_out_1 = NewDataReady_out;
    assign Pull_Low = 0;
    assign Pull_High = 1;
    
Frequency_Manager Frequency_Manager_1
    (.sysclk(subclk_1),
    .reset(reset),
    .FreqData_in(FreqData_in_1),
    .NewDataReady_in(NewDataReady_in_1),
    .DataValid_in(Clk_Wiz_s_axi_wready_1),
    .AddrValid_in(Clk_Wiz_s_axi_awready_1),
    .FreqData_out(Frequency_Manager_FreqData_out_1),
    .FreqAddr_out(Frequency_Manager_FreqAddr_out_1),
    .NewDataReady_out(NewDataReady_out_1),
    .DataReady_out(Frequency_Manager_DataReady_out_1),
    .AddrReady_out(Frequency_Manager_AddrReady_out_1),
    .strbEnable_out(Frequency_Manager_strbEnable_out_1));
    
clk_wiz_0 Clk_Wiz_1
    (.s_axi_aclk(subclk_1),
    .s_axi_aresetn(Pull_High),
    .s_axi_awaddr(Frequency_Manager_FreqAddr_out_1),
    .s_axi_awvalid(Frequency_Manager_AddrReady_out_1),
    .s_axi_awready(Clk_Wiz_s_axi_awready_1),
    .s_axi_wdata(Frequency_Manager_FreqData_out_1),
    .s_axi_wstrb(Frequency_Manager_strbEnable_out_1),
    .s_axi_wvalid(Frequency_Manager_DataReady_out_1),
    .s_axi_wready(Clk_Wiz_s_axi_wready_1),
    .s_axi_bresp(),
    .s_axi_bvalid(),
    .s_axi_bready(Pull_Low),
    .s_axi_araddr(Pull_Low),
    .s_axi_arvalid(Pull_Low),
    .s_axi_arready(),
    .s_axi_rdata(),
    .s_axi_rresp(),
    .s_axi_rvalid(),
    .s_axi_rready(Pull_Low),
    .clk_out1(varclk_1),
    .locked(),
    .clk_in1(subclk_2));
    
clk_wiz_1 Clk_Wiz_2
    (.clk_out1(subclk_1),
    .clk_out2(subclk_2),
    .clk_in1(sysclk));
endmodule