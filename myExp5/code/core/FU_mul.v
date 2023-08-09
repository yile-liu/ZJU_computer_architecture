`timescale 1ns / 1ps

module FU_mul(
    input clk, EN,
    input[31:0] A, B,
    output[31:0] res,
    output finish
);

    reg[6:0] state;
    assign finish = state[0] == 1'b1;
    initial begin
        state = 0;
    end

    reg[31:0] A_reg, B_reg;

    // 这里IP核的行为是：取AB做乘法，但是只有开始后第6个时钟时的结果是正确的（其他时候mulres是中间过程量）
    // 所以这里要手工计数，在第六个时钟周期改变state告诉外部此时可以取结果
    // 比较特别的是这里使用位移而不是常见的递减来计数
    always@(posedge clk) begin
        if(EN & state == 0) begin //state == 0
            A_reg <= A;
            B_reg <= B;
            state[6] <= 1;
        end
        else state <= (state >> 1);
    end

    wire [63:0] mulres;
    multiplier mul(.CLK(clk),.A(A_reg),.B(B_reg),.P(mulres));

    assign res = mulres[31:0];

endmodule