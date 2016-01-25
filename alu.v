`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : alu.v
//  Created On    : Tue Jan  19 06:40:00 2016
//  Last Modified : 
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth 
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & 
//
//  Description   : The Execution unit.
//                  Performs the following operations:
//                  - Arithmetic    (lista)
//                  - Logical			
//                  - Shift			
//                  - Comparison		
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "definitions.v"

module alu(
	 input [31:0] 				data_a,
    input [31:0] 				data_b,
    input [2:0]				operation,
    output reg [31:0] 		alu_result
    );

//--------------------------------------------------------------------------
// Operation Select
//--------------------------------------------------------------------------
	always @(*) begin
		case (operation)
			`OP_ADD  : alu_result = (data_a + data_b) & `MAX_RANGE;
			`OP_SUB  : alu_result = (data_a - data_b) & `MAX_RANGE;
			`OP_AND  : alu_result = data_a & data_b;
			`OP_OR   : alu_result = data_a | data_b;
			`OP_XOR  : alu_result = data_a ^ data_b;
			`OP_SLTU : alu_result = data_a < data_b;
			`OP_SLT  : alu_result = $signed(data_a) < $signed(data_b);
			default  : alu_result = 32'bx;
		endcase
	end
	
endmodule
