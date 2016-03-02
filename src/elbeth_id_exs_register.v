`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : id_exs_register.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-03-01 23:27:12
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : 
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
module elbeth_id_exs_register(
    input 					clk,
    input 					rst,
	input					ctrl_stall,
	input					ctrl_flush, 
	input [31:0] 	 		id_pc,
    input [3:0] 		   	id_alu_operation,
    input [31:0]			id_rs1_data,
    input [31:0] 			id_rs2_data,
    input [4:0] 	 		id_rd_addr,
	input [31:0] 			id_imm_shamt, 
	input [1:0]				id_ctrl_alu_port_a_select,
	input [1:0]				id_ctrl_alu_port_b_select,
	input					id_ctrl_data_w_reg_select,
	input					id_ctrl_reg_w,
	input					id_ctrl_mem_en,
	input [3:0]				id_ctrl_mem_rw,
	input					id_data_sign_mem,
	input					id_exception,
	output reg [31:0]  		exs_pc,
	output reg [3:0]   		exs_alu_operation,
	output reg [31:0]  		exs_rs1_data,
	output reg [31:0]  		exs_rs2_data,
	output reg [4:0]  		exs_rd_addr,
	output reg [31:0]  		exs_imm_shamt,
	output reg [1:0]		exs_ctrl_alu_port_a_select,
	output reg [1:0]		exs_ctrl_alu_port_b_select,
	output reg				exs_ctrl_data_w_reg_select,
	output reg				exs_ctrl_reg_w,
	output reg				exs_ctrl_mem_en,
	output reg [3:0]		exs_ctrl_mem_rw,
	output reg				exs_data_sign_mem,
	output reg 				exs_exception
    );

	always @(posedge clk) begin
		exs_pc <= (rst) ? 32'b0 : (ctrl_stall) ? exs_pc : id_pc;
		exs_alu_operation <= (rst) ? 5'b0 : (ctrl_stall) ? exs_alu_operation : id_alu_operation; 
		exs_rs1_data <= (rst) ? 32'b0 : (ctrl_stall) ? exs_rs1_data : id_rs1_data;
		exs_rs2_data <= (rst) ? 32'b0 : (ctrl_stall) ? exs_rs2_data : id_rs2_data;
		exs_rd_addr <= (rst) ? 5'b0 : (ctrl_stall) ? exs_rd_addr : id_rd_addr;
		exs_imm_shamt <= (rst) ? 32'b0 : (ctrl_stall) ? exs_imm_shamt : id_imm_shamt;
		exs_ctrl_alu_port_a_select <= (rst | ctrl_flush) ? 2'b0 : (ctrl_stall) ? exs_ctrl_alu_port_a_select : id_ctrl_alu_port_a_select;
		exs_ctrl_alu_port_b_select <= (rst | ctrl_flush) ? 2'b0 : (ctrl_stall) ? exs_ctrl_alu_port_b_select : id_ctrl_alu_port_b_select;
		exs_ctrl_data_w_reg_select <= (rst | ctrl_flush) ? 1'b0 : (ctrl_stall) ? exs_ctrl_data_w_reg_select : id_ctrl_data_w_reg_select;
		exs_ctrl_mem_en <= (rst | ctrl_flush) ? 32'b0 : (ctrl_stall) ? exs_ctrl_mem_en : id_ctrl_mem_en;
		exs_ctrl_mem_rw <= (rst | ctrl_flush) ? 32'b0 : (ctrl_stall) ? exs_ctrl_mem_rw : id_ctrl_mem_rw;
		exs_ctrl_reg_w <= (rst | ctrl_flush) ? 32'b0 : (ctrl_stall) ? exs_ctrl_reg_w : id_ctrl_reg_w;
		exs_ctrl_mem_rw <= (rst | ctrl_flush) ? 5'b0 : (ctrl_stall) ? exs_ctrl_mem_rw : id_ctrl_mem_rw;
		exs_data_sign_mem <= (rst | ctrl_flush) ? 1'b0 : (ctrl_stall) ? exs_data_sign_mem : id_data_sign_mem;
		exs_exception <= (rst | ctrl_flush) ? 1'b0 : (ctrl_stall) ? exs_exception : id_exception;
	end

endmodule //elbeth_id_exs_register
