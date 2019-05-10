`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2019 03:02:50 PM
// Design Name: 
// Module Name: Frequency_Manager
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


module Frequency_Manager(
    input sysclk,                       // clk
    input reset,                        // reset
    input [43:0] FreqData_in,           // data from FSM
    input NewDataReady_in,              // handshake from FSM
    input DataValid_in,                 // handshake with clk wiz
    input AddrValid_in,                 // handshake with clk wiz
    output reg [31:0] FreqData_out,     // new freq data for clk wiz
    output reg [10:0] FreqAddr_out,     // addr for setting new freq data
    output reg NewDataReady_out,        // handshake from FSM
    output reg DataReady_out,           // handshake with clk wiz
    output reg AddrReady_out,           // handshake with clk wiz
    output reg [3:0] strbEnable_out     // data enable of clk wiz
    );  

    // add variables here
    reg [31:0] FreqData, Reg2Data;
    reg [10:0] FreqAddr;
    reg [3:0] strbEnable;
    reg NewDataReady, DataReady, AddrReady;
    reg [2:0] curr_state, next_state;
        
//initial begin
//    curr_state <= 0;
//    next_state <= 0;
//    FreqData <= 0;
//    FreqAddr <= 0;
//    NewDataReady <= 1;
//    DataReady <= 0;
//    AddrReady <= 0;
//    strbEnable <= 3'b111;
//    FreqData_out <= 0;
//    FreqAddr_out <= 0;
//    NewDataReady_out <= 1;
//    DataReady_out <= 0;
//    AddrReady_out <= 0;
//    strbEnable_out <= 3'b111;
//end

always @ (posedge sysclk) begin
    curr_state <= next_state;
    FreqData_out <= FreqData;
    FreqAddr_out <= FreqAddr;
    NewDataReady_out <= NewDataReady;
    DataReady_out <= DataReady;
    AddrReady_out <= AddrReady;
    strbEnable_out <= strbEnable;
end

always @ (*) begin
    case (curr_state)
        3'b000:begin
            if (NewDataReady_in) begin
                Reg2Data[17:0] = FreqData_in[43:26];
                FreqData[25:0] = FreqData_in[25:0];
                FreqAddr[10:0] = 11'b01000000000;      // 0 + offset, not sure what baseaddr is supposed to be
                NewDataReady = 0;
                DataReady = DataReady_out;
                AddrReady = AddrReady_out;
                strbEnable = 3'b111;
                next_state = 3'b001;
            end else if (reset == 1) begin
                FreqData = 0;
                FreqAddr = 0;
                NewDataReady = 1;
                DataReady = 0;
                AddrReady = 0;
                strbEnable = 3'b111;
                next_state = 3'b000;
            end else begin
                FreqData = FreqData_out;
                FreqAddr = FreqAddr_out;
                NewDataReady = NewDataReady_out;
                DataReady = DataReady_out;
                AddrReady = AddrReady_out;
                strbEnable = 3'b111;
                next_state = 3'b000;
            end
        end
        3'b001:begin
            if (DataValid_in && AddrValid_in) begin
                FreqData = FreqData_out;
                FreqAddr = FreqAddr_out;
                NewDataReady = NewDataReady_out;
                DataReady = 1;
                AddrReady = 1;
                strbEnable = 3'b111;
                next_state = 3'b010;
            end else if (reset == 1) begin
                FreqData = 0;
                FreqAddr = 0;
                NewDataReady = 1;
                DataReady = 0;
                AddrReady = 0;
                strbEnable = 3'b111;
                next_state = 3'b000;
            end else begin
                FreqData = FreqData_out;
                FreqAddr = FreqAddr_out;
                NewDataReady = NewDataReady_out;
                DataReady = DataReady_out;
                AddrReady = AddrReady_out;
                strbEnable = 3'b111;
                next_state = 3'b001;
            end
        end
        3'b010:begin
            if (!DataValid_in && !AddrValid_in) begin
                FreqData[25:18] = 8'b00000000;
                FreqData[17:0] = Reg2Data[17:0];
                FreqAddr[10:0] = 11'b01000001000;       // 0 + offset, not sure what baseaddr is supposed to be
                NewDataReady = NewDataReady_out;
                DataReady = 0;
                AddrReady = 0;
                strbEnable = 3'b111;
                next_state = 3'b011;
            end else if (reset == 1) begin
                FreqData = 0;
                FreqAddr = 0;
                NewDataReady = 1;
                DataReady = 0;
                AddrReady = 0;
                strbEnable = 3'b111;
                next_state = 3'b000;
            end else begin
                FreqData = FreqData_out;
                FreqAddr = FreqAddr_out;
                NewDataReady = NewDataReady_out;
                DataReady = DataReady_out;
                AddrReady = AddrReady_out;
                strbEnable = 3'b111;
                next_state = 3'b010;
            end 
        end
        3'b011:begin
            if (DataValid_in && AddrValid_in) begin
                FreqData = FreqData_out;
                FreqAddr = FreqAddr_out;
                NewDataReady = NewDataReady_out;
                DataReady = 1;
                AddrReady = 1;
                strbEnable = 3'b111;
                next_state = 3'b100;
            end else if (reset == 1) begin
                FreqData = 0;
                FreqAddr = 0;
                NewDataReady = 1;
                DataReady = 0;
                AddrReady = 0;
                strbEnable = 3'b111;
                next_state = 3'b000;
            end else begin
                FreqData = FreqData_out;
                FreqAddr = FreqAddr_out;
                NewDataReady = NewDataReady_out;
                DataReady = DataReady_out;
                AddrReady = AddrReady_out;
                strbEnable = 3'b111;
                next_state = 3'b011;
            end
        end
        3'b100:begin
            if (!DataValid_in && !AddrValid_in) begin
                FreqData[31:0] = 32'b00000000000000000000000000000011;
                FreqAddr[10:0] = 11'b01001011100;
                NewDataReady = NewDataReady_out;
                DataReady = 0;
                AddrReady = 0;
                strbEnable = 3'b111;
                next_state = 3'b101;
            end else if (reset == 1) begin
                FreqData = 0;
                FreqAddr = 0;
                NewDataReady = 1;
                DataReady = 0;
                AddrReady = 0;
                strbEnable = 3'b111;
                next_state = 3'b000;
            end else begin
                FreqData = FreqData_out;
                FreqAddr = FreqAddr_out;
                NewDataReady = NewDataReady_out;
                DataReady = DataReady_out;
                AddrReady = AddrReady_out;
                strbEnable = 3'b111;
                next_state = 3'b100;
            end
        end
        3'b101:begin
            if (DataValid_in && AddrValid_in) begin
                FreqData = FreqData_out;
                FreqAddr = FreqAddr_out;
                NewDataReady = NewDataReady_out;
                DataReady = 1;
                AddrReady = 1;
                strbEnable = 3'b111;
                next_state = 3'b110;
            end else if (reset == 1) begin
                FreqData = 0;
                FreqAddr = 0;
                NewDataReady = 1;
                DataReady = 0;
                AddrReady = 0;
                strbEnable = 3'b111;
                next_state = 3'b000;
            end else begin
                FreqData = FreqData_out;
                FreqAddr = FreqAddr_out;
                NewDataReady = NewDataReady_out;
                DataReady = DataReady_out;
                AddrReady = AddrReady_out;
                strbEnable = 3'b111;
                next_state = 3'b101;
            end
        end
        3'b110:begin
            if (!DataValid_in && !AddrValid_in) begin
                FreqData = FreqData_out;
                FreqAddr = FreqAddr_out;
                NewDataReady = 1;
                DataReady = 0;
                AddrReady = 0;
                strbEnable = 3'b111;
                next_state = 3'b000;
            end else if (reset == 1) begin
                FreqData = 0;
                FreqAddr = 0;
                NewDataReady = 1;
                DataReady = 0;
                AddrReady = 0;
                strbEnable = 3'b111;
                next_state = 3'b000;
            end else begin
                FreqData = FreqData_out;
                FreqAddr = FreqAddr_out;
                NewDataReady = NewDataReady_out;
                DataReady = DataReady_out;
                AddrReady = AddrReady_out;
                strbEnable = 3'b111;
                next_state = 3'b110;
            end
        end
        default:begin
            FreqData = 0;
            FreqAddr = 0;
            NewDataReady = 1;
            DataReady = 0;
            AddrReady = 0;
            strbEnable = 3'b111;
            next_state = 3'b000;
        end
    endcase
end
endmodule
