// Jan Marjanovic, 2015
//
// This is a top module which combines DUT and MyHDL signals

module alu_top;

reg 	[31:0] 	data_a;
reg 	[31:0]	data_b;
reg		[3:0]	operation;
wire 	[31:0] 	result;

alu dut (.data_a(data_a), .data_b(data_b), .operation(operation), .alu_result(result));

initial begin
	$from_myhdl(data_a, data_b, operation);
	$to_myhdl(result);
end

initial begin
    $dumpfile("alu.vcd");
    $dumpvars();
end

endmodule
