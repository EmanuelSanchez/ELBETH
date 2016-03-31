`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : alu.v
//  Created On    : Tue Jan  19 06:40:00 2016
//  Last Modified : 2016-03-30 15:08:59
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : The Execution unit.
//                  Performs the following operations:
//                  - Arithmetic   
//                  - Logical			
//                  - Shift			
//                  - Comparison		
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

module mult #(
	parameter ITER=32,
	parameter DW=32
	)(	
	input 					clk,
	input					rst,
	input 					mult_en,
	input [DW-1:0] 			data_a,					// values (32 bits) values for operation
    input [DW-1:0] 			data_b,					// values (32 bits) values for operation
    input 					hilo_select,
    output reg				result_ready,
	output reg [DW-1:0] 	mult_result
    );
	localparam DW2 = 2*DW;

	reg [DW2:0] a_internal;
	reg [DW2:0] s_internal;
	reg [DW2:0] p_internal;
	wire [DW2:0] aux_1;
	wire [DW2:0] aux_2;

	reg [5:0] count;
	reg [DW2:0] result;

	wire [DW-1:0]  	comp_a2;
	reg 	working;
	wire [1:0] opt;


	assign aux_1 = p_internal + a_internal;
	assign aux_2 = p_internal + s_internal;
	assign comp_a2 = (data_a ^ `MAX_RANGE) + 1'b1;
	assign opt = p_internal[1:0];

	//assign comp_a2 = (~data_a) + 1'b1
	//assign result_ready = (rst) ? 1'b0 : (mult_en) ? !working : 1'b0;

	always @(*) begin
		if(result_ready&!hilo_select) begin
			mult_result = result[(DW2/2)-1:2];
		end
		else if(result_ready&hilo_select) begin
			mult_result = result[DW2-1:DW2/2];
		end
		else
			mult_result = 32'b0;
	end

	always @(posedge clk) begin
		working = mult_en;
		result_ready = 1'b0;
		if(rst) begin
			working = 1'b0;
			result_ready = 1'b0;
		end
		if(count==ITER) begin		
			working <= 1'b0;
			result_ready <= 1'b1;	
			result <= p_internal>>1'b1;
		end
	end

	always @(posedge clk) begin
		if (working) begin
			case (opt)
				2'd1 : begin 	p_internal <= $signed(aux_1) >>> 1'd1 ; end
				2'd2 : begin 	p_internal <= $signed(aux_2) >>> 1'd1 ; end
				default : begin p_internal <= $signed(p_internal) >>> 1'd1 ;	end
			endcase // p_internal[1:0]
			count<=count+1;
		end
		else begin
			a_internal <= (!working & mult_en) ? { {data_a}, 32'b0, 1'b0} : DW2-1'b0;
			s_internal <= (!working & mult_en) ? { {comp_a2}, 32'b0, 1'b0} : DW2-1'b0;
			p_internal <= (!working & mult_en) ? { 32'b0, {data_b}, 1'b0} : DW2-1'b0;
			count <= 0;
		end
	end
	
endmodule // mult
