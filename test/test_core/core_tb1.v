`include "elbeth_memory.v"
`include "elbeth_core.v"

module core_tb1();
	// inputs and outputs
	reg				rst;
	reg				clk=0;
	wire [31:0]		imem_in_data;
	wire 			imem_ready;
	wire			imem_error;
	wire [31:0]		imem_addr;
	wire			imem_en;
	wire [3:0]		imem_rw;
	wire [31:0]		imem_out_data;
	//Data memory
	wire [31:0]		dmem_in_data;
	wire			dmem_ready;
	wire			dmem_error;
	wire [31:0]		dmem_addr;
	wire			dmem_en;
	wire [3:0]		dmem_rw;
	wire [31:0]		dmem_out_data;

	//Bridge core-memory signals
	wire [7:0]		bridge_imem_addr;
	wire [7:0]		bridge_dmem_addr;

	//Simulation Signals
	wire [31:0]		instruction;
	reg  [7:0]		pc;
	wire [31:0]		data_from_memory;
	wire [31:0]		data_to_memory;
	wire [31:0]		data_addr;

	//Bridge assignements
	assign 		bridge_imem_addr = pc;
	assign 		bridge_dmem_addr = dmem_addr[9:2];

	//Simulation assignements
	assign 		imem_in_data = instruction;
	assign		data_from_memory = dmem_in_data;
	assign		data_to_memory = dmem_out_data;
	assign		data_addr = bridge_dmem_addr;

	always @(*) begin
		#50
		clk <= ~clk;
	end // always @(*)

	// test process
	initial
		begin
			$dumpfile("core_tb1.vcd");
			$dumpvars(0,core_tb1);

		pc = 8'h00;		

		#20
		rst=1'b1;
		#30
		rst=1'b0;
		#1000
		$finish;
	
	end // test process

	//test module instantiation
	elbeth_memory memory1(
    	clk,
		rst,
		//Port A
		imem_en,
		bridge_imem_addr,
		imem_in_data,
		imem_rw,
		instruction,
		imem_ready,
		//Port B	
		dmem_en,
		bridge_dmem_addr,
		data_to_memory,
		dmem_rw,
		data_from_memory,
		dmem_ready
		);
	elbeth_core core1(
		clk,
		rst,
		//Instruction memory
		instruction,
		imem_ready,
		imem_error,
		imem_addr,
		imem_en,
		imem_rw,
		imem_out_data,
		//Data memory
		data_from_memory,
		dmem_ready,
		dmem_error,
		dmem_addr,
		dmem_en,
		dmem_rw,
		data_to_memory		
		);

endmodule // coresup_tb1


