`timescale 1ns / 1ps

module RAM_B(
    input [31:0] addra,
    input clka,      // normal clock
    input[31:0] dina,
    input wea, 
    output[31:0] douta,
    input[2:0] mem_u_b_h_w
);

    reg[7:0] data[0:127];

    initial	begin
        $readmemh("ram.hex", data);
    end

    always @ (negedge clka) begin
        if (wea & ~|addra[31:7]) begin
            data[addra[6:0]] <= dina[7:0];
            if(mem_u_b_h_w[0] | mem_u_b_h_w[1])
                data[addra[6:0] + 1] <= dina[15:8];
            if(mem_u_b_h_w[1]) begin
                data[addra[6:0] + 2] <= dina[23:16];
                data[addra[6:0] + 3] <= dina[31:24];
            end
        end
    end

    
    assign douta = addra[31:7] ? 32'b0 :
        mem_u_b_h_w[1] ? {data[addra[6:0] + 3], data[addra[6:0] + 2],
                    data[addra[6:0] + 1], data[addra[6:0]]} :
        mem_u_b_h_w[0] ? {mem_u_b_h_w[2] ? 16'b0 : {16{data[addra[6:0] + 1][7]}},
                    data[addra[6:0] + 1], data[addra[6:0]]} :
        {mem_u_b_h_w[2] ? 24'b0 : {24{data[addra[6:0]][7]}}, data[addra[6:0]]};

endmodule