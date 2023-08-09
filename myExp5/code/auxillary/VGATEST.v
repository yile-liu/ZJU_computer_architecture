`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:35:20 09/25/2017
// Design Name:
// Module Name:    vga_debug
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module VGA_TESTP(
	input clk,
	input clk25,
//	input [9:0] PCol,                                      //改了变量名（建议与VGA文本模式统一，增加VGA外设。但修改问题太多，暂时恢复）
//	input [9:0] PRow,                                      //改了变量�??
    input SWO15,                                           //pipeline 新增 反汇编与指令切换
	input SWO14,                                           //存储数据翻页�??2021 Modify :增加显示两帧ROM数据
	input SWO13,                                           //ROM、RAM切换
	input [31:0] Debug_data,
	input [31:0] MEM_Addr,                                 //2021 新增 ROM测试地址�??
	input [31:0] MEM_Data,                                 //2021 新增 ROM 测试数据�??

	output[3:0] Red,
    output[3:0] Green,
    output[3:0] Blue,
    output VSYNC,
    output HSYNC,

//	output reg [11:0]dout,
	output [6:0] Debug_addr);

reg [8*89-1:0] Headline="Zhejiang University Computer Organization Experimental SOC Test Environment (With RISC-V)";
reg [31:0] data_buf [0:3];
reg [31:0] MEMBUF[0:255];            //存储器测试数据缓存：128单元，后继需要增加，并修改显示定位和格式
reg [7:0] ascii_code;
reg [8*7:0] strdata;
reg [11:0]dout;
wire pixel;
wire [9:0] PRow, PCol;

wire  [9:0] row_addr =  PRow - 10'd35;     // pixel ram row addr
wire  [9:0] col_addr =  PCol- 10'd143;    // pixel ram col addr

wire should_latch_debug_data = (PCol < 10'd143) && (PCol[2:0] == 3'b000) && (row_addr[3:0] == 4'b0000);

wire [4:0] char_index_row = row_addr[8:4] - 3;
wire [6:0] char_index_col = (PCol < 10'd143) ? 0 : (col_addr / 8 + 1);
wire [1:0] char_page = char_index_col / 20;
wire [4:0] char_index_in_page = char_index_col % 20;
//wire [2:0] char_index_in_reg_buf = 7 - (char_index_in_page - 9);               //没有使用   2021 Modify 注释�??

//    assign dout = pixel ? {4'b1111, {4{~Debug_addr[5]}}, {4{~Debug_addr[6]}}} : 12'b1100_0000_0000;         //Debug_addr[5]     12'b111111111111
reg flag;
    always @* begin                                                            // 2021 Modify 区域分色方便观察
       if(pixel)
            if(flag)dout = 12'b0000_0000_1111;
            else
            case(Debug_addr[6:5])
                2'b00:   dout = 12'b1111_1111_1111;
                2'b01:   dout = 12'b0000_0000_1111;
                2'b10:   dout = 12'b0000_1111_1111;
                default: dout = 12'b0000_1111_1111;
            endcase
      else if(SWO15 && ((row_addr[9:4] == 19 && col_addr[9:3] > 21 && col_addr[9:3] < 38)
                    || (row_addr[9:4] == 20 && col_addr[9:3] > 25 && col_addr[9:3] < 42)
                    || (row_addr[9:4] == 21 && col_addr[9:3] > 30 && col_addr[9:3] < 47)
                    || (row_addr[9:4] == 22 && col_addr[9:3] > 35 && col_addr[9:3] < 52)
                    || (row_addr[9:4] == 23 && col_addr[9:3] > 40 && col_addr[9:3] < 58)))
                dout = 12'b1100_1100_1100;
           else dout = 12'b1000_0000_0000;
    end

assign Debug_addr = {char_index_row , PCol[4:3]};
wire[7:0] current_display_reg_addr = {1'b0, char_index_row, char_page};
reg[31:0] code_if, code_id, code_exe, code_mem, code_wb;
wire [19*8-1:0] inst_if, inst_id, inst_exe, inst_mem, inst_wb;
    always @(negedge clk) begin                                     //2021 Modify ：ROM工作数据写入
        MEMBUF[{SWO13,MEM_Addr[8:2]}] <= MEM_Data;                  //SWO13=1缓存RAM,否则ROM
        case(Debug_addr)
            7'b00100001: code_if <= Debug_data;
            7'b00100101: code_id <= Debug_data;
            7'b00101001: code_exe <= Debug_data;
            7'b00101101: code_mem <= Debug_data;
            7'b00110001: code_wb <= Debug_data;
            default: begin
                code_if <= code_if;
                code_id <= code_id;
                code_exe <= code_exe;
                code_mem <= code_mem;
                code_wb <= code_wb;
            end
        endcase
    end

    Code2Inst c2i1(.code(code_if), .inst(inst_if));
    Code2Inst c2i2(.code(code_id), .inst(inst_id));
    Code2Inst c2i3(.code(code_exe), .inst(inst_exe));
    Code2Inst c2i4(.code(code_mem), .inst(inst_mem));
    Code2Inst c2i5(.code(code_wb), .inst(inst_wb));

    wire [31:0] MEMDATA = MEMBUF[{SWO13,1'b0,SWO14 + Debug_addr[5],Debug_addr[4:0]}];  //2021 Modify 显示ROM/RAM数据，没有读过的�??0000_00000H。SWO14控制两帧，每�??32个字

always @(posedge clk) begin                                         //2021 Modify
	if (should_latch_debug_data) begin
		if(Debug_addr[6]) data_buf[Debug_addr[1:0]] <= MEMDATA;   //屏幕下方显示ROM数据
		else data_buf[Debug_addr[1:0]] <= Debug_data;
	end
end
always @(posedge clk) begin
    flag <=0;                                                    //2021 Modify：动态显示定�??
	if ((row_addr < 1 * 16) || (row_addr >= 480 - 1 * 16))
        ascii_code <= " ";
    else if(row_addr[9:4] <= 2)
        ascii_code <= row_addr[9:4] == 1 ? (col_addr[9:3] > 13 && col_addr[9:3] < 68 ) ? Headline[(89 - col_addr[9:3] +13)*8 +:8] : " "
                                         : (col_addr[9:3] > 23 && col_addr[9:3] < 58 ) ? Headline[(34 - col_addr[9:3] +23)*8 +:8] : " ";
    else begin
      if(SWO15 && row_addr[9:4] >= 19 && row_addr[9:4] <= 23 && col_addr[9:3] > 21 && col_addr[9:3] < 60) begin
        if(SWO15 && row_addr[9:4] == 19 && col_addr[9:3] > 21 && col_addr[9:3] < 40)begin
           ascii_code <= inst_if[(38 - col_addr[9:3] +2)*8 +:8] ;
           flag <= 1;
        end
        else if(SWO15 && row_addr[9:4] == 20 && col_addr[9:3] > 25 && col_addr[9:3] < 44)begin
           ascii_code <= inst_id[(42 - col_addr[9:3] +2)*8 +:8] ;
           flag <= 1;
        end
        else if(SWO15 && row_addr[9:4] == 21 && col_addr[9:3] > 30 && col_addr[9:3] < 49)begin
           ascii_code <= inst_exe[(47 - col_addr[9:3] +2)*8 +:8] ;
           flag <= 1;
        end
        else if(SWO15 && row_addr[9:4] == 22 && col_addr[9:3] > 35 && col_addr[9:3] < 54)begin
           ascii_code <= inst_mem[(52 - col_addr[9:3] +2)*8 +:8] ;
           flag <= 1;
        end
        else if(SWO15 && row_addr[9:4] == 23 && col_addr[9:3] > 41 && col_addr[9:3] < 60)begin
           ascii_code <= inst_wb[(58 - col_addr[9:3] +2)*8 +:8] ;
           flag <= 1;
        end
        else ascii_code <= " ";
     end
        else if (col_addr[2:0] == 3'b111) begin     //--------------
            if ((char_index_in_page >= 2) && (char_index_in_page <= 8)) begin
                    ascii_code <= strdata[(6 - (char_index_in_page - 2)) * 8 +:8];
            end
            else if ((char_index_in_page >= 10) && (char_index_in_page <= 10 + 7)) begin
                    ascii_code <=  num2str(data_buf[char_page][(7 - (char_index_in_page - 10)) * 4  +: 4]);
            end else ascii_code <= " ";
        end
        else ascii_code <= ascii_code;
    end
end

    wire [8*5:0] MEMADDRSTR = SWO13 ? "RAM:0" : "CODE-";                                   //切换RAM/ROM地址显示标志
always @(posedge clk) begin                                                                 //2021 Modify ,后期还需要调�??
		case (current_display_reg_addr[7:5])
			3'b000: //strdata <= {"REG-x", num2str(current_display_reg_addr[5:4]), num2str(current_display_reg_addr[3:0])};
			//begin strdata[23:0] <= {"x",num2str(current_display_reg_addr[5:4]), num2str(current_display_reg_addr[3:0])};
			       case (current_display_reg_addr[4:0])
			       0: strdata <= "x0:zero";
			       1: strdata <= "x01: ra";
			       2: strdata <= "x02: sp";
			       3: strdata <= "x03: gp";
			       4: strdata <= "x04: tp";
                   5: strdata <= "x05: t0";
                   6: strdata <= "x06: t1";
                   7: strdata <= "x07: t2";

 			       8: strdata <= "x8:fps0";
                   9: strdata <= "x09: s1";
                  10: strdata <= "x10: a0";
                  11: strdata <= "x11: a1";
                  12: strdata <= "x12: a2";
                  13: strdata <= "x13: a3";
                  14: strdata <= "x14: a4";
                  15: strdata <= "x15: a5";
                  16: strdata <= "x16: a6";
                  17: strdata <= "x17: a7";

                  18: strdata <= "x18: s2";
                  19: strdata <= "x19: s3";
                  20: strdata <= "x20: s4";
                  21: strdata <= "x21: s5";
                  22: strdata <= "x22: s6";
                  23: strdata <= "x23: s7";
                  24: strdata <= "x24: s8";
                  25: strdata <= "x25: s9";
                  26: strdata <= "x26:s10";
                  27: strdata <= "x27:s11";
                  28: strdata <= "x28: t3";
                  29: strdata <= "x29: t4";
                  30: strdata <= "x30: t5";
                  31: strdata <= "x31: t6";
			       default: strdata <= "-------";
               endcase
//            end

			3'b001: case (current_display_reg_addr[4:0])
				// datapath debug signals, MUST be compatible with 'debug_data_signal' in 'datapath.v'
				0:  strdata <= "PC---IF";
				1:  strdata <= "INST-IF";
				2:  strdata <= "PC---IS";
				3:  strdata <= "INST-IS";

				4:  strdata <= "rs1addr";
				5:  strdata <= "rs1data";
				7:  strdata <= "rs2addr";
				6:  strdata <= "rs2data";

				8:  strdata <= "Imm-Sel";
				9:  strdata <= "Imm--FU";
				10: strdata <= "ALUout-";
				11: strdata <= "PC---EN";

				12: strdata <= "ALUE/Fi";
				13: strdata <= "ALUCtrl";
				14: strdata <= "ALUA-RO";
				15: strdata <= "ALUB-RO";

				16: strdata <= "memE/Fi";
				17: strdata <= "mem-wri";
				18: strdata <= "u-b-h-w";
				19: strdata <= "memdata";

                20: strdata <= "mulE/Fi";
				21: strdata <= "mulres-";
				22: strdata <= "divE/Fi";
				23: strdata <= "divres-";

				24: strdata <= "jmpE/Fi";
				25: strdata <= "jmpCtrl";
				26: strdata <= "PC-jump";
				27: strdata <= "PC-wrtb";

                28: strdata <= "RegWrit";
                29: strdata <= "rd-addr";
                30: strdata <= "DaToReg";
                31: strdata <= "wt-data";

				default: strdata <= "RESERVE";
			endcase
			3'b010: strdata <= {MEMADDRSTR, num2str({SWO14 + current_display_reg_addr[5],current_display_reg_addr[4]}), num2str(current_display_reg_addr[3:0])};
			3'b011: strdata <= {MEMADDRSTR, num2str({SWO14 ,current_display_reg_addr[5]}+1'b1), num2str(current_display_reg_addr[3:0])};
//			3'b010: strdata <= {MEMADDRSTR, num2str({SWO14 + current_display_reg_addr[5],current_display_reg_addr[4]}), num2str(current_display_reg_addr[3:0])};

			default: strdata <= "RESERVE";
		endcase
end


FONT8_16 FONT_8X16 (                               //后续修改为标准字�??
	.clk(clk),
	.ascii_code(ascii_code[6:0]),
	.row(row_addr[3:0]),
	.col(col_addr[2:0]),
	.row_of_pixels(pixel)
);

	function [7:0] num2str;
		input [3:0] number;
		begin
			if (number < 10)
				num2str = "0" + number;
			else
				num2str = "A" - 10 + number;
		end
	endfunction


        vga     U12(.clk(clk25),
                    .rst(1'b0),
                    .Din(dout),
                    .PCol(PCol),
                    .PRow(PRow),
                    .R(Red),
                    .G(Green),
                    .B(Blue),
                    .VS(VSYNC),
                    .HS(HSYNC),
                    .rdn(),
                    .vgaclk()
                     );


endmodule
