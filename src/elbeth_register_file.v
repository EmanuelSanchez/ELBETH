
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : register_file.v
//  Created On    : Tue Jan  19 06:40:00 2016
//  Last Modified : 2016-02-22 09:07:42
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth 
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & 
//
//  Description   : 32 General Purpose Registers
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////

module elbeth_register_file(
    input						clk,						// clock
	input [4:0] 				id_rs1_addr,				//	dirección del registro "a" a leer
    input [4:0] 				id_rs2_addr,				// dirección del registro "b" a leer
    input [31:0] 				rd_data,					// dato a escribir en "d"
    input [4:0] 				rd_addr,						// dirección del registro "d" a escribir
	input						ctrl_w_enable,			// señal de control para activar la escritura
    output [31:0] 				id_rs1_data,				// dato del registro "a"
    output [31:0] 				id_rs2_data					// dato del registro "a"
    );
	 
	reg [31:0]					gp_register [1:31];

//--------------------------------------------------------------------------
// Write in Register: it happens on falling edge
//--------------------------------------------------------------------------
	always @( negedge clk ) begin
		if( rd_addr != 5'b0 )
			if ( ctrl_w_enable )
				gp_register[rd_addr] <= rd_data;
			else
				gp_register[rd_addr] <= gp_register[rd_addr];
	end
	
//--------------------------------------------------------------------------
// Read of Register
//--------------------------------------------------------------------------
	assign id_rs1_data = (id_rs1_addr != 0) ? gp_register[id_rs1_addr] : 32'b0;
	assign id_rs2_data = (id_rs2_addr != 0) ? gp_register[id_rs2_addr] : 32'b0;


endmodule	//elbeth_register_file
