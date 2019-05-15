`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// UMBC Spring 19'
// Keven Nettie 
// Ben Mogren
//////////////////////////////////////////////////////////////////////////////////

module dynamic_clk(
    input clk_4x, 
    input clk,
    input [9:0] div,
    input [21:0] div_frac,
    input new_data,
    input reset,
    output pulse_var,
    output ADC_clk
    );
    
    reg [9:0] div_latched;
    reg [9:0] div_latched_temp;
    reg [21:0] div_frac_latched;
    reg [21:0] div_frac_latched_temp;
    reg [22:0] remainder;
    reg [22:0] remainder_temp;
    reg [9:0] freq_div;
    reg [9:0] freq_div_temp;
    reg [4:0] sel;
    reg [4:0] sel_temp;
    reg [4:0] sel_next;
    reg [10:0] ADC_count;
    reg [10:0] ADC_count_temp;
    reg ADC_out;
    reg [1:0] pulse_extend;
    reg [1:0] pulse_extend_next;
    
    wire pulse = remainder[22]?(freq_div >= (div_latched+1)):(freq_div >= div_latched);
    assign pulse_var = pulse_extend != 0 || pulse;
    assign ADC_clk = ADC_out;
    
always @ (posedge clk_4x) begin // Add slow clock
    ADC_count <= ADC_count_temp;
    freq_div <= freq_div_temp;
    pulse_extend <= pulse_extend_next;
end

always @ (posedge clk) begin
    sel <= sel_temp;
    remainder <= remainder_temp;
    div_latched <= div_latched_temp;
    div_frac_latched <= div_frac_latched_temp;
end

always @ (*) begin
    // synchronus reset
    if (reset || new_data) begin
        ADC_count_temp <= 0;
        freq_div_temp <= 0;
        sel_temp <= 0;
        remainder_temp <= 0;
        div_latched_temp <= div;
        div_frac_latched_temp <= div_frac;
        pulse_extend_next <= 0;
    end else begin
        div_latched_temp <= div_latched;
        div_frac_latched_temp <= div_frac_latched;
        
        if (pulse || pulse_extend != 0) begin
            pulse_extend_next <= pulse_extend + 1;
        end else begin
            pulse_extend_next <= 0;
        end
        
        // reg for freq_div with add and sub
        if (pulse) begin
            freq_div_temp <= 0;
        end else begin
            freq_div_temp <= (freq_div + 1);
        end
        
        //Add the remainder 
        if(pulse_var) begin
            if(remainder[22]) begin
                remainder_temp <= remainder - (23'b10000000000000000000000-div_frac_latched);
            end else begin
                remainder_temp <= remainder + div_frac_latched;
            end
        end else begin
            remainder_temp <= remainder;
        end
    
        // ADC_count
        if (pulse) begin
            ADC_count_temp <= 0;
        end else begin
            if (ADC_count >= div_latched) begin
                ADC_count_temp <= ADC_count - div_latched;
            end else begin
                ADC_count_temp <= ADC_count + sel;
            end
        end
        
        if (sel == 0) begin
            sel_temp <= sel_next;
        end else begin
            sel_temp <= sel;
        end
    end
    
    // ADC out logic
    if (ADC_count <= {1'b0,div_latched[9:1]}) begin
        ADC_out <= 1;
    end else begin
        ADC_out <= 0;
    end
    
    //Setting select for an appropriate ADC clock.
    if(div_latched > 640) begin
        sel_next <= 32;
    end else if(div_latched > 320) begin
        sel_next <= 16;
    end else if(div_latched > 160) begin
        sel_next <= 8;
    end else if(div_latched > 80) begin
        sel_next <= 4;
    end else if(div_latched > 40) begin
        sel_next <= 2;
    end else if(div_latched >= 20) begin
        sel_next <= 1;
    end else begin
        sel_next <= 0;
    end
    
end
endmodule
