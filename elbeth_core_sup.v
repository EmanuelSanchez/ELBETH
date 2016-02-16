`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:17:40 02/13/2016 
// Design Name: 
// Module Name:    microcontroller 
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
module microcontroller(
    input rst,
	 input clk,
	 input clk2
    );

	core elbeth_core(
		 .clk(clk), 
		 .rst(rst), 
		 .douta(douta), 
		 .addra(addra), 
		 .doutb(doutb), 
		 .addrb(addrb), 
		 .enb(enb), 
		 .wea(wea), 
		 .dinb(dinb)
		 );

	ram memory_ram (
		  .clka(clka), 			// input clka
		  .wea(wea), 				// input [3 : 0] wea
		  .addra(addra),			// input [31 : 0] addra
		  .dina(dina), 			// input [31 : 0] dina
		  .douta(douta), 			// output [31 : 0] douta
		  .clkb(clkb), 			// input clkb
		  .enb(enb), 				// input enb
		  .web(web), 				// input [3 : 0] web
		  .addrb(addrb),			// input [31 : 0] addrb
		  .dinb(dinb), 			// input [31 : 0] dinb
		  .doutb(doutb) 			// output [31 : 0] doutb
	);
endmodule
