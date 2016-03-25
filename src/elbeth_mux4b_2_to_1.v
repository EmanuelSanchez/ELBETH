//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:29:13 02/10/2016 
// Design Name: 
// Module Name:    mux_2_a_1 
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
module elbeth_mux4b_2_to_1(
	input [3:0]		mux_in_1,
	input [3:0]		mux_in_2,
	input 				bit_select,
	output [3:0]		mux_out
    );

	assign mux_out = (bit_select) ? mux_in_2 : mux_in_1; 
	 
endmodule // elbeth_mux_2_to_1