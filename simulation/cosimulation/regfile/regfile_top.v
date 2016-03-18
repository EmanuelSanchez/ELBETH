// Jan Marjanovic, 2015
//
// This is a top module which combines DUT and MyHDL signals

module alu_top;

    reg						clk;						// clock
	reg [4:0] 				id_rs1_addr;				//	dirección del registro "a" a leer
    reg [4:0] 				id_rs2_addr;				// dirección del registro "b" a leer
    reg [31:0] 				exs_rd_data;					// dato a escribir en "d"
    reg [4:0] 				exs_rd_addr;						// dirección del registro "d" a escribir
	reg						reg_file_w_en;			// señal de control para activar la escritura
    wire [31:0] 			id_rs1_data_gpr;				// dato del registro "a"
    wire [31:0] 			id_rs2_data_gpr;

	elbeth_register_file dut (
		 //Inputs
		 .clk(clk), 
		 .id_rs1_addr(id_rs1_addr), 
		 .id_rs2_addr(id_rs2_addr), 
		 .rd_data(exs_rd_data), 
		 .rd_addr(exs_rd_addr),
		 //In Control Signals
		 .ctrl_w_enable(reg_file_w_en),
		 //Outputs
		 .id_rs1_data(id_rs1_data_gpr), 
		 .id_rs2_data(id_rs2_data_gpr)
		 );

initial begin
	$from_myhdl(clk, id_rs1_addr, id_rs2_addr, exs_rd_data, exs_rd_addr, reg_file_w_en);
	$to_myhdl(id_rs1_data_gpr, id_rs2_data_gpr);
end

initial begin
    $dumpfile("reg_file.vcd");
    $dumpvars();
end

endmodule
