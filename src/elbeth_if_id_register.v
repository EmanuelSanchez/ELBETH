`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : if_id_register.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-02-17 08:27:36
//  Revision      : 0.1
//  Author        : Emanuel S�nchez & Ninisbeth Segovia
//  Company       : Universidad Sim�n Bol�var
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
	input					ctrl_stall,
    output reg [31:0] 		id_instruction,
    output reg [31:0] 		id_pc
    );

	always @(posedge clk) begin
		id_instruction <= (rst) ? 32'b0 : if_instruction;
		id_pc <= (rst) ? 32'b0 : if_pc;
	end
	
endmodule	// elbeth_if_id_register
