`timescale 1ps/1ps

module HazardDetectionUnit(
    input clk,
    input Branch_ID, rs1use_ID, rs2use_ID,
    input[1:0] hazard_optype_ID,
    input[4:0] rd_EXE, rd_MEM, rs1_ID, rs2_ID, rs2_EXE,
    output PC_EN_IF, reg_FD_EN, reg_FD_stall, reg_FD_flush,
        reg_DE_EN, reg_DE_flush, reg_EM_EN, reg_EM_flush, reg_MW_EN,
    output forward_ctrl_ls, 
    output[1:0] forward_ctrl_A, forward_ctrl_B 
);
    //according to the diagram, design the Hazard Detection Unit

    assign reg_FD_EN = 1;   //启用Reg_IF_ID寄存器
    assign reg_DE_EN = 1;   //启用Reg_ID_EX寄存器
    assign reg_EM_EN = 1;   //启用Reg_EX_MEM寄存器
    assign reg_MW_EN = 1;   //启用Reg_MEM_WB寄存器

    //持续向指令下一阶段传递信号
    reg[1:0] hazard_optype_EXE, hazard_optype_MEM;
    always@(posedge clk) begin
        hazard_optype_MEM <= hazard_optype_EXE;
        hazard_optype_EXE <= hazard_optype_ID & {2{~reg_DE_flush}};
    end

    localparam hazard_optype_ALU = 2'b01;
    localparam hazard_optype_LOAD = 2'b10;
    localparam hazard_optype_STORE = 2'b11;

    //rs1的forward与stall的情况分类
    wire rs1_stall      = rs1use_ID && rd_EXE && rs1_ID == rd_EXE && hazard_optype_EXE == hazard_optype_LOAD 
                                && hazard_optype_ID != hazard_optype_STORE;    //上一条指令是load，下一条指令的EXE级要使用load的结果，无法forward，只能stall
    wire rs1_forward_1  = rs1use_ID && rd_EXE && rs1_ID == rd_EXE && hazard_optype_EXE == hazard_optype_ALU;     //ALU运算，EXE级的结果forward
    wire rs1_forward_2  = rs1use_ID && rd_MEM && rs1_ID == rd_MEM && hazard_optype_MEM == hazard_optype_ALU;     //ALU运算，MEM级的结果forward
    wire rs1_forward_3  = rs1use_ID && rd_MEM && rs1_ID == rd_MEM && hazard_optype_MEM == hazard_optype_LOAD;    //LOAD数据，MEM级的结果forward
    //rs2的forward与stall的情况分类
    wire rs2_stall      = rs2use_ID && rd_EXE && rs2_ID == rd_EXE && hazard_optype_EXE == hazard_optype_LOAD 
                                && hazard_optype_ID != hazard_optype_STORE;    //上一条指令是load，下一条指令的EXE级要使用load的结果，无法forward，只能stall
    wire rs2_forward_1  = rs2use_ID && rd_EXE && rs2_ID == rd_EXE && hazard_optype_EXE == hazard_optype_ALU;     //ALU运算，EXE级的结果forward
    wire rs2_forward_2  = rs2use_ID && rd_MEM && rs2_ID == rd_MEM && hazard_optype_MEM == hazard_optype_ALU;     //ALU运算，MEM级的结果forward
    wire rs2_forward_3  = rs2use_ID && rd_MEM && rs2_ID == rd_MEM && hazard_optype_MEM == hazard_optype_LOAD;    //LOAD数据，MEM级的结果forward

    wire load_stall = rs1_stall | rs2_stall;    //将两个需要stall的情况合并

    assign PC_EN_IF = ~load_stall;      //stall时PC停一个时钟，不取新的指令

    assign reg_FD_stall = load_stall;   //stall则保持存的指令和PC的值不变
    assign reg_DE_flush = load_stall;   //DE寄存器在stall时没有值，指令变成addi x0, x0, 0

    assign reg_FD_flush = Branch_ID;    //前一时钟取到了错误的指令，flush

    assign forward_ctrl_A = {2{rs1_forward_1}} & 2'b01 |
                            {2{rs1_forward_2}} & 2'b10 |
                            {2{rs1_forward_3}} & 2'b11 ;

    assign forward_ctrl_B = {2{rs2_forward_1}} & 2'b01 |
                            {2{rs2_forward_2}} & 2'b10 |
                            {2{rs2_forward_3}} & 2'b11 ;

    assign forward_ctrl_ls = rs2_EXE == rd_MEM && hazard_optype_EXE == hazard_optype_STORE
                            && hazard_optype_MEM == hazard_optype_LOAD;    // load出来的数据立刻store回去，forward到mem

endmodule