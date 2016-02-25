module memory_tb;
    // Inputs and outputs 
	reg  clk = 0;
	reg  rst = 0;
	reg  			amem_enable;
	reg	 [7:0]		amem_addr;
	reg	 [31:0]		amem_data_in;
	reg	 [3:0]		amem_wr;
	wire [31:0]		amem_data_out;
	wire 			amem_ready;

    reg	 			bmem_enable;
	reg  [7:0]		bmem_addr;
	reg	 [31:0]		bmem_data_in;
	reg  [3:0]		bmem_wr;
	wire [31:0]		bmem_data_out;
	wire			bmem_ready;


	// Test process
	always @(*) begin
		#25
		clk <= !clk;
	end

	initial
		begin
			$dumpfile("memory_tb.vcd");
			$dumpvars(0,memory_tb);

			//test vector: bmem write a 1 byte
			#50
			bmem_addr = 8'd0;
			bmem_data_in = 32'hFF;
			bmem_wr = 4'b0001;
			bmem_enable = 1'b1;

			//test vector: bmem write a halfword
			#50
			bmem_addr = 8'd1;
			bmem_data_in = 32'hFFFF;
			bmem_wr = 4'b0011;
			bmem_enable = 1'b1;

			//test vector: bmem write a word
			#50
			bmem_addr = 8'd2;
			bmem_data_in = 32'hFFFFFFFF;
			bmem_wr = 4'b1111;
			bmem_enable = 1'b1;

			//test vector: read amem
			#50
			amem_addr = 8'd0;        
			amem_wr= 4'd0;
			amem_enable = 1'b1;
			bmem_enable = 1'b0;

			//test vector: read amem
			#50
			amem_addr = 8'd1;            
			amem_enable = 1'b1;

			//test vector: read amem
			#50
			amem_addr = 8'd2;
			amem_enable = 1'b1;

			//finish
			#50 
			$finish;
		end
	elbeth_memory memory1 (clk, rst, amem_enable, amem_addr, amem_data_in, amem_wr, amem_data_out, amem_ready, bmem_enable, bmem_addr, bmem_data_in, bmem_wr, bmem_data_out, bmem_ready);
endmodule // memory_tb