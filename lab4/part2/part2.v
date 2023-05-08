/*
Oscar Reyes-Sanchez
Digital Systems
16-bit counter using a register, displayed on 7 segment displays
KEY0 is the clock
SW[0] is the enable
SW[1] is the reset
*/



module part2 (KEY0, SW, HEX0, HEX1, HEX2, HEX3, LEDR);
	input KEY0;
	input [1:0] SW;
	output [0:6] HEX0, HEX1, HEX2, HEX3;
	output [9:0] LEDR;
	assign LEDR = 10'b0000000000;
	
	wire [0:6] disp0, disp1, disp2, disp3;
	wire [15:0] Q;
	wire Enable, Clock, Reset;
	assign Enable = SW[0];
	assign Clock = KEY0;
	assign Reset = ~SW[1];
	
	counter16bit counter (Enable, Clock, Q, Reset);
	
	hex7seg hextodisp0 (Q[3:0], disp0);
	hex7seg hextodisp1 (Q[7:4], disp1);
	hex7seg hextodisp2 (Q[11:8], disp2);
	hex7seg hextodisp3 (Q[15:12], disp3);
	
	assign HEX0 = disp0;
	assign HEX1 = disp1;
	assign HEX2 = disp2;
	assign HEX3 = disp3;

endmodule

module counter16bit (Enable, Clock, Count, Resetn);
	input Enable, Clock, Resetn;
	output reg [15:0] Count;
	always @(posedge Clock)
		if (!Resetn)
			Count <= 0;
		else if (Enable)
			Count <= Count + 1'b1;
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