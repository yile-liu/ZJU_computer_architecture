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
module  CPUTEST(input[31:0]PC_IF,               //IF\u9636\u6BB5PC\u6307\u9488\u4FE1\u53F7
                input[31:0]PC_ID,               //ID\u9636\u6BB5PC\u6307\u9488\u4FE1\u53F7
                input[31:0]PC_EXE,              //EXE\u9636\u6BB5PC\u6307\u9488\u4FE1\u53F7
                input[31:0]PC_MEM,              //MEM\u9636\u6BB5PC\u6307\u9488\u4FE1\u53F7
                input[31:0]PC_WB,               //WB\u9636\u6BB5PC\u6307\u9488\u4FE1\u53F7
                input[31:0]PC_next_IF,          //IF\u9636\u6BB5next PC
                input[31:0]PCJump,              //UJ/jalr/B\u6307\u4EE4\u8BA1\u7B97\u51FA\u7684\u8DF3\u8F6CPC\u6307\u9488
                input[31:0]inst_IF,             //IF\u9636\u6BB5\u8BFB\u51FA\u6307\u4EE4
                input[31:0]inst_ID,             //ID\u9636\u6BB5\u6267\u884C\u6307\u4EE4
                input[31:0]inst_EXE,            //EXE\u9636\u6BB5\u6267\u884C\u6307\u4EE4
                input[31:0]inst_MEM,            //MEM\u9636\u6BB5\u6267\u884C\u6307\u4EE4
                input[31:0]inst_WB,             //WB\u9636\u6BB5\u6267\u884C\u6307\u4EE4
                
                input[31:0]RS1DATA,             //rs1\u5BC4\u5B58\u5668\u8BFB\u51FA\u6570 (ID\u9636\u6BB5)
                input[31:0]RS2DATA,             //rs2\u5BC4\u5B58\u5668\u8BFB\u51FA\u6570 (ID\u9636\u6BB5)
                input[31:0]Imm32,               //ImmGen\u8BA1\u7B97\u51FA\u768432\u4F4D\u7ACB\u5373\u6570 (ID\u9636\u6BB5)
                input[31:0]Datai,               //\u5916\u90E8\u8F93\u5165CPU\u6570\u636E (MEM\u9636\u6BB5)
                input[31:0]Datao,               //CPU\u8F93\u51FA\u6570\u636E (\u5BF9\u5E94MEM\u9636\u6BB5rs2\u5BC4\u5B58\u5668\u8F93\uFF7F?)
                input[31:0]Addr,                //CPU\u8F93\u51FA\u5730\u5740(\u5BF9\u5E94MEM\u9636\u6BB5\u7684ALU\u8FD0\u7B97\u7ED3\u679C)
                input[31:0]A,                   //ALU A\u7AEF\u53E3\u8F93\u5165\u6570\u636E (EXE\u9636\u6BB5)
                input[31:0]B,                   //ALU B\u7AEF\u53E3\u8F93\u5165\u6570\u636E (EXE\u9636\u6BB5)
                input[31:0]ALU_out,             //ALU\u8FD0\u7B97\u7ED3\u679C (EXE\u9636\u6BB5)
                input[31:0]WDATA,               //\u5BC4\u5B58\u5668\u5199\u5165\u6570\uFF7F? (WB\u9636\u6BB5)
                input [3:0]ALUC,                //ALU\u64CD\u4F5C\u529F\u80FD\u7F16\u7801 (EXE\u9636\u6BB5)
                input [1:0]DatatoReg,           //\u5BC4\u5B58\u5668\u5199\u901A\u8DEF\u63A7\u5236 (WB\u9636\u6BB5)
                input [1:0]PCSource,            //\u4E0B\u4E00\u6761PC\u9009\u62E9\u4FE1\u53F7 (MEM\u9636\u6BB5)
                input [2:0]ImmSel,              //\u7ACB\u5373\u6570\u751F\u6210\uFFFD?\uFFFD\u8DEF\u9009\u62E9\u4FE1\u53F7 (ID\u9636\u6BB5)
                input PCEN,                     //PC\u4F7F\u80FD\u4FE1\u53F7
                input Branch,                   //\u8DF3\u8F6C\u4FE1\u53F7 (MEM\u9636\u6BB5)
                input ALUSrc_A,                 //\u5BC4\u5B58\u5668A\u901A\u9053\u63A7\u5236 (EXE\u9636\u6BB5)
                input ALUSrc_B,                 //\u5BC4\u5B58\u5668B\u901A\u9053\u63A7\u5236 (EXE\u9636\u6BB5)
                input WR,                       //\u5B58\u50A8\u5668\u5199\u4FE1\u53F7 (MEM\u9636\u6BB5)
                input MIO,                      //\u5B58\u50A8\u5668\u8BFB\u5199\u4FE1\uFF7F? (MEM\u9636\u6BB5)
                input RegWrite,                 //\u5BC4\u5B58\u5668\u5199\u4FE1\u53F7 (WB\u9636\u6BB5)
                input data_hazard,              //\u6570\u636E\u51B2\u7A81\u63A7\u5236\u4FE1\u53F7
                input control_hazard,           //\u63A7\u5236\u51B2\u7A81\u63A7\u5236\u4FE1\u53F7
                input[4:0]Debug_addr,           //\u91C7\u6837\u65F6\u5E8F\u5730\u5740
                output reg [31:0] Test_signal   //\u91C7\u6837\u8F93\u51FA\u6570\u636E
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
            10: Test_signal = 32'hAA55AA55;
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