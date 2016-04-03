////////////////////////////////////////////////////////////////////////////////////////////////////
//==================================================================================================
//  Filename      : elbeth_bridge_memory.v
//  Created On    : Mon Jan  31 09:46:00 2016
//  Last Modified : 2016-03-29 22:47:36
//  Revision      : 0.1
//  Author        : Emanuel Sánchez & Ninisbeth Segovia
//  Company       : Universidad Simón Bolívar
//  Email         : emanuelsab@gmail.com & ninisbeth_segovia@hotmail.com
//
//  Description   : Intermediate module between processor and memory
//==================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

module elbeth_bridge_memory(
	//Memory port A
	output 				 amem_en,
	output [13:0]		 amem_addr,
	output [31:0]		 amem_out_data,
	output [3:0]		 amem_rw,
	input  [31:0]		 amem_in_data,
	input  				 amem_ready,
	input				 amem_error,
	//Memory port B
	output 				 bmem_en,
	output [13:0]		 bmem_addr,	
	output [31:0]		 bmem_out_data,	
	output reg [3:0]	 bmem_rw,
	input  [31:0]		 bmem_in_data,
	input 				 bmem_ready,
	input				 bmem_error,
	//Processor instruction memory
	input				 imem_en,
	input  [31:0]		 imem_addr,
	output [31:0]		 imem_in_data,
	output 				 imem_ready,
	output				 imem_except,
	output [3:0]		 imem_except_src,
	//Processor data memory 
	input  [3:0]		 dmem_data_inf,
	input 				 dmem_rw,
	input 				 dmem_en,
	input  [31:0]		 dmem_addr,
	input  [31:0]		 dmem_out_data,
	output reg [31:0]	 dmem_in_data,
	output 				 dmem_ready,
	output reg			 dmem_except,
	output reg [3:0]	 dmem_except_src
	);
	
	wire 	dmem_signed_data;
	wire 	dmem_word;
	wire 	dmem_halfword;
	wire 	dmem_byte;

	//Data information
	assign 	dmem_signed_data = dmem_data_inf[3];
	assign	dmem_word = dmem_data_inf[2];
	assign	dmem_halfword = dmem_data_inf[1];
	assign	dmem_byte = dmem_data_inf[0];

	//Instruction memory exeption
	assign imem_except = ( (|imem_addr[1:0]) | amem_error ) ? 1'b1 : 1'b0;
	assign imem_except_src = (imem_except) ? (amem_error) ? `ECODE_INST_ADDR_FAULT : `ECODE_INST_ADDR_MISALIGNED : 4'b0;
	
	//Instruction memory assignments
	assign imem_in_data = amem_in_data;
	assign imem_ready = amem_ready;

	assign amem_addr = (!imem_except) ? imem_addr[16:2] : 15'bx;
	assign amem_en= imem_en & ~amem_error;
	assign amem_rw = 4'b0;
	assign amem_out_data = 31'bz;

	//Data memory exception
	always @(*) begin
		if (dmem_word & (|dmem_addr[1:0])) begin
			dmem_except = 1'b1;
			dmem_except_src = `ECODE_STORE_AMO_ADDR_MISALIGNED;
		end
		else if (dmem_halfword & dmem_addr[0]) begin
			dmem_except = 1'b1;
			dmem_except_src = `ECODE_STORE_AMO_ADDR_MISALIGNED;
		end
		else if (bmem_error) begin
			dmem_except = 1'b1;
			dmem_except_src = `ECODE_STORE_AMO_ACCESS_FAULT;
		end
		else begin
			dmem_except = 1'b0;
			dmem_except_src = 4'b0;
		end
	end

	always @(*) begin
		if (dmem_except) begin
			if(bmem_error) begin
				if(dmem_rw == 4'b0)
					dmem_except_src = `ECODE_LOAD_ACCESS_FAULT;
				else
					dmem_except_src = `ECODE_STORE_AMO_ACCESS_FAULT;
			end
			else begin
				if(dmem_rw == 4'b0)
					dmem_except_src = `ECODE_LOAD_ADDR_MISALIGNED;
				else
					dmem_except_src = `ECODE_STORE_AMO_ADDR_MISALIGNED;
			end
		end		
	end

	//Read data from Data Memory
	always @(*) begin
		if (!(dmem_rw) & dmem_byte) begin
	            case (dmem_addr[1:0])
	                2'b00   : dmem_in_data = (dmem_signed_data) ? { {24{bmem_in_data[7]} },  bmem_in_data[7:0] }   : {24'b0, bmem_in_data[7:0]};
	                2'b01   : dmem_in_data = (dmem_signed_data) ? { {24{bmem_in_data[15]} }, bmem_in_data[15:8] }  : {24'b0, bmem_in_data[15:8]};
	                2'b10   : dmem_in_data = (dmem_signed_data) ? { {24{bmem_in_data[23]} }, bmem_in_data[23:16] } : {24'b0, bmem_in_data[23:16]};
	                2'b11   : dmem_in_data = (dmem_signed_data) ? { {24{bmem_in_data[31]} }, bmem_in_data[31:24] } : {24'b0, bmem_in_data[31:24]};
	                default : dmem_in_data = 32'hx;
           		endcase // case (dmem_addr[1:0])
        end
        else if (!(dmem_rw) & dmem_halfword) begin
            case (dmem_addr[1])
                1'b0    : dmem_in_data = (dmem_signed_data) ? { {16{bmem_in_data[15]} }, bmem_in_data[15:0] }   : {16'b0, bmem_in_data[15:0]};
                1'b1    : dmem_in_data = (dmem_signed_data) ? { {16{bmem_in_data[31]} }, bmem_in_data[31:16] }  : {16'b0, bmem_in_data[31:16]};
                default : dmem_in_data = 32'hx;
            endcase // case (dmem_addr[1])
        end
       	else if (!(dmem_rw) & dmem_word) begin
       		dmem_in_data = bmem_in_data;
       	end // else if (!(|dmem_rw[3:0]) & dmem_word)
       	else begin
       		dmem_in_data = 32'h0;
       	end // else
	end // always @(*)

	//Write Data Memory
	always @(*) begin
		bmem_rw = 4'b0;
		if(dmem_rw) begin
             bmem_rw[3] = (dmem_byte & (dmem_addr[1:0] == 2'b11)) | (dmem_halfword & dmem_addr[1])  | dmem_word;
             bmem_rw[2] = (dmem_byte & (dmem_addr[1:0] == 2'b10)) | (dmem_halfword & dmem_addr[1])  | dmem_word;
             bmem_rw[1] = (dmem_byte & (dmem_addr[1:0] == 2'b01)) | (dmem_halfword & ~dmem_addr[1]) | dmem_word;
             bmem_rw[0] = (dmem_byte & (dmem_addr[1:0] == 2'b00)) | (dmem_halfword & ~dmem_addr[1]) | dmem_word;
		end
	end

    assign bmem_out_data[31:24] = (dmem_byte) ? dmem_out_data[7:0] : ((dmem_halfword) ? dmem_out_data[15:8] : dmem_out_data[31:24]);
    assign bmem_out_data[23:16] = (dmem_byte | dmem_halfword) ? dmem_out_data[7:0] : dmem_out_data[23:16];
    assign bmem_out_data[15:8]  = (dmem_byte) ? dmem_out_data[7:0] : dmem_out_data[15:8];
    assign bmem_out_data[7:0]   = dmem_out_data[7:0];

    //Data memory assignments
    assign bmem_addr = ((!dmem_except) & dmem_en) ? dmem_addr[16:2] : 15'bx;
	assign bmem_en = dmem_en;
	assign dmem_ready = bmem_ready;

endmodule // elbeth_bridge_memory