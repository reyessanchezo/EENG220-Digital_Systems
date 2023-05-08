/*
Oscar Reyes-Sanchez, CMPE
Digital Systems
September 15, 2022
7 segment decoder
*/

module part4 (SW, LEDR, HEX0);

	input  [9:0]SW;
	output [9:0]LEDR;
	output [6:0]HEX0;
	
	//assign HEX0 = SW[6:0]; // for testing
	
	wire [1:0]c;
	assign c = SW[1:0];
	
	assign HEX0[0] = ~c[0];
	assign HEX0[1] = c[1] ^ c[0];
	assign HEX0[2] = c[1] ^ c[0];
	assign HEX0[3] = c[1] & ~c[0];
	assign HEX0[4] = 1'b0;
	assign HEX0[5] = ~c[1] & ~c[0];
	assign HEX0[6] = c[1];
	
	
endmodule