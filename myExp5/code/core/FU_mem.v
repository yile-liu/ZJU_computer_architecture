`timescale 1ns / 1ps

module FU_mem(
    input clk, EN, mem_w,
    input[2:0] bhw,
    input[31:0] rs1_data, rs2_data, imm,
    output[31:0] mem_data,
    output finish
);

    reg[1:0] state;
    assign finish = state[0] == 1'b1;
    initial begin
        state = 0;
    end

    reg mem_w_reg;
    reg[2:0] bhw_reg;
    reg[31:0] rs1_data_reg, rs2_data_reg, imm_reg, addr;
    
    // 与mul类似，内存在启动之后两个周期才会读回结果
    // 所以我们使用state位移计数
    always@(posedge clk) begin
        if(EN & state == 0) begin //state == 0
            rs1_data_reg <= rs1_data;
            rs2_data_reg <= rs2_data;
            imm_reg <= imm;
            mem_w_reg <= mem_w;
            bhw_reg <= bhw;
            addr <= imm + rs1_data;
            state[1] <= 1;
        end
        else begin
            state <= (state >> 1);
        end
    end

    RAM_B ram(.clka(clk),.addra(addr),.dina(rs2_data_reg),.wea(mem_w_reg),
        .douta(mem_data),.mem_u_b_h_w(bhw_reg));

endmodule