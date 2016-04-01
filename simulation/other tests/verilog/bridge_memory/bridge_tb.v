////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : bridge_tb1.v
//  Last Modified : 2016-03-05 19:32:36
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//  Description   : 
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////

`include "elbeth_bridge_memory.v"


module bridge_tb();

	reg 			clk;
	reg 			rst;

	wire 			amem_en;
	wire [7:0] 		amem_addr;
	wire [31:0] 	amem_in_data;
	wire [3:0] 		amem_rw;
	wire [31:0] 	amem_out_data;
	wire 			amem_ready;
	wire			amem_error;

	wire 			bmem_en;
	wire [7:0] 		bmem_addr;
	wire [31:0] 	bmem_in_data;
	wire [3:0] 		bmem_rw;
	wire [31:0] 	bmem_out_data;
	wire 			bmem_ready;
	wire			bmem_error;

	reg [31:0] 		imem_addr;				//pc
	wire [31:0] 	imem_in_data;			//instruction
	wire 		 	imem_ready;
	wire 			imem_except;
	wire [3:0] 		imem_except_src;

	reg 			dmem_en;
	reg  [31:0] 	dmem_addr;
	reg  [31:0] 	dmem_out_data;
	reg  [3:0] 		dmem_rw;
	wire [31:0] 	dmem_in_data;
	wire		 	dmem_ready;
	wire 			dmem_except;
	wire [3:0] 		dmem_except_src;

	assign amem_error = 1'b0;	//Without error
	assign bmem_error = 1'b0;	//Without error

	// test process
	initial
	begin
		$dumpfile("bridge_tb.vcd");
		$dumpvars(0,bridge_tb);

		#50
		imem_addr = 31'b011;

		#50
		$finish;
	end

	elbeth_bridge_memory brige_memory_cpu(
		//Memory port A
		amem_en,
		amem_addr,
		amem_in_data,
		amem_rw,
		amem_out_data,
		amem_ready,
		amem_error,
		//Memory port B
		bmem_en,
		bmem_addr,
		bmem_in_data,
		bmem_rw,
		bmem_out_data,	
		bmem_ready,
		bmem_error,
		//Processor instruction memory
		imem_addr,
		imem_in_data,
		imem_ready,
		imem_except,
		imem_except_src,
		//Processor data memory 
		dmem_en,
		dmem_addr,
		dmem_out_data,
		dmem_rw,
		dmem_in_data,
		dmem_ready,
		dmem_except,
		dmem_except_src
		);

endmodule // bridge_tb