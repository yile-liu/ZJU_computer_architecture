`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/09 15:47:19
// Design Name: 
// Module Name: MUX4T1_32
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


module MUX4T1_32(
    input [1:0]s,
    input [31:0]I0, I1, I2, I3,
    output [31:0]o
    );

    wire s0 = s == 2'b00;
    wire s1 = s == 2'b01;
    wire s2 = s == 2'b10;
    wire s3 = s == 2'b11;
    
    assign o =  {32{s0}} & I0 |
                {32{s1}} & I1 |
                {32{s2}} & I2 |
                {32{s3}} & I3 ;
endmodule
