`timescale 1ns / 1ps
`include "CtrlDefine.vh"

module CtrlUnit(
    input clk,
    input rst,

    input[31:0] PC,
    input[31:0] inst,
    input[31:0] imm,
    
    input ALU_done,
    input MEM_done,
    input MUL_done,
    input DIV_done,
    input JUMP_done,
    input is_jump,

    // IF
    output IS_en,

    // IS
    output[2:0] ImmSel,

    // RO/FU
    output reg ALU_en, MEM_en, MUL_en, DIV_en, JUMP_en,
    output reg[31:0] PC_ctrl,
    output reg[31:0] imm_ctrl,
    output reg[4:0] rs1_ctrl, rs2_ctrl, 
    
    // FU
    output reg[4:0] JUMP_op,
    output reg[3:0] ALU_op,
    output reg ALU_use_PC,
    output reg ALU_use_imm,
    output reg MEM_we,
    output reg[2:0] MEM_bhw,
    output reg[2:0] MUL_op,
    output reg[1:0] DIV_op,
    
    // WB
    output reg[2:0] write_sel,
    output reg reg_write,
    output reg[4:0] rd_ctrl
);
    // used in for loop
    integer i;

    reg[31:0] FUS[1:5]; //FunctionUnitState记录各单元当前的状态 约等于计分板?
    reg[31:0] IMM[1:5];

    // records which FU will write corresponding reg at WB
    reg[2:0] RRS[0:31];

    // sometimes an instruction needs PC to execute
    // pc record
    reg[31:0] PCR[1:5];

    wire RO_en;
    wire normal_stall;
    reg ctrl_stall = 0, IS_flush = 0;

    // a jump (JAL/JALR/BXX) instr has issued,
    // stop issuing until result is known
    wire jump_stall;

    // instruction field
    wire[6:0] funct7 = inst[31:25];
    wire[2:0] funct3 = inst[14:12];
    wire[6:0] opcode = inst[6:0];
    wire[4:0] rd = inst[11:7];
    wire[4:0] rs1 = inst[19:15];
    wire[4:0] rs2 = inst[24:20];

    // type specification
    wire Rop = opcode == 7'b0110011;
    wire Iop = opcode == 7'b0010011;
    wire Bop = opcode == 7'b1100011;
    wire Lop = opcode == 7'b0000011;
    wire Sop = opcode == 7'b0100011;

    wire funct7_0  = funct7 == 7'h0;
    wire funct7_1  = funct7 == 7'h1;
    wire funct7_32 = funct7 == 7'h20;

    wire funct3_0 = funct3 == 3'h0;
    wire funct3_1 = funct3 == 3'h1;
    wire funct3_2 = funct3 == 3'h2;
    wire funct3_3 = funct3 == 3'h3;
    wire funct3_4 = funct3 == 3'h4;
    wire funct3_5 = funct3 == 3'h5;
    wire funct3_6 = funct3 == 3'h6;
    wire funct3_7 = funct3 == 3'h7;

    wire ADD  = Rop & funct3_0 & funct7_0;
    wire SUB  = Rop & funct3_0 & funct7_32;
    wire SLL  = Rop & funct3_1 & funct7_0;
    wire SLT  = Rop & funct3_2 & funct7_0;
    wire SLTU = Rop & funct3_3 & funct7_0;
    wire XOR  = Rop & funct3_4 & funct7_0;
    wire SRL  = Rop & funct3_5 & funct7_0;
    wire SRA  = Rop & funct3_5 & funct7_32;
    wire OR   = Rop & funct3_6 & funct7_0;
    wire AND  = Rop & funct3_7 & funct7_0;

    wire MUL    = Rop & funct3_0 & funct7_1;
    wire MULH   = Rop & funct3_1 & funct7_1;
    wire MULHSU = Rop & funct3_2 & funct7_1;
    wire MULHU  = Rop & funct3_3 & funct7_1;
    wire DIV    = Rop & funct3_4 & funct7_1;
    wire DIVU   = Rop & funct3_5 & funct7_1;
    wire REM    = Rop & funct3_6 & funct7_1;
    wire REMU    = Rop & funct3_7 & funct7_1;

    wire ADDI  = Iop & funct3_0;	
    wire SLTI  = Iop & funct3_2;
    wire SLTIU = Iop & funct3_3;
    wire XORI  = Iop & funct3_4;
    wire ORI   = Iop & funct3_6;
    wire ANDI  = Iop & funct3_7;
    wire SLLI  = Iop & funct3_1 & funct7_0;
    wire SRLI  = Iop & funct3_5 & funct7_0;
    wire SRAI  = Iop & funct3_5 & funct7_32;

    wire BEQ = Bop & funct3_0;
    wire BNE = Bop & funct3_1;
    wire BLT = Bop & funct3_4;
    wire BGE = Bop & funct3_5;
    wire BLTU = Bop & funct3_6;
    wire BGEU = Bop & funct3_7;

    wire LB =  Lop & funct3_0;
    wire LH =  Lop & funct3_1;
    wire LW =  Lop & funct3_2;
    wire LBU = Lop & funct3_4;
    wire LHU = Lop & funct3_5;

    wire SB = Sop & funct3_0;
    wire SH = Sop & funct3_1;
    wire SW = Sop & funct3_2;

    wire LUI   = opcode == 7'b0110111;
    wire AUIPC = opcode == 7'b0010111;

    wire JAL  =  opcode == 7'b1101111;
    wire JALR = (opcode == 7'b1100111) && funct3_0;

    wire R_valid = AND | OR | ADD | XOR | SLL | SRL | SRA | SUB | SLT | SLTU 
        | MUL | MULH | MULHSU | MULHU | DIV | DIVU | REM | REMU;
    wire I_valid = ANDI | ORI | ADDI | XORI | SLLI | SRLI | SRAI | SLTI | SLTIU;
    wire B_valid = BEQ | BNE | BLT | BGE | BLTU | BGEU;
    wire L_valid = LW | LH | LB | LHU | LBU;
    wire S_valid = SW | SH | SB;

    // function unit specification
    wire use_ALU = AND | OR | ADD | XOR | SLL | SRL | SRA | SUB | SLT | SLTU
        | I_valid | LUI | AUIPC;
    wire use_MEM = L_valid | S_valid;
    wire use_MUL = MUL | MULH | MULHSU | MULHU;
    wire use_DIV = DIV | DIVU | REM | REMU;
    wire use_JUMP = B_valid | JAL | JALR;

    // normal stall: structural hazard or WAW
    // FU被占用 或者 目标Reg有别的指令需要写入
    assign normal_stall = (use_FU == 3'b0 ? 3'b0 : FUS[use_FU][`BUSY]) || RRS[dst];

    assign IS_en = IS_flush | ~normal_stall & ~ctrl_stall;
    assign RO_en = ~IS_flush & ~normal_stall & ~ctrl_stall;

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            ctrl_stall <= 0;
        end
        else begin
            // IS
            if (RO_en & (use_FU == `FU_JUMP)) begin
                ctrl_stall <= 1;
            end
            else if (JUMP_done) begin
                ctrl_stall <= 0;
            end
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            IS_flush <= 0;
        end
        else if (JUMP_done & is_jump) begin
            IS_flush <= 1;
        end
        else begin
            IS_flush <= 0;
        end
    end

    assign jump_stall = FUS[`FU_JUMP][`BUSY] & (~JUMP_done);

    wire[2:0] use_FU = {3{use_ALU}}  & `FU_ALU  |
                       {3{use_MEM}}  & `FU_MEM  |
                       {3{use_MUL}}  & `FU_MUL  |
                       {3{use_DIV}}  & `FU_DIV  |
                       {3{use_JUMP}} & `FU_JUMP ;

    wire[4:0] op = {5{ADD}}          & `ALU_ADD    |
                   {5{SUB}}          & `ALU_SUB    |
                   {5{AND}}          & `ALU_AND    |
                   {5{OR}}           & `ALU_OR     |
                   {5{XOR}}          & `ALU_XOR    |
                   {5{SLL}}          & `ALU_SLL    |
                   {5{SRL}}          & `ALU_SRL    |
                   {5{SLT}}          & `ALU_SLT    |
                   {5{SLTU}}         & `ALU_SLTU   |
                   {5{SRA}}          & `ALU_SRA    |
                   {5{LUI}}          & `ALU_LUI    |
                   {5{AUIPC}}        & `ALU_AUIPC  |
                   {5{ADDI}}         & `ALU_ADDI   |
                   {5{ANDI}}         & `ALU_ANDI   |
                   {5{ORI}}          & `ALU_ORI    |
                   {5{XORI}}         & `ALU_XORI   |
                   {5{SLLI}}         & `ALU_SLLI   |
                   {5{SRLI}}         & `ALU_SRLI   |
                   {5{SLTI}}         & `ALU_SLTI   |
                   {5{SLTIU}}        & `ALU_SLTIU  |
                   {5{SRAI}}         & `ALU_SRAI   |
                   {5{LB}}           & `MEM_LB     |
                   {5{LH}}           & `MEM_LH     |
                   {5{LW}}           & `MEM_LW     |
                   {5{LBU}}          & `MEM_LBU    |
                   {5{LHU}}          & `MEM_LHU    |
                   {5{SB}}           & `MEM_SB     |
                   {5{SH}}           & `MEM_SH     |
                   {5{SW}}           & `MEM_SW     |
                   {5{MUL}}          & `MUL_MUL    |
                   {5{MULH}}         & `MUL_MULH   |
                   {5{MULHSU}}       & `MUL_MULHU  |
                   {5{MULHU}}        & `MUL_MULHSU |
                   {5{DIV}}          & `DIV_DIV    |
                   {5{DIVU}}         & `DIV_DIVU   |
                   {5{REM}}          & `DIV_REM    |
                   {5{REMU}}         & `DIV_REMU   |
                   {5{BEQ}}          & `JUMP_BEQ   |
                   {5{BNE}}          & `JUMP_BNE   |
                   {5{BLT}}          & `JUMP_BLT   |
                   {5{BGE}}          & `JUMP_BGE   |
                   {5{BLTU}}         & `JUMP_BLTU  |
                   {5{BGEU}}         & `JUMP_BGEU  |
                   {5{JAL}}          & `JUMP_JAL   |
                   {5{JALR}}         & `JUMP_JALR  ;

    wire[4:0] dst = {5{R_valid | I_valid | L_valid | LUI | AUIPC | JAL | JALR}} & rd;
    wire[4:0] src1 = {5{R_valid | I_valid | S_valid | L_valid | B_valid | JALR}} & rs1;
    wire[4:0] src2 = {5{R_valid | S_valid | B_valid}} & rs2;
    wire[2:0] fu1 = RRS[src1];
    wire[2:0] fu2 = RRS[src2];
    wire rdy1 = ~|fu1;
    wire rdy2 = ~|fu2;

    assign ImmSel = {3{JALR | L_valid | I_valid}} & `Imm_type_I |
                    {3{B_valid}}                  & `Imm_type_B |
                    {3{JAL}}                      & `Imm_type_J |
                    {3{S_valid}}                  & `Imm_type_S |
                    {3{LUI | AUIPC}}              & `Imm_type_U ;

    // ensure WAR:
    // If an FU hasn't read a register value (RO), don't write to it.
    // 在记分牌中RDY==1表示数据已经就为但还没有被读走 此时不能覆盖写入
    wire ALU_WAR = (
        (FUS[`FU_MEM][`SRC1_H:`SRC1_L]  != FUS[`FU_ALU][`DST_H:`DST_L] | !FUS[`FU_MEM][`RDY1])  &    //fill sth. here
        (FUS[`FU_MEM][`SRC2_H:`SRC2_L]  != FUS[`FU_ALU][`DST_H:`DST_L] | !FUS[`FU_MEM][`RDY2])  &    //fill sth. here
        (FUS[`FU_MUL][`SRC1_H:`SRC1_L]  != FUS[`FU_ALU][`DST_H:`DST_L] | !FUS[`FU_MUL][`RDY1])  &    //fill sth. here
        (FUS[`FU_MUL][`SRC2_H:`SRC2_L]  != FUS[`FU_ALU][`DST_H:`DST_L] | !FUS[`FU_MUL][`RDY2])  &    //fill sth. here
        (FUS[`FU_DIV][`SRC1_H:`SRC1_L]  != FUS[`FU_ALU][`DST_H:`DST_L] | !FUS[`FU_DIV][`RDY1])  &    //fill sth. here
        (FUS[`FU_DIV][`SRC2_H:`SRC2_L]  != FUS[`FU_ALU][`DST_H:`DST_L] | !FUS[`FU_DIV][`RDY2])  &    //fill sth. here
        (FUS[`FU_JUMP][`SRC1_H:`SRC1_L] != FUS[`FU_ALU][`DST_H:`DST_L] | !FUS[`FU_JUMP][`RDY1])  &   //fill sth. here
        (FUS[`FU_JUMP][`SRC2_H:`SRC2_L] != FUS[`FU_ALU][`DST_H:`DST_L] | !FUS[`FU_JUMP][`RDY2])      //fill sth. here
    );

    wire MEM_WAR = (
        (FUS[`FU_ALU][`SRC1_H:`SRC1_L]  != FUS[`FU_MEM][`DST_H:`DST_L] | !FUS[`FU_ALU][`RDY1]) &    //fill sth. here
        (FUS[`FU_ALU][`SRC2_H:`SRC2_L]  != FUS[`FU_MEM][`DST_H:`DST_L] | !FUS[`FU_ALU][`RDY2]) &    //fill sth. here
        (FUS[`FU_MUL][`SRC1_H:`SRC1_L]  != FUS[`FU_MEM][`DST_H:`DST_L] | !FUS[`FU_MUL][`RDY1]) &    //fill sth. here
        (FUS[`FU_MUL][`SRC2_H:`SRC2_L]  != FUS[`FU_MEM][`DST_H:`DST_L] | !FUS[`FU_MUL][`RDY2]) &    //fill sth. here
        (FUS[`FU_DIV][`SRC1_H:`SRC1_L]  != FUS[`FU_MEM][`DST_H:`DST_L] | !FUS[`FU_DIV][`RDY1]) &    //fill sth. here
        (FUS[`FU_DIV][`SRC2_H:`SRC2_L]  != FUS[`FU_MEM][`DST_H:`DST_L] | !FUS[`FU_DIV][`RDY2]) &    //fill sth. here
        (FUS[`FU_JUMP][`SRC1_H:`SRC1_L] != FUS[`FU_MEM][`DST_H:`DST_L] | !FUS[`FU_JUMP][`RDY1]) &   //fill sth. here
        (FUS[`FU_JUMP][`SRC2_H:`SRC2_L] != FUS[`FU_MEM][`DST_H:`DST_L] | !FUS[`FU_JUMP][`RDY2])     //fill sth. here
    );

    wire MUL_WAR = (
        (FUS[`FU_ALU][`SRC1_H:`SRC1_L] != FUS[`FU_MUL][`DST_H:`DST_L] | !FUS[`FU_ALU][`RDY1]) &     //fill sth. here
        (FUS[`FU_ALU][`SRC2_H:`SRC2_L] != FUS[`FU_MUL][`DST_H:`DST_L] | !FUS[`FU_ALU][`RDY2]) &     //fill sth. here
        (FUS[`FU_MEM][`SRC1_H:`SRC1_L] != FUS[`FU_MUL][`DST_H:`DST_L] | !FUS[`FU_MEM][`RDY1]) &     //fill sth. here
        (FUS[`FU_MEM][`SRC2_H:`SRC2_L] != FUS[`FU_MUL][`DST_H:`DST_L] | !FUS[`FU_MEM][`RDY2]) &     //fill sth. here
        (FUS[`FU_DIV][`SRC1_H:`SRC1_L] != FUS[`FU_MUL][`DST_H:`DST_L] | !FUS[`FU_DIV][`RDY1]) &     //fill sth. here
        (FUS[`FU_DIV][`SRC2_H:`SRC2_L] != FUS[`FU_MUL][`DST_H:`DST_L] | !FUS[`FU_DIV][`RDY2]) &     //fill sth. here
        (FUS[`FU_JUMP][`SRC1_H:`SRC1_L]!= FUS[`FU_MUL][`DST_H:`DST_L] | !FUS[`FU_JUMP][`RDY1]) &    //fill sth. here
        (FUS[`FU_JUMP][`SRC2_H:`SRC2_L]!= FUS[`FU_MUL][`DST_H:`DST_L] | !FUS[`FU_JUMP][`RDY2])      //fill sth. here
    );

    wire DIV_WAR = (
        (FUS[`FU_ALU][`SRC1_H:`SRC1_L] != FUS[`FU_DIV][`DST_H:`DST_L] | !FUS[`FU_ALU][`RDY1]) &      //fill sth. here
        (FUS[`FU_ALU][`SRC2_H:`SRC2_L] != FUS[`FU_DIV][`DST_H:`DST_L] | !FUS[`FU_ALU][`RDY2]) &      //fill sth. here
        (FUS[`FU_MEM][`SRC1_H:`SRC1_L] != FUS[`FU_DIV][`DST_H:`DST_L] | !FUS[`FU_MEM][`RDY1]) &      //fill sth. here
        (FUS[`FU_MEM][`SRC2_H:`SRC2_L] != FUS[`FU_DIV][`DST_H:`DST_L] | !FUS[`FU_MEM][`RDY2]) &      //fill sth. here
        (FUS[`FU_MUL][`SRC1_H:`SRC1_L] != FUS[`FU_DIV][`DST_H:`DST_L] | !FUS[`FU_MUL][`RDY1]) &      //fill sth. here
        (FUS[`FU_MUL][`SRC2_H:`SRC2_L] != FUS[`FU_DIV][`DST_H:`DST_L] | !FUS[`FU_MUL][`RDY2]) &      //fill sth. here
        (FUS[`FU_JUMP][`SRC1_H:`SRC1_L]!= FUS[`FU_DIV][`DST_H:`DST_L] | !FUS[`FU_JUMP][`RDY1]) &     //fill sth. here
        (FUS[`FU_JUMP][`SRC2_H:`SRC2_L]!= FUS[`FU_DIV][`DST_H:`DST_L] | !FUS[`FU_JUMP][`RDY2])       //fill sth. here
    );

    wire JUMP_WAR = (
        (FUS[`FU_ALU][`SRC1_H:`SRC1_L] != FUS[`FU_JUMP][`DST_H:`DST_L] | !FUS[`FU_ALU][`RDY1]) &      //fill sth. here
        (FUS[`FU_ALU][`SRC2_H:`SRC2_L] != FUS[`FU_JUMP][`DST_H:`DST_L] | !FUS[`FU_ALU][`RDY2]) &      //fill sth. here
        (FUS[`FU_MEM][`SRC1_H:`SRC1_L] != FUS[`FU_JUMP][`DST_H:`DST_L] | !FUS[`FU_MEM][`RDY1]) &      //fill sth. here
        (FUS[`FU_MEM][`SRC2_H:`SRC2_L] != FUS[`FU_JUMP][`DST_H:`DST_L] | !FUS[`FU_MEM][`RDY2]) &      //fill sth. here
        (FUS[`FU_MUL][`SRC1_H:`SRC1_L] != FUS[`FU_JUMP][`DST_H:`DST_L] | !FUS[`FU_MUL][`RDY1]) &      //fill sth. here
        (FUS[`FU_MUL][`SRC2_H:`SRC2_L] != FUS[`FU_JUMP][`DST_H:`DST_L] | !FUS[`FU_MUL][`RDY2]) &      //fill sth. here
        (FUS[`FU_DIV][`SRC1_H:`SRC1_L] != FUS[`FU_JUMP][`DST_H:`DST_L] | !FUS[`FU_DIV][`RDY1]) &      //fill sth. here
        (FUS[`FU_DIV][`SRC2_H:`SRC2_L] != FUS[`FU_JUMP][`DST_H:`DST_L] | !FUS[`FU_DIV][`RDY2])        //fill sth. here
    );

    // maintain the table
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            // reset the scoreboard
            for (i = 0; i < 32; i = i + 1) begin
                RRS[i] <= 3'b0;
            end

            for (i = 1; i <= 5; i = i + 1) begin
                FUS[i] <= 32'b0;
                IMM[i] <= 32'b0;
            end
        end

        else begin
            // IS
            if (RO_en) begin
                // not busy, no WAW, write info to FUS and RRS
                if (|dst) RRS[dst] <= use_FU;
                FUS[use_FU][`BUSY] <= 1'b1;
                FUS[use_FU][`OP_H:`OP_L] <= op;
                FUS[use_FU][`DST_H:`DST_L] <= dst;
                FUS[use_FU][`SRC1_H:`SRC1_L] <= src1;
                FUS[use_FU][`SRC2_H:`SRC2_L] <= src2;
                FUS[use_FU][`FU1_H:`FU1_L] <= fu1;
                FUS[use_FU][`FU2_H:`FU2_L] <= fu2;
                FUS[use_FU][`RDY1] <= rdy1;
                FUS[use_FU][`RDY2] <= rdy2;
                FUS[use_FU][`FU_DONE] <= 1'b0;
                IMM[use_FU] <= imm;
                PCR[use_FU] <= PC;
            end

            // RO
            // 两个操作数都Ready才读数并且重置RDY位 但是这里好像只维护记分牌状态 实际读数操作不在这里
            if (FUS[`FU_JUMP][`RDY1] & FUS[`FU_JUMP][`RDY2]) begin
                // JUMP
                FUS[`FU_JUMP][`RDY1] <= 1'b0;
                FUS[`FU_JUMP][`RDY2] <= 1'b0;
            end
            else if (FUS[`FU_ALU][`RDY1] & FUS[`FU_ALU][`RDY2]) begin   //fill sth. here.
                // ALU
                FUS[`FU_ALU][`RDY1] <= 1'b0;
                FUS[`FU_ALU][`RDY2] <= 1'b0;
            end
            else if (FUS[`FU_MEM][`RDY1] & FUS[`FU_MEM][`RDY2]) begin   //fill sth. here.
                // MEM
                FUS[`FU_MEM][`RDY1] <= 1'b0;
                FUS[`FU_MEM][`RDY2] <= 1'b0;
            end
            else if (FUS[`FU_MUL][`RDY1] & FUS[`FU_MUL][`RDY2]) begin   //fill sth. here.
                // MUL
                FUS[`FU_MUL][`RDY1] <= 1'b0;
                FUS[`FU_MUL][`RDY2] <= 1'b0;
            end
            else if (FUS[`FU_DIV][`RDY1] & FUS[`FU_DIV][`RDY2]) begin   //fill sth. here.
                // DIV
                FUS[`FU_DIV][`RDY1] <= 1'b0;
                FUS[`FU_DIV][`RDY2] <= 1'b0;
            end

            // EX
            // 只有没有done时才需要更新状态 done了就不用管了
            // 新指令来会在IS阶段将done重新置为0
            if (~FUS[`FU_ALU][`FU_DONE]) FUS[`FU_ALU][`FU_DONE] <= ALU_done;    //fill sth. here
            if (~FUS[`FU_MEM][`FU_DONE]) FUS[`FU_MEM][`FU_DONE] <= MEM_done;    //fill sth. here
            if (~FUS[`FU_MUL][`FU_DONE]) FUS[`FU_MUL][`FU_DONE] <= MUL_done;
            if (~FUS[`FU_DIV][`FU_DONE]) FUS[`FU_DIV][`FU_DONE] <= DIV_done;
            if (~FUS[`FU_JUMP][`FU_DONE]) FUS[`FU_JUMP][`FU_DONE] <= JUMP_done;

            // WB
            // WAR代表有人在等
            if (FUS[`FU_JUMP][`FU_DONE] & JUMP_WAR) begin   // JUMP
                FUS[`FU_JUMP] <= 32'b0;
                RRS[FUS[`FU_JUMP][`DST_H:`DST_L]] <= 3'b0;

                // ensure RAW
                if (FUS[`FU_ALU][`FU1_H:`FU1_L] == `FU_JUMP) FUS[`FU_ALU][`RDY1] <= 1'b1;           //fill sth. here
                if (FUS[`FU_MEM][`FU1_H:`FU1_L] == `FU_JUMP) FUS[`FU_MEM][`RDY1] <= 1'b1;           //fill sth. here
                if (FUS[`FU_MUL][`FU1_H:`FU1_L] == `FU_JUMP) FUS[`FU_MUL][`RDY1] <= 1'b1;           //fill sth. here
                if (FUS[`FU_DIV][`FU1_H:`FU1_L] == `FU_JUMP) FUS[`FU_DIV][`RDY1] <= 1'b1;           //fill sth. here

                if (FUS[`FU_ALU][`FU2_H:`FU2_L] == `FU_JUMP) FUS[`FU_ALU][`RDY2] <= 1'b1;           //fill sth. here
                if (FUS[`FU_MEM][`FU2_H:`FU2_L] == `FU_JUMP) FUS[`FU_MEM][`RDY2] <= 1'b1;           //fill sth. here
                if (FUS[`FU_MUL][`FU2_H:`FU2_L] == `FU_JUMP) FUS[`FU_MUL][`RDY2] <= 1'b1;           //fill sth. here
                if (FUS[`FU_DIV][`FU2_H:`FU2_L] == `FU_JUMP) FUS[`FU_DIV][`RDY2] <= 1'b1;           //fill sth. here
            end
            else if (FUS[`FU_ALU][`FU_DONE] & ALU_WAR) begin     // ALU
                FUS[`FU_ALU] <= 32'b0;
                RRS[FUS[`FU_ALU][`DST_H:`DST_L]] <= 3'b0;

                // ensure RAW
                if (FUS[`FU_JUMP][`FU1_H:`FU1_L] == `FU_ALU) FUS[`FU_JUMP][`RDY1] <= 1'b1;          //fill sth. here
                if (FUS[`FU_MEM][`FU1_H:`FU1_L] == `FU_ALU) FUS[`FU_MEM][`RDY1] <= 1'b1;            //fill sth. here
                if (FUS[`FU_MUL][`FU1_H:`FU1_L] == `FU_ALU) FUS[`FU_MUL][`RDY1] <= 1'b1;            //fill sth. here
                if (FUS[`FU_DIV][`FU1_H:`FU1_L] == `FU_ALU) FUS[`FU_DIV][`RDY1] <= 1'b1;            //fill sth. here

                if (FUS[`FU_JUMP][`FU2_H:`FU2_L] == `FU_ALU) FUS[`FU_JUMP][`RDY2] <= 1'b1;          //fill sth. here
                if (FUS[`FU_MEM][`FU2_H:`FU2_L] == `FU_ALU) FUS[`FU_MEM][`RDY2] <= 1'b1;            //fill sth. here
                if (FUS[`FU_MUL][`FU2_H:`FU2_L] == `FU_ALU) FUS[`FU_MUL][`RDY2] <= 1'b1;            //fill sth. here
                if (FUS[`FU_DIV][`FU2_H:`FU2_L] == `FU_ALU) FUS[`FU_DIV][`RDY2] <= 1'b1;            //fill sth. here
            end
            else if (FUS[`FU_MEM][`FU_DONE] & MEM_WAR) begin     // MEM
                FUS[`FU_MEM] <= 32'b0;
                RRS[FUS[`FU_MEM][`DST_H:`DST_L]] <= 3'b0;

                // ensure RAW
                if (FUS[`FU_JUMP][`FU1_H:`FU1_L] == `FU_MEM) FUS[`FU_JUMP][`RDY1] <= 1'b1;          //fill sth. here
                if (FUS[`FU_ALU][`FU1_H:`FU1_L] == `FU_MEM) FUS[`FU_ALU][`RDY1] <= 1'b1;            //fill sth. here
                if (FUS[`FU_MUL][`FU1_H:`FU1_L] == `FU_MEM) FUS[`FU_MUL][`RDY1] <= 1'b1;            //fill sth. here
                if (FUS[`FU_DIV][`FU1_H:`FU1_L] == `FU_MEM) FUS[`FU_DIV][`RDY1] <= 1'b1;            //fill sth. here

                if (FUS[`FU_JUMP][`FU2_H:`FU2_L] == `FU_MEM) FUS[`FU_JUMP][`RDY2] <= 1'b1;          //fill sth. here
                if (FUS[`FU_ALU][`FU2_H:`FU2_L] == `FU_MEM) FUS[`FU_ALU][`RDY2] <= 1'b1;            //fill sth. here
                if (FUS[`FU_MUL][`FU2_H:`FU2_L] == `FU_MEM) FUS[`FU_MUL][`RDY2] <= 1'b1;            //fill sth. here
                if (FUS[`FU_DIV][`FU2_H:`FU2_L] == `FU_MEM) FUS[`FU_DIV][`RDY2] <= 1'b1;            //fill sth. here
            end
            else if (FUS[`FU_MUL][`FU_DONE] & MUL_WAR) begin     // MUL
                FUS[`FU_MUL] <= 32'b0;
                RRS[FUS[`FU_MUL][`DST_H:`DST_L]] <= 3'b0;

                // ensure RAW
                if (FUS[`FU_JUMP][`FU1_H:`FU1_L] == `FU_MUL) FUS[`FU_JUMP][`RDY1] <= 1'b1;          //fill sth. here
                if (FUS[`FU_ALU][`FU1_H:`FU1_L] == `FU_MUL) FUS[`FU_ALU][`RDY1] <= 1'b1;            //fill sth. here
                if (FUS[`FU_MEM][`FU1_H:`FU1_L] == `FU_MUL) FUS[`FU_MEM][`RDY1] <= 1'b1;            //fill sth. here
                if (FUS[`FU_DIV][`FU1_H:`FU1_L] == `FU_MUL) FUS[`FU_DIV][`RDY1] <= 1'b1;            //fill sth. here

                if (FUS[`FU_JUMP][`FU2_H:`FU2_L] == `FU_MUL) FUS[`FU_JUMP][`RDY2] <= 1'b1;          //fill sth. here
                if (FUS[`FU_ALU][`FU2_H:`FU2_L] == `FU_MUL) FUS[`FU_ALU][`RDY2] <= 1'b1;            //fill sth. here
                if (FUS[`FU_MEM][`FU2_H:`FU2_L] == `FU_MUL) FUS[`FU_MEM][`RDY2] <= 1'b1;            //fill sth. here
                if (FUS[`FU_DIV][`FU2_H:`FU2_L] == `FU_MUL) FUS[`FU_DIV][`RDY2] <= 1'b1;            //fill sth. here
            end
            else if (FUS[`FU_DIV][`FU_DONE] & DIV_WAR) begin     // DIV
                FUS[`FU_DIV] <= 32'b0;
                RRS[FUS[`FU_DIV][`DST_H:`DST_L]] <= 3'b0;

                // ensure RAW
                if (FUS[`FU_JUMP][`FU1_H:`FU1_L] == `FU_DIV) FUS[`FU_JUMP][`RDY1] <= 1'b1;          //fill sth. here
                if (FUS[`FU_ALU][`FU1_H:`FU1_L] == `FU_DIV) FUS[`FU_ALU][`RDY1] <= 1'b1;            //fill sth. here
                if (FUS[`FU_MEM][`FU1_H:`FU1_L] == `FU_DIV) FUS[`FU_MEM][`RDY1] <= 1'b1;            //fill sth. here
                if (FUS[`FU_MUL][`FU1_H:`FU1_L] == `FU_DIV) FUS[`FU_MUL][`RDY1] <= 1'b1;            //fill sth. here

                if (FUS[`FU_JUMP][`FU2_H:`FU2_L] == `FU_DIV) FUS[`FU_JUMP][`RDY2] <= 1'b1;          //fill sth. here
                if (FUS[`FU_ALU][`FU2_H:`FU2_L] == `FU_DIV) FUS[`FU_ALU][`RDY2] <= 1'b1;            //fill sth. here
                if (FUS[`FU_MEM][`FU2_H:`FU2_L] == `FU_DIV) FUS[`FU_MEM][`RDY2] <= 1'b1;            //fill sth. here
                if (FUS[`FU_MUL][`FU2_H:`FU2_L] == `FU_DIV) FUS[`FU_MUL][`RDY2] <= 1'b1;            //fill sth. here
            end
        end
    end

    // ctrl signals should be combinational logic
    // RO
    always @ (*) begin
        ALU_en = 0;
        MEM_en = 0;
        MUL_en = 0;
        DIV_en = 0;
        JUMP_en = 0;

        rs1_ctrl = 0;
        rs2_ctrl = 0;
        PC_ctrl = 0;
        imm_ctrl = 0;
        JUMP_op = 0;
        ALU_op = 0;
        ALU_use_PC = 0;
        ALU_use_imm = 0;
        MEM_we = 0;
        MEM_bhw = 0;
        MUL_op = 0;
        DIV_op = 0;

        // JUMP
        if (FUS[`FU_JUMP][`RDY1] & FUS[`FU_JUMP][`RDY2]) begin
            ALU_en = 1'b0;
            MEM_en = 1'b0;
            MUL_en = 1'b0;
            DIV_en = 1'b0;
            JUMP_en = 1'b1;

            JUMP_op = FUS[`FU_JUMP][`OP_H:`OP_L];
            rs1_ctrl = FUS[`FU_JUMP][`SRC1_H:`SRC1_L];
            rs2_ctrl = FUS[`FU_JUMP][`SRC2_H:`SRC2_L];
            PC_ctrl = PCR[`FU_JUMP];
            imm_ctrl = IMM[`FU_JUMP];
        end
        // ALU
        else if (FUS[`FU_ALU][`RDY1] & FUS[`FU_ALU][`RDY2]) begin
            ALU_en = 1'b1;
            MEM_en = 1'b0;
            MUL_en = 1'b0;
            DIV_en = 1'b0;
            JUMP_en = 1'b0;

            ALU_op = FUS[`FU_ALU][`OP_H:`OP_L] == `ALU_AUIPC ? 
                      4'b0001 : FUS[`FU_ALU][`OP_L+3:`OP_L];
            rs1_ctrl = FUS[`FU_ALU][`SRC1_H:`SRC1_L];
            rs2_ctrl = FUS[`FU_ALU][`SRC2_H:`SRC2_L];
            ALU_use_PC = FUS[`FU_ALU][`OP_H:`OP_L] == `ALU_AUIPC;
            ALU_use_imm = FUS[`FU_ALU][`OP_H];
            PC_ctrl = PCR[`FU_ALU];
            imm_ctrl = IMM[`FU_ALU];
        end
        // MEM
        else if (FUS[`FU_MEM][`RDY1] & FUS[`FU_MEM][`RDY2]) begin
            ALU_en = 1'b0;
            MEM_en = 1'b1;
            MUL_en = 1'b0;
            DIV_en = 1'b0;
            JUMP_en = 1'b0;

            MEM_we = FUS[`FU_MEM][`OP_L];
            MEM_bhw = FUS[`FU_MEM][`OP_L+3:`OP_L+1];
            rs1_ctrl = FUS[`FU_MEM][`SRC1_H:`SRC1_L];
            rs2_ctrl = FUS[`FU_MEM][`SRC2_H:`SRC2_L];   // if store
            imm_ctrl = IMM[`FU_MEM];
        end
        // MUL
        else if (FUS[`FU_MUL][`RDY1] & FUS[`FU_MUL][`RDY2]) begin
            ALU_en = 1'b0;
            MEM_en = 1'b0;
            MUL_en = 1'b1;
            DIV_en = 1'b0;
            JUMP_en = 1'b0;

            MUL_op = FUS[`FU_MUL][`OP_L+2:`OP_L];
            rs1_ctrl = FUS[`FU_MUL][`SRC1_H:`SRC1_L];
            rs2_ctrl = FUS[`FU_MUL][`SRC2_H:`SRC2_L];
        end
        else if (FUS[`FU_DIV][`RDY1] & FUS[`FU_DIV][`RDY2]) begin
            ALU_en = 1'b0;
            MEM_en = 1'b0;
            MUL_en = 1'b0;
            DIV_en = 1'b1;
            JUMP_en = 1'b0;
            
            DIV_op = FUS[`FU_DIV][`OP_L+1:`OP_L];
            rs1_ctrl = FUS[`FU_DIV][`SRC1_H:`SRC1_L];
            rs2_ctrl = FUS[`FU_DIV][`SRC2_H:`SRC2_L];
        end
    end

    // WB
    always @ (*) begin
        write_sel = 0;
        reg_write = 0;
        rd_ctrl = 0;

        if (FUS[`FU_JUMP][`FU_DONE] & JUMP_WAR) begin
            write_sel = 3'd4;
            reg_write = 1'b1;
            rd_ctrl = FUS[`FU_JUMP][`DST_H:`DST_L];
        end
        else if (FUS[`FU_ALU][`FU_DONE] & ALU_WAR) begin
            write_sel = 3'd0;
            reg_write = 1'b1;
            rd_ctrl = FUS[`FU_ALU][`DST_H:`DST_L];
        end
        else if (FUS[`FU_MEM][`FU_DONE] & MEM_WAR) begin
            write_sel = 3'd1;
            reg_write = 1'b1;
            rd_ctrl = FUS[`FU_MEM][`DST_H:`DST_L];
        end
        else if (FUS[`FU_MUL][`FU_DONE] & MUL_WAR) begin
            write_sel = 3'd2;
            reg_write = 1'b1;
            rd_ctrl = FUS[`FU_MUL][`DST_H:`DST_L];
        end
        else if (FUS[`FU_DIV][`FU_DONE] & DIV_WAR) begin
            write_sel = 3'd3;
            reg_write = 1'b1;
            rd_ctrl = FUS[`FU_DIV][`DST_H:`DST_L];
        end
    end
endmodule