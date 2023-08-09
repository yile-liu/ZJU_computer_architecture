`timescale 1ns / 1ps

/**
 * Parallel-Serial Converter.
 * Author: Zhao, Hongyu  <power_zhy@foxmail.com>
 */
module parallel2serial (
    input wire clk,  // main clock
    input wire rst,  // synchronous reset
    input wire [DATA_BITS-1:0] data,  // parallel input data
    input wire start,  // start command
    output reg busy,  // busy flag
    output reg finish,  // finish acknowledgement
    output reg s_clk = 0,  // serial clock
    output reg s_clr = 0,  // serial clear
    output wire s_dat  // serial output data
    );
    
	`include "function.vh"
    parameter
        P_CLK_FREQ = 100,  // main clock frequency in MHz
        S_CLK_FREQ = 10,  // serial clock frequency in MHz
        DATA_BITS = 32,  // data length
        CODE_ENDIAN = 0;  // 0 for little-endian and 1 for big-endian
    localparam
        COUNT_HALFCYCLE = 1 + (P_CLK_FREQ-1) / S_CLK_FREQ / 2,
        CYCLE_COUNT_BITS = GET_WIDTH(COUNT_HALFCYCLE-1),
        DATA_COUNT_BITS = GET_WIDTH(DATA_BITS-1);
    
    reg [DATA_BITS:0] buff;
    reg [CYCLE_COUNT_BITS-1:0] cycle_count = 0;
    wire s_clk_negedge;
    
    localparam
        S_IDLE = 0,  // idle
        S_CLEAR = 1,  // clear
        S_WORK = 2,  // converting
        S_DONE = 3;  // acknowledge
    
    reg [2:0] state = 0;
    reg [2:0] next_state;
    reg [DATA_COUNT_BITS-1:0] data_count = 0;
    reg [DATA_COUNT_BITS-1:0] next_data_count;
    
    always @(*) begin
        next_state = 0;
        next_data_count = 0;
        case (state)
            S_IDLE: begin
                if (start) begin
                    next_state = S_CLEAR;
                end
                else begin
                    next_state = S_IDLE;
                end
            end
            S_CLEAR: begin
                if (s_clk_negedge) begin
                    next_state = S_WORK;
                end
                else begin
                    next_state = S_CLEAR;
                end
            end
            S_WORK: begin
                if (s_clk_negedge) begin
                    next_data_count = data_count + 1'h1;
                    if (data_count == DATA_BITS-1)
                        next_state = S_DONE;
                    else
                        next_state = S_WORK;
                end
                else begin
                    next_data_count = data_count;
                    next_state = S_WORK;
                end
            end
            S_DONE: begin
                next_state = S_IDLE;
            end
        endcase
    end
    
    always @(posedge clk) begin
        if (rst) begin
            state <= 0;
            data_count <= 0;
        end
        else begin
            state <= next_state;
            data_count <= next_data_count;
        end
    end
    
    always @(posedge clk) begin
        busy <= 0;
        finish <= 0;
        s_clr <= 0;
        if (~rst) case (next_state)
            S_IDLE: begin
                buff <= 0;
            end
            S_CLEAR: begin
                busy <= 1;
                if (CODE_ENDIAN)
                    buff <= {1'b0, data};
                else
                    buff <= {data, 1'b0};
                s_clr <= 1;
            end
            S_WORK: begin
                busy <= 1;
                if (s_clk_negedge) begin
                    if (CODE_ENDIAN)
                        buff <= {buff[DATA_BITS-1:0], 1'b0};
                    else
                        buff <= {1'b0, buff[DATA_BITS:1]};
                end
            end
            S_DONE: begin
                finish <= 1;
            end
        endcase
    end
    
    assign s_dat = CODE_ENDIAN ? buff[DATA_BITS] : buff[0];
    
    always @(posedge clk) begin
        if (rst || state==S_IDLE || state==S_DONE) begin
            cycle_count <= 0;
            s_clk <= 0;
        end
        else begin
            if (cycle_count == COUNT_HALFCYCLE-1) begin
                cycle_count <= 0;
                s_clk <= ~s_clk;
            end
            else begin
                cycle_count <= cycle_count + 1'h1;
            end
        end
    end
    
    assign
        s_clk_negedge = (cycle_count == COUNT_HALFCYCLE-1) && s_clk;  // make it one clock prior than s_clk so that s_dat can be synchronized with s_clk
    
endmodule
