`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : add4.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-03-01 20:02:26
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : 
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
module elbeth_add4(
    input [31:0] 	in,
    output [31:0] 	out
    );
	
	assign out = in + 32'd4;

endmodule //elbeth_add4
