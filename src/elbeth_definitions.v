//==================================================================================================
//  Filename      : elbeth_defines.v
//  Created On    : Mon Aug 31 19:32:04 2015
//  Last Modified : 2016-03-30 15:35:55
//  Revision      : 0.1
//  Author        : NINISBETH SEGOVIA Y EMANUEL SANCHEZ
//  Company       : Universidad Simón Bolívar
//  Email         : 11-10960@usb.ve
//
//  Description   : Definiciones
//==================================================================================================

//--------------------------------------------------------------------------
// Others definitions
//--------------------------------------------------------------------------

`define MAX_RANGE			32'hFFFFFFFF	// maximum value represented with 32 bits
`define NOP					32'h00000033	//Nop or burble

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
`define OP_TYPE_SYSTEM		7'b1110011  
`define OP_FENCE			7'b0001111
`define OP_MULT			    7'b0110011 


//--------------------------------------------------------------------------
// PRIV Funct3
//--------------------------------------------------------------------------

`define F3_PRIV		 3'd0  
`define F3_CSRRW  	 3'd1
`define F3_CSRRS  	 3'd2
`define F3_CSRRC  	 3'd3
`define F3_CSRRWI 	 3'd5
`define F3_CSRRSI 	 3'd6
`define F3_CSRRCI 	 3'd7

//--------------------------------------------------------------------------
// PRIV Funct12
//--------------------------------------------------------------------------

`define FUNCT12_ECALL  12'b000000000000
`define FUNCT12_EBREAK 12'b000000000001
`define FUNCT12_ERET   12'b000100000000

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

`define R_CTRL_VECTOR				7'b000010x
`define I_CTRL_VECTOR				7'b010010x
`define I_LOADS_B_CTRL_VECTOR		7'b0101110
`define I_LOADS_H_CTRL_VECTOR		7'b0101110
`define I_LOADS_W_CTRL_VECTOR		7'b0101110
`define I_LOADS_UB_CTRL_VECTOR		7'b0101110
`define I_LOADS_UH_CTRL_VECTOR		7'b0101110
`define I_JALR_CTRL_VECTOR			7'b110010x
`define S_W_CTRL_VECTOR				7'b01xx011
`define S_H_CTRL_VECTOR				7'b01xx011
`define S_B_CTRL_VECTOR				7'b01xx011
`define SB_CTRL_VECTOR				7'bxxxx00x
`define U_LUI_CTRL_VECTOR			7'b010010x
`define U_AUIPC_CTRL_VECTOR			7'b110010x
`define UJ_JAL_CTRL_VECTOR			7'b110010x
`define CSR_PRV_CTRL_VECTOR			7'bxxxx00x
`define CSR_CMD_CTRL_VECTOR 		7'b001010x
`define CSR_CMDI_CTRL_VECTOR		7'b011010x

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

`define BYTE				4'b1001
`define HALFWORD			4'b1010
`define WORD				4'b1100
`define BYTE_UNSIGNED		4'b0001
`define HALFWORD_UNSIGNED	4'b0010

//--------------------------------------------------------------------------
// Memormy Read/Write
//--------------------------------------------------------------------------

`define MEM_READ			4'b0
`define MEM_W_BYTE			4'b0001
`define MEM_W_HALFWORD		4'b0011
`define MEM_W_WORD			4'b1111

//--------------------------------------------------------------------------
// Hazard unit
//--------------------------------------------------------------------------

`define RD_ZERO				5'b0
`define FROM_ALU			1'b0
`define FROM_MEM			1'b1

//--------------------------------------------------------------------------
// CSR address
//--------------------------------------------------------------------------

`define CSR_ADDR_CYCLE     12'hC00
`define CSR_ADDR_TIME      12'hC01
`define CSR_ADDR_INSTRET   12'hC02
`define CSR_ADDR_CYCLEH    12'hC80
`define CSR_ADDR_TIMEH     12'hC81
`define CSR_ADDR_INSTRETH  12'hC82
`define CSR_ADDR_MCPUID    12'hF00
`define CSR_ADDR_MIMPID    12'hF01
`define CSR_ADDR_MHARTID   12'hF10
`define CSR_ADDR_MSTATUS   12'h300
`define CSR_ADDR_MTVEC     12'h301
`define CSR_ADDR_MTDELEG   12'h302
`define CSR_ADDR_MIE       12'h304
`define CSR_ADDR_MTIMECMP  12'h321
`define CSR_ADDR_MTIME     12'h701
`define CSR_ADDR_MTIMEH    12'h741
`define CSR_ADDR_MSCRATCH  12'h340
`define CSR_ADDR_MEPC      12'h341
`define CSR_ADDR_MCAUSE    12'h342
`define CSR_ADDR_MBADADDR  12'h343
`define CSR_ADDR_MIP       12'h344
`define CSR_ADDR_CYCLEW    12'h900
`define CSR_ADDR_TIMEW     12'h901
`define CSR_ADDR_INSTRETW  12'h902
`define CSR_ADDR_CYCLEHW   12'h980
`define CSR_ADDR_TIMEHW    12'h981
`define CSR_ADDR_INSTRETHW 12'h982

`define CSR_ADDR_TO_HOST   12'h780
`define CSR_ADDR_FROM_HOST 12'h781

//--------------------------------------------------------------------------
// CSR comands
//--------------------------------------------------------------------------

`define CSR_READ      3'd4
`define CSR_WRITE     3'd5
`define CSR_SET       3'd6
`define CSR_CLEAR     3'd7

//--------------------------------------------------------------------------
// Exception codes
//--------------------------------------------------------------------------

`define ECODE_INST_ADDR_MISALIGNED       4'd0
`define ECODE_INST_ADDR_FAULT            4'd1
`define ECODE_ILLEGAL_INST               4'd2
`define ECODE_BREAKPOINT                 4'd3
`define ECODE_LOAD_ADDR_MISALIGNED       4'd4
`define ECODE_LOAD_ACCESS_FAULT          4'd5
`define ECODE_STORE_AMO_ADDR_MISALIGNED  4'd6
`define ECODE_STORE_AMO_ACCESS_FAULT     4'd7
`define ECODE_ECALL_FROM_U               4'd8
`define ECODE_ECALL_FROM_S               4'd9
`define ECODE_ECALL_FROM_H               4'd10
`define ECODE_ECALL_FROM_M               4'd11

//--------------------------------------------------------------------------
// Priviliged modes
//--------------------------------------------------------------------------

`define PRV_U         2'd0
`define PRV_S         2'd1
`define PRV_H         2'd2
`define PRV_M         2'd3