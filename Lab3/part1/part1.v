/*
Oscar Reyes-Sanchez
RS Latch in verilog
*/	
module part1 (KEY0, KEY1, LEDR, SW);
	input KEY0, KEY1;
	input [9:0] SW;
	output [9:0] LEDR;
	
	wire Q;
	
	rslatch latch1 (SW[0], ~KEY1, ~KEY0, Q);
	
	assign LEDR[0] = SW[0];
	assign LEDR[1] = ~KEY1;
	assign LEDR[2] = ~KEY0;
	assign LEDR[3] = Q;
	assign LEDR[9:4] = 0;
endmodule

module rslatch (Clk, R, S, Q);
	input Clk, R, S;
	output Q;
	
	wire R_g, S_g, Qa, Qb /* synthesis keep */ ;
	
	assign R_g = R & Clk;
	assign S_g = S & Clk;
	assign Qa = ~(R_g | Qb);
	assign Qb = ~(S_g | Qa);
	assign Q = Qa;

	endmodule