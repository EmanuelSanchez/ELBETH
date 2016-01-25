`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : pc_registrer.v
//  Created On    : Tue Jan  19 06:40:00 2016
//  Last Modified : 
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth 
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & 
//
//  Description   : Program Counter
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
module pc_register(
	 input						clk,
	 input						rst,
	 input						ctrl_stall,
    input [31:0] 				next_pc,
    output reg [31:0]	 	pc
    );

	always @(posedge clk) begin
		pc <= (rst) ? 32'b0 : ((ctrl_stall) ? pc : next_pc);
	end

endmodule
