`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:07:52 02/13/2016 
// Design Name: 
// Module Name:    zero_extend 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "elbeth_definitions.v"

module zero_signed_extend(
    input [31:0] 		data_mem,
    input [3:0] 		ctrl_data_size,
	 input 				ctrl_data_signed,
	 output reg reg_data_mem
    );
	
	always @(*) begin
		case (ctrl_data_size)
			`WORD : 			begin
						reg_data_mem = data_mem; end
			`HALFWORD : 	begin 
					if (ctrl_data_signed == 0)
							reg_data_mem = {16'b0, data_mem[15:0]}; 
					else
							reg_data_mem = {{17{data_mem[15]}}, data_mem[14:0]}; end
			`BYTE :			begin	
					if (ctrl_data_signed == 0)
							reg_data_mem = {24'b0, data_mem[7:0]};
					else
							reg_data_mem = {{25{data_mem[7]}}, data_mem[6:0]}; end
		endcase
	end
endmodule
