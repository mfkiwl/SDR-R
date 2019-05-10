`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2019 11:00:56 PM
// Design Name: 
// Module Name: test_inputs
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


module test_inputs(
    input sysclk,
    input btn0,
    input btn1,
    output reg [43:0] FreqData,
    output reg NewDataReady,
    output reg sel,
    output reg debounce
    );
    
    reg [43:0] FreqData_temp;
    reg NewDataReady_temp;
    reg sel_temp;
    reg debounce_temp;
    reg init;
    
//initial begin
//    FreqData <= 0;
//    FreqData_temp <= 0;
//    NewDataReady <= 0;
//    NewDataReady_temp <= 0;
//    sel <= 0;
//    debounce <= 0;
//    sel_temp <= 0;
//    debounce_temp <= 0;
//end

always @ (posedge sysclk) begin
    FreqData <= FreqData_temp;
    NewDataReady <= NewDataReady_temp;
    sel <= sel_temp;
    debounce <= debounce_temp;
end 

always @ (*) begin
    case (init)
        1'b1:begin
            init <= 1;
        end
        default:begin
           FreqData_temp = 0;
           NewDataReady_temp = 0;
           sel_temp = 0;
           debounce_temp = 0;
           init = 1;
        end
    endcase                
    
    if (btn1 == 1) begin
        FreqData_temp = 0;
        NewDataReady_temp = 0;
        sel_temp = 0;
        debounce_temp = 0;
    end else begin
        FreqData_temp = FreqData;
        NewDataReady_temp = NewDataReady;
        sel_temp = sel;
        debounce_temp = debounce;
    end
    
    if (NewDataReady == 1) begin
        NewDataReady_temp = 0;
    end
    
    if (btn0 && !sel && !debounce) begin
        FreqData_temp[43:0] = 44'b11100001001011101010101010000110001100000001; // 20 MHz
        NewDataReady_temp = 1;
        sel_temp = 1;
        debounce_temp = 1;
    end else if (btn0 && sel && !debounce) begin
        FreqData_temp[43:0] = 44'b11001100010011101110101101110110001100000001; // 6.4 MHz
        NewDataReady_temp = 1;
        sel_temp = 0;
        debounce_temp = 1;
    end else if (!btn0 && debounce) begin
        debounce_temp = 0;
    end 
    
end
endmodule
