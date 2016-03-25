//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:45:26 02/10/2016 
// Design Name: 
// Module Name:    mux_3_a_1 
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
module elbeth_mux_3_to_1(
	input [31:0]		mux_in_1,
	input [31:0]		mux_in_2,
	input [31:0]		mux_in_3,
	input [1:0]			bit_select,
	output reg [31:0]		mux_out 
    );
always @(*) begin	 
		case (bit_select)
				2'b00: begin mux_out = mux_in_1; end
				2'b01: begin mux_out = mux_in_2; end
				2'b10: begin mux_out = mux_in_3; end
	   endcase 
	end
endmodule
