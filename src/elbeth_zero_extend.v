`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : elbeth_zero_signed_extend.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-02-29 11:13:42
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : zero extend of data memory
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

module zero_signed_extend(
    input [31:0] 		data_mem,
    input [3:0] 		ctrl_data_size,
	input 				ctrl_data_signed,
	output reg out_data_mem
    );
	
	always @(*) begin
		case (ctrl_data_size)
			`WORD : 			begin
					out_data_mem = data_mem; end
			`HALFWORD : 	begin 
					if (ctrl_data_signed == 0)
							reg_data_mem = {16'b0, data_mem[15:0]}; 
					else
							reg_data_mem = {{17{data_mem[15]}}, data_mem[14:0]}; 
					end
			`BYTE :			begin	
					if (ctrl_data_signed == 0)
							reg_data_mem = {24'b0, data_mem[7:0]};
					else
							reg_data_mem = {{25{data_mem[7]}}, data_mem[6:0]}; 
					end
		endcase
	end
endmodule // zero_signed_extend