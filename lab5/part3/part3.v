module part3 (SW, KEY0, KEY1, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, MAX10_CLK1_50, Arduino_IO);

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
	
	TestCode Code (Buttondb[3:0], doneout, LEDR[3:0]);

endmodule

module TestCode (button, doneout, LEDR);
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
			
			idle: if(button[0]) y_Q <= A;
				else y_Q <= idle;
			
			A: if(button[0]) y_Q <= AA;
				else y_Q <= idle;
			
			AA: if(button[3]) y_Q <= AA1;
				else y_Q <= idle;
			
			AA1: y_Q <= AA1;
			
			default: y_Q <= idle;
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