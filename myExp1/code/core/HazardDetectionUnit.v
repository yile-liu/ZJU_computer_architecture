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

    assign reg_FD_EN = 1;   //����Reg_IF_ID�Ĵ���
    assign reg_DE_EN = 1;   //����Reg_ID_EX�Ĵ���
    assign reg_EM_EN = 1;   //����Reg_EX_MEM�Ĵ���
    assign reg_MW_EN = 1;   //����Reg_MEM_WB�Ĵ���

    //������ָ����һ�׶δ����ź�
    reg[1:0] hazard_optype_EXE, hazard_optype_MEM;
    always@(posedge clk) begin
        hazard_optype_MEM <= hazard_optype_EXE;
        hazard_optype_EXE <= hazard_optype_ID & {2{~reg_DE_flush}};
    end

    localparam hazard_optype_ALU = 2'b01;
    localparam hazard_optype_LOAD = 2'b10;
    localparam hazard_optype_STORE = 2'b11;

    //rs1��forward��stall���������
    wire rs1_stall      = rs1use_ID && rd_EXE && rs1_ID == rd_EXE && hazard_optype_EXE == hazard_optype_LOAD 
                                && hazard_optype_ID != hazard_optype_STORE;    //��һ��ָ����load����һ��ָ���EXE��Ҫʹ��load�Ľ�����޷�forward��ֻ��stall
    wire rs1_forward_1  = rs1use_ID && rd_EXE && rs1_ID == rd_EXE && hazard_optype_EXE == hazard_optype_ALU;     //ALU���㣬EXE���Ľ��forward
    wire rs1_forward_2  = rs1use_ID && rd_MEM && rs1_ID == rd_MEM && hazard_optype_MEM == hazard_optype_ALU;     //ALU���㣬MEM���Ľ��forward
    wire rs1_forward_3  = rs1use_ID && rd_MEM && rs1_ID == rd_MEM && hazard_optype_MEM == hazard_optype_LOAD;    //LOAD���ݣ�MEM���Ľ��forward
    //rs2��forward��stall���������
    wire rs2_stall      = rs2use_ID && rd_EXE && rs2_ID == rd_EXE && hazard_optype_EXE == hazard_optype_LOAD 
                                && hazard_optype_ID != hazard_optype_STORE;    //��һ��ָ����load����һ��ָ���EXE��Ҫʹ��load�Ľ�����޷�forward��ֻ��stall
    wire rs2_forward_1  = rs2use_ID && rd_EXE && rs2_ID == rd_EXE && hazard_optype_EXE == hazard_optype_ALU;     //ALU���㣬EXE���Ľ��forward
    wire rs2_forward_2  = rs2use_ID && rd_MEM && rs2_ID == rd_MEM && hazard_optype_MEM == hazard_optype_ALU;     //ALU���㣬MEM���Ľ��forward
    wire rs2_forward_3  = rs2use_ID && rd_MEM && rs2_ID == rd_MEM && hazard_optype_MEM == hazard_optype_LOAD;    //LOAD���ݣ�MEM���Ľ��forward

    wire load_stall = rs1_stall | rs2_stall;    //��������Ҫstall������ϲ�

    assign PC_EN_IF = ~load_stall;      //stallʱPCͣһ��ʱ�ӣ���ȡ�µ�ָ��

    assign reg_FD_stall = load_stall;   //stall�򱣳ִ��ָ���PC��ֵ����
    assign reg_DE_flush = load_stall;   //DE�Ĵ�����stallʱû��ֵ��ָ����addi x0, x0, 0

    assign reg_FD_flush = Branch_ID;    //ǰһʱ��ȡ���˴����ָ�flush

    assign forward_ctrl_A = {2{rs1_forward_1}} & 2'b01 |
                            {2{rs1_forward_2}} & 2'b10 |
                            {2{rs1_forward_3}} & 2'b11 ;

    assign forward_ctrl_B = {2{rs2_forward_1}} & 2'b01 |
                            {2{rs2_forward_2}} & 2'b10 |
                            {2{rs2_forward_3}} & 2'b11 ;

    assign forward_ctrl_ls = rs2_EXE == rd_MEM && hazard_optype_EXE == hazard_optype_STORE
                            && hazard_optype_MEM == hazard_optype_LOAD;    // load��������������store��ȥ��forward��mem

endmodule