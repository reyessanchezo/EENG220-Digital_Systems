/*
Oscar Reyes-Sanchez
Master-slave D flip-flop in verilog
*/
module part3 (SW, LEDR);
	input [9:0] SW;
	output [9:0] LEDR;
	
	wire Q, Qm, D, clk;
	assign D = SW[1];
	assign clk = SW[0];
	
	gateddlatch master (~clk, D, Qm);
	gateddlatch slave (clk, Qm, Q);
	
	assign LEDR[0] = clk;
	assign LEDR[1] = D;
	assign LEDR[2] = Q;
	//assign LEDR[9:3] = 7'b0;
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