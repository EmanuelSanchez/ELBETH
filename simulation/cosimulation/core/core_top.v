module core_top();
	// inputs and outputs
	reg				rst=1;
	reg				clk=0;
	wire [31:0]		imem_in_data;
	wire 			imem_ready;
	wire [11:0]		imem_addr;
	wire			imem_en;
	wire [3:0]		imem_rw;
	wire [31:0]		imem_out_data;
	//Data memory
	wire [31:0]		dmem_in_data;
	wire			dmem_ready;
	wire [11:0]		dmem_addr;
	wire			dmem_en;
	wire [3:0]		dmem_rw;
	wire [31:0]		dmem_out_data;
	
	wire [31:0]		toHost;

	assign toHost = core.csr.to_host;

	//test module instantiation
	elbeth_memory memory(
    	.clk(clk),
		.rst(rst),
		//Port A
		.amem_enable(imem_en),
		.amem_addr(imem_addr),
		.amem_data_in(imem_in_data),
		.amem_rw(imem_rw),
		.amem_data_out(imem_out_data),
		.amem_ready(imem_ready),
		//Port B	
		.bmem_enable(dmem_en),
		.bmem_addr(dmem_addr),
		.bmem_data_in(dmem_in_data),
		.bmem_rw(dmem_rw),
		.bmem_data_out(dmem_out_data),
		.bmem_ready(dmem_ready)
		);

	elbeth_core core(
    	.clk(clk),
		.rst(rst),
		//Instruction memory
		.imem_out_data(imem_in_data),
		.imem_ready(imem_ready),
		.imem_error(1'b0),
		.imem_addr(imem_addr),
		.imem_en(imem_en),
		.imem_rw(imem_rw),
		.imem_in_data(imem_out_data),
		
		//Data memory
		.dmem_out_data(dmem_in_data),
		.dmem_ready(dmem_ready),
		.dmem_error(1'b0),
		.dmem_addr(dmem_addr),
		.dmem_en(dmem_en),
		.dmem_rw(dmem_rw),
		.dmem_in_data(dmem_out_data)
		);

	initial begin
		$from_myhdl(clk, rst);
		$to_myhdl(imem_addr, imem_out_data, toHost);
	end

	// test process
	initial
		begin
			$dumpfile("core.vcd");
			$dumpvars();
	end // test process


endmodule