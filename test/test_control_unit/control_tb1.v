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
							exs_dmem_ready,
							exs_dmem_en,
							id_pc_select,
							id_alu_port_a_select,
							id_alu_port_b_select,
							id_data_w_reg_select,
							id_reg_w,
							id_mem_en,
							id_data_size_mem,
							id_data_sign_mem,
							if_stall,
							id_stall);

endmodule // control_tb