/*
Oscar Reyes-Sanchez
Digital Systems
8-bit counter using 8 T Flip-Flop modules
Output shown using 7 segment displays
SW[1] is the enable 
SW[0] is the reset
KEY0 is the clock

*/


module part1 (KEY0, SW, HEX0, HEX1, LEDR);
	input KEY0;
	input [1:0] SW;
	output [0:6] HEX0, HEX1;
	output [9:0] LEDR;
	assign LEDR = 10'b0000000000; //Setting LEDRs to off
	
	wire Enable, Clock, Clear; //Creating different wires
	wire [7:0] Q, T;
	wire [0:6] disp0, disp1;
	
	assign Clock = KEY0;
	assign Enable = SW[1];
	assign Clear = ~SW[0];
	
	//TFlip Flop setup
	ToggleFF TFF0 (Enable, Clock, Clear, Q[0]);
	assign T[1] = Enable & Q[0];
	
	ToggleFF TFF1 (T[1], Clock, Clear, Q[1]);
	assign T[2] = T[1] & Q[1];
	
	ToggleFF TFF2 (T[2], Clock, Clear, Q[2]);
	assign T[3] = T[2] & Q[2];

	ToggleFF TFF3 (T[3], Clock, Clear, Q[3]);
	assign T[4] = T[3] & Q[3];
	
	ToggleFF TFF4(T[4], Clock, Clear, Q[4]);
	assign T[5] = T[4] & Q[4];
	
	ToggleFF TFF5 (T[5], Clock, Clear, Q[5]);
	assign T[6] = T[5] & Q[5];
	
	ToggleFF TFF6 (T[6], Clock, Clear, Q[6]);
	assign T[7] = T[6] & Q[6];
	
	ToggleFF TFF7 (T[7], Clock, Clear, Q[7]);

	hex7seg hextodisp0 (Q[3:0], disp0);
	hex7seg hextodisp1 (Q[7:4], disp1);
	
	assign HEX0 = disp0;
	assign HEX1 = disp1;

endmodule

module ToggleFF(T, Clock, Resetn, Q);
	input T, Clock, Resetn;
	output reg Q;
	
	always @(posedge Clock)
		if (Resetn  == 1'b0)	// synchronous clear
			Q <= 1'b0;
		else if(T)
			Q <= ~Q;
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