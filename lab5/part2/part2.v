/*
Oscar Reyes-Sanchez
Digital Systems
November 6, 2022
3 digit counter that increments once per second, with synchronous reset
Output is displayed on HEX displays
*/
module part2 (KEY0, HEX0, HEX1, HEX2, MAX10_CLK1_50, LEDR);
	//Setting up ports
	input KEY0, MAX10_CLK1_50;
	output [0:6] HEX0, HEX1, HEX2;
	output [9:0] LEDR;
	assign LEDR [9:0] = 10'b0;
	
	//setting up wires
	wire sec;
	wire [3:0] ro;
	wire [3:0] Q, Q10, Q100; //each counter gets a wire
	wire [0:25] t; //empty wire to satisfy port req
	
// Tested using same module for all 
//	counter onesec (MAX10_CLK1_50, KEY0, t, sec); //one tick per second
//	defparam onesplace.n = 26;
//	defparam onesplace.k = 50000000;

	//seperate timer module
	timer onesec (MAX10_CLK1_50, 1'b1, sec);

	//Counters, one per display
	counter onesplace (sec, KEY0, Q, ro[0]); //ones place
	defparam onesplace.n = 4;
	defparam onesplace.k = 10;
	counter tensplace (ro[0], KEY0, Q10, ro[1]); //tens place
	defparam tensplace.n = 4;
	defparam tensplace.k = 10;
	counter hundredsplace (ro[1], KEY0, Q100, ro[2]); //hundreds place
	defparam hundredsplace.n = 4;
	defparam hundredsplace.k = 10;
	
	//decoders to displays
	hex7seg hextodisp0 (Q, HEX0);
	hex7seg hextodisp1 (Q10, HEX1);
	hex7seg hextodisp2 (Q100, HEX2);
	
endmodule

//Timer module that ticks once per second
module timer (Clock, Reset_n, tc);
	parameter n = 26;
	
	input Clock, Reset_n;
	reg [n-1:0] Q;
	output reg tc; //terminal count, used to trigger next counter
		
	always @(posedge Clock) //reset after 1 second
		begin
		if (Q == 26'b10111110101111000010000000) 
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

module counter (Clock, Reset_n, Q, rollover);
	parameter n = 8;
	parameter k = 20;
	
	input Clock, Reset_n;
	output reg rollover;
	output [n-1:0] Q;
	reg [n-1:0] Q;
	
	always @(posedge Clock or negedge Reset_n)
	begin	
		if (!Reset_n)
			begin
				Q <= 1'd0;
				
			end
		else 
			if(Q == (k-1)) //If Q is k-1
				begin
					Q <= 1'd0;
					rollover <= 1'b1;
				end
			else 
				begin
					Q <= Q + 1'b1;
					rollover <= 1'b0;
				end
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