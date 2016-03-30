////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : elbeth_control_unit.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-03-29 22:18:16
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
	input 							clk,
	input							rst,
    input 	[6:0] 					if_opcode,				// instruction segmentation
	input	[2:0]					if_funct3,				// .
	input	[2:0]					exs_funct3,				//
	input							if_imem_ready,			// Instruction memory signals
	input							if_imem_en,				// .
	input							id_match_forward_rs1,	// Hazar unit signals
	input							id_match_forward_rs2,	// .
	input							id_branch_taken,		// Branch unit signals
	input 							id_except_from_if,
	input 							id_except_from_decode,
	input							exs_dmem_ready,			// Data memory signals
	input							exs_dmem_en,			// .
	input 							exs_except_from_id,
	input 							exs_except_from_mem,
	input 							except_illegal_acces,
	input 							exs_eret,
	output							if_pc_stall,
	output 	[1:0]					if_pc_select, 			// Datapath signals
	output							if_stall,				// Stall signals 
	output 							if_mem_en,
	output 							if_flush,
	output							id_stall,				// .
	output 							id_flush,
	output							id_rs1_select,			// .
	output							id_rs2_select,			// .
	output							id_alu_port_a_select,	// .
	output							id_alu_port_b_select,	// .
	output	[1:0]					id_data_w_reg_select,	// .
	output							id_reg_w,				// .
	output 							id_mem_en,				// .
	output 							id_mem_rw,
	output							id_exception,
	output							id_except_src_select,
	output							exs_csr_imm_select,
	output 							exs_exception,
	output							exs_except_src_select,
	output							exs_retire
    );

	wire 				imem_request_stall;
	wire 				dmem_request_stall;
	reg 				eret_internal;

	wire 				id_except;
	wire 				exs_except;

	reg		[14:0]		 datapath;

	always @(posedge clk) begin
		if(eret_internal) begin
			 eret_internal <= 0;
		end else begin
			 eret_internal <= exs_eret;
		end
	end

	assign	imem_request_stall = (if_imem_en & ~if_imem_ready);
	assign	dmem_request_stall = exs_dmem_en & ~exs_dmem_ready;
	assign  id_except = id_except_from_if | id_except_from_decode;
	assign  exs_except = exs_except_from_id | exs_except_from_mem | except_illegal_acces;

	//Other control signals
	assign	if_pc_stall = dmem_request_stall | (imem_request_stall & (!exs_eret)) | eret_internal;
	assign	if_stall = (rst) ? 1'b1 : dmem_request_stall | (imem_request_stall & (!exs_eret)) | eret_internal;
	assign 	if_flush = (rst) ? 1'b0 : id_branch_taken | exs_except | exs_eret;
	assign	id_stall = (rst) ? 1'b1 : dmem_request_stall | (imem_request_stall & (!exs_eret)) | eret_internal;
	assign 	id_except_src_select = (id_except_from_if) ? 1'b0 : 1'b1;
	assign  id_flush = (rst) ? 1'b0 : exs_except | exs_eret;
	assign 	id_exception = id_except;
	assign 	exs_csr_imm_select = exs_funct3[2];
	assign  exs_retire = !(exs_exception | id_stall | id_flush);
	assign  exs_except_src_select = (exs_except_from_id) ? 1'b0 : 1'b1;
	assign 	exs_exception = exs_except;
	assign  if_mem_en = (~rst & ~if_imem_ready & ~exs_except);

//----------------------------------------------------------------------------------------------------------------------------------
// Control Vectors
//----------------------------------------------------------------------------------------------------------------------------------
//   Bit     Name                		Description
//----------------------------------------------------------------------------------------------------------------------------------
//		10	:	if_pc_select					Select: (0) pc + 4, (1)	branch, (2) exception (3) epc
//		9	:	.								
//		8	: 	id_select_rs1					Select: (0) rs1, (1) forwarding
//		7	:	id_select_rs2					Select: (0) rs2, (1) forwarding
//		6	:	id_alu_port_a_select			Select: (0) rs1, (1) pc
//		5	:	id_alu_port_b_select			Select: (0) rs2, (1) inmediate
//		4	:	id_data_reg_mem_select			Select: (0) alu_result (1) memory_data (2) csr
//		3	:   .
//		2	:	id_reg_w						Write register enable
//		1	:	id_mem_en						Data Memory enable
// 		0   :   id_mem_rw 						Select: (0) read, (1) write
//---------------------------------------------------------------------------------------------------------------------------------

	assign	if_pc_select			= datapath[10:9];
	assign	id_rs1_select 			= datapath[8];
	assign	id_rs2_select 		 	= datapath[7];
	assign	id_alu_port_a_select 	= datapath[6];
	assign	id_alu_port_b_select 	= datapath[5];
	assign	id_data_w_reg_select 	= datapath[4:3];
	assign	id_reg_w 			 	= datapath[2];
	assign	id_mem_en      		 	= datapath[1];
	assign	id_mem_rw	 			= datapath[0];

