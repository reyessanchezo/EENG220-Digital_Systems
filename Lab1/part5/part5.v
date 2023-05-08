/*
Oscar Reyes-Sanchez, CMPE
Digital Systems
September 15, 2022
7SD rotating word
*/

module part5(SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, u, v, w, x);

	input  [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	output [1:0] u, v, w, x;
	
	assign HEX5 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign u = 2'b00;
	assign v = 2'b01;
	assign w = 2'b10;
	assign x = 2'b11;
	
	wire [1:0] M3, M2, M1, M0;
	
	mux_2bit_4to1 mux0(SW[9:8], u, v, w, x, M3);
	decoder(M3, HEX3);

	mux_2bit_4to1 mux1(SW[9:8], v, w, x, u, M2);
	decoder(M2, HEX2);
	
	mux_2bit_4to1 mux2(SW[9:8], w, x, u, v, M1);
	decoder(M1, HEX1);
	
	mux_2bit_4to1 mux3(SW[9:8], x, u, v, w, M0);
	decoder(M0, HEX0);
	
endmodule

module decoder(c, disp);
	input [1:0] c;
	output [6:0] disp;
	
	assign disp[0] = ~(c[1] & c[0]);
	assign disp[1] = ~(c[1] & c[0]);
	assign disp[2] = c[1] & c[0];
	assign disp[3] = c[1] & c[0];
	assign disp[4] = 1'b0;
	assign disp[5] = c[1] ^ c[0];
	assign disp[6] = 1'b0;
	

endmodule


module mux_2bit_4to1 (s, u, v, w, x, M);

	input  [1:0] s, u, v, w, x;
	wire [1:0] m0, m1;
	output [1:0] M;
	
	//mux 
	assign m0[0]  = (~s[0] & u[0]) | (s[0] & v[0]);  //mux 0
	assign m0[1]  = (~s[0] & u[1]) | (s[0] & v[1]);  //mux 0
 	
	assign m1[0] = (~s[0] & w[0]) | (s[0] & x[0]);  //mux 1
	assign m1[1] = (~s[0] & w[1]) | (s[0] & x[1]);  //mux 1
	
	assign M[0] = (~s[1] & m0[0]) | (s[1] & m1[0]); //mux out
	assign M[1] = (~s[1] & m0[1]) | (s[1] & m1[1]); //mux out
	
	
endmodule