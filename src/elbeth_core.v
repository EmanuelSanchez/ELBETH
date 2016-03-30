`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : elbeth_core.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-03-30 09:07:54
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : Core
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_mux_2_to_1.v"
`include "elbeth_mux_3_to_1.v"
`include "elbeth_mux_4_to_1.v"
`include "elbeth_control_unit.v"
`include "elbeth_add4.v"
`include "elbeth_pc_register.v"
`include "elbeth_if_id_register.v"
`include "elbeth_decoder.v"
`include "elbeth_hazard_unit.v"
`include "elbeth_branch_unit.v"
`include "elbeth_register_file.v"
`include "elbeth_id_exs_register.v"
`include "elbeth_alu.v"
`include "elbeth_csr_register.v"
`include "elbeth_bridge_memory.v"

module elbeth_core(
    input			 	 clk,
    input				 rst,
	//Instruction memory
	input  [31:0]		 imem_in_data,		//instruction
	input  				 imem_ready,
	input 				 imem_error,
	output [13:0]		 imem_addr,			//pc
	output 				 imem_en,
	output [3:0]		 imem_rw,
	output [31:0]		 imem_out_data,

	//Data memory
	input  [31:0]		 dmem_in_data,
	input 				 dmem_ready,
	input 				 dmem_error,
	output [13:0]		 dmem_addr,
	output 				 dmem_en,
	output [3:0]		 dmem_rw,
	output [31:0]		 dmem_out_data
    );

	//Wires to instruction fetch
	 wire 	[31:0]		if_instruction;
	//Wires to instruction memory
	 wire 	[31:0]		if_pc_add4;
	 wire 	[1:0]		if_pc_select;
	 wire 	[31:0]		if_pc;
	 wire   [31:0]		if_next_pc;
	 wire 				pc_reg_stall;
	 wire 	[3:0]		if_except_src;
	//Wires to instruction decode
	 wire 	[31:0]		id_pc;
	 wire 	[2:0]		id_funct3;
	 wire 	[31:0]		id_pc_branch;
	 wire 	[31:0] 		id_offset_branch;
	 wire 	[2:0]		id_op_branch;
	 wire 	[4:0]		id_rs1_addr;
	 wire 	[4:0]		id_rs2_addr;
	 wire 	[4:0]		id_rd_addr;
	 wire 	[31:0]		id_imm_shamt;
	 wire 	[31:0]		id_rs1_data_gpr;
	 wire 	[31:0]		id_rs2_data_gpr;
	 wire 	[3:0]		id_op_alu;
	 wire 	[31:0]		id_rs1_data;
	 wire 	[31:0]		id_rs2_data;
	 wire 	[3:0]		id_data_inf;
	 wire 	[2:0]		id_csr_cmd;
	 wire 	[11:0]		id_csr_addr;
	 wire  	[1:0] 		id_data_w_gpr_select;
	 wire 	[3:0] 		id_except_src_from_if;
	 wire 	[3:0]		id_except_src_decode;
	 wire 	[3:0] 		id_except_src;
	 wire 				reg_file_w_en;
	//Wires to instruction segmentation
	 wire	[31:0]		id_instruction;
	 wire	[6:0]		opcode;
	 wire	[4:0]		inst_0;
	 wire	[2:0]		inst_1;
	 wire	[4:0]		inst_2;
	 wire	[4:0]		inst_3;
	 wire	[6:0]		inst_4;
	//Wires to execute
	 wire 	[31:0]		exs_pc_except;
	 wire 	[4:0]		exs_rd_addr;
	 wire 	[31:0]		exs_rd_data;
	 wire 	[31:0]		exs_pc;
	 wire 	[2:0]		exs_funct3;
	 wire 	[3:0] 		exs_alu_operation;
	 wire 	[31:0]		exs_rs1_data;
	 wire 	[31:0]		exs_rs2_data;
	 wire 	[31:0]		exs_imm_shamt;
	 wire 	[31:0] 		exs_alu_data_a;
	 wire 	[31:0]		exs_alu_data_b;
	 wire 	[31:0]		exs_alu_result;
	 wire 	[3:0]		exs_data_inf;
	 wire 	[31:0]		exs_gpr_data_mem;
	 wire 	[3:0] 		exs_except_src_from_id;
	 wire 	[3:0] 		exs_except_src;
	 wire  	[1:0] 		exs_data_w_gpr_select;
	 wire 				exs_exception;
	//Wires to data memory
	 wire	[31:0]		exs_data_memory_out;
	 wire 	[3:0] 		exs_except_src_from_mem;

	//Wires to CSR
	 wire [11:0]		exs_csr_addr;
	 wire [31:0]		exs_epc;
	 wire [2:0]			exs_csr_cmd;
	 wire [31:0]		exs_csr_wdata;
	 wire [1:0] 		csr_prv;

	//Instruction segmentation
	 assign opcode = id_instruction[6:0];
	 assign inst_0 = id_instruction[11:7];
	 assign inst_1 = id_instruction[14:12];
	 assign inst_2 = id_instruction[19:15];
	 assign inst_3 = id_instruction[24:20];
	 assign inst_4 = id_instruction[31:25];
	//Registeer file enable
	 assign reg_file_w_en = (!id_stall) & exs_gpr_w;
	 
	 assign exs_exception = exs_csr_exception | except_illegal_acces;
//--------------------------------------------------------------------------
// IF stage
//--------------------------------------------------------------------------

	elbeth_add4 pc_adder_4 (
		//Inputs
		 .in(if_pc),
		//Outputs
		 .out(if_pc_add4)
		 );

	elbeth_mux_4_to_1 pc_select (
		//Inputs
		.mux_in_1(if_pc_add4), 
		.mux_in_2(id_pc_branch), 
		.mux_in_3(exs_pc_except),
		.mux_in_4(exs_epc),
		//IN Control Signals
		.bit_select(if_pc_select), 
		//Outputs
		.mux_out(if_next_pc)
    );

	elbeth_pc_register pc_register (
		 //Inputs
		 .clk(clk), 
		 .rst(rst),
		 .next_pc(if_next_pc),
		 //In Control Signals
		 .ctrl_stall(if_pc_stall),
		 //Outputs
		 .pc(if_pc)
		 );

	elbeth_bridge_memory brige_memory_cpu(
		//Memory port A
		.amem_en(imem_en),
		.amem_addr(imem_addr),
		.amem_in_data(imem_in_data),
		.amem_rw(imem_rw),
		.amem_out_data(imem_out_data),
		.amem_ready(imem_ready),
		.amem_error(imem_error),
		//Memory port B
		.bmem_en(dmem_en),
		.bmem_addr(dmem_addr),
		.bmem_in_data(dmem_in_data),
		.bmem_rw(dmem_rw),
		.bmem_out_data(dmem_out_data),
		.bmem_ready(dmem_ready),
		.bmem_error(dmem_error),
		//Processor instruction memory
		.imem_en(if_mem_en),
		.imem_addr(if_pc),
		.imem_in_data(if_instruction),
		.imem_ready(id_imem_ready),
		.imem_except(if_except),
		.imem_except_src(if_except_src),
		//Processor data memory
		.dmem_data_inf(exs_data_inf),
		.dmem_rw(exs_mem_rw),
		.dmem_en(exs_mem_en),
		.dmem_addr(exs_alu_result),
		.dmem_out_data(exs_rs2_data),
		.dmem_in_data(exs_data_memory_out),
		.dmem_ready(exs_dmem_ready),
		.dmem_except(exs_except_from_mem),
		.dmem_except_src(exs_except_src_from_mem)
		);

	elbeth_if_id_register if_id_register (
		 //Inputs
		 .clk(clk), 
		 .rst(rst), 
		 .if_instruction(if_instruction), 
		 .if_pc(if_pc),
		 .if_except(if_except),
		 .if_except_src(if_except_src),
		 //In Control Signals 
		 .ctrl_stall(if_stall), 
		 .ctrl_flush(if_flush),
		 //Outputs
		 .id_instruction(id_instruction),
		 .id_pc(id_pc),
		 .id_except(id_except_from_if),
		 .id_except_src(id_except_src_from_if)
		 );
		 
//--------------------------------------------------------------------------
// ID stage
//--------------------------------------------------------------------------

	elbeth_decoder decoder_unit (
		 //Inputs
		 .rst(rst),
		 .opcode(opcode), 
		 .inst_0(inst_0), 
		 .inst_1(inst_1), 
		 .inst_2(inst_2), 
		 .inst_3(inst_3), 
		 .inst_4(inst_4),
		 .csr_prv(csr_prv),
		 //Outputs
		 .id_offset_branch(id_offset_branch), 
		 .id_op_branch(id_op_branch), 
		 .id_rs1_addr(id_rs1_addr), 
		 .id_rs2_addr(id_rs2_addr), 
		 .id_rd_addr(id_rd_addr), 
		 .id_imm_shamt(id_imm_shamt), 
		 .id_op_alu(id_op_alu),
		 .id_data_inf(id_data_inf),
		 .id_except(id_except_from_decode),
		 .id_except_src(id_except_src_decode),
		 .id_eret(id_eret),
		 .csr_cmd(id_csr_cmd),
		 .csr_addr(id_csr_addr)
		 );

	elbeth_hazard_unit hazard_unit (
		 .id_rs1(id_rs1_addr),
		 .id_rs2(id_rs2_addr),
		 .exs_rd_addr(exs_rd_addr),
		 .exs_w_gpr_en(exs_gpr_w),
		 .match_forward_rs1(id_match_forward_rs1),
		 .match_forward_rs2(id_match_forward_rs2)
		);

	elbeth_register_file register_file (
		 //Inputs
		 .clk(clk), 
		 .id_rs1_addr(id_rs1_addr), 
		 .id_rs2_addr(id_rs2_addr), 
		 .rd_data(exs_rd_data), 
		 .rd_addr(exs_rd_addr),
		 //In Control Signals
		 .ctrl_w_enable(reg_file_w_en),
		 //Outputs
		 .id_rs1_data(id_rs1_data_gpr), 
		 .id_rs2_data(id_rs2_data_gpr)
		 );

	elbeth_branch_unit branch_unit (
		 //Inputs
		 .offset(id_offset_branch), 
		 .id_pc(id_pc), 
		 .operation(id_op_branch), 
		 .id_data_rs1(id_rs1_data), 
		 .id_data_rs2(id_rs2_data), 
		 //Ouputs
		 .pc_branch(id_pc_branch),
		 .branch_taken(branch_taken)
		 );

	elbeth_mux_2_to_1 rs1_select (
		 //Inputs
		 .mux_in_1(id_rs1_data_gpr), 
		 .mux_in_2(exs_rd_data), 
		 //In Control Signals
		 .bit_select(id_rs1_select), 
		 //Outputs
		 .mux_out(id_rs1_data)
		 );

	elbeth_mux_2_to_1 rs2_select (
		 //Inputs
		 .mux_in_1(id_rs2_data_gpr), 
		 .mux_in_2(exs_rd_data), 
		 //In Control Signals
		 .bit_select(id_rs2_select), 
		 //Outputs
		 .mux_out(id_rs2_data)
		 );

	elbeth_id_exs_register id_exs_register	(
		 //Inputs
		 .clk(clk), 
		 .rst(rst), 
		 .ctrl_stall(id_stall), 
		 .ctrl_flush(id_flush),
		 .id_pc(id_pc),
		 .id_funct3(inst_1),
		 .id_alu_operation(id_op_alu), 
		 .id_rs1_data(id_rs1_data), 
		 .id_rs2_data(id_rs2_data), 
		 .id_rd_addr(id_rd_addr), 
		 .id_imm_shamt(id_imm_shamt),
		 //In Control Signals
		 .id_ctrl_alu_port_a_select(id_alu_port_a_select), 
		 .id_ctrl_alu_port_b_select(id_alu_port_b_select),  
		 .id_ctrl_data_w_reg_select(id_data_w_gpr_select), 
		 .id_ctrl_reg_w(id_gpr_w),
		 .id_ctrl_mem_en(id_mem_en),
		 .id_ctrl_mem_rw(id_mem_rw), 
		 .id_data_inf(id_data_inf),
		 .id_exception(id_except_to_exs),
		 .id_except_src(id_except_src),
		 .id_eret(id_eret),										//Falta en control
		 .id_csr_cmd(id_csr_cmd),
		 .id_csr_addr(id_csr_addr),
		 //Outpus
		 .exs_pc(exs_pc),
		 .exs_funct3(exs_funct3),
		 .exs_alu_operation(exs_alu_operation),
		 .exs_rs1_data(exs_rs1_data), 
		 .exs_rs2_data(exs_rs2_data), 
		 .exs_rd_addr(exs_rd_addr), 
		 .exs_imm_shamt(exs_imm_shamt),
		 //Out Control Signals
		 .exs_ctrl_alu_port_a_select(exs_alu_port_a_select), 
		 .exs_ctrl_alu_port_b_select(exs_alu_port_b_select),  
		 .exs_ctrl_data_w_reg_select(exs_data_w_gpr_select),
		 .exs_ctrl_reg_w(exs_gpr_w),
		 .exs_ctrl_mem_en(exs_mem_en),
		 .exs_ctrl_mem_rw(exs_mem_rw),
		 .exs_data_inf(exs_data_inf),
		 .exs_exception(exs_except_from_id),
		 .exs_except_src(exs_except_src_from_id),
		 .exs_eret(exs_eret),
		 .exs_csr_cmd(exs_csr_cmd),
		 .exs_csr_addr(exs_csr_addr)
		 );
		 
//--------------------------------------------------------------------------
// EXS stage
//--------------------------------------------------------------------------

	elbeth_mux_2_to_1 alu_port_a_select (
		 //Inputs
		 .mux_in_1(exs_rs1_data),
		 .mux_in_2(exs_pc), 
		 //In Control Signals
		 .bit_select(exs_alu_port_a_select), 
		 //Outputs
		 .mux_out(exs_alu_data_a)
		 );

	elbeth_mux_2_to_1 alu_port_b_select (
		 //Inputs
		 .mux_in_1(exs_rs2_data), 
		 .mux_in_2(exs_imm_shamt), 
		 //In Control Signals
		 .bit_select(exs_alu_port_b_select),
		 //Outputs
		 .mux_out(exs_alu_data_b)
		 );

	elbeth_alu alu (
		 //Inputs
		 .data_a(exs_alu_data_a), 
		 .data_b(exs_alu_data_b), 
		 .operation(exs_alu_operation), 
		 //Outputs
		 .alu_result(exs_alu_result)
		 );

	elbeth_mux_3_to_1 write_reg_data_select(
		 //Inputs
		 .mux_in_1(exs_alu_result), 
		 .mux_in_2(exs_data_memory_out),
		 .mux_in_3(exs_csr_wdata),
		 //In Control Signals
		 .bit_select(exs_data_w_gpr_select), 
		 //Outputs
		 .mux_out(exs_rd_data)
		 );

	elbeth_csr_register csr(
		 //Inputs
		 .clk(clk),
		 .rst(rst),
		 .addr(exs_csr_addr),
		 .cmd(exs_csr_cmd),
		 .wdata(exs_alu_result),
		 .retire(exs_retire),  							
		 .exception(exs_csr_exception),
		 .exception_code(exs_except_src),
		 .eret(exs_eret),									// Falta agregar a control (output)
		 .exception_load_addr(exs_alu_result),
		 .exception_pc(exs_pc),
		 .prv(csr_prv),
		 .io_interrupt(),
		 .illegal_access(except_illegal_acces),
		 .rdata(exs_csr_wdata),
		 .handler_pc(exs_pc_except),
		 .epc(exs_epc),
		 .io_interrupt_code()
		 );
	
//--------------------------------------------------------------------------
// Control Unit
//--------------------------------------------------------------------------
	
	elbeth_control_unit control_unit(
		 //Inputs
		 .clk(clk),
		 .rst(rst),
		 .if_opcode(opcode),
		 .if_funct3(inst_1),
		 .exs_funct3(exs_funct3),
		 //In Control Signals
		 .if_imem_ready(id_imem_ready),
		 .if_imem_en(imem_en),
		 .id_match_forward_rs1(id_match_forward_rs1),
		 .id_match_forward_rs2(id_match_forward_rs2),
		 .id_branch_taken(branch_taken),
		 .id_except_from_if(id_except_from_if),
		 .id_except_from_decode(id_except_from_decode),
		 .id_except_src_if(id_except_src_from_if),
		 .exs_dmem_ready(exs_dmem_ready),
		 .exs_dmem_en(dmem_en),
		 .exs_except_from_id(exs_except_from_id),
		 .exs_except_from_mem(exs_except_from_mem),
		 .exs_except_src_id(exs_except_src_from_id),
		 .exs_except_src_mem(exs_except_src_from_mem),
		 .except_illegal_acces(except_illegal_acces),
		 .exs_eret(exs_eret),
		 //Out Control Signals
		 .if_mem_en(if_mem_en),
		 .if_stall(if_stall),
		 .if_flush(if_flush),
		 .if_pc_stall(if_pc_stall),
		 .id_stall(id_stall),
		 .id_flush(id_flush),
		 .if_pc_select(if_pc_select),
		 .id_rs1_select(id_rs1_select),
		 .id_rs2_select(id_rs2_select),
		 .id_alu_port_a_select(id_alu_port_a_select), 
		 .id_alu_port_b_select(id_alu_port_b_select), 
		 .id_data_w_reg_select(id_data_w_gpr_select), 
		 .id_reg_w(id_gpr_w),
		 .id_mem_en(id_mem_en),
		 .id_mem_rw(id_mem_rw),
		 .id_exception(id_except_to_exs),
		 .id_exception_src(id_except_src),
		 .exs_csr_imm_select(exs_csr_imm_select),
		 .exs_exception_src(exs_except_src),
		 .exs_retire(exs_retire),
		 .exs_exception(exs_csr_exception)
		 );
endmodule // core