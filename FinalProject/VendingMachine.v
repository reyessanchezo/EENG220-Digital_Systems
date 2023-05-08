/*
Vending Machine Team
Digital Systems
December
Program that runs a Vending Machine-like system on an FPGA
*/

module VendingMachine (SW, KEY0, KEY1, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, MAX10_CLK1_50, Arduino_IO);

	input [9:0] SW;
	input KEY0, KEY1, MAX10_CLK1_50;
	output [9:0] LEDR;
	output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	inout [15:0] Arduino_IO; 
	
	wire [15:8] motors;
	wire [7:0] buttons;
	wire [3:0] Buttondb;
	assign buttons = Arduino_IO[7:0]; //IO pins for the keypad
	wire Reset, BoutA, BoutB, clk, add, snack, pulse, pulse2, go, doneout;
	wire [1:0] code;
	wire check;
	assign Reset = ~KEY0;
	
	//Debounce module cleans signal from pushbuttons
	button_debouncer key0db (MAX10_CLK1_50, 1'b1, ~buttons[0], Buttondb[0]);
	button_debouncer key1db (MAX10_CLK1_50, 1'b1, ~buttons[1], Buttondb[1]);
	button_debouncer key2db (MAX10_CLK1_50, 1'b1, ~buttons[2], Buttondb[2]);
	button_debouncer key3db (MAX10_CLK1_50, 1'b1, ~buttons[3], Buttondb[3]);
	
//	TestCode Code (Buttondb[3:0], doneout, LEDR[3:0]);
	
	
	FSM1 mainFSM (clk, Reset, Buttondb, KEY1, BoutA, BoutB, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	
	pulseFSM motor1 (clk, BoutA, pulse2, LEDR[9]); //one motor revolution, led9 shows done state
		defparam motor1.num = 4'hA;
	pulseFSM motor2 (clk, BoutB, pulse, LEDR[8]); //one motor revolution, led8 shows done state
		defparam motor2.num = 4'hB;
	
	timer mpulse (MAX10_CLK1_50, 1, clk, 1);
	
	assign LEDR[0] = pulse;
	assign LEDR[1] = pulse2;
	assign Arduino_IO[14] = pulse; //motor 1
	assign Arduino_IO[15] = pulse2;//motor 2 
	assign LEDR[5] = BoutA;
	assign LEDR[4] = BoutB;
	

	
	
	
endmodule

 /* module TestCode (button, doneout, LEDR);
	input [3:0] button;
	output reg [9:0] LEDR;
	//input go;
	output reg doneout;
	//output reg [1:0] code;
	
	//assign LEDR[9:0] = 10'b0000000000;
	
	parameter idle = 4'b0000, A = 4'b0001, AA = 4'b0010, AA1 = 4'b0011, done = 4'b0100; //Can be expanded for more codes
	reg [3:0] y_Q;
	
	always @(posedge button[0] or posedge button[1] or posedge button[2] or posedge button[3]) begin
		case (y_Q)			
			
			idle: if(button[0]) y_Q = A;
				else y_Q = idle;
			
			A: if(button[0]) y_Q = AA;
				else y_Q = idle;
			
			AA:	if(button[3]) y_Q = AA1;
				else y_Q = idle;
			
			AA1: y_Q = idle;
			
			default: y_Q = idle;
		endcase
		
		case(y_Q)
			idle: begin
				doneout = 0;
				LEDR[0] = 1;
			end
			A: begin
				doneout = 0;
				LEDR[1] = 1;
			end
			AA: begin
				doneout = 0;
				LEDR[2] = 1;
				end
			AA1: begin
				doneout = 1;
				LEDR[3] = 1;
			end
		endcase
	end
endmodule 
*/


module pulseFSM (clk, go, pulse, done);
	input clk, go;
	reg [25:0] I;
	output reg pulse, done;
	//output reg [6:0] disp;
	parameter Wait = 2'b00, pinON = 2'b01, pinOFF = 2'b10, num = 4'h0;
	reg [2:0] y_Q, y_D; //State regs
	
	always @(posedge clk) begin
		begin: state_table
			case (y_Q) // case transitions
				Wait: if (go) y_Q = pinON;
					else y_Q = Wait;
					
				pinON: y_Q = pinOFF;
				
				pinOFF: if(I < 384) y_Q = pinON; //Keeps cycling until a second has passed, will be set to correspond to number of pulses needed to fully dispense a thing
					else y_Q = Wait; //384 pulses per revolution
					
				default: y_Q = Wait;
			endcase
		end
		
		case (y_Q) //case actions
			Wait: begin
				pulse = 0;
				I = 0;
				done = 1;
				//disp = 7'b1111111;
			end
			
			pinON: begin
				pulse = 1;
				done = 0;
				//disp = num;
			end
			
			pinOFF: begin
				pulse = 0;
				done = 0;
				I = I + 1;
			end
			
		endcase
	end
	
	
endmodule

//Timer module that brings clock down to 600Hz
module timer (Clock, Reset_n, tc, resume); //MAX10Clock, 1, outputpulse, 1
	parameter n = 26;
	
	input Clock, Reset_n, resume;
	reg [n-1:0] Q;
	output reg tc; //terminal count, output pulse
		
	always @(posedge Clock) 
		begin
		if (Q == 250000)  // 200 Hz, where stepper has most torque is 250000; 
				begin
				Q <= 1'd0;
				tc <= 1'b1;
				end
			else
				begin
				if(resume)
					begin
						Q <= Q + 1'b1;
						tc <= 1'b0;
					end
				end
		end
endmodule

module FSM1 (clk, rst, buttons, KEY1, OutA, OutB, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input clk, rst, KEY1;
	input [3:0] buttons;
	//input [1:0] i;
	output reg [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	parameter Reset = 4'b0000, CodeIn = 4'b0001, SnackSelect = 4'b0010, Motor1 = 4'b0011, Motor2 = 4'b0100, DisplayCredits = 4'b0101, CreditsMinus = 4'b0110;
	reg [3:0] y, y_Q;
	reg Credits;
	output reg OutA, OutB;
	
	
	
	always @(posedge clk) begin
		if (rst) y_Q = Reset;
		
		else begin: state_table
			case (y_Q) // case transitions
				
				Reset: y_Q = CodeIn;
					
				CodeIn: if (buttons[2]) y_Q = DisplayCredits;
					else y_Q = CodeIn;
				
				DisplayCredits: if (Credits > 0) y_Q = SnackSelect; 
					else y_Q = CodeIn;
				
				SnackSelect: if (buttons[0]) y_Q = Motor1;
						else if (buttons[1]) y_Q = Motor2;
						else y_Q = SnackSelect;
				
				Motor1: if (KEY1) y_Q = CreditsMinus;
					else y_Q = Motor1;
				
				Motor2: if (KEY1) y_Q = CreditsMinus;
					else y_Q = Motor1;
				
				CreditsMinus: y_Q = CodeIn;	
				
				default: y_Q = Reset;
				
			endcase
		end
		
		case (y_Q) //case actions
			
			Reset: begin
				Credits = 3;
				HEX5 <= 7'b1111111;
				HEX4 <= 7'b1111111;
				HEX3 <= 7'b1111111;
				HEX2 <= 7'b1111111;
				HEX1 <= 7'b1111111;
				HEX0 <= 7'b1111111;
				
			end
			
			CodeIn: begin
				HEX5 <= 7'b1111111;
				HEX4 <= 7'b1111111;
				HEX3 <= 7'b0110001;
				HEX2 <= 7'b1100010;
				HEX1 <= 7'b1000010;
				HEX0 <= 7'b0110000;
				//disp[3:0] = 16'hC0DE;
				
			end
			
			DisplayCredits: begin
			
			end
			
			SnackSelect: begin
				//A or b
				HEX5 <= 7'b0001000;
				HEX4 <= 7'b1111111; 
				HEX3 <= 7'b1100010;
				HEX2 <= 7'b1111010;
				HEX1 <= 7'b1111111; 
				HEX0 <= 7'b1100000;
				
			end
			
			Motor1: begin
				OutA = 1;
				HEX5 <= 7'b1111111;
				HEX4 <= 7'b1111111;
				HEX3 <= 7'b1111111;
				HEX2 <= 7'b1111111;
				HEX1 <= 7'b1111111;
				HEX0 <= 7'b1111111;
			end
			
			Motor2: begin
				OutB = 1;
				HEX5 <= 7'b1111111;
				HEX4 <= 7'b1111111;
				HEX3 <= 7'b1111111;
				HEX2 <= 7'b1111111;
				HEX1 <= 7'b1111111;
				HEX0 <= 7'b1111111;
			end
			
			CreditsMinus: begin
				OutA = 0;
				OutB = 0;
				Credits = Credits - 1;
				//case(Credits[i])
					//2'b00: HEX0 = 7'b0000001;
					//2'b01: HEX0 = 7'b1001111;
					//2'b10: HEX0 = 7'b0010010;
					//2'b11: HEX0 = 7'b0000110;
				//endcase
			end
		endcase
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

//Debounce module from Intel
module button_debouncer	( 
							clk,
							rst_n,
							data_in,
							data_out			
						);
					
input						clk;
input						rst_n;
input						data_in;
output						data_out;
									

//=======================================================
//  REG/WIRE declarations
//=======================================================
parameter	preset_val 	= 0;
parameter 	counter_max = 100000; 


reg						data_out;									
reg						data_in_0;	
reg						data_in_1;
reg						data_in_2;
reg						data_in_3;
reg			[20:0]		counter;
	
//=======================================================
//  Structural coding
//=======================================================

always	@(posedge clk or negedge rst_n)
begin
	if	(!rst_n)
	begin
		data_out		<=	preset_val;
		counter			<=	counter_max;
		data_in_0		<=	0;
		data_in_1		<=	0;
		data_in_2		<=	0;
		data_in_3		<=	0;			
	end else begin
		if	(counter == 0) 
		begin
			data_out	<=	data_in_3;
			counter		<=	counter_max;
		end else begin
			counter		<=	counter - 1;
		end
		data_in_0	<=	data_in;	
		data_in_1	<=	data_in_0;
		data_in_2	<=	data_in_1;
		data_in_3	<=	data_in_2;
	end
end
			
				

endmodule