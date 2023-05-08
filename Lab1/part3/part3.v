/*
Oscar Reyes-Sanchez, CMPE
Digital Systems
September 15, 2022
Two-bit 4 to 1 mux
*/

module part3 (SW, LEDR);

	input  [9:0]SW;
	output [9:0]LEDR;
	
	wire [1:0] s, m, m1, m2;
	wire [1:0] u, v, w, x;
	
	assign s = SW[9:8];
	assign u = SW[7:6];
	assign v = SW[5:4];
	assign w = SW[3:2];
	assign x = SW[1:0];
	
	//assign LEDR[9:2] = SW[9:2]; // Assigning lights for debug
	assign LEDR[1:0] = m2; // Had this flipped, couldn't realize what was wrong
	
	//mux attempt 2 following diagram from pdf
	assign m[0]  = (~s[0] & u[0]) | (s[0] & v[0]);  //mux 0
	assign m[1]  = (~s[0] & u[1]) | (s[0] & v[1]);  //mux 0
 	
	assign m1[0] = (~s[0] & w[0]) | (s[0] & x[0]);  //mux 1
	assign m1[1] = (~s[0] & w[1]) | (s[0] & x[1]);  //mux 1
	
	assign m2[0] = (~s[1] & m[0]) | (s[1] & m1[0]); //mux 2
	assign m2[1] = (~s[1] & m[1]) | (s[1] & m1[1]); //mux 2
	
	//mux that doesn't work
	/*
	assign m[1] = (~s[1] & ~s[0] & u[1]) | (~s[1] & s[0] & v[1]) | (s[1] & ~s[0] & w[1]) | (s[1] & s[0] & x[1]);
	assign m[0] = (~s[1] & ~s[0] & u[0]) | (~s[1] & s[0] & v[0]) | (s[1] & ~s[0] & w[0]) | (s[1] & s[0] & x[0]);
   */
	endmodule