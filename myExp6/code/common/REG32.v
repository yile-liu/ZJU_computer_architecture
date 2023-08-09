`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/02/18 12:57:09
// Design Name: 
// Module Name: REG32
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


module REG32(
                    input clk,
					input rst,
					input CE,
					input [31:0]D,
					output reg[31:0]Q
					);
					
	always @(posedge clk or posedge rst)
		if (rst)  Q <= 32'h00000000;
		else if (CE) Q <= D;

endmodule
