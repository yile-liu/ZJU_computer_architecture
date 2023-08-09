`timescale 1ns / 1ps
module Code2Inst (
    input[31:0] code,
    output reg [19*8-1:0] inst
);
/*
    wire[3*8-1:0] INST_rd ={"x", num2str({3'b000,code[11]}), num2str(code[10:7])};            
    wire[3*8-1:0] INST_rs1 ={"x", num2str({3'b000,code[19]}), num2str(code[18:15])};            
    wire[3*8-1:0] INST_rs2 ={"x", num2str({3'b000,code[24]}), num2str(code[23:20])};  
    wire[3*8-1:0] imm_12 ={num2str(code[31:28]), num2str(code[27:24]), num2str(code[23:20])};
    wire[3*8-1:0] Simm_12 ={num2str(code[31:28]), num2str({code[27:25],code[11]}), num2str(code[10:7])};
    
    wire[4*8-1:0] SBim_12 ={num2str(code[31]),num2str({ code[7],code[30:28]}), num2str({code[27:25],code[11]}), num2str({code[10:8],1'b0})};
    wire[6*8-1:0] UJim_20 ={num2str(code[31]),num2str(code[19:16]),num2str(code[15:12]),num2str({code[20],code[30:28]}), num2str(code[27:24]), num2str({code[23:21],1'b0})};
    wire[5*8-1:0] Uimm_20 ={num2str(code[31:28]),num2str(code[27:24]),num2str(code[23:20]), num2str(code[19:16]), num2str(code[15:12])};
    
    wire[13*8-1:0] R_Type = {" ", INST_rd,",", INST_rs1,",",INST_rs2, " "};         //3*3+2=11     1
    wire[13*8-1:0] I_Type = {" ", INST_rd,",", INST_rs1,",", imm_12, "H"};          //3*3+2=11      1
    wire[13*8-1:0] S_Type = {" ", INST_rs1,",", INST_rs2,",", Simm_12, "H"};        //3*3+2=11     1
    wire[13*8-1:0] SB_Type = {" ",INST_rs1,",", INST_rs2,",", SBim_12};             //2*3+4+2=12    0
    wire[13*8-1:0] UJ_Type = {" ",INST_rd,",", UJim_20, "H "};                      //3+6+1=10    1  
    wire[13*8-1:0] U_Type = {" ", INST_rd,",", Uimm_20, "H  "};                     //3+5+1=9    3
    
    always @* begin 
        if(code==32'h00000000) inst = "nop DStall:lw 00   ";
        else if(code==32'h00000013) inst = "nop JStall:addi0   ";
        else 
        case(code[6:2])                                             //OP
            5'b01100:begin
                case({code[14:12],code[30]})                        //fun3fun7[6]
                    4'b0000: inst = {" add",R_Type, "  "};
                    4'b0001: inst = {" sub",R_Type, "  "};
                    4'b1110: inst = {" and",R_Type, "  "};
                    4'b1100: inst = {" or",R_Type, "   "};
                    4'b0100: inst = {" slt",R_Type, "  "};
                    4'b0110: inst = {" sltu",R_Type, " "};
                    4'b1010: inst = {" srl",R_Type, "  "};
                    4'b1000: inst = {" xor",R_Type, "  "};
                    4'b0010: inst = {" sll",R_Type, "  "};
                    default: inst = "illegal instruction";          //illegal instruction     
                    endcase
            end
            5'b00000: inst = {" lw",I_Type, "   "};
            5'b01000: inst = {" sw",S_Type, "   "};
            5'b11000: begin
                case(code[14:12])
                    3'b000: inst = {"beq",SB_Type, "   "};
                    3'b001: inst = {"bne",SB_Type, "   "};
                    3'b100: inst = {"blt",SB_Type, "   "};
                    default: inst = "illegal instruction";          //illegal instruction
                endcase
            end
            5'b11011: inst = {"jal", UJ_Type, "  "};
            5'b11001: inst = {"jalr", I_Type, "  "};
            5'b00100: begin 
                case(code[14:12])                                   //ALU(I): fun3
                    3'b000: inst = {"addi", I_Type, "  "};
                    3'b111: inst = {"andi", I_Type, "  "};
                    3'b110: inst = {"ori", I_Type, "  "};
                    3'b010: inst = {"slti", I_Type, "  "};
                    3'b011: inst = {"sltiu", I_Type};
                    3'b101: inst = {"srli", I_Type, "  "};
                    3'b001: inst = {"slli", I_Type, "  "};
                    3'b100: inst = {"xori", I_Type, "  "};
                    default: inst = "illeillegal instruction";      //illegal instruction     
                endcase
            end
            5'b01101: inst = {"lui", U_Type, "  "};
            default:  inst = "illegal instruction";                 //illegal instruction     
        endcase  
    end
    
    function [7:0] num2str;
		input [3:0] number;
		begin
			if (number < 10)
				num2str = "0" + number;
			else
				num2str = "A" - 10 + number;
		end
	endfunction
*/
    initial begin
        inst = "not in use";
    end
endmodule