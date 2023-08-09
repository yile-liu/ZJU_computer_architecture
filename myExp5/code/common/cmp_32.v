`timescale 1ns / 1ps

module cmp_32(  input [31:0] a,
                input [31:0] b,
                input [2:0] ctrl,
                output c
    );
    localparam cmp_EQ  = 3'b001;
    localparam cmp_NE  = 3'b010;
    localparam cmp_LT  = 3'b011;
    localparam cmp_LTU = 3'b100;
    localparam cmp_GE  = 3'b101;
    localparam cmp_GEU = 3'b110;

    wire res_EQ  = a == b;
    wire res_NE  = ~res_EQ;
    wire res_LT  = (a[31] & ~b[31]) || (~(a[31] ^ b[31]) && a < b);
    wire res_LTU = a < b;
    wire res_GE  = ~res_LT;
    wire res_GEU = ~res_LTU;

    wire EQ  = ctrl == cmp_EQ ; 
    wire NE  = ctrl == cmp_NE ; 
    wire LT  = ctrl == cmp_LT ; 
    wire LTU = ctrl == cmp_LTU;
    wire GE  = ctrl == cmp_GE ; 
    wire GEU = ctrl == cmp_GEU;

    assign c = EQ  & res_EQ  |
               NE  & res_NE  |
               LT  & res_LT  |
               LTU & res_LTU |
               GE  & res_GE  |
               GEU & res_GEU ;
    

endmodule