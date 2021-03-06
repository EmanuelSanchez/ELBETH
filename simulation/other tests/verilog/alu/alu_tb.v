`include "elbeth_alu.v"

module alu_tb;
	// inputs and outputs

	reg [31:0]	data_a;
	reg [31:0]	data_b;
	reg [3:0]	operation;
	wire [31:0]	alu_result;

	// test process
	initial
		begin
			$dumpfile("alu_tb.vcd");
			$dumpvars(0,alu_tb);
			$monitor("PORT_A: %0d, PORT_B: %0d, RESULTADO = %0d", data_a, data_b, alu_result);

			//test vector #1: ADD
			#50
			data_a = 32'd3;
			data_b = 32'd4;
			operation = 4'd0;

			//test vector #2: SUB
			#50
			data_a = 32'd5;
			data_b = 32'd2;
			operation = 4'd1;

			//test vector #3: OR
			#50
			data_a = 32'b1010;
			data_b = 32'b0101;
			operation = 4'd3;

			//test vector #4: SLT
			#50
			data_a = 32'd3;
			data_b = 32'd4;
			operation = 4'd5;

			//finish
			#50 
			$finish;

		end

	//test module instantiation
	elbeth_alu alu1 (data_a, data_b, operation, alu_result);

endmodule // alu_tb