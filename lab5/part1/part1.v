/*
Oscar Reyes-Sanchez 
Digital Systems
November 6, 2022
8-bit counter with KEY1 providing the clock signal and KEY0 resetting
Output is displayed on LEDRs 7 through 0, with a rollover value displayed on LEDR 9
Also uses a debounce moduel for KEY1
*/

module part1(KEY0, KEY1, LEDR, MAX10_CLK1_50);
	//Setting up ports
	input KEY0, KEY1, MAX10_CLK1_50;
	output [9:0] LEDR;
	
	//Wires
	wire [7:0] Q;
	wire ro, clk;
	
	//Debounce module cleans signal from pushbutton
	button_debouncer db (MAX10_CLK1_50, 1'b1, ~KEY1, clk);
	
	//debounce module outputs into the counter
	counter ZeroToK (clk, KEY0, Q, ro);
		defparam ZeroToK.n = 8;
	

	assign LEDR[0] = Q[0];
	assign LEDR[1] = Q[1];
	assign LEDR[2] = Q[2];
	assign LEDR[3] = Q[3];
	assign LEDR[4] = Q[4];
	assign LEDR[5] = Q[5];
	assign LEDR[6] = Q[6];
	assign LEDR[7] = Q[7];
	assign LEDR[9] = ro;
	assign LEDR[8] = 1'b0;

endmodule

module counter (Clock, Reset_n, Q, rollover);
	parameter n = 8;
	parameter k = 20;
	
	input Clock, Reset_n;
	output reg rollover;
	output [n-1:0] Q;
	reg [n-1:0] Q;
	
//	always @(Q)
//		begin
//			if (Q == (k-1))
//				rollover <= 1'b1;
//			else
//				rollover <= 1'b0;
//		end
	
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

//Debounce module 
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