`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2018 03:54:52 PM
// Design Name: 
// Module Name: filter_even
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


module filter_even(
    input [7:0] data_in,
    input clk_var,
    input enable,
    input reset,
    output reg [7:0] data_out
    );
    
    reg [27:0] in_old_1;
    reg [27:0] in_old_2;
    reg [27:0] out_old_1;
    reg [27:0] out_old_2;
    reg [55:0] temp;
    parameter [27:0] B = 28'b00000000_00100011010101011010;

//initial begin
//    $display("B = %b", B);
//    in_old_1 = 28'b11111111_00000000000000000000;
//    in_old_2 = 28'b11111111_00000000000000000000;
//    out_old_1 = 28'b11111111_00000000000000000000;
//    out_old_2 = 28'b11111111_00000000000000000000;
//    temp = 56'b0000000000000000_0000000000000000000000000000000000000000;
//end

always @ (posedge clk_var) begin
    temp = ((B * out_old_2) + {8'b00000000, in_old_2, 20'b00000000000000000000} - (B * {data_in, 20'b00000000000000000000}));
    $display("TEST_ EVEN = %b", temp);
    if (reset) begin
        data_out <= 28'b0;
        in_old_1 <= 28'b0;
        in_old_2 <= 28'b0;
        out_old_1 <= 28'b0;
        out_old_2 <= 28'b0;
    end else begin
        if (enable) begin
            data_out <= temp [47:40];
            in_old_1 <= {data_in, 20'b00000000000000000000};
            in_old_2 <= in_old_1;
            out_old_1 <= temp [47:20];
            out_old_2 <= out_old_1;
        end else begin
            data_out <= data_out;
            in_old_1 <= in_old_1;
            in_old_2 <= in_old_2;
            out_old_1 <= out_old_1;
            out_old_2 <= out_old_2;
        end
    end
end 
endmodule
