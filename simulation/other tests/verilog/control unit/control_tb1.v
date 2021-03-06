////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : control_tb1.v
//  Last Modified : 2016-03-02 08:07:55
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//  Description   : test the elbeth_control_unit: stall for memory read/write
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_control_unit.v"

module control_tb1;
	// inputs and outputs

	reg 						rst = 0;
    reg 	[6:0] 				if_opcode;
	reg 	[3:0]				if_funct3;

	//Memory signals
	reg	 	       				if_imem_ready;
	reg							if_imem_en;
	reg							exs_dmem_ready;
	reg 						exs_dmem_en;
	//Datapath signals
	wire 	[1:0]					id_pc_select;
	wire	[1:0]					id_alu_port_a_select;
	wire	[1:0]					id_alu_port_b_select;
	wire							id_data_w_reg_select;
	wire							id_reg_w;
	wire 							id_mem_en;
	wire	[3:0]					id_data_size_mem;
	wire							id_data_sign_mem;
	//Stall signals
	wire							if_stall;
	wire							id_stall;

	// test process
	initial
		begin
			$dumpfile("control_tb1.vcd");
			$dumpvars(0,control_tb1);

//test the stall signals
			//test vector: inst mem rw
			#50
			if_imem_ready = 1'b0;
			if_imem_en = 1'b1;
			exs_dmem_ready = 1'b0;
			exs_dmem_en = 1'b0;

			//test vector: inst mem pos rw 1
			#50
			if_imem_ready = 1'b1;
			if_imem_en = 1'b1;
			exs_dmem_ready = 1'b0;
			exs_dmem_en = 1'b0;

			//test vector: inst mem pos rw 2
			#50
			if_imem_ready = 1'b1;
			if_imem_en = 1'b0;
			exs_dmem_ready = 1'b0;
			exs_dmem_en = 1'b0;

			//test vector: data mem rw
			#50
			if_imem_ready = 1'b0;
			if_imem_en = 1'b0;
			exs_dmem_ready = 1'b0;
			exs_dmem_en = 1'b1;

			//test vector: data mem pos rw 1
			#50
			if_imem_ready = 1'b0;
			if_imem_en = 1'b0;
			exs_dmem_ready = 1'b1;
			exs_dmem_en = 1'b1;

			//test vector: data mem pos rw 2
			#50
			if_imem_ready = 1'b0;
			if_imem_en = 1'b0;
			exs_dmem_ready = 1'b1;
			exs_dmem_en = 1'b0;

			//test vector: inst mem rw and data mem rw
			#50
			if_imem_ready = 1'b0;
			if_imem_en = 1'b1;
			exs_dmem_ready = 1'b0;
			exs_dmem_en = 1'b1;

			//test vector: inst mem rw and data mem pos rw 1
			#50
			if_imem_ready = 1'b1;
			if_imem_en = 1'b1;
			exs_dmem_ready = 1'b1;
			exs_dmem_en = 1'b1;

			//test vector: inst mem rw and data mem pos rw 2
			#50
			if_imem_ready = 1'b1;
			if_imem_en = 1'b0;
			exs_dmem_ready = 1'b1;
			exs_dmem_en = 1'b0;

			//test vector: inst mem rw and data mem pre rw 
			#50
			if_imem_ready = 1'b1;
			if_imem_en = 1'b1;
			exs_dmem_ready = 1'b0;
			exs_dmem_en = 1'b1;

			//test vector: inst mem pre rw and data mem rw 
			#50
			if_imem_ready = 1'b0;
			if_imem_en = 1'b1;
			exs_dmem_ready = 1'b1;
			exs_dmem_en = 1'b1;

			//finish
			#50
			$finish;

		end

	//test module instantiation
	elbeth_control_unit c1 (rst, 
							if_opcode, 
							if_funct3,
							if_imem_ready,
							if_imem_en,
							id_match_forward_rs1,
							id_match_forward_rs2,
							id_branch_taken,
							exs_dmem_ready,
							exs_dmem_en,
							exs_exception,
							if_stall,
							id_stall,
							if_flush,
							id_flush,
							id_pc_select,
							id_select_rs1,
							id_select_rs2,
							id_alu_port_a_select,
							id_alu_port_b_select,
							id_data_w_reg_select,
							id_reg_w,
							id_mem_en,
							id_mem_rw,
							id_data_sign_mem);

endmodule // control_tb