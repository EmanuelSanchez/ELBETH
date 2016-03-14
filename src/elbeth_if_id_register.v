////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : if_id_register.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-03-14 10:41:37
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : 
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
module elbeth_if_id_register(
    input clk,
    input rst,
    input [31:0]			if_instruction,
    input [31:0] 			if_pc,
    input [3:0]             if_except_src,
    input                   if_except,
	input					ctrl_stall,
    input                   ctrl_flush,
    output reg [31:0] 		id_instruction,
    output reg [31:0] 		id_pc,
    output reg [3:0]        id_except_src,
    output reg              id_except
    );

	always @(posedge clk) begin
		id_instruction <= (rst | ctrl_flush) ? 32'b0 : (ctrl_stall) ? id_instruction : if_instruction;
		id_pc <= (rst | ctrl_flush) ? 32'b0 : (ctrl_stall) ? id_pc : if_pc;
        id_except <= (rst | ctrl_flush) ? 1'b0 : (ctrl_stall) ? id_except : if_except;
        id_except_src <= (rst | ctrl_flush) ? 4'b0 : (ctrl_stall) ? id_except_src : if_except_src;
	end // always @(posedge clk)
	
endmodule	// elbeth_if_id_register
