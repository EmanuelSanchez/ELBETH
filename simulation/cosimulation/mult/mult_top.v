// Jan Marjanovic, 2015
//
// This is a top module which combines DUT and MyHDL signals

module mult_top;

	reg				rst=0;
	reg				clk;
	reg 			mult_en;
	reg [31:0] 			data_a;					// values (32 bits) values for operation
    reg [31:0] 			data_b;					// values (32 bits) values for operation
    reg 					hilo_select;
    wire 					result_ready;
	wire [31:0] 		mult_result;

	mult mult(
    	.clk(clk),
		.rst(rst),
		.mult_en(mult_en),
		.data_a(data_a),
		.data_b(data_b),
		.hilo_select(hilo_select),
		.result_ready(result_ready),
		.mult_result(mult_result)
		);

initial begin
	$from_myhdl(clk, rst, mult_en, data_a, data_b, hilo_select);
	$to_myhdl(result_ready, mult_result);
end

initial begin
    $dumpfile("mult.vcd");
    $dumpvars();
end

endmodule
