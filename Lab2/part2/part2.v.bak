module part2 (SW, HEX0, HEX1);

	input [9:0] SW;
	output [6:0] HEX0;
	output [6:0] HEX1;
	
	wire z;
	wire [3:0] A;
	
	wire [6:0] H0, H1;
	
endmodule

module fourwide2x1 (s, a, b, out);

	input s;
	input [3:0] a, b;


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
	