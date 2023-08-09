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

    wire PC_EN_IF, IS_EN, FU_ALU_EN, FU_mem_EN, FU_mul_EN, FU_div_EN, FU_jump_EN;
    wire RegWrite_ctrl, ALUSrcA_ctrl, ALUSrcB_ctrl, mem_w_ctrl;
    wire[2:0] ImmSel_ctrl, bhw_ctrl, DatatoReg_ctrl;
    wire[3:0] ALUControl_ctrl;
    wire[4:0] Jump_ctrl;
    wire[4:0] rs1_addr_ctrl, rs2_addr_ctrl, rd_ctrl;
    wire[31:0] PC_ctrl, imm_ctrl;


    wire [31:0] PC_IF, next_PC_IF, PC_4_IF, inst_IF;

    wire[31:0]inst_IS, PC_IS, Imm_out_IS;

    wire[31:0]rs1_data_RO, rs2_data_RO, ALUA_RO, ALUB_RO;

    wire FU_ALU_finish, FU_mem_finish, FU_mul_finish, FU_div_finish, FU_jump_finish, is_jump_FU;
    wire[31:0]ALUout_FU, mem_data_FU, mulres_FU, divres_FU, PC_jump_FU, PC_wb_FU;

    wire[31:0]ALUout_WB, mem_data_WB, mulres_WB, divres_WB, PC_wb_WB, wt_data_WB;


    // IF
    assign PC_EN_IF = IS_EN | FU_jump_finish & is_jump_FU;

    REG32 REG_PC(.clk(debug_clk),.rst(rst),.CE(PC_EN_IF),.D(next_PC_IF),.Q(PC_IF));
    
    add_32 add_IF(.a(PC_IF),.b(32'd4),.c(PC_4_IF));

    MUX2T1_32 mux_IF(.I0(PC_4_IF),.I1(PC_jump_FU),.s(FU_jump_finish & is_jump_FU),.o(next_PC_IF));

    ROM_D inst_rom(.a(PC_IF[8:2]),.spo(inst_IF));


    //Issue
    REG_IF_IS reg_IF_IS(.clk(debug_clk),.rst(rst),.EN(IS_EN),
        .flush(1'b0),.PCOUT(PC_IF),.IR(inst_IF),

        .IR_IS(inst_IS),.PCurrent_IS(PC_IS));
    
    ImmGen imm_gen(.ImmSel(ImmSel_ctrl),.inst_field(inst_IS),.Imm_out(Imm_out_IS));

    CtrlUnit ctrl(.clk(debug_clk),.rst(rst),.PC(PC_IS),.inst(inst_IS),.imm(Imm_out_IS),
        .ALU_done(FU_ALU_finish),.MEM_done(FU_mem_finish),.MUL_done(FU_mul_finish),.DIV_done(FU_div_finish),.JUMP_done(FU_jump_finish),.is_jump(is_jump_FU),
        .IS_en(IS_EN),.ImmSel(ImmSel_ctrl),.ALU_en(FU_ALU_EN),
        .MEM_en(FU_mem_EN),.MUL_en(FU_mul_EN),.DIV_en(FU_div_EN),.JUMP_en(FU_jump_EN),
        .PC_ctrl(PC_ctrl),.imm_ctrl(imm_ctrl),.rs1_ctrl(rs1_addr_ctrl),.rs2_ctrl(rs2_addr_ctrl),
        .JUMP_op(Jump_ctrl),.ALU_op(ALUControl_ctrl),.ALU_use_PC(ALUSrcA_ctrl),.ALU_use_imm(ALUSrcB_ctrl),
        .MEM_we(mem_w_ctrl),.MEM_bhw(bhw_ctrl),.MUL_op(),.DIV_op(),
        .write_sel(DatatoReg_ctrl),.reg_write(RegWrite_ctrl),.rd_ctrl(rd_ctrl)    
    );


    // RO
    Regs register(.clk(debug_clk),.rst(rst),
        .R_addr_A(rs1_addr_ctrl),.rdata_A(rs1_data_RO),
        .R_addr_B(rs2_addr_ctrl),.rdata_B(rs2_data_RO),
        .L_S(RegWrite_ctrl),.Wt_addr(rd_ctrl),.Wt_data(wt_data_WB),
        .Debug_addr(debug_addr[4:0]),.Debug_regs(debug_regs));

    MUX2T1_32 mux_imm_ALU_RO_A(.I0(rs1_data_RO),.I1(PC_ctrl),.s(ALUSrcA_ctrl),.o(ALUA_RO));

    MUX2T1_32 mux_imm_ALU_RO_B(.I0(rs2_data_RO),.I1(imm_ctrl),.s(ALUSrcB_ctrl),.o(ALUB_RO));


    // FU
    FU_ALU alu(.clk(debug_clk),.EN(FU_ALU_EN),.finish(FU_ALU_finish),
        .ALUControl(ALUControl_ctrl),.ALUA(ALUA_RO),.ALUB(ALUB_RO),.res(ALUout_FU),
        .zero(),.overflow());

    FU_mem mem(.clk(debug_clk),.EN(FU_mem_EN),.finish(FU_mem_finish),
        .mem_w(mem_w_ctrl),.bhw(bhw_ctrl),.rs1_data(rs1_data_RO),.rs2_data(rs2_data_RO),
        .imm(imm_ctrl),.mem_data(mem_data_FU));

    FU_mul mu(.clk(debug_clk),.EN(FU_mul_EN),.finish(FU_mul_finish),
        .A(rs1_data_RO),.B(rs2_data_RO),.res(mulres_FU));

    FU_div du(.clk(debug_clk),.EN(FU_div_EN),.finish(FU_div_finish),
        .A(rs1_data_RO),.B(rs2_data_RO),.res(divres_FU));

    FU_jump ju(.clk(debug_clk),.EN(FU_jump_EN),.finish(FU_jump_finish),
        .JALR(Jump_ctrl[4]),.cmp_ctrl(Jump_ctrl[3:0]),.rs1_data(rs1_data_RO),.rs2_data(rs2_data_RO),
        .imm(imm_ctrl),.PC(PC_ctrl),.PC_jump(PC_jump_FU),.PC_wb(PC_wb_FU),.is_jump(is_jump_FU));


    // WB
    REG32 reg_WB_ALU(.clk(debug_clk),.rst(rst),.CE(FU_ALU_finish),.D(ALUout_FU),.Q(ALUout_WB));

    REG32 reg_WB_mem(.clk(debug_clk),.rst(rst),.CE(FU_mem_finish),.D(mem_data_FU),.Q(mem_data_WB));

    REG32 reg_WB_mul(.clk(debug_clk),.rst(rst),.CE(FU_mul_finish),.D(mulres_FU),.Q(mulres_WB));

    REG32 reg_WB_div(.clk(debug_clk),.rst(rst),.CE(FU_div_finish),.D(divres_FU),.Q(divres_WB));
    
    REG32 reg_WB_jump(.clk(debug_clk),.rst(rst),.CE(FU_jump_finish),.D(PC_wb_FU),.Q(PC_wb_WB));

    MUX8T1_32 mux_DtR(.s(DatatoReg_ctrl),.I0(ALUout_WB),.I1(mem_data_WB),.I2(mulres_WB),.I3(divres_WB),
        .I4(PC_wb_WB),.I5(32'd0),.I6(32'd0),.I7(32'd0),.o(wt_data_WB));


    always @* begin
        case (debug_addr[4:0])
            0:  Test_signal = PC_IF;
            1:  Test_signal = inst_IF;
            2:  Test_signal = PC_IS;  
            3:  Test_signal = inst_IS;

            4:  Test_signal = rs1_addr_ctrl;
            5:  Test_signal = rs1_data_RO;
            6:  Test_signal = rs2_addr_ctrl;
            7:  Test_signal = rs2_data_RO;

            8:  Test_signal = ImmSel_ctrl;
            9:  Test_signal = imm_ctrl;
            10: Test_signal = ALUout_FU;
            11: Test_signal = PC_EN_IF;

            12: Test_signal = {15'b0, FU_ALU_EN, 15'b0, FU_ALU_finish};
            13: Test_signal = ALUControl_ctrl;
            14: Test_signal = ALUA_RO;
            15: Test_signal = ALUB_RO;

            16: Test_signal = {15'b0, FU_mem_EN, 15'b0, FU_mem_finish};
            17: Test_signal = mem_w_ctrl;
            18: Test_signal = bhw_ctrl;
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