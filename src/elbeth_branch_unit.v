`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:48:19 02/11/2016 
// Design Name: 
// Module Name:    elbeth_branch_unit 
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

module elbeth_branch_unit(
    input [31:0] 			offset,
    input [31:0] 			id_pc,
    input [2:0] 			operation,
    input [31:0]			id_data_rs1,
    input [31:0] 			id_data_rs2,
	 output reg [31:0] 	pc_branch	
    );

	always @(*) begin
		case (operation)
				`OP_JAL	:	begin pc_branch = id_pc + $signed(offset); end
				`OP_JALR :	begin pc_branch = (id_data_rs1 + $signed(offset))&32'hFFFFFFF8; end
				`OP_BEQ  :	begin pc_branch = (id_data_rs1 == id_data_rs2) ? id_pc + $signed(offset) : id_pc + 32'd4; end
				`OP_BNE  :  begin pc_branch = (id_data_rs1 != id_data_rs2) ? id_pc + $signed(offset) : id_pc + 32'd4; end
				`OP_BLT  :  begin pc_branch = ($signed(id_data_rs1) < $signed(id_data_rs2)) ? id_pc + $signed(offset) : id_pc + 32'd4; end
				`OP_BLTU :  begin pc_branch = (id_data_rs1 < id_data_rs2) ? id_pc + $signed(offset) : id_pc + 32'd4; end
				`OP_BGE  :  begin pc_branch = ($signed(id_data_rs1) > $signed(id_data_rs2)) ? id_pc + $signed(offset) : id_pc + 32'd4; end
				`OP_BGEU :  begin pc_branch = (id_data_rs1 > id_data_rs2) ? id_pc + $signed(offset) : id_pc + 32'd4; end
		endcase
	end
endmodule