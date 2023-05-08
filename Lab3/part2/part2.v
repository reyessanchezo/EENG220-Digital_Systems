/*
Oscar Reyes-Sanchez
D Latch in verilog
	*/
module part2 (KEY1, LEDR, SW);
	input KEY1;
	input [9:0] SW;
	output [9:0] LEDR;
	
	wire Q;
	
	gateddlatch latch1 (SW[0], ~KEY1, Q);
	
	assign LEDR[0] = SW[0];
	assign LEDR[1] = ~KEY1;
	assign LEDR[2] = Q;
	assign LEDR[9:3] = 7'b0;	
endmodule


module gateddlatch (Clk, D, Q);
	input Clk, D;
	output Q;
	
	wire R, S, R_g, S_g, Qa, Qb /* synthesis keep */ ;
	
	assign S = D;
	assign R = ~D;
	
	assign R_g = ~(R & Clk);
	assign S_g = ~(S & Clk);
	assign Qa = ~(S_g & Qb);
	assign Qb = ~(R_g & Qa);
	assign Q = Qa;

endmodule