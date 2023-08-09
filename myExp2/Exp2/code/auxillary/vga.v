module  vga(input clk,					 // clk = 100Hz
				input rst,
				input [11:0]Din,			// bbbb_gggg_rrrr, pixel
				output  [9:0]PCol,		    // pixel ram row address, 480 (512) lines
				output  [9:0]PRow,		    // pixel ram col address, 640 (1024) pixels
				output reg rdn,			   // read pixel RAM (active_low)
				output reg [3:0]R, G, B,    // red, green, blue colors
				output reg HS, VS,			// horizontal and vertical synchronization
				output vgaclk               //vga clk = 25MHz
				); 
				
/*reg[1:0] clk1;				
   always @ (posedge clk) 
                    if (rst) clk1 <= 0;
                    else clk1 <= clk1 + 1;
*/                    
   assign vgaclk = clk; //1[1];                 
       		
// h_count: VGA horizontal counter (0-799)
reg [9:0] h_count; // VGA horizontal counter (0-799): pixels
   always @ (posedge vgaclk) begin
       if (rst) begin
           h_count <= 10'h0;
       end else if (h_count >= 10'd799) begin
           h_count <= 10'h0;
       end else begin 
           h_count <= h_count + 10'h1;
       end
   end
// v_count: VGA vertical counter (0-524)
reg [9:0] v_count; // VGA vertical   counter (0-524): lines
   always @ (posedge vgaclk or posedge rst) begin
       if (rst) begin
           v_count <= 10'h0;
       end else if (h_count == 10'd799) begin
           if (v_count >= 10'd524) begin
               v_count <= 10'h0;
           end else begin
               v_count <= v_count + 10'h1;
           end
       end
   end
    // signals, will be latched for outputs
   // wire  [9:0] row_addr =  v_count - 10'd35;     // pixel ram row addr 
   // wire  [9:0] col_addr =  h_count - 10'd143;    // pixel ram col addr 
   assign  PCol  =  h_count;// - 10'd143;    					// pixel Screen addr col
   assign  PRow  =  v_count;// - 10'd35;                         // pixel Screen addr row

    wire        h_sync = (h_count > 10'd95);    	//  96 -> 799
    wire        v_sync = (v_count > 10'd1);     	//   2 -> 524
    wire        read   = (h_count > 10'd142) && 	// 143 -> 782
                         (h_count < 10'd783) && 	//        640 pixels
                         (v_count > 10'd34)  && 	//  35 -> 514
                         (v_count < 10'd515);   	//        480 lines
    // vga signals
    always @ (posedge vgaclk) begin
        //row <= row_addr[8:0]; // pixel ram row address
        //col <= col_addr;      // pixel ram col address
        rdn <= ~read;     		// read pixel (active low)
        HS  <= h_sync;   		// horizontal synchronization
        VS  <= v_sync;   		// vertical   synchronization
        R   <= rdn ? 4'h0 : Din[3:0]; 		// 3-bit red
        G   <= rdn ? 4'h0 : Din[7:4]; 		// 3-bit green
        B   <= rdn ? 4'h0 : Din[11:8]; 	// 2-bit blue
    end
	 
endmodule
