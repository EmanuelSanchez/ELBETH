`timescale 1ns / 1ps
//==================================================================================================
//  Filename      : elbeth_defines.v
//  Created On    : Mon Aug 31 19:32:04 2015
//  Last Modified : 2016-02-29 10:33:04
//  Revision      : 0.1
//  Author        : NINISBETH SEGOVIA Y EMANUEL SANCHEZ
//  Company       : Universidad Simón Bolívar
//  Email         : 11-10960@usb.ve
//
//  Description   : Definiciones
//==================================================================================================


//--------------------------------------------------------------------------
// Maximum range
//--------------------------------------------------------------------------

`define MAX_RANGE			32'hFFFFFFFF	// maximum value represented with 32 bits

//--------------------------------------------------------------------------
// Instruction formats: opcodes types instructions
//--------------------------------------------------------------------------

`define OP_TYPE_I           7'b0010011
`define OP_TYPE_U_LUI       7'b0110111        
`define OP_TYPE_U_AUIPC     7'b0010111        
`define OP_TYPE_R           7'b0110011         
`define OP_TYPE_UJ_JAL      7'b1101111        
`define OP_TYPE_I_JALR      7'b1100111         
`define OP_TYPE_SB          7'b1100011         
`define OP_TYPE_I_LOADS     7'b0000011          
`define OP_TYPE_S           7'b0100011          

//----------------------------------------------------------------------------------------------------------------------------------
// Control Vectors
//----------------------------------------------------------------------------------------------------------------------------------
//   Bit     Name                		Description
//----------------------------------------------------------------------------------------------------------------------------------
//		15	:	if_pc_select					Select: (0) pc + 4, (1)	branch, (2) exception
//		14	:	.								
//		13	: 	id_select_rs1					Select: (0) rs1, (1) forwarding
//		12	:	id_select_rs2					Select: (0) rs2, (1) forwarding
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

`define R_CTRL_VECTOR				12'b0000010xxxxx
`define I_CTRL_VECTOR				12'b0001010xxxxx
`define I_LOADS_B_CTRL_VECTOR		12'b000111100001
`define I_LOADS_H_CTRL_VECTOR		12'b000111100001
`define I_LOADS_W_CTRL_VECTOR		12'b000111100001
`define I_LOADS_UB_CTRL_VECTOR		12'b000111100000
`define I_LOADS_UH_CTRL_VECTOR		12'b000111100000
`define I_JALR_CTRL_VECTOR			12'b0101010xxxxx
`define S_W_CTRL_VECTOR				12'b0001x011000x
`define S_H_CTRL_VECTOR				12'b0001x010010x
`define S_B_CTRL_VECTOR				12'b0001x010001x
`define SB_CTRL_VECTOR				12'bxxxxx00xxxxx
`define U_LUI_CTRL_VECTOR			12'b001010xxxxxx
`define U_AUIPC_CTRL_VECTOR			12'b101010xxxxxx
`define UJ_JAL_CTRL_VECTOR			12'b101010xxxxxx

//--------------------------------------------------------------------------
// ALU operations
//--------------------------------------------------------------------------

`define OP_ADD				4'd0
`define OP_SUB				4'd1
`define OP_AND				4'd2
`define OP_OR				4'd3
`define OP_XOR				4'd4
`define OP_SLT				4'd5
`define OP_SLTU				4'd6
`define OP_SLL				4'd7
`define OP_SRL				4'd8
`define OP_SRA				4'd9
`define OP_LUI				4'd10
`define OP_AUIPC			4'd11

//--------------------------------------------------------------------------
// Branch operations
//--------------------------------------------------------------------------

`define OP_JAL				3'd0
`define OP_JALR				3'd1
`define OP_BEQ				3'd2
`define OP_BNE				3'd3
`define OP_BLT				3'd4
`define OP_BGE				3'd5
`define OP_BLTU				3'd6
`define OP_BGEU				3'd7

//--------------------------------------------------------------------------
// Size data memory
//--------------------------------------------------------------------------

`define BYTE				4'b0001
`define HALFWORD			4'b0010
`define WORD				4'b1000

//--------------------------------------------------------------------------
// Hazard unit
//--------------------------------------------------------------------------

`define RD_ZERO				5'b0
`define MEM_READ			4'b0
`define FROM_ALU			1'b0
`define FROM_MEM			1'b1