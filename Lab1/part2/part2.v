/*
Oscar Reyes-Sanchez, CMPE
Digital Systems
September 15, 2022
4-bit wide 2-1 MUX on MAX-10 FPGA
*/

module part2 (SW,LEDR);
	input  [9:0]SW;
	output [9:0]LEDR;
	
	wire s, i; //declare s
	wire [3:0] x, y, m; //declare i/o
	
	assign s = SW[9]; // Connect input to internal signal
	assign x = SW[3:0];
	assign y = SW[7:4];
	assign i = SW[8]; // enable switch, set to 1'b1 to nullify  
		
	assign LEDR[9] = s;
	assign LEDR[8] = i; //displays system state, on or off
	assign LEDR[3:0] = m; //mux output
	assign LEDR[7:4] = 5'b00000;
	
	//MUX code
	assign m[0] = i & ((~s & x[0]) | (s & y[0])); //mux 0
	assign m[1] = i & ((~s & x[1]) | (s & y[1])); //mux 1
	assign m[2] = i & ((~s & x[2]) | (s & y[2])); //mux 2
	assign m[3] = i & ((~s & x[3]) | (s & y[3])); //mux 3
	
endmodule