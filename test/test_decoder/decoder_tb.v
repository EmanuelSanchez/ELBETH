////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : decoder_tb.v
//  Last Modified : 2016-02-25 22:42:22
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : module to decodification of instructions
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////

module decoder_tb;
// inputs and outputs
    reg 	[6:0] 				opcode;
	reg 	[4:0]				inst_0;
	reg 	[2:0]				inst_1;
	reg 	[4:0]				inst_2;
	reg 	[4:0]				inst_3;
	reg 	[6:0]				inst_4;
    wire	[31:0]				id_offset_branch;
	wire	[3:0]				id_op_branch;
    wire 	[4:0] 				id_rs1_addr;
    wire 	[4:0]	 			id_rs2_addr;
	wire 	[4:0] 				id_rd_addr;
	wire 	[31:0] 				id_imm_shamt;
    wire	[3:0] 				id_op_alu;

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
					  id_offset_branch,
					  id_op_branch,
					  id_rs1_addr,
					  id_rs2_addr,
					  id_rd_addr,
					  id_imm_shamt,
					  id_op_alu);

endmodule // decoder_tb