`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : memory.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-02-15 22:13:48
//  Revision      : 0.1
//  Author        : Emanuel S�nchez & Ninisbeth Segovia
//  Company       : Universidad Sim�n Bol�var
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : Memory Ram with Dual port
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////

`include "elbeth_definitions.v"

module elbeth_memory #(
	parameter AW = 32						// Memory address width
	parameter DW = 32						// Memory data width
	 )(
    input clk,
	input rst,
	//Port A
	input					amem_enable,
	input		[31:0]		amem_addr,
	input		[31:0]		amem_data_in,
	input 		[3:0]		amem_wr,
	output	reg [31:0]		amem_data_out,
	output	reg				amem_ready,
	//Port B	
	input					bmem_enable
	input		[31:0]		bmem_addr,
	input		[31:0]		bmem_data_in,
	input 		[3:0]		bmem_wr,
	output	reg [31:0]		bmem_data_out,
	output	reg				bmem_ready,
    );
	 
	localparam NPOS = 2 ** AW;				// Positions number in memory
	
	reg [DW-1:0]		memory_array [0: NPOS-1];		// 

    reg     [31:0]  amem_data_out;
    reg     [31:0]  bmem_data_out;

    //--------------------------------------------------------------------------
    // initialize memory
    //--------------------------------------------------------------------------

    initial begin
        $readmemh("mem.hex", mem);
    end

    //--------------------------------------------------------------------------
    // Set the ready signal
    //--------------------------------------------------------------------------
    always @(posedge clk) begin
        amem_ready <= (rst) ? 1'b0 : amem_enable;
        bmem_ready <= (rst) ? 1'b0 : bmem_enable;
    end
	

	always @(*) begin
        amem_dout = (amem_ready) ? amem_data_out : 32'bz;
        bmem_dout = (bmem_ready) ? bmem_data_out : 32'bz;
    end

    //--------------------------------------------------------------------------
    // Port A
    //--------------------------------------------------------------------------

    always @(posedge clk) begin
        amem_data_out <= memory_array[amem_addr];
        if(amem_wr != 4'b0) begin
            amem_data_out         		   <= amem_data_in;
            memory_array[amem_addr][7:0]   <= (amem_wr[0] & amem_enable) ? amem_din[7:0]       : memory_array[amem_addr][7:0];
            memory_array[amem_addr][15:8]  <= (amem_wr[1] & amem_enable) ? amem_data_in[15:8]  : memory_array[amem_addr][15:8];
            memory_array[amem_addr][23:16] <= (amem_wr[2] & amem_enable) ? amem_data_in[23:16] : memory_array[amem_addr][23:16];
            memory_array[amem_addr][31:24] <= (amem_wr[3] & amem_enable) ? amem_data_in[31:24] : memory_array[amem_addr][31:24];
        end
    end

    //--------------------------------------------------------------------------
    // Port B
    //--------------------------------------------------------------------------

    always @(posedge clk) begin
        bmem_data_out <= memory_array[bmem_addr];
        if(bmem_wr != 4'b0) begin
            bmem_data_out      <= bmem_data_in;
            memory_array[bmem_addr][7:0]   <= (bmem_wr[0] & bmem_enable) ? bmem_din[7:0]   : memory_array[bmem_addr][7:0];
            memory_array[bmem_addr][15:8]  <= (bmem_wr[1] & bmem_enable) ? bmem_din[15:8]  : memory_array[bmem_addr][15:8];
            memory_array[bmem_addr][23:16] <= (bmem_wr[2] & bmem_enable) ? bmem_din[23:16] : memory_array[bmem_addr][23:16];
            memory_array[bmem_addr][31:24] <= (bmem_wr[3] & bmem_enable) ? bmem_din[31:24] : memory_array[bmem_addr][31:24];
        end
    end
 endmodule

endmodule	//elbeth_memory