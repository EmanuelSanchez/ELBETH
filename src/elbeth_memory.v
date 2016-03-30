////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : memory.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-03-29 22:47:26
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : Memory Ram with Dual port
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////

`include "elbeth_definitions.v"

module elbeth_memory #(
	parameter AW = 14,						// Memory address width
	parameter DW = 32,						// Memory data width
    parameter FILE_MEM = "memory.hex"
	)(   
    input clk,
	input rst,
	//Port A
	input					amem_enable,
	input		[AW-1:0]	amem_addr,
	input		[31:0]		amem_data_in,
	input 		[3:0]		amem_rw,
	output	reg [31:0]		amem_data_out,
	output	reg				amem_ready,
	//Port B	
	input					bmem_enable,
	input		[AW-1:0]	bmem_addr,
	input		[31:0]		bmem_data_in,
	input 		[3:0]		bmem_rw,
	output	reg [31:0]		bmem_data_out,
	output	reg				bmem_ready
    );

	localparam NPOS = 2 ** AW;				// Positions number in memory

	reg    [DW-1:0]	memory_array [0: NPOS - 1];		// MEMORIA DE 256 PALABRAS. CADA POSICION DE MEMORIA (DE 1 A 256)
    reg     [31:0]  amem_d_out;                     // PARA DIRECCIONAR 256 POSICIONES, SE NECESITAN 8 BITS (amem_addr y bmem_addr)
    reg     [31:0]  bmem_d_out; //

    //--------------------------------------------------------------------------
    // initialize memory
    //--------------------------------------------------------------------------

    initial 

    begin
        $readmemh(FILE_MEM, memory_array);
    end

    //--------------------------------------------------------------------------
    // Set the ready signal
    //--------------------------------------------------------------------------
    always @(posedge clk) begin                     
        amem_ready = (rst) ? 1'b0 : amem_enable;
        bmem_ready = (rst) ? 1'b0 : bmem_enable;
    end

	always @(*) begin
        amem_data_out = (amem_ready) ? amem_d_out : 32'bz;
        bmem_data_out = (bmem_ready) ? bmem_d_out : 32'bz;
    end

    //--------------------------------------------------------------------------
    // Port A
    //--------------------------------------------------------------------------

    always @(posedge clk) begin
        amem_d_out <= memory_array[amem_addr];
        if(amem_rw != 4'b0) begin
            memory_array[amem_addr][7:0]   = (amem_rw[0] & amem_enable) ? amem_data_in[7:0]   : memory_array[amem_addr][7:0];
            memory_array[amem_addr][15:8]  = (amem_rw[1] & amem_enable) ? amem_data_in[15:8]  : memory_array[amem_addr][15:8];
            memory_array[amem_addr][23:16] = (amem_rw[2] & amem_enable) ? amem_data_in[23:16] : memory_array[amem_addr][23:16];
            memory_array[amem_addr][31:24] = (amem_rw[3] & amem_enable) ? amem_data_in[31:24] : memory_array[amem_addr][31:24];
        end
    end

    //--------------------------------------------------------------------------
    // Port B
    //--------------------------------------------------------------------------

    always @(posedge clk) begin
        bmem_d_out <= memory_array[bmem_addr];
        if(bmem_rw != 4'b0) begin
            memory_array[bmem_addr][7:0]   = (bmem_rw[0] & bmem_enable) ? bmem_data_in[7:0]   : memory_array[bmem_addr][7:0];
            memory_array[bmem_addr][15:8]  = (bmem_rw[1] & bmem_enable) ? bmem_data_in[15:8]  : memory_array[bmem_addr][15:8];
            memory_array[bmem_addr][23:16] = (bmem_rw[2] & bmem_enable) ? bmem_data_in[23:16] : memory_array[bmem_addr][23:16];
            memory_array[bmem_addr][31:24] = (bmem_rw[3] & bmem_enable) ? bmem_data_in[31:24] : memory_array[bmem_addr][31:24];
        end
    end

endmodule //endmodule
