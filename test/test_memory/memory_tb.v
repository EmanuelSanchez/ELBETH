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
			$monitor("In_addr_a = %h   out_a = %h   In_addr_b = %h   out_b = %h", amem_addr, amem_data_out, bmem_addr, bmem_data_out);

			//test vector: read amem
			#40
			amem_addr = 8'd0;              
			amem_wr= 4'd0;
			amem_enable = 1'b1;

			//test vector: bmem 0001 = 1 byte
			#50
			bmem_addr = 8'd9;
			bmem_data_in = 32'd8;
			bmem_wr = 4'd1;
			bmem_enable = 1'b1;

			//test vector: bmem 0010 = 1 halfword
			#50
			bmem_addr = 8'd2;
			bmem_data_in = 32'd20;
			bmem_wr = 4'd1;
			bmem_enable = 1'b1;

			//test vector: bmem 1000 = 1 word
			#50
			bmem_addr = 8'd3;
			bmem_data_in = 32'd256;
			bmem_wr = 4'd1;
			bmem_enable = 1'b1;

			//finish
			#50 
			$finish;
		end
	elbeth_memory memory1 (clk, rst, amem_enable, amem_addr, amem_data_in, amem_wr, amem_data_out, amem_ready, bmem_enable, bmem_addr, bmem_data_in, bmem_wr, bmem_data_out, bmem_ready);
endmodule // memory_tb