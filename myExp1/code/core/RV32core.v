`timescale 1ns / 1ps


module  RV32core(
        input debug_en,  // debug enable
        input debug_step,  // debug step clock
        input [6:0] debug_addr,  // debug address
        output[31:0] debug_data,  // debug data
        input clk,  // main clock
        input rst,  // synchronous reset
        input interrupter  // interrupt source, for future use
    );

    wire debug_clk;

    debug_clk clock(.clk(clk),.debug_en(debug_en),.debug_step(debug_step),.debug_clk(debug_clk));

    wire Branch_ctrl, JALR, RegWrite_ctrl, mem_w_ctrl, MIO_ctrl,
        ALUSrc_A_ctrl, ALUSrc_B_ctrl, DatatoReg_ctrl, rs1use_ctrl, rs2use_ctrl;
    wire[1:0] hazard_optype_ctrl;
    wire[2:0] ImmSel_ctrl, cmp_ctrl;
    wire[3:0] ALUControl_ctrl;

    wire forward_ctrl_ls;
    wire[1:0] forward_ctrl_A, forward_ctrl_B;

    wire PC_EN_IF;
    wire [31:0] PC_IF, next_PC_IF, PC_4_IF, inst_IF;

    wire reg_FD_EN,reg_FD_stall,reg_FD_flush, cmp_res_ID;
    wire [31:0] jump_PC_ID, PC_ID, inst_ID, Debug_regs, rs1_data_reg, rs2_data_reg,
        Imm_out_ID, rs1_data_ID, rs2_data_ID, addA_ID;
    
    wire reg_DE_EN, reg_DE_flush, RegWrite_EXE, mem_w_EXE, MIO_EXE,
        ALUSrc_A_EXE, ALUSrc_B_EXE, ALUzero_EXE, ALUoverflow_EXE, DatatoReg_EXE;
    wire[2:0] u_b_h_w_EXE;
    wire[3:0] ALUControl_EXE;
    wire[4:0] rs1_EXE, rs2_EXE, rd_EXE;
    wire[31:0] ALUout_EXE, PC_EXE, inst_EXE, rs1_data_EXE, rs2_data_EXE, Imm_EXE,
        ALUA_EXE, ALUB_EXE, Dataout_EXE;
    
    wire reg_EM_EN, reg_EM_flush, RegWrite_MEM, DatatoReg_MEM, mem_w_MEM, MIO_MEM;
    wire[2:0] u_b_h_w_MEM;
    wire[4:0] rd_MEM;
    wire[31:0] ALUout_MEM, PC_MEM, inst_MEM, Dataout_MEM, Datain_MEM;


    wire reg_MW_EN, RegWrite_WB, DatatoReg_WB;
    wire[4:0] rd_WB;
    wire [31:0] wt_data_WB, PC_WB, inst_WB, ALUout_WB, Datain_WB;


    // IF
    REG32 REG_PC(.clk(debug_clk),.rst(rst),.CE(PC_EN_IF),.D(next_PC_IF),.Q(PC_IF));
    
    add_32 add_IF(.a(PC_IF),.b(32'd4),.c(PC_4_IF));

    MUX2T1_32 mux_IF(.I0(PC_4_IF),.I1(jump_PC_ID),.s(Branch_ctrl),.o(next_PC_IF));        //to fill sth. in ()

    ROM_D inst_rom(.a(PC_IF[8:2]),.spo(inst_IF));


    // ID
    REG_IF_ID reg_IF_ID(.clk(debug_clk),.rst(rst),.EN(reg_FD_EN),.Data_stall(reg_FD_stall),
        .flush(reg_FD_flush),.PCOUT(PC_IF),.IR(inst_IF),

        .IR_ID(inst_ID),.PCurrent_ID(PC_ID));
    
    CtrlUnit ctrl(.inst(inst_ID),.cmp_res(cmp_res_ID),.Branch(Branch_ctrl),.ALUSrc_A(ALUSrc_A_ctrl),
        .ALUSrc_B(ALUSrc_B_ctrl),.DatatoReg(DatatoReg_ctrl),.RegWrite(RegWrite_ctrl),
        .mem_w(mem_w_ctrl),.MIO(MIO_ctrl),.rs1use(rs1use_ctrl),.rs2use(rs2use_ctrl),
        .hazard_optype(hazard_optype_ctrl),.ImmSel(ImmSel_ctrl),.cmp_ctrl(cmp_ctrl),
        .ALUControl(ALUControl_ctrl),.JALR(JALR));
    
    Regs register(.clk(debug_clk),.rst(rst),.L_S(RegWrite_WB),.R_addr_A(inst_ID[19:15]),
        .R_addr_B(inst_ID[24:20]),.rdata_A(rs1_data_reg),.rdata_B(rs2_data_reg),
        .Wt_addr(rd_WB),.Wt_data(wt_data_WB),
        .Debug_addr(debug_addr[4:0]),.Debug_regs(Debug_regs));
    
    ImmGen imm_gen(.ImmSel(ImmSel_ctrl),.inst_field(inst_ID),.Imm_out(Imm_out_ID));
    
    MUX4T1_32 mux_forward_A(.I0(rs1_data_reg),.I1(ALUout_EXE),.I2(ALUout_MEM),.I3(Datain_MEM),        //to fill sth. in ()
        .s(forward_ctrl_A),.o(rs1_data_ID));
    
    MUX4T1_32 mux_forward_B(.I0(rs2_data_reg),.I1(ALUout_EXE),.I2(ALUout_MEM),.I3(Datain_MEM),        //to fill sth. in ()
        .s(forward_ctrl_B),.o(rs2_data_ID));
    
    MUX2T1_32 mux_branch_ID(.I0(PC_ID),.I1(rs1_data_ID),.s(JALR),.o(addA_ID));

    add_32 add_branch_ID(.a(addA_ID),.b(Imm_out_ID),.c(jump_PC_ID));

    cmp_32 cmp_ID(.a(rs1_data_ID),.b(rs2_data_ID),.ctrl(cmp_ctrl),.c(cmp_res_ID));        
    
    HazardDetectionUnit hazard_unit(.clk(debug_clk),.Branch_ID(Branch_ctrl),.rs1use_ID(rs1use_ctrl),
        .rs2use_ID(rs2use_ctrl),.hazard_optype_ID(hazard_optype_ctrl),.rd_EXE(rd_EXE),
        .rd_MEM(rd_MEM),.rs1_ID(inst_ID[19:15]),.rs2_ID(inst_ID[24:20]),.rs2_EXE(rs2_EXE),
        .PC_EN_IF(PC_EN_IF),.reg_FD_EN(reg_FD_EN),.reg_FD_stall(reg_FD_stall),
        .reg_FD_flush(reg_FD_flush),.reg_DE_EN(reg_DE_EN),.reg_DE_flush(reg_DE_flush),
       .reg_EM_EN(reg_EM_EN),.reg_EM_flush(reg_EM_flush),.reg_MW_EN(reg_MW_EN),
        .forward_ctrl_ls(forward_ctrl_ls),.forward_ctrl_A(forward_ctrl_A),
        .forward_ctrl_B(forward_ctrl_B));


    // EX
    REG_ID_EX reg_ID_EX(.clk(debug_clk),.rst(rst),.EN(reg_DE_EN),.flush(reg_DE_flush),.IR_ID(inst_ID),
        .PCurrent_ID(PC_ID),.rs1_addr(inst_ID[19:15]),.rs2_addr(inst_ID[24:20]),.rs1_data(rs1_data_ID),
        .rs2_data(rs2_data_ID),.Imm32(Imm_out_ID),.rd_addr(inst_ID[11:7]),.ALUSrc_A(ALUSrc_A_ctrl),
        .ALUSrc_B(ALUSrc_B_ctrl),.ALUC(ALUControl_ctrl),.DatatoReg(DatatoReg_ctrl),
        .RegWrite(RegWrite_ctrl),.WR(mem_w_ctrl),.u_b_h_w(inst_ID[14:12]),.MIO(MIO_ctrl),

        .PCurrent_EX(PC_EXE),.IR_EX(inst_EXE),.rs1_EX(rs1_EXE),.rs2_EX(rs2_EXE),
        .A_EX(rs1_data_EXE),.B_EX(rs2_data_EXE),.Imm32_EX(Imm_EXE),.rd_EX(rd_EXE),
        .ALUSrc_A_EX(ALUSrc_A_EXE),.ALUSrc_B_EX(ALUSrc_B_EXE),.ALUC_EX(ALUControl_EXE),
        .DatatoReg_EX(DatatoReg_EXE),.RegWrite_EX(RegWrite_EXE),.WR_EX(mem_w_EXE),
        .u_b_h_w_EX(u_b_h_w_EXE),.MIO_EX(MIO_EXE));
    
    MUX2T1_32 mux_A_EXE(.I0(rs1_data_EXE),.I1(PC_EXE),.s(ALUSrc_A_EXE),.o(ALUA_EXE));     //to fill sth. in ()
    
    MUX2T1_32 mux_B_EXE(.I0(rs2_data_EXE),.I1(Imm_EXE),.s(ALUSrc_B_EXE),.o(ALUB_EXE));       //to fill sth. in ()

    ALU alu(.A(ALUA_EXE),.B(ALUB_EXE),.Control(ALUControl_EXE),
        .res(ALUout_EXE),.zero(ALUzero_EXE),.overflow(ALUoverflow_EXE));
    
    MUX2T1_32 mux_forward_EXE(.I0(rs2_data_EXE),.I1(Datain_MEM),.s(forward_ctrl_ls),.o(Dataout_EXE));        //to fill sth. in ()


    // MEM
    REG_EX_MEM reg_EXE_MEM(.clk(debug_clk),.rst(rst),.EN(reg_EM_EN),.flush(reg_EM_flush),
        .IR_EX(inst_EXE),.PCurrent_EX(PC_EXE),.ALUO_EX(ALUout_EXE),.B_EX(Dataout_EXE),
        .rd_EX(rd_EXE),.DatatoReg_EX(DatatoReg_EXE),.RegWrite_EX(RegWrite_EXE),
        .WR_EX(mem_w_EXE),.u_b_h_w_EX(u_b_h_w_EXE),.MIO_EX(MIO_EXE),

        .PCurrent_MEM(PC_MEM),.IR_MEM(inst_MEM),.ALUO_MEM(ALUout_MEM),.Datao_MEM(Dataout_MEM),
        .rd_MEM(rd_MEM),.DatatoReg_MEM(DatatoReg_MEM),.RegWrite_MEM(RegWrite_MEM),
        .WR_MEM(mem_w_MEM),.u_b_h_w_MEM(u_b_h_w_MEM),.MIO_MEM(MIO_MEM));
    
    RAM_B data_ram(.addra(ALUout_MEM),.clka(debug_clk),.dina(Dataout_MEM), 
        .wea(mem_w_MEM),.douta(Datain_MEM),.mem_u_b_h_w(u_b_h_w_MEM));


    // WB
    REG_MEM_WB reg_MEM_WB(.clk(debug_clk),.rst(rst),.EN(reg_MW_EN),.IR_MEM(inst_MEM),
        .PCurrent_MEM(PC_MEM),.ALUO_MEM(ALUout_MEM),.Datai(Datain_MEM),.rd_MEM(rd_MEM),
        .DatatoReg_MEM(DatatoReg_MEM),.RegWrite_MEM(RegWrite_MEM),

        .PCurrent_WB(PC_WB),.IR_WB(inst_WB),.ALUO_WB(ALUout_WB),.MDR_WB(Datain_WB),
        .rd_WB(rd_WB),.DatatoReg_WB(DatatoReg_WB),.RegWrite_WB(RegWrite_WB));
    
    MUX2T1_32 mux_WB(.I0(ALUout_WB),.I1(Datain_WB),.s(DatatoReg_WB),.o(wt_data_WB));


    wire [31:0] Test_signal;
    assign debug_data = debug_addr[5] ? Test_signal : Debug_regs;
    
    CPUTEST    U1_3(.PC_IF(PC_IF),
                    .PC_ID(PC_ID),
                    .PC_EXE(PC_EXE),
                    .PC_MEM(PC_MEM),
                    .PC_WB(PC_WB),
                    .PC_next_IF(next_PC_IF),
                    .PCJump(jump_PC_ID),
                    .inst_IF(inst_IF),
                    .inst_ID(inst_ID),
                    .inst_EXE(inst_EXE),
                    .inst_MEM(inst_MEM),
                    .inst_WB(inst_WB),
                    .PCEN(PC_EN_IF),
                    .Branch(Branch_ctrl),
                    .PCSource(Branch_ctrl),
                    .RS1DATA(rs1_data_reg),
                    .RS2DATA(rs2_data_reg),
                    .Imm32(Imm_out_ID),
                    .ImmSel(ImmSel_ctrl),
                    .ALUC(ALUControl_ctrl),
                    .ALUSrc_A(ALUSrc_A_ctrl),
                    .ALUSrc_B(ALUSrc_B_ctrl),
                    .A(ALUA_EXE),
                    .B(ALUB_EXE),
                    .ALU_out(ALUout_MEM),
                    .Datai(Datain_MEM),
                    .Datao(Dataout_MEM),
                    .Addr(Addr),
                    .WR(MWR),
                    .MIO(MIO_MEM),
                    .WDATA(wt_data_WB),
                    .DatatoReg(DatatoReg_WB),
                    .RegWrite(RegWrite_WB),
                    .data_hazard(reg_FD_stall),
                    .control_hazard(Branch_ctrl),

                    .Debug_addr(debug_addr[4:0]),
                    .Test_signal(Test_signal)    
                    );

endmodule