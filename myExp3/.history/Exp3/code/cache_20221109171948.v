// | ----------- address 32 ----------- |
// | 31   9 | 8     4 | 3    2 | 1    0 |
// | tag 23 | index 5 | word 2 | byte 2 |

module cache (
	input wire clk,  // clock
	input wire rst,  // reset
	input wire [ADDR_BITS-1:0] addr,  // address
    input wire load,    //  read refreshes recent bit
	input wire store,  // set valid to 1 and reset dirty to 0
	input wire edit,  // set dirty to 1
	input wire invalid,  // reset valid to 0
    input wire [2:0] u_b_h_w, // select signed or not & data width
                              // please refer to definition of LB, LH, LW, LBU, LHU in RV32I Instruction Set  
	input wire [31:0] din,  // data write in
	output reg hit = 0,  // hit or not
	output reg [31:0] dout = 0,  // data read out
	output reg valid = 0,  // valid bit
	output reg dirty = 0,  // dirty bit
	output reg [TAG_BITS-1:0] tag = 0  // tag bits
	);

    `include "addr_define.vh"

    wire [31:0] word1, word2;
    wire [15:0] half_word1, half_word2;
    wire [7:0]  byte1, byte2;
    wire recent1, recent2, valid1, valid2, dirty1, dirty2;
    wire [TAG_BITS-1:0] tag1, tag2;
    wire hit1, hit2;

    reg [ELEMENT_NUM-1:0] inner_recent = 0;
    reg [ELEMENT_NUM-1:0] inner_valid = 0;
    reg [ELEMENT_NUM-1:0] inner_dirty = 0;
    reg [TAG_BITS-1:0] inner_tag [0:ELEMENT_NUM-1];
    // 64 elements, 2 ways set associative => 32 sets
    reg [31:0] inner_data [0:ELEMENT_NUM*ELEMENT_WORDS-1];

    // initialize tag and data with 0
    integer i;
    initial begin
        for (i = 0; i < ELEMENT_NUM; i = i + 1)
            inner_tag[i] = 23'b0;

        for (i = 0; i < ELEMENT_NUM*ELEMENT_WORDS; i = i + 1)
            inner_data[i] = 32'b0;
    end

    // the bits in an input address:
    wire [TAG_BITS-1:0] addr_tag;
    wire [SET_INDEX_WIDTH-1:0] addr_index;     // idx of set
    wire [ELEMENT_INDEX_WIDTH-1:0] addr_element1; 
    wire [ELEMENT_INDEX_WIDTH-1:0] addr_element2;     // idx of element
    wire [ELEMENT_INDEX_WIDTH+ELEMENT_WORDS_WIDTH-1:0] addr_word1;
    wire [ELEMENT_INDEX_WIDTH+ELEMENT_WORDS_WIDTH-1:0] addr_word2; // element index + word index


    // | ----------- address 32 ----------- |
    // | 31   9 | 8     4 | 3    2 | 1    0 |
    // | tag 23 | index 5 | word 2 | byte 2 |
    assign addr_tag = addr[31:9];
    assign addr_index = addr[8:4];
    
    assign addr_element1 = {addr_index, 1'b0};
    assign addr_element2 = ;      //need to fill in
    assign addr_word1 = {addr_element1, addr[ELEMENT_WORDS_WIDTH+WORD_BYTES_WIDTH-1:WORD_BYTES_WIDTH]};
    assign addr_word2 = ;           //need to fill in

    assign word1 = inner_data[addr_word1];
    assign word2 = ;                //need to fill in
    assign half_word1 = addr[1] ? word1[31:16] : word1[15:0];
    assign half_word2 = ;           //need to fill in
    assign byte1 = addr[1] ?
                    addr[0] ? word1[31:24] : word1[23:16] :
                    addr[0] ? word1[15:8] :  word1[7:0]   ;
    assign byte2 = ;                //need to fill in

    assign recent1 = inner_recent[addr_element1];
    assign recent2 = ;              //need to fill in
    assign valid1 = inner_valid[addr_element1];
    assign valid2 = ;               //need to fill in
    assign dirty1 = inner_dirty[addr_element1];
    assign dirty2 = ;               //need to fill in
    assign tag1 = inner_tag[addr_element1];
    assign tag2 = ;                 //need to fill in

    assign hit1 = valid1 & (tag1 == addr_tag);
    assign hit2 = ;                 //need to fill in

    always @ (posedge clk) begin
        valid <= ;                  //need to fill in
        dirty <= ;                  //need to fill in
        tag <= ;                    //need to fill in
        hit <= ;                    //need to fill in
        
        //
        // Cache to Reg
        //

        // read $ with load==0 means moving data from $ to mem
        // no need to update recent bit
        // otherwise the refresh process will be affected
        if (load) begin
            if (hit1) begin
                dout <=
                    u_b_h_w[1] ? word1 :
                    u_b_h_w[0] ? {u_b_h_w[2] ? 16'b0 : {16{half_word1[15]}}, half_word1} :
                    {u_b_h_w[2] ? 24'b0 : {24{byte1[7]}}, byte1};
                
                // inner_recent will be refreshed only on r/w hit
                // (including the r/w hit after miss and replacement)
                inner_recent[addr_element1] <= 1'b1;
                inner_recent[addr_element2] <= 1'b0;
            end
            else if (hit2) begin
                    //need to fill in
            end
        end
        else dout <= inner_data[ recent1 ? addr_word2 : addr_word1 ];


        //
        // CPU Modify Cache
        //
        if (edit) begin
            if (hit1) begin
                inner_data[addr_word1] <= 
                    u_b_h_w[1] ?        // word?
                        din
                    :
                        u_b_h_w[0] ?    // half word?
                            addr[1] ?       // upper / lower?
                                {din[15:0], word1[15:0]} 
                            :
                                {word1[31:16], din[15:0]} 
                        :   // byte
                            addr[1] ?
                                addr[0] ?
                                    {din[7:0], word1[23:0]}   // 11
                                :
                                    {word1[31:24], din[7:0], word1[15:0]} // 10
                            :
                                addr[0] ?
                                    {word1[31:16], din[7:0], word1[7:0]}   // 01
                                :
                                    {word1[31:8], din[7:0]} // 00
                ;
                inner_dirty[addr_element1] <= 1'b1;
                inner_recent[addr_element1] <= 1'b1;
                inner_recent[addr_element2] <= 1'b0;
            end
            else if (hit2) begin
                    //need to fill in
            end
        end

        //
        // Mem to Cache
        // LRU stratergy, block transfer
        //
        if (store) begin
            if (recent1) begin  // replace 2
                inner_data[addr_word2] <= din;
                inner_valid[addr_element2] <= 1'b1;
                inner_dirty[addr_element2] <= 1'b0;
                inner_tag[addr_element2] <= addr_tag;
            end else begin
                // recent2 == 1 => replace 1
                // recent2 == 0 => no data in this set, place to 1
                //need to fill in
            end
        end

        // not used currently, can be used to reset the cache.
        if (invalid) begin
            inner_recent[addr_element1] <= 1'b0;
            inner_recent[addr_element2] <= 1'b0;
            inner_valid[addr_element1] <= 1'b0;
            inner_valid[addr_element2] <= 1'b0;
            inner_dirty[addr_element1] <= 1'b0;
            inner_dirty[addr_element2] <= 1'b0;
        end
    end

endmodule
