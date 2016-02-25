`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : elbeth_hazard_unit1.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-02-25 01:34:36
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : Execute the forwarding
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

module elbeth_hazard_unit (
	input [4:0] 	id_rs1,
	input [4:0]		id_rs2,
	input [4:0]		exs_rd_addr,
	input			exs_w_gpr_en,
	input 			exs_mem_en,
	input 			exs_mem_wr,
	output			match_forward_rs1,
	output 			match_forward_rs2,
	output			forward_from
);
	wire			forward_from_mem;
	wire			forward_from_alu;

	assign match_forward_rs1 = (exs_rd_addr == exs_rs1) & (exs_rd_addr != `RD_ZERO) & (exs_w_gpr_en);
	assign match_forward_rs2 = (exs_rd_addr == exs_rs2) & (exs_rd_addr != `RD_ZERO) & (exs_w_gpr_en);
	
endmodule