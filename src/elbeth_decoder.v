////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : elbeth_decoder.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-03-30 16:04:02
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : module to decodification of instructions
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

module elbeth_decoder(
	input						rst,
    input 	[6:0] 				opcode,
	input 	[4:0]				inst_0,
	input 	[2:0]				inst_1,
	input 	[4:0]				inst_2,
	input 	[4:0]				inst_3,
	input 	[6:0]				inst_4,
	input 	[1:0]				csr_prv,
    output reg [31:0]			id_offset_branch,
	output reg	[2:0]			id_op_branch,
    output reg [4:0] 			id_rs1_addr,
    output reg [4:0] 			id_rs2_addr,
	output reg [4:0] 			id_rd_addr,
	output reg [31:0] 			id_imm_shamt,
    output reg [3:0] 			id_op_alu,
    output reg [3:0]			id_data_inf,
    output	 					id_except,
    output	   [3:0] 			id_except_src,
    output reg [2:0]			csr_cmd,
    output reg [11:0]			csr_addr,
    output reg 					id_eret
    );

	wire 	[4:0]			rd;
	wire 	[4:0]			rs1;
	wire 	[4:0]			rs2;
	wire 	[2:0]			funct3;
	wire					funct7;
	wire 	[11:0]			funct12;
	reg 					illegal_instruction;
	reg 					ecall;
	reg 					ebreak;
	
	assign rd = inst_0;
	assign funct3 = inst_1;
	assign rs1 = inst_2;
	assign rs2 = inst_3;
	assign funct7 = inst_4[5];
	assign funct12 = {{inst_4[6:0]}, {inst_3[4:0]}};
	assign id_except = illegal_instruction | ecall;
	assign id_except_src = (id_except) ? (illegal_instruction) ? `ECODE_ILLEGAL_INST : (`ECODE_ECALL_FROM_U + csr_prv) : 4'd0;

	always @(*) begin
		ecall = 1'b0;
		ebreak = 1'b0;
		illegal_instruction = 1'b0;
		csr_addr = 12'b0;
		csr_cmd = 3'b0;
		id_eret = 1'b0;
		id_op_branch = 3'bx;
		id_data_inf = 4'b0;
		case (opcode)
				`OP_TYPE_R :	begin
						id_rd_addr <= rd;
						id_rs1_addr <= rs1;
						id_rs2_addr <= rs2;
						case	(funct3)
								3'd0 :	begin		id_op_alu = (funct7) ? `OP_SUB : `OP_ADD; end
								3'd1 :	begin		id_op_alu = `OP_SLL; end
								3'd2 :	begin		id_op_alu = `OP_SLT; end
								3'd3 :	begin		id_op_alu = `OP_SLTU; end
								3'd4 :	begin		id_op_alu = `OP_XOR; end
								3'd5 :	begin		id_op_alu = (funct7) ? `OP_SRA : `OP_SRL; end
								3'd6 :	begin		id_op_alu = `OP_OR; end
								3'd7 :	begin		id_op_alu = `OP_AND; end
								default : begin	id_op_alu = 3'bx; end
						endcase								
				end
				`OP_TYPE_I :	begin
						id_rd_addr <= rd;
						id_rs1_addr <= rs1;
						case	(funct3)
								3'd0 :	begin		
										id_op_alu = `OP_ADD;
										id_imm_shamt <= { {21{inst_4[6]}}, {inst_4[5:0]}, {inst_3[4:0]}}; end
								3'd1 :	begin		
										id_op_alu <= `OP_SLL;
										id_imm_shamt <= { 27'b0, inst_3}; end
								3'd2 :	begin
										id_op_alu = `OP_SLT;
										id_imm_shamt <= { {21{inst_4[6]}}, {inst_4[5:0]}, {inst_3[4:0]}}; end
								3'd3 :	begin
										id_op_alu = `OP_SLTU;
										id_imm_shamt <= { {21{inst_4[6]}}, {inst_4[5:0]}, {inst_3[4:0]}}; end
								3'd4 :	begin
										id_op_alu = `OP_XOR;
										id_imm_shamt <= { {21{inst_4[6]}}, {inst_4[5:0]}, {inst_3[4:0]}}; end
								3'd5 :	begin		
										id_op_alu <= (funct7) ? `OP_SRA : `OP_SRL;
										id_imm_shamt <= { 27'b0, inst_3}; end
								3'd6 :	begin
										id_op_alu = `OP_OR;
										id_imm_shamt <= { {21{inst_4[6]}}, {inst_4[5:0]}, {inst_3[4:0]}}; end
								3'd7 :	begin
										id_op_alu = `OP_AND;
										id_imm_shamt <= { {21{inst_4[6]}}, {inst_4[5:0]}, {inst_3[4:0]}}; end
								default : begin	id_op_alu = 3'bx; end
						endcase
				end
				`OP_TYPE_I_LOADS : begin
						id_rd_addr <= rd;
						id_rs1_addr <= rs1;
						id_imm_shamt <= { {21{inst_4[6]}}, {inst_4[5:0]}, {inst_3[4:0]}};
						id_op_alu <= `OP_ADD;
						case	(funct3)
								3'd0 : 	  begin id_data_inf = `BYTE;	end
								3'd1 :    begin id_data_inf = `HALFWORD;	end
								3'd2 :	  begin id_data_inf = `WORD;	end
								3'd4 :	  begin id_data_inf = `BYTE_UNSIGNED;	end
								3'd5 :	  begin id_data_inf = `HALFWORD_UNSIGNED; end
								default : illegal_instruction = 1'b1;
						endcase
				end
				`OP_TYPE_I_JALR : begin
						id_rd_addr <= rd;
						id_rs1_addr <= rs1;
						id_imm_shamt <= { {29'd0}, {3'd4}};
						id_offset_branch <= { {21{inst_4[6]}}, {inst_4[5:0]}, {inst_3[4:1]}, 1'b0};
						id_op_alu <= `OP_ADD;
						id_op_branch <= `OP_JALR;
				end
				`OP_TYPE_S : begin
						id_rs1_addr <= rs1;
						id_rs2_addr <= rs2;
						id_imm_shamt <= { {21{inst_4[6]}}, {inst_4[5:0]}, {inst_0[4:0]}};
						id_op_alu <= `OP_ADD;
						case	(funct3)
								3'd0 : 	  begin id_data_inf = `BYTE;	end
								3'd1 :    begin id_data_inf = `HALFWORD;	end
								3'd2 :	  begin id_data_inf = `WORD;	end
								default : illegal_instruction = 1'b1;
						endcase
				end
				`OP_TYPE_SB : begin
						id_rs1_addr <= rs1;
						id_rs2_addr <= rs2;
						id_offset_branch <= { {20{inst_4[6]}}, {inst_0[0]}, {inst_4[5:0]}, {inst_0[4:1]}, {1'b0}};
						case	(funct3)
								3'd0 :	begin		id_op_branch = `OP_BEQ; end
								3'd1 :	begin		id_op_branch = `OP_BNE; end
								3'd4 :	begin		id_op_branch = `OP_BLT; end
								3'd5 :	begin		id_op_branch = `OP_BGE; end
								3'd6 :	begin		id_op_branch = `OP_BLTU; end
								3'd7 :	begin		id_op_branch = `OP_BGEU; end
								default : begin	id_op_branch = 3'bx; end
						endcase
				end
				`OP_TYPE_U_LUI : begin
						id_rd_addr <= rd;
						id_rs1_addr <= 5'd0;
						id_imm_shamt <= {{inst_4[6:0]}, {inst_3[4:0]}, {inst_2[4:0]}, {inst_1[2:0]}, {12'b0}};
						id_op_alu <= `OP_ADD;
				end
				`OP_TYPE_U_AUIPC : begin
						id_rd_addr <= rd;
						id_imm_shamt <= {{inst_4[6:0]}, {inst_3[4:0]}, {inst_2[4:0]}, {inst_1[2:0]}, {12'b0}};
						id_op_alu <= `OP_ADD;						
				end
				`OP_TYPE_UJ_JAL : begin
						id_rd_addr <= rd;
						id_imm_shamt <= { {29'd0}, {3'd4}};
						id_offset_branch <= { {12{inst_4[6]}}, {inst_2[4:0]}, {inst_1[2:0]}, {inst_3[0]}, {inst_4[5:0]}, {inst_3[4:1]}, {1'b0}};							
						id_op_alu <= `OP_ADD;
						id_op_branch <= `OP_JAL;
				end
				`OP_FENCE : begin
						id_rd_addr <= 5'd0;
						id_op_alu <= 4'b0;
						id_rs1_addr <= 5'b0;
						id_rs2_addr <= 5'b0;
				end
				`OP_TYPE_SYSTEM : begin
						id_rd_addr <= rd;
						csr_addr <= funct12;						//falta agregar a la pared id_exs
						case (funct3)
								`F3_PRIV :	begin
									if ((id_rs1_addr == 0) && (id_rd_addr == 0)) begin
											case (funct12)
													`FUNCT12_ECALL : ecall = 1'b1;
													`FUNCT12_EBREAK : ebreak = 1'b1;
													`FUNCT12_ERET : begin
														if (csr_prv == 0)
																illegal_instruction = 1'b1;
														else
																id_eret = 1'b1;
													end // FUNCT12_ERET :
													default : illegal_instruction = 1'b1;
											endcase // funct12
										end // if ((id_rs1_addr == 0) && (id_rd_addr == 0))
								end // case : F3_PRIV
								`F3_CSRRW :	begin	
									csr_cmd <= (id_rs1_addr == 5'b0) ? `CSR_READ : `CSR_WRITE; 
									id_rs1_addr <= rs1;
									id_rs2_addr <= 5'b0;
									id_op_alu <= `OP_ADD;
								end
								`F3_CSRRS :	begin	
									csr_cmd <= (id_rs1_addr == 0) ? `CSR_READ : `CSR_SET; 
									id_rs1_addr <= rs1;
									id_rs2_addr <= 5'b0;
									id_op_alu <= `OP_ADD;
								end
								`F3_CSRRC :	begin	
									csr_cmd <= (id_rs1_addr == 0) ? `CSR_READ : `CSR_CLEAR; 
									id_rs1_addr <= rs1;
									id_rs2_addr <= 5'b0;
									id_op_alu <= `OP_ADD;
								end
								`F3_CSRRWI : begin	
									csr_cmd <= (id_rs1_addr == 0) ? `CSR_READ : `CSR_WRITE; 
									id_imm_shamt <= {{27'b0}, {inst_2[4:0]}};
									id_rs1_addr <= 5'b0;
									id_op_alu <= `OP_ADD;
								end
								`F3_CSRRSI : begin	
									csr_cmd <= (id_rs1_addr == 0) ? `CSR_READ : `CSR_SET; 
									id_imm_shamt <= {{27'b0}, {inst_2[4:0]}};
									id_rs1_addr <= 5'b0;
									id_op_alu <= `OP_ADD;
								end
								`F3_CSRRCI : begin	
									csr_cmd <= (id_rs1_addr == 0) ? `CSR_READ : `CSR_CLEAR; 
									id_imm_shamt <= {{27'b0}, {inst_2[4:0]}};
									id_rs1_addr <= 5'b0;
									id_op_alu <= `OP_ADD;
								end
								default : begin	illegal_instruction = 1'b1; end
						endcase // case(funct3)
				end // case : OP_TYPE_SYSTEM
				default : begin illegal_instruction = 1'b1; end
		endcase // opcode
	end // always @(*)
endmodule // elbeth_decoder