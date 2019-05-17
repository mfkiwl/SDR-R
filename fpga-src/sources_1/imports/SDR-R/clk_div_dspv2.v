`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// UMBC
// Ben Mogren
// Spring 19'
//////////////////////////////////////////////////////////////////////////////////


module clk_div_dsp(
    input [9:0] div,
    input [21:0] div_frac,
    input rst,
    //input new_data,
    input clk_4x,
    input clk,
    output ADC_out,
    output rader_pulse
    );
    
    //reg [9:0] div_latched;
    //reg [21:0] div_frac_latched;
    //reg [5:0] select;
    
    reg [22:0] remainder;
    reg [22:0] remainder_next;
    
    reg pulse_meta;
    reg pulse_out;
    
    wire pulse_meta_next;
    wire  [9:0] count_adc;
    wire [9:0] count_main;
    wire main_counter_reset;
    wire adc_counter_reset;
    wire [9:0] main_cont_max;
    reg [9:0] adc_count_max;

    c_counter_binary_0 freq_div_counter_main
        (
        .CLK(clk_4x),
        .SCLR(main_counter_reset),
        .Q(count_main)
        );
    c_counter_binary_0 freq_div_counter_ADC
        (
        .CLK(clk_4x),
        .SCLR(adc_counter_reset),
        .Q(count_adc)
        );
    
    assign adc_counter_reset = (count_adc >= adc_count_max)|rst|main_counter_reset;  // Manage the ADC divisor.
    assign ADC_out = count_adc <= adc_count_max >> 1;       // ADC output 'clock' signal
    
    assign main_counter_reset = (count_main >= main_cont_max)|rst;// Dithering of divisor size based upon remainder
    assign main_cont_max = (remainder[22])? div - 1 : div;
    assign rader_pulse = pulse_out;
    
    assign pulse_meta_next = main_counter_reset | ( pulse_meta & (!pulse_out)); // Logic for synchronizing pulse with 100MHz clock
    
always @ (posedge clk) begin
    if(rst)begin
        pulse_out <= 0;
        remainder <= 0;
    end else begin
        pulse_out <= pulse_meta;
        remainder <= remainder_next;
    end
end

always @ (posedge clk_4x) begin
    if(rst)begin
        pulse_meta <= 0;
    end else begin
        pulse_meta <= pulse_meta_next;
    end
end

always @ (*) begin
    
    // Update the remainder after every main counter rollover.
    if(pulse_out) begin
        if(remainder[22]) begin
            remainder_next <= remainder - (23'b10000000000000000000000-div_frac);
        end else begin
            remainder_next <= remainder + div_frac;
        end
    end else begin
        remainder_next <= remainder;
    end
    
    //Setting select for an appropriate ADC clock.
    if(div > 640) begin
        adc_count_max <= div >> 5;
    end else if(div > 320) begin
        adc_count_max <= div >> 4;
    end else if(div > 160) begin
        adc_count_max <= div >> 3;
    end else if(div > 80) begin
        adc_count_max <= div >> 2;
    end else if(div > 40) begin
        adc_count_max <= div >> 1;
    end else if(div >= 20) begin
        adc_count_max <= div;
    end else begin
        adc_count_max <= 20;
    end
end

endmodule