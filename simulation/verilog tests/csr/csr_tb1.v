////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : csr_tb1.v
//  Last Modified : 2016-03-02 17:24:05
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//  Description   : test the csr
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_csr_register.v"

module csr_tb1();
		reg 					 clk=0;
		reg 					 rst;
		reg [11:0]				 addr;
		reg [2:0]   			 cmd;
		reg [31:0]        		 wdata;
		reg                      retire;
		reg                      exception;
		reg [3:0]     			 exception_code;
		reg                      eret;
		reg [31:0] 		         exception_load_addr;
		reg [31:0]        		 exception_pc;
	 	wire [1:0]				 pvr;
		wire 					 interrupt;
		wire                     illegal_access;
		wire [31:0]		         rdata;
		wire [31:0]        		 handler_pc;
		wire [31:0]       		 epc;
		wire [3:0]				 interrupt_code;
		wire [31:0] 			 to_host;

	always @(*) begin
			#50
			clk<=~clk;
		end

	// test process
	initial
		begin
			$dumpfile("csr_tb1.vcd");
			$dumpvars(0,csr_tb1);

//test the stall signals
			//test vector: inst mem rw
			#50
			rst = 1;
			#60
			rst = 0;

			#50
			$finish;
		end

	elbeth_csr_register csr(
							clk,
							rst,
							addr,
							cmd,
							wdata,
							retire,
							exception,
							exception_code,
							eret,
							exception_load_addr,
							exception_pc,
						 	pvr,
							interrupt,
							illegal_access,
							rdata,
							handler_pc,
							epc,
							interrupt_code,
							to_host
		);


endmodule // csr_tb1