`timescale 1ns / 1ps

module ImmGen(
            input  wire [2:0] ImmSel,
            input  wire [31:0] inst_field,
            output[31:0] Imm_out
    );
    parameter Imm_type_I = 3'b001;
    parameter Imm_type_B = 3'b010;
    parameter Imm_type_J = 3'b011;
    parameter Imm_type_S = 3'b100;
    parameter Imm_type_U = 3'b101;

    wire I = ImmSel == Imm_type_I;
    wire B = ImmSel == Imm_type_B;
    wire J = ImmSel == Imm_type_J;
    wire S = ImmSel == Imm_type_S;
    wire U = ImmSel == Imm_type_U;

    wire[31:0] Imm_I = {{20{inst_field[31]}}, inst_field[31:20]};
    wire[31:0] Imm_B = {{20{inst_field[31]}}, inst_field[7], inst_field[30:25], inst_field[11:8], 1'b0};
    wire[31:0] Imm_J = {{12{inst_field[31]}}, inst_field[19:12], inst_field[20], inst_field[30:21],1'b0};
    wire[31:0] Imm_S = {{20{inst_field[31]}}, inst_field[31:25], inst_field[11:7]};
    wire[31:0] Imm_U = {inst_field[31:12], 12'b0};

    assign Imm_out = {32{I}} & Imm_I |
                     {32{B}} & Imm_B |
                     {32{J}} & Imm_J |
                     {32{S}} & Imm_S |
                     {32{U}} & Imm_U ;
endmodule
