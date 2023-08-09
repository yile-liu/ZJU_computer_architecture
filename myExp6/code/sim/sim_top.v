module sim_top;

	// Inputs
	reg clk;
	reg rstn;

	top uut (
		.CLK_200M_P(clk),
		.CLK_200M_N(~clk),
		.SW(16'b0),
		.RSTN(rstn),
		.BTN_X(),
		.BTN_Y(4'b0),
		.SEGLED_CLK(),
		.SEGLED_DO(),
		.SEGLED_PEN(),
		.LED_PEN(),
		.LED_DO(),
		.LED_CLK(),
		.VGA_B(),
		.VGA_G(),
		.VGA_R(),
		.HS(),
		.VS()
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rstn = 0;

		// Wait 100 ns for global reset to finish
		#95 rstn = 1;
        
		// Add stimulus here
	end
	
	initial forever #10 clk = ~clk;
      
endmodule
