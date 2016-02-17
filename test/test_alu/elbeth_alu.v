`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : alu.v
//  Created On    : Tue Jan  19 06:40:00 2016
//  Last Modified : 2016-02-15 20:24:21
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : The Execution unit.
//                  Performs the following operations:
//                  - Arithmetic   
//                  - Logical			
//                  - Shift			
//                  - Comparison		
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

module elbeth_alu(	
	input [31:0] 				data_a,					// values (32 bits) values for operation
    input [31:0] 				data_b,					// values (32 bits) values for operation
    input [3:0]				operation,					// code of the corresponding operation
	output reg [31:0] 		alu_result
    );
	 
	 wire shift_shamt;
	 
	 assign shift_shamt = data_b;

//--------------------------------------------------------------------------
// Operation Select
//--------------------------------------------------------------------------
	always @(*) begin
		case (operation)
			`OP_ADD   : alu_result = (data_a + data_b) & `MAX_RANGE;
			`OP_SUB   : alu_result = (data_a - data_b) & `MAX_RANGE;
			`OP_AND   : alu_result = data_a & data_b;
			`OP_OR    : alu_result = data_a | data_b;
			`OP_XOR   : alu_result = data_a ^ data_b;
			`OP_SLTU  : alu_result = data_a < data_b;
			`OP_SLT   : alu_result = $signed(data_a) < $signed(data_b);
			`OP_SLL   : alu_result = data_a << shift_shamt;
			`OP_SRL   : alu_result = data_a >> shift_shamt;
			`OP_SRA	 : alu_result = $signed(data_a) >>> shift_shamt;
			default   : alu_result = 32'bx;
		endcase // operation
	end		
endmodule	//elbeth_alu
