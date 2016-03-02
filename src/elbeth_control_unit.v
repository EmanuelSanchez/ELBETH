`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : elbeth_control_unit.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-03-01 23:32:37
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : Control unit: pipeline control and detec misaligned address to memory (no decode instructions)
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

module elbeth_control_unit(
	input							rst,
    input 	[6:0] 					if_opcode,				// instruction segmentation
	input	[2:0]					if_funct3,				// .
	input							if_imem_ready,			// Instruction memory signals
	input							if_imem_en,				// .
	input							id_match_forward_rs1,	// Hazar unit signals
	input							id_match_forward_rs2,	// .
	input							id_branch_taken,		// Branch unit signals
	input							exs_dmem_ready,			// Data memory signals
	input							exs_dmem_en,			// .
	input							exs_exception,			// Exception signal (exception always come from execute)
	output							if_stall,				// Stall signals 
	output							id_stall,				// .
	output 							if_flush,
	output 							id_flush,
	output 	[1:0]					if_pc_select, 			// Datapath signals
	output							id_rs1_select,			// .
	output							id_rs2_select,			// .
	output	[1:0]					id_alu_port_a_select,	// .
	output	[1:0]					id_alu_port_b_select,	// .
	output							id_data_w_reg_select,	// .
	output							id_reg_w,				// .
	output 							id_mem_en,				// .
	output	[3:0]					id_mem_rw,				// .
	output							id_data_sign_mem		// .
    );
	
	wire 				imem_request_stall;
	wire 				dmem_request_stall;
	wire 				id_data_size_mem;

	reg		[15:0]		 datapath;

	assign  id_data_size_mem = id_mem_rw;
	assign	imem_request_stall = if_imem_en & ~if_imem_ready;		// Need stall if the memory is enabled and the ready signal is dowm
	assign	dmem_request_stall = exs_dmem_en & ~exs_dmem_ready;		// .		
	assign	if_stall = imem_request_stall | dmem_request_stall;		// Pipeline stall (instruction fetch)
	assign  id_stall = dmem_request_stall;							// .    		  (instruction decode)
	assign 	if_flush = id_branch_taken | exs_exception;
	assign  id_flush = exs_exception;
//----------------------------------------------------------------------------------------------------------------------------------
// 					Datapath: it generates control signals
//----------------------------------------------------------------------------------------------------------------------------------
//   Bit     Name                		Description
//----------------------------------------------------------------------------------------------------------------------------------
//		15	:	if_pc_select					Select: (0) pc + 4, (1)	branch, (2) exception
//		14	:	.								
//		13	: 	id_rs1_select					Select: (0) rs1, (1) forwarding
//		12	:	id_rs2_select					Select: (0) rs2, (1) forwarding
//		11	:	id_alu_port_a_select			Select: (0) rs1, (1) pc, (2) forwarding
//		10  :	.
//		9	:	id_alu_port_b_select			Select: (0) rs2, (1) inmediate, (2) forwarding
//		8	:	.
//		7	:	id_data_reg_mem_select			Select: alu_result/memory_data		
//		6	:	id_reg_w						Write register enable
//		5	:	id_mem_en						Data Memory enable
//		4	:	id_data_size_mem 				Size of bytes to read o write: 	(0000) Write enable = 0
//		3	:	.																				(0001) byte & Write enable = 1
//		2	:	.																				(0010) halfword & Write enable = 1
//		1	:	.																				(1000) word &	Write enable = 1
//		0	:	id_data_sign_mem		 		Unsigned/Signed data memory
//---------------------------------------------------------------------------------------------------------------------------------

	assign	if_pc_select 		 = datapath[15:14];
	assign	id_rs1_select 		 = datapath[13];
	assign	id_rs2_select 		 = datapath[12];
	assign	id_alu_port_a_select = datapath[11:10];
	assign	id_alu_port_b_select = datapath[9:8];
	assign	id_data_w_reg_select = datapath[7];
	assign	id_reg_w 			 = datapath[6];
	assign	id_mem_en      		 = datapath[5];
	assign	id_data_size_mem 	 = datapath[4:1];
	assign	id_data_sign_mem	 = datapath[0];

//--------------------------------------------------------------------------
// set the control signals (control vectors)
//--------------------------------------------------------------------------

	always @(*) begin
		datapath[15:14] = (rst) ? 2'd0 : (exs_exception) ? 2'd2 : (id_branch_taken) ? 2'd1 : 2'b0; // Selecting exception pc
		datapath[13] = (rst) ? 1'd0 : (id_match_forward_rs1) ? 1'b1 : 1'b0;		 				// Selecting forwarding or rs1
		datapath[12] = (rst) ? 1'd0 : (id_match_forward_rs2) ? 1'b1 : 1'b0;		 				// Selecting forwarding or rs2
	end

	always @(*) begin
		case (if_opcode)
				`OP_TYPE_R :	begin datapath[11:0] = `R_CTRL_VECTOR; end
				`OP_TYPE_I :	begin datapath[11:0] = `I_CTRL_VECTOR; end
				`OP_TYPE_I_LOADS : begin
						case	(if_funct3)
								3'd0 : 	  begin datapath[11:0] = `I_LOADS_B_CTRL_VECTOR;	end
								3'd1 :    begin datapath[11:0] = `I_LOADS_H_CTRL_VECTOR;	end
								3'd2 :	  begin datapath[11:0] = `I_LOADS_W_CTRL_VECTOR;	end
								3'd4 :	  begin datapath[11:0] = `I_LOADS_UB_CTRL_VECTOR;	end
								3'd5 :	  begin datapath[11:0] = `I_LOADS_UH_CTRL_VECTOR; end
								default : begin datapath[11:0] = 12'bx; end
						endcase
				end
				`OP_TYPE_I_JALR :	begin datapath[11:0] = `I_JALR_CTRL_VECTOR; end
				`OP_TYPE_S : begin
						case	(if_funct3)
								3'd0 :	  begin datapath[11:0] = `S_B_CTRL_VECTOR; end
								3'd1 :	  begin datapath[11:0] = `S_H_CTRL_VECTOR; end
								3'd2 :	  begin datapath[11:0] = `S_W_CTRL_VECTOR	; end
								default : begin datapath[11:0] = 12'bx; end
						endcase
				end
				`OP_TYPE_SB :      begin datapath[11:0] = `SB_CTRL_VECTOR; end
				`OP_TYPE_U_LUI :   begin datapath[11:0] = `U_LUI_CTRL_VECTOR; end
				`OP_TYPE_U_AUIPC : begin datapath[11:0] = `U_AUIPC_CTRL_VECTOR; end
				`OP_TYPE_UJ_JAL :  begin datapath[11:0] = `UJ_JAL_CTRL_VECTOR; end
				default : 		   begin datapath = 16'b0; end
		endcase // if_funct3
	end // always @(*)

endmodule // elbeth_control_unit