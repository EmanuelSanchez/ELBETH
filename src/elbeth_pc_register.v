////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : pc_registrer.v
//  Created On    : Tue Jan  19 06:40:00 2016
//  Last Modified : 2016-03-07 21:02:21
//  Revision      : 0.1
//  Author        : Emanuel S�nchez & Ninisbeth 
//  Company       : Universidad Sim�n Bol�var
//  Email         : emanuelsab@gmail.com & 
//
//  Description   : Program Counter
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
module elbeth_pc_register(
	input						clk,
	input						rst,
	input						ctrl_stall,
    input [31:0] 				next_pc,
    output reg [31:0]	 		pc
    );

	always @(posedge clk) begin
		pc <= (rst) ? 32'b0 : ((ctrl_stall) ? pc : next_pc);
	end

endmodule	//elbeth_pc_register
