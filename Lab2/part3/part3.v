/*
Oscar Reyes-Sanchez
4 bit Carr-Ripple Adder
October 10, 2022
Digital Systems
*/

module part3 (SW, LEDR);

	input [9:0] SW;
	output [9:0] LEDR;
	
	wire [3:0] A, B, S; 
	wire Cin, Cout, Cout1, Cout2, Cout3;
	
	assign A = SW[7:4];
	assign B = SW[3:0];
	assign Cin = SW[8];
	assign LEDR[3:0] = S;
	assign LEDR[4] = Cout3;
	assign LEDR[9:5] = 5'b0;
	
	FA fa0 (A[0], B[0], Cin,  S[0], Cout);
	FA fa1 (A[1], B[1], Cout, S[1], Cout1);
	FA fa2 (A[2], B[2], Cout1, S[2], Cout2);
	FA fa3 (A[3], B[3], Cout2, S[3], Cout3);
	
endmodule

//For subtracting, ~B[n] and Cin to be 1
module FA (a, b, cin, s, cout);

	input a, b, cin;
	output s, cout;
	
	assign s = (a ^ b) ^ cin;
	assign cout = (~(a ^ b) & b) | ((a ^ b) & cin);

endmodule