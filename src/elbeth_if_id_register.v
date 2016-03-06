`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : if_id_register.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-03-02 20:00:29
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
    input [3:0]             if_except_source,
	input					ctrl_stall,
    input                   ctrl_flush,
    output reg [31:0] 		id_instruction,
    output reg [31:0] 		id_pc,
    output reg [3:0]        id_except_source
    );

	always @(posedge clk) begin
		id_instruction <= (rst | ctrl_flush) ? 32'b0 : (ctrl_stall) ? id_instruction : if_instruction;
		id_pc <= (rst | flush) ? 32'b0 : (ctrl_stall) ? id_pc : if_pc;
        id_except_source <= (rst | flush) ? 4'b0 : (ctrl_stall) ? id_except_source : if_except_source;
	end // always @(posedge clk)
	
endmodule	// elbeth_if_id_register
