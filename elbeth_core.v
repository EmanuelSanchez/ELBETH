`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:56:19 01/31/2016 
// Design Name: 
// Module Name:    core 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module core(
    input			 	 clk,
    input				 rst,
	 //Instruction Memory
	 input  [31:0]		 imem_r_data,		//douta = instruction
	 output [31:0]		 imem_addr,			//addra  = pc
	 //Data Memory
	 input  [31:0]		 dmem_r_data,		//doutb = data
	 output [31:0]		 dmem_addr,			//addrb = alu_result
	 output [31:0]		 dmem_enb,
	 output [3:0]		 dmem_data_size,
	 output [31:0]		 dmem_w_data		
    );
	 
	 //Wires to Instruction Memory
	 wire	  [31:0]		addres_data_memory;
	 wire	  [31:0]		instrucion_memory;
	 //Wires to Data Memory
	 wire	  [31:0]		data_memory_out;
	 wire	  [3:0]		size_data_memory;
	
	 wire	  [31:0]		id_instruction;
	 wire					opcode;
	 wire					inst_0;
	 wire					inst_1;
	 wire					inst_2;
	 wire					inst_3;
	 wire					inst_4;
	 
	 assign	imem_r_data = if_instruction;
	 assign	imem_addr 	= pc;
	 
	 assign	dmem_r_data 	= data_memory_out;
	 assign	dmem_addr 		= alu_result;
	 assign	dmem_enb 		= exs_ctrl_mem_en;
	 assign	dmem_data_size	= size_data_memory;
	 assign	dmem_w_data		= exs_rs2_data;

	//Instruction segmentation
	 assign opcode = id_instruction[6:0];
	 assign inst_0 = id_instruction[11:7];
	 assign inst_1 = id_instruction[14:12];
	 assign inst_2 = id_instruction[19:15];
	 assign inst_3 = id_instruction[24:20];
	 assign inst_4 = id_instruction[31:25];
	 
//--------------------------------------------------------------------------
// IF stage
//--------------------------------------------------------------------------

	elbeth_add4 pc_adder_4 (
		//Inputs
		 .in(pc), 
		//Outputs
		 .out(pc_add4)
		 );

	elbeth_mux_3_to_1 pc_select (
		//Inputs
		.mux_in_1(pc_add4), 
		.mux_in_2(pc_branch), 
		.mux_in_3(pc_except),
		//IN Control Signals
		.bit_select(if_pc_select), 
		//Outputs
		.mux_out(next_pc)
    );

	elbeth_pc_register pc_register (
		 //Inputs
		 .clk(clk), 
		 .rst(rst),
		 .next_pc(next_pc), 
		 //In Control Signals
		 .ctrl_stall(ctrl_stall),
		 //Outputs
		 .pc(pc)
		 );

	elbeth_if_id_register if_id_register (
		 //Inputs
		 .clk(clk), 
		 .rst(rst), 
		 .if_instruction(if_instruction), 
		 .if_pc(pc), 
		 //In Control Signals
		 .ctrl_stall(ctrl_stall), 
		 //Outputs
		 .id_instruction(id_instruction),
		 .id_pc(id_pc)
		 );
		 
//--------------------------------------------------------------------------
// ID stage
//--------------------------------------------------------------------------

	elbeth_decoder decoder_unit (
		 //Inputs
		 .opcode(opcode), 
		 .inst_0(inst_0), 
		 .inst_1(inst_1), 
		 .inst_2(inst_2), 
		 .inst_3(inst_3), 
		 .inst_4(inst_4), 
		 //Outputs
		 .id_offset_branch(id_offset_branch), 
		 .id_op_branch(id_op_branch), 
		 .id_rs1_addr(id_rs1_addr), 
		 .id_rs2_addr(id_rs2_addr), 
		 .id_rd_addr(id_rd_addr), 
		 .id_imm_shamt(id_imm_shamt), 
		 .id_op_alu(id_op_alu)
		 );

	elbeth_register_file register_file (
		 //Inputs
		 .clk(clk), 
		 .id_rs1_addr(id_rs1_addr), 
		 .id_rs2_addr(id_rs2_addr), 
		 .rd_data(exs_rd_data), 
		 .rd_addr(exs_rd_addr),
		 //In Control Signals
		 .ctrl_w_enable(exs_ctrl_reg_w),
		 //Outputs
		 .id_rs1_data(id_rs1_data), 
		 .id_rs2_data(id_rs2_data)
		 );

	elbeth_branch_unit branch_unit (
		 //Inputs
		 .offset(id_offset_branch), 
		 .id_pc(id_pc), 
		 .operation(id_op_branch), 
		 .id_data_rs1(id_rs1_data), 
		 .id_data_rs2(id_rs2_data), 
		 //Ouputs
		 .pc_branch(pc_branch)
		 );

	elbeth_id_exs_register id_exs_register	(
		 //Inputs
		 .clk(clk), 
		 .rst(rst), 
		 .ctrl_stall(ctrl_stall), 
		 .id_pc(id_pc), 
		 .id_alu_operation(id_op_alu), 
		 .id_rs1_data(id_rs1_data), 
		 .id_rs2_data(id_rs2_data), 
		 .id_rd_addr(id_rd_addr), 
		 .id_imm_shamt(id_imm_shamt), 
		 //In Control Signals
		 .id_ctrl_stall(id_ctrl_stall), 
		 .id_ctrl_alu_port_a_select(id_alu_port_a_select), 
		 .id_ctrl_alu_port_b_select(id_alu_port_b_select),  
		 .id_ctrl_data_w_reg_select(id_data_w_reg_select), 
		 .id_ctrl_reg_w(id_reg_w), 
		 .id_ctrl_mem_en(id_mem_en), 
		 .id_data_size_mem(id_data_size_mem), 
		 .id_data_sign_mem(id_data_sign_mem),
		 //Outpus
		 .exs_pc(exs_pc), 
		 .exs_alu_operation(exs_alu_operation), 
		 .exs_rs1_data(exs_rs1_data), 
		 .exs_rs2_data(exs_rs2_data), 
		 .exs_rd_addr(exs_rd_addr), 
		 .exs_imm_shamt(exs_imm_shamt),
		 //Out Control Signals
		 .exs_ctrl_stall(exs_ctrl_stall), 
		 .exs_ctrl_alu_port_a_select(exs_ctrl_alu_port_a_select), 
		 .exs_ctrl_alu_port_b_select(exs_ctrl_alu_port_b_select),  
		 .exs_ctrl_data_w_reg_select(exs_ctrl_data_w_reg_select),
		 .exs_ctrl_reg_w(exs_ctrl_reg_w), 
		 .exs_ctrl_mem_en(exs_ctrl_mem_en), 
		 .exs_data_size_mem(size_data_memory), 
		 .exs_data_sign_mem(exs_data_sign_mem)
		 );
		 
//--------------------------------------------------------------------------
// EXS stage
//--------------------------------------------------------------------------

	elbeth_mux_3_to_1 alu_port_a_select (
		 //Inputs
		 .mux_in_1(exs_rs1_data), 
		 .mux_in_2(exs_pc), 
		 .mux_in_3(mux_in_3), 										//Por incluir Forwarding
		 //In Control Signals
		 .bit_select(exs_ctrl_alu_port_a_select), 
		 //Outputs
		 .mux_out(alu_data_a)										//
		 );

	elbeth_mux_3_to_1 alu_port_b_select (
		 //Inputs
		 .mux_in_1(exs_rs2_data), 
		 .mux_in_2(exs_imm_shamt), 
		 .mux_in_3(mux_in_3), 									//Por incluir Forwarding
		 //In Control Signals
		 .bit_select(exs_ctrl_alu_port_b_select),
		 //Outputs
		 .mux_out(alu_data_b)										//
		 );

	elbeth_alu alu (
		 //Inputs
		 .data_a(alu_data_a), 
		 .data_b(alu_data_b), 
		 .operation(exs_alu_operation), 
		 //Outputs
		 .alu_result(alu_result)
		 );

	zero_signed_extend instance_name (
		 //Inputs
		 .data_mem(data_memory_out), 
		 .ctrl_data_size(ctrl_data_size), 
		 //In Control Signals
		 .ctrl_data_signed(exs_data_sign_mem), 
		 //Outputs
		 .reg_data_mem(reg_data_mem)
		 );

	mux_2_to_1 write_reg_data_select(
		 //Inputs
		 .mux_in_1(alu_result), 
		 .mux_in_2(reg_data_mem), 
		 //In Control Signals
		 .bit_select(exs_ctrl_data_w_reg_select), 
		 //Outputs
		 .mux_out(exs_rd_data)
		 );
//--------------------------------------------------------------------------
// Control Unit
//--------------------------------------------------------------------------
	
	elbeth_control_unit control_unit (
		 //Inputs
		 .rst(rst), 
		 .if_opcode(opcode),
		 .if_funct3(inst_1),
		 //In Control Signals
		 .exs_mem_ready(exs_mem_ready),
		 //Out Control Signals
		 .if_pc_select(if_pc_select), 
		 .id_registers_stall(id_registers_stall), 		//Incluir senal de la Inst Memory
		 .id_alu_port_a_select(id_alu_port_a_select), 
		 .id_alu_port_b_select(id_alu_port_b_select), 
		 .id_data_w_reg_select(id_data_w_reg_select), 
		 .id_reg_w(id_reg_w),
		 .id_mem_en(id_mem_en), 
		 .id_data_size_mem(id_data_size_mem), 
		 .id_data_sign_mem(id_data_sign_mem)
		 );

endmodule
