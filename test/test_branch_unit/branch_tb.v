////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : branch_tb.v
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//  Description   : test to the branch unit: JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

module branch_tb;
	// inputs and outputs
    reg [31:0] 			offset;
    reg [31:0] 			id_pc;
    reg [2:0] 			operation;
    reg [31:0]			id_data_rs1;
    reg [31:0] 			id_data_rs2;
	wire [31:0] 		pc_branch;
	wire 				branch_taken;

	// test process
	initial
	begin
		$dumpfile("branch_tb.vcd");
		$dumpvars(0,branch_tb);

		//test the stall signals
		//vector test: JAL
		offset = 32'hF2;
		id_pc = 32'hFFFF0000;
		operation = `OP_JAL;

		//vector test: JALR
		offset = 32'hF8;
		id_pc = 32'hFFAA0000;
		operation = `OP_JALR;

		//vector test: BEQ
		offset = 32';
		id_pc = ;
		operation = `OP_BEQ;
		id_data_rs1 = ;
		id_data_rs2 = ;

		//vector test: BNE
		offset = 32';
		id_pc = ;
		operation = `OP_BNE;
		id_data_rs1 = ;
		id_data_rs2 = ;

		//vector test: BLT
		offset = 32';
		id_pc = ;
		operation = `OP_BLT;
		id_data_rs1 = ;
		id_data_rs2 = ;

		//vector test: BGE
		offset = 32';
		id_pc = ;
		operation = `OP_BGE;
		id_data_rs1 = ;
		id_data_rs2 = ;

		//vector test: BLTU
		offset = 32';
		id_pc = ;
		operation = `OP_BLTU;
		id_data_rs1 = ;
		id_data_rs2 = ;

		//vector test: BGEU
		offset = 32';
		id_pc = ;
		operation = `OP_BGEU;
		id_data_rs1 = ;
		id_data_rs2 = ;

	end

	elbeth_branch_unit b1 (offset,
						  id_pc,
						  operation,
						  id_data_rs1,
						  id_data_rs2,
						  pc_branch,
						  branch_taken);

endmodule // branch_tb