`timescale 1ns / 1ps

/**
 * Display number using 7-segment tubes.
 * Author: Zhao, Hongyu  <power_zhy@foxmail.com>
 */
module display (
    input wire clk,  // main clock
    input wire rst,  // synchronous reset
    input wire [7:0] en,  // enable for each tube
    input wire [31:0] data,  // data to display
    input wire [7:0] dot,  // enable for each dot
    input wire [15:0] led,  // LED display
    // LED interfaces
    output wire led_clk,
    output wire led_en,
    output wire led_clr_n,
    output wire led_do,
    // 7-segment tube interfaces
    output wire seg_clk,
    output wire seg_en,
    output wire seg_clr_n,
    output wire seg_do
    );
    
    `include "function.vh"
    parameter
        CLK_FREQ = 25;  // main clock frequency in MHz
    localparam
        SEG_PULSE = 1'b0;
    localparam
        REFRESH_INTERVAL = 100,  // refresh interval for led and segment tubes, in ms
        COUNT_REFRESH = 1 + CLK_FREQ * REFRESH_INTERVAL * 1000,
        COUNT_BITS = GET_WIDTH(COUNT_REFRESH-1);
    
    function [6:0] digit2seg;
        input [3:0] number;
        begin
            case (number)
                4'h0: digit2seg = 7'b0111111;
                4'h1: digit2seg = 7'b0000110;
                4'h2: digit2seg = 7'b1011011;
                4'h3: digit2seg = 7'b1001111;
                4'h4: digit2seg = 7'b1100110;
                4'h5: digit2seg = 7'b1101101;
                4'h6: digit2seg = 7'b1111101;
                4'h7: digit2seg = 7'b0000111;
                4'h8: digit2seg = 7'b1111111;
                4'h9: digit2seg = 7'b1101111;
                4'hA: digit2seg = 7'b1110111;
                4'hB: digit2seg = 7'b1111100;
                4'hC: digit2seg = 7'b0111001;
                4'hD: digit2seg = 7'b1011110;
                4'hE: digit2seg = 7'b1111001;
                4'hF: digit2seg = 7'b1110001;
            endcase
        end
    endfunction
    
    wire [63:0] segment;
    
    genvar i;
    generate for (i=0; i<8; i=i+1) begin: SEG_GEN
        assign
            segment[8*i+7] = dot[i],
            segment[8*i+6-:7] = en[i] ? digit2seg(data[4*i+3-:4]) : 7'b0;
    end
    endgenerate
    
    wire led_start, seg_start;
    wire led_clr, seg_clr;
    reg [COUNT_BITS-1:0] clk_count = 0;
    
    assign
        led_en = 1,
        led_clr_n = ~led_clr,
        seg_en = 1,
        seg_clr_n = ~seg_clr;
    
    parallel2serial #(
        .P_CLK_FREQ(CLK_FREQ),
        .S_CLK_FREQ(20),
        .DATA_BITS(16),
        .CODE_ENDIAN(1)
        ) P2S_LED (
        .clk(clk),
        .rst(rst),
        .data(SEG_PULSE ? led : ~led),
        .start(led_start),
        .busy(),
        .finish(),
        .s_clk(led_clk),
        .s_clr(led_clr),
        .s_dat(led_do)
        );
    
    parallel2serial #(
        .P_CLK_FREQ(CLK_FREQ),
        .S_CLK_FREQ(20),
        .DATA_BITS(64),
        .CODE_ENDIAN(1)
        ) P2S_SEG (
        .clk(clk),
        .rst(rst),
        .data(SEG_PULSE ? segment : ~segment),
        .start(seg_start),
        .busy(),
        .finish(),
        .s_clk(seg_clk),
        .s_clr(seg_clr),
        .s_dat(seg_do)
        );
    
    always @(posedge clk) begin
        if (rst)
            clk_count <= 0;
        else if (clk_count[COUNT_BITS-1])
            clk_count <= 0;
        else
            clk_count <= clk_count + 1'h1;
    end
    
    assign
        led_start = clk_count[COUNT_BITS-1],
        seg_start = clk_count[COUNT_BITS-1];
    
endmodule
