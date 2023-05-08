/*
Oscar Reyes-Sanchez
1 Hz counter using board oscillator and 7 segment display
*/

module part3 (MAX10_CLK1_50, HEX0, LEDR);
	input MAX10_CLK1_50;
	output [0:6] HEX0;
	output [9:0] LEDR;
	assign LEDR = 10'b0;
	
	wire ResCount; //Reset 0 to 9 counter
	wire ResTimer;
	wire tc; //trigger for 0 to 9 counter
	wire [3:0] count; // 4-bit count value

	assign ResCount = 1'b1;
	assign ResTimer = 1'b1; //No external reset
	
	timer FiftyToOne (MAX10_CLK1_50, ResTimer, tc);
	
	counter ZeroToNine (MAX10_CLK1_50, tc, ResCount, count);
	
	hex7seg hextodisp0 (count, HEX0);
	
	/*
	Goal
	If timer reaches 50 million, reset and add one to hexcount
	*/
	
endmodule


//Timer module that ticks once per second
module timer (Clock, Reset_n, tc);
	parameter n = 26;
	
	input Clock, Reset_n;
	reg [n-1:0] Q;
	output reg tc; //terminal count, used to trigger next counter
		
	always @(posedge Clock) //reset after 1 second
		begin
		if (Q == 26'b010111110101111000010000000) 
				begin
				Q <= 1'd0;
				tc <= 1'b1;
				end
			else
				begin
				Q <= Q + 1'b1;
				tc <= 1'b0;
				end
		end
endmodule

//Counter module that counts up to 15
module counter (Clock, Enable, Reset_n, Q);
	parameter n = 4;
	
	input Clock, Enable, Reset_n;
	output reg [n-1:0] Q;
		
	always @(posedge Clock) //reset when at 9
		begin
			if (Q == 4'b1010) 
				Q <= 1'd0;
			else if (Enable)
				Q <= Q + 1'b1;
		end
endmodule

module hex7seg (hex, display);
	input [3:0] hex;
	output [0:6] display;

	reg [0:6] display;

	/*
	 *       0  
	 *      ---  
	 *     |   |
	 *    5|   |1
	 *     | 6 |
	 *      ---  
	 *     |   |
	 *    4|   |2
	 *     |   |
	 *      ---  
	 *       3  
	 */

	always @ (hex)
		case (hex) 
			4'h0: display = 7'b0000001;
			4'h1: display = 7'b1001111;
			4'h2: display = 7'b0010010;
			4'h3: display = 7'b0000110;
			4'h4: display = 7'b1001100;
			4'h5: display = 7'b0100100;
			4'h6: display = 7'b0100000;
			4'h7: display = 7'b0001111;
			4'h8: display = 7'b0000000;
			4'h9: display = 7'b0001100;
			4'hA: display = 7'b0001000;
			4'hB: display = 7'b1100000;
			4'hC: display = 7'b1110010;
			4'hD: display = 7'b1000010;
			4'hE: display = 7'b0110000;
			4'hF: display = 7'b0111000;
			default: display = 7'b1111111;
		endcase
endmodule