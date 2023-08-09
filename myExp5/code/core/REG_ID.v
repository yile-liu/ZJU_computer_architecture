`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:34:44 03/12/2012
// Design Name:
// Module Name:    REGS IF/ID Latch
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module    REG_ID(input clk,                                      //IF/ID Latch
                    input rst,
                    input EN,                                       //流水寄存器使能
                    input flush,                                    //控制竞争清除并等待
                    input [31:0] PCOUT,                             //指令存储器指针
                    input [31:0] IR,                                //指令存储器输出

                    output reg[31:0] IR_ID,                         //取指锁存
                    output reg[31:0] PCurrent_ID,                   //当前存在指令地址
                    output reg valid
                );

//reg[31:0]PCurrent_ID,IR_ID;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            IR_ID <= 32'h00000013;                            //复位清零s
            PCurrent_ID <= 32'h00000000;                     //复位清零
            valid <= 0;
        end
        else if(flush) begin
            PCurrent_ID <= PCOUT;                       //正常取指,传送下一流水级译码
            IR_ID <= 32'h00000013;              //IR waiting for Control Hazards i清s除指令并暂停
            valid <= 0;
        end
        else if(EN)begin
            IR_ID <= IR;                       //正常取指,传送下一流水级译码
            PCurrent_ID <= PCOUT;             //当前取指PC地址，Branch/Junp指令计算目标地址用(非PC+4)
            valid <= 1;
        end
    end
endmodule