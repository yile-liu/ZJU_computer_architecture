`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/21 14:20:23
// Design Name: 
// Module Name: MEMTEST
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
module  CPUTEST(input[31:0]PC_IF,               //IF阶段PC指针信号
                input[31:0]PC_ID,               //ID阶段PC指针信号
                input[31:0]PC_EXE,              //EXE阶段PC指针信号
                input[31:0]PC_MEM,              //MEM阶段PC指针信号
                input[31:0]PC_WB,               //WB阶段PC指针信号
                input[31:0]PC_next_IF,          //IF阶段next PC
                input[31:0]PCJump,              //UJ/jalr/B指令计算出的跳转PC指针
                input[31:0]inst_IF,             //IF阶段读出指令
                input[31:0]inst_ID,             //ID阶段执行指令
                input[31:0]inst_EXE,            //EXE阶段执行指令
                input[31:0]inst_MEM,            //MEM阶段执行指令
                input[31:0]inst_WB,             //WB阶段执行指令
                
                input[31:0]RS1DATA,             //rs1寄存器读出数 (ID阶段)
                input[31:0]RS2DATA,             //rs2寄存器读出数 (ID阶段)
                input[31:0]Imm32,               //ImmGen计算出的32位立即数 (ID阶段)
                input[31:0]Datai,               //外部输入CPU数据 (MEM阶段)
                input[31:0]Datao,               //CPU输出数据 (对应MEM阶段rs2寄存器输�??)
                input[31:0]Addr,                //CPU输出地址(对应MEM阶段的ALU运算结果)
                input[31:0]A,                   //ALU A端口输入数据 (EXE阶段)
                input[31:0]B,                   //ALU B端口输入数据 (EXE阶段)
                input[31:0]ALU_out,             //ALU运算结果 (EXE阶段)
                input[31:0]WDATA,               //寄存器写入数�?? (WB阶段)
                input [3:0]ALUC,                //ALU操作功能编码 (EXE阶段)
                input [1:0]DatatoReg,           //寄存器写通路控制 (WB阶段)
                input [1:0]PCSource,            //下一条PC选择信号 (MEM阶段)
                input [2:0]ImmSel,              //立即数生成�?�路选择信号 (ID阶段)
                input PCEN,                     //PC使能信号
                input Branch,                   //跳转信号 (MEM阶段)
                input ALUSrc_A,                 //寄存器A通道控制 (EXE阶段)
                input ALUSrc_B,                 //寄存器B通道控制 (EXE阶段)
                input WR,                       //存储器写信号 (MEM阶段)
                input MIO,                      //存储器读写信�?? (MEM阶段)
                input RegWrite,                 //寄存器写信号 (WB阶段)
                input data_hazard,              //数据冲突控制信号
                input control_hazard,           //控制冲突控制信号
                input[31:0] exp_sig,
                input[4:0]Debug_addr,           //采样时序地址
                output reg [31:0] Test_signal   //采样输出数据
                );

    always @* begin
        case (Debug_addr[4:0])
            0: Test_signal = PC_IF;
            1: Test_signal = inst_IF;
            2: Test_signal = RS1DATA;
            3: Test_signal = RS2DATA;

            4: Test_signal = PC_ID;      
            5: Test_signal = inst_ID;
            6: Test_signal = inst_ID[19:15];    // rs1 address
            7: Test_signal = inst_ID[24:20];    // rs2 address

            8: Test_signal = PC_EXE;      
            9: Test_signal = inst_EXE;    
            10: Test_signal = exp_sig;
            11: Test_signal = PCJump;

            12: Test_signal = PC_MEM; 
            13: Test_signal = inst_MEM;   
            14: Test_signal = {15'h0, Branch, 7'h0, PCEN, 6'h0, PCSource};  
            15: Test_signal = {15'h0, data_hazard, 15'h0, control_hazard}; 

            16: Test_signal = PC_WB;      
            17: Test_signal = inst_WB;        
            18: Test_signal = {14'h0, ImmSel, 7'h0, ALUSrc_A, 7'h0, ALUSrc_B};
            19: Test_signal = PC_next_IF;
                           
            20: Test_signal = A;
            21: Test_signal = ALU_out;
            22: Test_signal = Addr;
            23: Test_signal = ALUC; 

            24: Test_signal = B;
            25: Test_signal = WDATA;
            26: Test_signal = Datai;
            27: Test_signal = {15'h0, WR, 15'h0, MIO};

            28: Test_signal = Imm32;
            29: Test_signal = inst_WB[11:7]; // rd address
            30: Test_signal = Datao;
            31: Test_signal = {15'h0, RegWrite, 14'h0, DatatoReg};
            
            default: Test_signal = 32'hAA55_AA55;
        endcase
    end
                          
endmodule