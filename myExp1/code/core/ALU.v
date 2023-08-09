`timescale 1ns / 1ps

module ALU(
    input[31:0] A, B,
    input[3:0] Control,
    output[31:0] res,
    output zero, overflow
);

    parameter ALU_ADD  = 4'b0001;
    parameter ALU_SUB  = 4'b0010;
    parameter ALU_AND  = 4'b0011;
    parameter ALU_OR   = 4'b0100;
    parameter ALU_XOR  = 4'b0101;
    parameter ALU_SLL  = 4'b0110;
    parameter ALU_SRL  = 4'b0111;
    parameter ALU_SLT  = 4'b1000;
    parameter ALU_SLTU = 4'b1001;
    parameter ALU_SRA  = 4'b1010;
    parameter ALU_Ap4  = 4'b1011;
    parameter ALU_Bout = 4'b1100;

    wire[4:0] shamt = B[4:0];
    wire[32:0] res_subu = {1'b0,A} - {1'b0,B};

    wire[31:0] res_ADD  = A + B;
    wire[31:0] res_SUB  = A - B;
    wire[31:0] res_AND  = A & B;
    wire[31:0] res_OR   = A | B;
    wire[31:0] res_XOR  = A ^ B;
    wire[31:0] res_SLL  = A << shamt;
    wire[31:0] res_SRL  = A >> shamt;

    wire add_of = A[31] & B[31] & ~res_ADD[31] | // neg + neg = pos
                  ~A[31] & ~B[31] & res_ADD[31]; // pos + pos = neg
    wire sub_of = ~A[31] & B[31] & res_SUB[31] | // pos - neg = neg
                  A[31] & ~B[31] & ~res_SUB[31]; // neg - pos = pos
    
    wire[31:0] res_SLT  = {31'b0, res_SUB[31] ^ sub_of};
    wire[31:0] res_SLTU = {31'b0, res_subu[32]};
    wire[31:0] res_SRA  = {{32{A[31]}}, A} >> shamt;
    wire[31:0] res_Ap4  = A + 4;
    wire[31:0] res_Bout = B;

    wire ADD  = Control == ALU_ADD ;
    wire SUB  = Control == ALU_SUB ;
    wire AND  = Control == ALU_AND ;
    wire OR   = Control == ALU_OR  ;
    wire XOR  = Control == ALU_XOR ;
    wire SLL  = Control == ALU_SLL ;
    wire SRL  = Control == ALU_SRL ;
    wire SLT  = Control == ALU_SLT ;
    wire SLTU = Control == ALU_SLTU;
    wire SRA  = Control == ALU_SRA ;
    wire Ap4  = Control == ALU_Ap4 ;
    wire Bout = Control == ALU_Bout;

    
    assign zero = ~|res;
    
    assign overflow = (Control == ALU_ADD && add_of) | 
                    (Control == ALU_SUB && sub_of);
    
    assign res = {32{ADD }} & res_ADD  |
                 {32{SUB }} & res_SUB  |
                 {32{AND }} & res_AND  |
                 {32{OR  }} & res_OR   |
                 {32{XOR }} & res_XOR  |
                 {32{SLL }} & res_SLL  |
                 {32{SRL }} & res_SRL  |
                 {32{SLT }} & res_SLT  |
                 {32{SLTU}} & res_SLTU |
                 {32{SRA }} & res_SRA  |
                 {32{Ap4 }} & res_Ap4  |
                 {32{Bout}} & res_Bout ;

endmodule