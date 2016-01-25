`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : register_file.v
//  Created On    : Tue Jan  19 06:40:00 2016
//  Last Modified : 
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth 
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & 
//
//  Description   : 32 General Purpose Registers
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////

module register_file(
    input						clk,							// clock
	 input [4:0] 				reg_addres_a,				//	dirección del registro "a" a leer
    input [4:0] 				reg_addres_b,				// dirección del registro "b" a leer
    input [31:0] 				data_d,						// dato a escribir en "d"
    input [4:0] 				reg_addres_d,				// dirección del registro "d" a escribir
	 input						ctrl_wb_enable,			// Señal de control para activar la escritura
    output [31:0] 			data_a,					// dato del registro "a"
    output [31:0] 			data_b					// dato del registro "a"
//	   output reg [0:31] 			data_a,					// dato del registro "a"
//    output reg [0:31] 			data_b					// dato del registro "a"
    );
	
	reg [31:0]					gpregister;

//--------------------------------------------------------------------------
// Read of Register
//--------------------------------------------------------------------------
	//always @(*) begin
		//if ( reg_addres_a != 0 )
//			data_a = gpregister[reg_addres_a];
		//else
//			data_a = 32'b0;
		//if ( reg_addres_b != 0 )
//			data_b = gpregister[reg_addres_b];
		//else
//			data_b = 32'b0;
//	end
	
	assign data_a = (reg_addres_a != 0) ? gpregister[reg_addres_a] : 32'b0;
	assign data_b = (reg_addres_b != 0) ? gpregister[reg_addres_b] : 32'b0;

//--------------------------------------------------------------------------
// Write in Register: it happens on falling edge
//--------------------------------------------------------------------------
	always @( negedge clk ) begin
		if( reg_addres_d != 5'b0 )
			if ( ctrl_wb_enable )
				gpregister[reg_addres_d] <= data_d;
			else
				gpregister[reg_addres_d] <= gpregister[reg_addres_d];
	end

endmodule	
