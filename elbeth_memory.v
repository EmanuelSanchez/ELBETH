`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : memory.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : 
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////

`include "elbeth_definitions.v"

module elbeth_memory #(
    parameter AW = 32,			// addres width
	 parameter DW = 32,			// data width
	 parameter mem_ini = 32'h00000000,
	 parameter mem_end = 32'hFFFFFFFF
	 )(
    input clk,
	 input rst,
	 input ctrl_write_e,
	 input ctrl_read_e,
    input [AW-1:0] 			pc_addr,
    input [AW-1:0] 			save_addr,
	 input [DW-1:0] 			data_w,
    output reg[DW-1:0] 	instruction,
	 output reg [1:0] 	exception
    );
	 
	localparam NPOS = 2 ** AW;
	
	reg [DW-1:0]		memory_array [0: 749999];		// 2.5 MB	
	
	always @(posedge clk) begin
		if (ctrl_write_e == 1)
			if (save_addr < `LIMIT_INSTRUC)
				memory_array[save_addr] = data_w;
			else
				exception = 2'b10;
	end
	
	always @(posedge clk) begin
		if (ctrl_read_e == 1)
			if(pc_addr < `LIMIT_INSTRUC)
				instruction = memory_array[pc_addr];
			else
				exception = 2'b1;
	end
	
endmodule	//elbeth_memory
