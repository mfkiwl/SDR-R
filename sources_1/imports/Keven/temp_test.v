`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2019 05:31:28 PM
// Design Name: 
// Module Name: temp_test
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


module temp_test(
    input sysclk,
    input btn0,
    input btn1,
    output pio26,
    output pio27,
    output pio28,
    output pio29,
    output pio30,
    output pio31
    );
    
    wire varclk_1;
    wire NewDataReady_1;
    wire FreqData_1;
    wire NewDataReady_out_1;
    wire sel_1;
    wire decounce_1;
    
    assign pio26 = varclk_1;
    assign pio27 = NewDataReady_1;
    assign pio28 = NewDataReady_out_1;
    assign pio29 = btn0;
    assign pio30 = sel_1;
    assign pio31 = debounce_1;
    
test_inputs test_inputs_1
    (.sysclk(sysclk),
    .btn0(btn0),
    .btn1(btn1),
    .FreqData(FreqData_1),
    .NewDataReady(NewDataReady_1),
    .sel(sel_1),
    .debounce(debounce_1));

ClockManager ClockManager_1
    (.sysclk(sysclk),
    .reset(btn1),
    .FreqData_in(FreqData_1),
    .NewDataReady_in(NewDataReady_1),
    .varclk(varclk_1),
    .NewDataReady_out(NewDataReady_out_1));
    
endmodule
