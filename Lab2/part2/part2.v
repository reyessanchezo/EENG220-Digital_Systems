/*
Oscar Reyes-Sanchez
Binary to decimal converter using 7 segment displays
*/

module part2 (SW, HEX0, HEX1, LEDR);

	input [9:0] SW;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [9:0] LEDR;
	assign LEDR = 10'b0;
	
	wire z;
	wire [3:0] A, B;
	wire [6:0] H0, H1;
	
	Acircuit VtoA (SW[3:0], A); 
	assign z = (SW[3] & SW[1]) | (SW[3] & SW[2] & ~SW[1]);
	fourwide2x1 VorA (z, SW[3:0], A, B);
	
	forZbcd7seg disp1 (z, H1);
	assign HEX1 = H1;
	
	bcd7seg disp0 (B, H0);
	assign HEX0 = H0;
	
	
endmodule

module Acircuit (V, A);

	input [3:0] V;
	output [3:0] A;
	
	assign A[0] = V[0];
	assign A[1] = ~V[1];
	assign A[2] = V[3] & V[2] & V[1];
	assign A[3] = 0;
	
endmodule

module fourwide2x1 (s, a, b, out);

	input s;
	input [3:0] a, b;
	output [3:0] out;
	
	assign out[0] = (~s & a[0]) | (s & b[0]);
	assign out[1] = (~s & a[1]) | (s & b[1]);
	assign out[2] = (~s & a[2]) | (s & b[2]);
	assign out[3] = (~s & a[3]) | (s & b[3]);

endmodule

module forZbcd7seg (z, out);

	input z;
	output [6:0] out;
	
	assign out[0] = z;
	assign out[1] = 0;
	assign out[2] = 0;
	assign out[3] = z;
	assign out[4] = z;
	assign out[5] = z;
	assign out[6] = 1;
	
endmodule


module bcd7seg (s, out);

	input  [3:0] s;
	output [6:0] out;
	
	assign out[0] = (s[2] & ~s[1] & ~s[0]) | (~s[3] & ~s[2] & ~s[1] & s[0]);
	assign out[1] = (s[2] & ~s[1] &  s[0]) | ( s[2] &  s[1] &  ~s[0]);
	assign out[2] = ~s[3] & ~s[2] &  s[1]  &  ~s[0];
	assign out[3] = (s[2] &  s[1] &  s[0]) | (~s[3] &  s[2] &  ~s[1] & ~s[0]) | (~s[3] & ~s[2] & ~s[1] & s[0]);
	assign out[4] = s[0] | (s[2] & ~s[1] & ~s[0]);
	assign out[5] = (~s[3] & ~s[2] & s[0]) | (~s[3] & ~s[2] & s[1]) | (~s[3] & s[1] & s[0]);
	assign out[6] = (~s[3] & ~s[2] & ~s[1]) | (s[2] & s[1] & s[0]);

endmodule
	