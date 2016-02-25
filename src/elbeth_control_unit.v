`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : elbeth_control_unit.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-02-24 14:47:59
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : Memory Ram with Dual port
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

module elbeth_control_unit(
	input							rst,
    input 	[6:0] 					if_opcode,
	input	[3:0]					if_funct3,
	//Instruction memory
	input							imem_ready,
	input							dmem_ready,
	input							imem_request_stall,
	input							dmem_request_stall,
	 
	output 	[1:0]					if_pc_select,
	output							if_imem_en,
	output							if_
    output							id_registers_stall,	 
	output	[1:0]					id_alu_port_a_select,
	output	[1:0]					id_alu_port_b_select,
	output							id_data_w_reg_select,
	output							id_reg_w,
	output 							id_mem_en,
	output	[3:0]					id_data_size_mem,
	output							id_data_sign_mem,
	
	output							if_stall,
	output							id_stall
    );

	reg		[14:0]		 datapath;

	assign	if_pc_select 		 = (rst) ? 2'b0 : datapath[14:13];
	assign	id_registers_stall 	 = (rst) ? 1'b0 : datapath[12];
	assign	id_alu_port_a_select = (rst) ? 2'b0 : datapath[11:10];
	assign	id_alu_port_b_select = (rst) ? 2'b0 : datapath[9:8];
	assign	id_data_w_reg_select = (rst) ? 1'b0 : datapath[7];
	assign	id_reg_w 			 = (rst) ? 1'b0 :datapath[6];
	assign	id_mem_en      		 = (rst) ? 1'b0 : datapath[5];
	assign	id_data_size_mem 	 = (rst) ? 2'b0 : datapath[4:1];
	assign	id_data_sign_mem	 = (rst) ? 1'b0 : datapath[0];
	
	assign	if_stall = ()

//--------------------------------------------------------------------------
// Pipeline Stall
//--------------------------------------------------------------------------	

/*
  --------------------------------------------------------------------------------
     Bit     Description
  --------------------------------------------------------------------------------
	  2		stall PC register
	  1		stall if_id register
	  0		stall id_exs register
*/

	always @(*) begin :
		pipeline_stall = (imem_request_stall) ? `PC_STALL;
		pipeline_stall = (dmem_request_stall) ? `ID_IF_STALL;
		
	end

/*
//--------------------------------------------------------------------------
// 	Control vectors
//--------------------------------------------------------------------------	
  --------------------------------------------------------------------------------
     Bit     Name                		Description
  --------------------------------------------------------------------------------
		14	:	if_pc_select					Select: (0) pc + 4, (1)	branch, (2) exception
		13	:	.								
		12	: 	id_registers_stall				Stall the pipeline
		11	:	id_alu_port_a_select			Select: (0) rs1, (1) pc, (2) forwarding
		10 :	.
		9	:	id_alu_port_b_select			Select: (0) rs2, (1) inmediate, (2) forwarding
		8	:	.
		7	:	id_data_reg_mem_select			Select: alu_result/memory_data		
		6	:	id_reg_w						Write register enable
		5	:	id_mem_en						Data Memory enable
		4	:	id_data_size_mem 				Size of bytes to read o write: 	(0000) Write enable = 0
		3	:	.																				(0001) byte & Write enable = 1
		2	:	.																				(0010) halfword & Write enable = 1
		1	:	.																				(1000) word &	Write enable = 1
		0	:	id_data_sign_mem		 		Unsigned/Signed data memory
*/

	always @(*) begin
		case (if_opcode)
				`OP_TYPE_R :	begin	
						datapath = `R_CTRL_VECTOR;
				end
				`OP_TYPE_I :	begin
						datapath = `I_CTRL_VECTOR;
				end
				`OP_TYPE_I_LOADS : begin
						case	(if_funct3)
								3'd0 :	begin datapath = `I_LOADS_B_CTRL_VECTOR;	end
								3'd1 :	begin datapath = `I_LOADS_H_CTRL_VECTOR;	end
								3'd2 :	begin datapath = `I_LOADS_W_CTRL_VECTOR;	end
								3'd4 :	begin datapath = `I_LOADS_UB_CTRL_VECTOR;	end
								3'd5 :	begin datapath = `I_LOADS_UH_CTRL_VECTOR; end
								default : begin datapath = 15'bx; end
						endcase
				end
				`OP_TYPE_I_JALR : begin
							datapath = `I_JALR_CTRL_VECTOR;
				end
				`OP_TYPE_S : begin
						case	(if_funct3)
								3'd0 :	 begin datapath = `S_B_CTRL_VECTOR; end
								3'd1 :	 begin datapath = `S_H_CTRL_VECTOR; end
								3'd2 :	 begin datapath = `S_W_CTRL_VECTOR	; end
								default : begin datapath = 15'bx; end
						endcase
				end
				`OP_TYPE_SB : begin
						datapath = `SB_CTRL_VECTOR;
				end
				`OP_TYPE_U_LUI : begin
						datapath = `U_LUI_CTRL_VECTOR;
				end
				`OP_TYPE_U_AUIPC : begin
						datapath = `U_AUIPC_CTRL_VECTOR;
				end
				`OP_TYPE_UJ_JAL : begin
						datapath = `UJ_JAL_CTRL_VECTOR;
				end
				default : begin datapath = 15'bx; end
		endcase
	end

endmodule
