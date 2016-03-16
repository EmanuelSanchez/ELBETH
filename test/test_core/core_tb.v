`include "elbeth_memory.v"
`include "elbeth_core.v"

module core_tb();
	// inputs and outputs
	reg				rst=1;
	reg				clk=0;
	wire [31:0]		imem_in_data;
	wire 			imem_ready;
	wire			imem_error;
	wire [7:0]		imem_addr;
	wire			imem_en;
	wire [3:0]		imem_rw;
	wire [31:0]		imem_out_data;
	//Data memory
	wire [31:0]		dmem_in_data;
	wire			dmem_ready;
	wire			dmem_error;
	wire [7:0]		dmem_addr;
	wire			dmem_en;
	wire [3:0]		dmem_rw;
	wire [31:0]		dmem_out_data;

	always @(*) begin
		#50
		clk <= ~clk;
	end // always @(*)

	// test process
	initial
		begin
			$dumpfile("core_tb.vcd");
			$dumpvars(0,core_tb);

		#200
		rst = 0;
		#1000
		$finish;
	
	end // test process

	//test module instantiation
	elbeth_memory memory(
    	clk,
		rst,
		//Port A
		imem_en,
		imem_addr,
		imem_in_data,
		imem_rw,
		imem_out_data,
		imem_ready,
		//Port B	
		dmem_en,
		dmem_addr,
		dmem_in_data,
		dmem_rw,
		dmem_out_data,
		dmem_ready
		);
	elbeth_core core(
		clk,
		rst,
		//Instruction memory
		imem_out_data,
		imem_ready,
		imem_error,
		imem_addr,
		imem_en,
		imem_rw,
		imem_in_data,
		
		//Data memory
		dmem_out_data,
		dmem_ready,
		dmem_error,
		dmem_addr,
		dmem_en,
		dmem_rw,
		dmem_in_data
		);

endmodule


