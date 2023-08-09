`timescale 1ns / 1ps

module MUX8T1_32(
    input [2:0]s,
    input [31:0]I0, I1, I2, I3, I4, I5, I6, I7, 
    output [31:0]o
    );

    wire s0 = s == 3'b000;
    wire s1 = s == 3'b001;
    wire s2 = s == 3'b010;
    wire s3 = s == 3'b011;
    wire s4 = s == 3'b100;
    wire s5 = s == 3'b101;
    wire s6 = s == 3'b110;
    wire s7 = s == 3'b111;
    
    assign o  = {32{s0}} & I0 |
                {32{s1}} & I1 |
                {32{s2}} & I2 |
                {32{s3}} & I3 |
                {32{s4}} & I4 |
                {32{s5}} & I5 |
                {32{s6}} & I6 |
                {32{s7}} & I7;
endmodule
