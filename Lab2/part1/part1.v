/*
Oscar Reyes-Sanchez
Lab 2 part 1
decoder for two displays
*/

module part1 (SW, LEDR, HEX0, HEX1);

	input  [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	
	assign LEDR = 10'b0;
	wire [6:0] H0, H1;
	
	bcd7seg disp1 (SW[7:4], H1);
	assign HEX1 = H1;
	
	bcd7seg disp0 (SW[3:0], H0);
	assign HEX0 = H0;
	
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