//--------------------------------------------------------------------------
// set the control signals (control vectors)
//--------------------------------------------------------------------------

	always @(*) begin
		if( !id_except_from_decode ) begin
			datapath[10] <= (rst) ? 1'd0 : (exs_except) ? 1'b1 : (exs_eret) ? 1'b1 : (id_branch_taken) ? 1'b0 : 1'b0; // Selecting exception pc
			datapath[9] <= (rst) ? 1'd0 : (exs_except) ? 1'b0 : (exs_eret) ? 1'b1 : (id_branch_taken) ? 1'b1 : 1'b0; // Selecting exception pc
			datapath[8] <= (rst) ? 1'd0 : (id_match_forward_rs1) ? 1'b1 : 1'b0;		 				// Selecting forwarding or rs1
			datapath[7] <= (rst) ? 1'd0 : (id_match_forward_rs2) ? 1'b1 : 1'b0;		 				// Selecting forwarding or rs2
		end // if( !id_except_from_decode )
		else
			datapath[10:7] = 4'b0;
	end // always @(*)

	always @(*) begin
		if( !id_except_from_decode ) begin
				case (if_opcode)
						`OP_TYPE_R :	begin datapath[6:0] = `R_CTRL_VECTOR; end
						`OP_TYPE_I :	begin datapath[6:0] = `I_CTRL_VECTOR; end
						`OP_TYPE_I_LOADS : begin
								case	(if_funct3)
										3'd0 : 	  begin datapath[6:0] = `I_LOADS_B_CTRL_VECTOR;	end
										3'd1 :    begin datapath[6:0] = `I_LOADS_H_CTRL_VECTOR;	end
										3'd2 :	  begin datapath[6:0] = `I_LOADS_W_CTRL_VECTOR;	end
										3'd4 :	  begin datapath[6:0] = `I_LOADS_UB_CTRL_VECTOR;	end
										3'd5 :	  begin datapath[6:0] = `I_LOADS_UH_CTRL_VECTOR; end
										default : begin datapath[6:0] = 12'bx; end
								endcase
						end
						`OP_TYPE_I_JALR :	begin datapath[6:0] = `I_JALR_CTRL_VECTOR; end
						`OP_TYPE_S : begin
								case	(if_funct3)
										3'd0 :	  begin datapath[6:0] = `S_B_CTRL_VECTOR; end
										3'd1 :	  begin datapath[6:0] = `S_H_CTRL_VECTOR; end
										3'd2 :	  begin datapath[6:0] = `S_W_CTRL_VECTOR	; end
										default : begin datapath[6:0] = 12'bx; end
								endcase
						end
						`OP_TYPE_SB :      begin datapath[6:0] = `SB_CTRL_VECTOR; end
						`OP_TYPE_U_LUI :   begin datapath[6:0] = `U_LUI_CTRL_VECTOR; end
						`OP_TYPE_U_AUIPC : begin datapath[6:0] = `U_AUIPC_CTRL_VECTOR; end
						`OP_TYPE_UJ_JAL :  begin datapath[6:0] = `UJ_JAL_CTRL_VECTOR; end
						`OP_FENCE : begin datapath[6:0] = `R_CTRL_VECTOR; end
						`OP_TYPE_SYSTEM :  begin
								case (if_funct3)
										`F3_PRIV :	 begin datapath[6:0] = `CSR_PRV_CTRL_VECTOR; end
										`F3_CSRRW :	 begin datapath[6:0] = `CSR_CMD_CTRL_VECTOR; end
										`F3_CSRRS :	 begin datapath[6:0] = `CSR_CMD_CTRL_VECTOR; end
										`F3_CSRRC :	 begin datapath[6:0] = `CSR_CMD_CTRL_VECTOR; end
										`F3_CSRRWI : begin datapath[6:0] = `CSR_CMDI_CTRL_VECTOR; end
										`F3_CSRRSI : begin datapath[6:0] = `CSR_CMDI_CTRL_VECTOR; end
										`F3_CSRRCI : begin datapath[6:0] = `CSR_CMDI_CTRL_VECTOR; end
								endcase // if_funct3
						end
						default : begin datapath = 7'b0; end
				endcase // if_funct3
		end // if( !id_except_from_decode )
		else
			datapath[6:0] = 7'b0;
	end // always @(*)

endmodule // elbeth_control_unit