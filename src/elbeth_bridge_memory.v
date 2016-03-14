////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : elbeth_bridge_memory.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-03-14 09:56:29
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : Intermediate module between processor and memory
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

module elbeth_bridge_memory(
	//Memory port A
	output 				 amem_en,
	output [7:0]		 amem_addr,
	output [31:0]		 amem_out_data,
	output [3:0]		 amem_rw,
	input  [31:0]		 amem_in_data,
	input  				 amem_ready,
	input				 amem_error,
	//Memory port B
	output 				 bmem_en,
	output [7:0]		 bmem_addr,	
	output [31:0]		 bmem_out_data,	
	output [3:0]		 bmem_rw,
	input  [31:0]		 bmem_in_data,
	input 				 bmem_ready,
	input				 bmem_error,
	//Processor instruction memory
	input  [31:0]		 imem_addr,
	output [31:0]		 imem_in_data,
	output 				 imem_ready,
	output				 imem_except,
	output [3:0]		 imem_except_src,
	//Processor data memory 
	input 				 dmem_en,
	input  [31:0]		 dmem_addr,
	input  [31:0]		 dmem_out_data,
	input  [3:0]	 	 dmem_rw,
	output [31:0]		 dmem_in_data,
	output 				 dmem_ready,
	output				 dmem_except,
	output reg [3:0]	 dmem_except_src
	);

	assign imem_except = ( (|imem_addr[1:0]) | amem_error ) ? 1'b1 : 1'b0;
	assign imem_except_src = (imem_except & amem_error) ? `ECODE_INST_ADDR_FAULT : `ECODE_INST_ADDR_MISALIGNED;
	assign imem_in_data = amem_in_data;
	assign imem_ready = amem_ready;

	assign amem_addr = (!imem_except) ? imem_addr[9:2] : 8'bx;
	assign amem_en= 1'b1;
	assign amem_rw = 4'b0;
	assign amem_out_data = 31'bz;

	assign dmem_except = (dmem_en & ((|dmem_addr[1:0]) | bmem_error )) ? 1'b1 : 1'b0;

	always @(*) begin
		if (dmem_except) begin
			if(bmem_error) begin
				if(dmem_rw == 4'b0)
					dmem_except_src = `ECODE_LOAD_ACCESS_FAULT;
				else
					dmem_except_src = `ECODE_STORE_AMO_ACCESS_FAULT;
			end
			else if(dmem_rw == 4'b0)
				dmem_except_src = `ECODE_LOAD_ADDR_MISALIGNED;
			else
				dmem_except_src = `ECODE_STORE_AMO_ADDR_MISALIGNED;
		end		
	end

	assign dmem_in_data = bmem_in_data;
	assign dmem_ready = bmem_ready;

	assign bmem_addr = ((!dmem_except) & dmem_en) ? dmem_addr[9:2] : 8'bx;
	assign bmem_en = dmem_en;
	assign bmem_rw = dmem_rw;
	assign bmem_out_data = dmem_out_data;

endmodule // elbeth_bridge_memory