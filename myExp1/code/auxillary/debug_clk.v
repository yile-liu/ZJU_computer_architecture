`timescale 1ns / 1ps

module debug_clk(
    input clk, debug_en, debug_step,
    output debug_clk
);
    assign debug_clk = debug_en ? debug_step : clk;
endmodule