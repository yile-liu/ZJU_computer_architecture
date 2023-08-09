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
    wire[31:0] debug_regs;
    reg[31:0] Test_signal;
	assign debug_data = debug_addr[5] ? Test_signal : debug_regs;

    debug_clk clock(.clk(clk),.debug_en(debug_en),.debug_step(debug_step),.debug_clk(debug_clk));

    wire reg_IF_EN, reg_ID_EN, reg_ID_flush, FU_ALU_EN, FU_mem_EN, FU_mul_EN, FU_div_EN, FU_jump_EN;
    wire RegWrite_ctrl, ALUSrcA_ctrl, ALUSrcB_ctrl, mem_w_ctrl, branch_ctrl;
    wire[2:0] ImmSel_ctrl, DatatoReg_ctrl;
    wire[3:0] ALUControl_ctrl, Jump_ctrl;
    wire[4:0] rd_ctrl;


    wire [31:0] PC_IF, next_PC_IF, PC_4_IF, inst_IF;

    wire valid_ID;
    wire[31:0]inst_ID, PC_ID, Imm_out_ID, rs1_data_ID, rs2_data_ID, ALUA_ID, ALUB_ID;

    wire FU_ALU_finish, FU_mem_finish, FU_mul_finish, FU_div_finish, FU_jump_finish, cmp_res_FU;
    wire[31:0]ALUout_FU, mem_data_FU, mulres_FU, divres_FU, PC_jump_FU, PC_wb_FU;

    wire[31:0]ALUout_WB, mem_data_WB, mulres_WB, divres_WB, PC_wb_WB, wt_data_WB;


    // IF
    REG32 REG_PC(.clk(debug_clk),.rst(rst),.CE(reg_IF_EN),.D(next_PC_IF),.Q(PC_IF));
    
    add_32 add_IF(.a(PC_IF),.b(32'd4),.c(PC_4_IF));

    MUX2T1_32 mux_IF(.I0(PC_4_IF),.I1(PC_jump_FU),.s(branch_ctrl),.o(next_PC_IF));

    ROM_D inst_rom(.a(PC_IF[8:2]),.spo(inst_IF));


    //Issue
    REG_ID reg_ID(.clk(debug_clk),.rst(rst),.EN(reg_ID_EN),
        .flush(reg_ID_flush),.PCOUT(PC_IF),.IR(inst_IF),

        .IR_ID(inst_ID),.PCurrent_ID(PC_ID),.valid(valid_ID));
    
    CtrlUnit ctrl(.clk(debug_clk),.rst(rst),.inst(inst_ID),.valid_ID(valid_ID),
        .ALU_done(FU_ALU_finish),.MEM_done(FU_mem_finish),.MUL_done(FU_mul_finish),
        .DIV_done(FU_div_finish),.JUMP_done(FU_jump_finish),.cmp_res_FU(cmp_res_FU),

        .reg_IF_en(reg_IF_EN),.branch_ctrl(branch_ctrl),.reg_ID_en(reg_ID_EN),
        .reg_ID_flush(reg_ID_flush),.ImmSel(ImmSel_ctrl),.ALU_en(FU_ALU_EN),
        .MEM_en(FU_mem_EN),.MUL_en(FU_mul_EN),.DIV_en(FU_div_EN),.JUMP_en(FU_jump_EN),
        .JUMP_op(Jump_ctrl),.ALU_op(ALUControl_ctrl),.MEM_we(mem_w_ctrl),
        .ALUSrcA(ALUSrcA_ctrl),.ALUSrcB(ALUSrcB_ctrl),
        .write_sel(DatatoReg_ctrl),.reg_write(RegWrite_ctrl),.rd_ctrl(rd_ctrl));

    ImmGen imm_gen(.ImmSel(ImmSel_ctrl),.inst_field(inst_ID),.Imm_out(Imm_out_ID));             // FILLED

    Regs register(.clk(debug_clk),.rst(rst),
        .R_addr_A(inst_ID[19:15]),.rdata_A(rs1_data_ID),
        .R_addr_B(inst_ID[24:20]),.rdata_B(rs2_data_ID),
        .L_S(RegWrite_ctrl),.Wt_addr(rd_ctrl),.Wt_data(wt_data_WB),
        .Debug_addr(debug_addr[4:0]),.Debug_regs(debug_regs));

    MUX2T1_32 mux_imm_ALU_ID_A(.I0(rs1_data_ID),.I1(PC_ID),.s(ALUSrcA_ctrl),.o(ALUA_ID));       // FILLED

    MUX2T1_32 mux_imm_ALU_ID_B(.I0(rs2_data_ID),.I1(Imm_out_ID),.s(ALUSrcB_ctrl),.o(ALUB_ID));  // FILLED


    // FU
    FU_ALU alu(.clk(debug_clk),.EN(FU_ALU_EN),.finish(FU_ALU_finish),
        .ALUControl(ALUControl_ctrl),.ALUA(ALUA_ID),.ALUB(ALUB_ID),.res(ALUout_FU),
        .zero(),.overflow());

    FU_mem mem(.clk(debug_clk),.EN(FU_mem_EN),.finish(FU_mem_finish),
        .mem_w(mem_w_ctrl),.bhw(inst_ID[14:12]),.rs1_data(rs1_data_ID),.rs2_data(rs2_data_ID),
        .imm(Imm_out_ID),.mem_data(mem_data_FU));

    FU_mul mu(.clk(debug_clk),.EN(FU_mul_EN),.finish(FU_mul_finish),
        .A(rs1_data_ID),.B(rs2_data_ID),.res(mulres_FU));

    FU_div du(.clk(debug_clk),.EN(FU_div_EN),.finish(FU_div_finish),
        .A(rs1_data_ID),.B(rs2_data_ID),.res(divres_FU));

    FU_jump ju(.clk(debug_clk),.EN(FU_jump_EN),.finish(FU_jump_finish),
        .JALR(Jump_ctrl[3]),.cmp_ctrl(Jump_ctrl[2:0]),.rs1_data(rs1_data_ID),.rs2_data(rs2_data_ID),
        .imm(Imm_out_ID),.PC(PC_ID),.PC_jump(PC_jump_FU),.PC_wb(PC_wb_FU),.cmp_res(cmp_res_FU));


    // WB
    REG32 reg_WB_ALU(.clk(debug_clk),.rst(rst),.CE(FU_ALU_finish),.D(ALUout_FU),.Q(ALUout_WB));

    REG32 reg_WB_mem(.clk(debug_clk),.rst(rst),.CE(FU_mem_finish),.D(mem_data_FU),.Q(mem_data_WB));

    REG32 reg_WB_mul(.clk(debug_clk),.rst(rst),.CE(FU_mul_finish),.D(mulres_FU),.Q(mulres_WB));

    REG32 reg_WB_div(.clk(debug_clk),.rst(rst),.CE(FU_div_finish),.D(divres_FU),.Q(divres_WB));
    
    REG32 reg_WB_jump(.clk(debug_clk),.rst(rst),.CE(FU_jump_finish),.D(PC_wb_FU),.Q(PC_wb_WB));
    
    MUX8T1_32 mux_DtR(.s(DatatoReg_ctrl),.I0(32'd0),.I1(ALUout_WB),.I2(mem_data_WB),.I3(mulres_WB),
        .I4(divres_WB),.I5(PC_wb_WB),.I6(32'd0),.I7(32'd0),.o(wt_data_WB));                         // FILLED                       


    always @* begin
        case (debug_addr[4:0])
            0:  Test_signal = PC_IF;
            1:  Test_signal = inst_IF;
            2:  Test_signal = PC_ID;  
            3:  Test_signal = inst_ID;

            4:  Test_signal = inst_ID[19:15];
            5:  Test_signal = rs1_data_ID;
            6:  Test_signal = inst_ID[24:20];
            7:  Test_signal = rs2_data_ID;

            8:  Test_signal = ImmSel_ctrl;
            9:  Test_signal = Imm_out_ID;
            10: Test_signal = ALUout_FU;
            11: Test_signal = reg_IF_EN;

            12: Test_signal = {15'b0, FU_ALU_EN, 15'b0, FU_ALU_finish};
            13: Test_signal = ALUControl_ctrl;
            14: Test_signal = ALUA_ID;
            15: Test_signal = ALUB_ID;

            16: Test_signal = {15'b0, FU_mem_EN, 15'b0, FU_mem_finish};
            17: Test_signal = mem_w_ctrl;
            18: Test_signal = inst_ID[14:12];
            19: Test_signal = mem_data_FU;

            20: Test_signal = {15'b0, FU_mul_EN, 15'b0, FU_mul_finish};
            21: Test_signal = mulres_FU;
            22: Test_signal = {15'b0, FU_div_EN, 15'b0, FU_div_finish};
            23: Test_signal = divres_FU;

            24: Test_signal = {15'b0, FU_jump_EN, 15'b0, FU_jump_finish};
            25: Test_signal = Jump_ctrl;
            26: Test_signal = PC_jump_FU;
            27: Test_signal = PC_wb_FU;

            28: Test_signal = RegWrite_ctrl;
            29: Test_signal = rd_ctrl;
            30: Test_signal = DatatoReg_ctrl;
            31: Test_signal = wt_data_WB;
            
            default: Test_signal = 32'hAA55_AA55;
        endcase
    end

endmodule