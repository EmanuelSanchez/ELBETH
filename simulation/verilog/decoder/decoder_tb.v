////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : decoder_tb.v
//  Last Modified : 2016-03-07 13:48:21
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : module to decodification of instructions
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_decoder.v"

module decoder_tb;
// inputs and outputs
    reg 	[6:0] 				opcode;
	reg 	[4:0]				inst_0;
	reg 	[2:0]				inst_1;
	reg 	[4:0]				inst_2;
	reg 	[4:0]				inst_3;
	reg 	[6:0]				inst_4;
	reg 	[1:0] 				csr_prv;
    wire	[31:0]				id_offset_branch;
	wire	[3:0]				id_op_branch;
    wire 	[4:0] 				id_rs1_addr;
    wire 	[4:0]	 			id_rs2_addr;
	wire 	[4:0] 				id_rd_addr;
	wire 	[31:0] 				id_imm_shamt;
    wire	[3:0] 				id_op_alu;
    wire	 					id_except_illegal_instruction;
    wire    [3:0] 				id_except_src;
    wire    [2:0]				csr_cmd;
    wire    [11:0]				csr_addr;

// test process
	initial
		begin
			$dumpfile("decoder_tb.vcd");
			$dumpvars(0,decoder_tb);

			//test vector: ipcode = 0
			opcode = 7'b0;

			//finish
			#50
			$finish();
		end

	elbeth_decoder d1 (opcode,
					  inst_0,
					  inst_1,
					  inst_2,
					  inst_3,
					  inst_4,
					  csr_prv,
					  id_offset_branch,
					  id_op_branch,
					  id_rs1_addr,
					  id_rs2_addr,
					  id_rd_addr,
					  id_imm_shamt,
					  id_op_alu,
					  id_except_illegal_instruction,
					  id_except_src,
					  csr_cmd,
					  csr_addr);

endmodule // decoder_tb