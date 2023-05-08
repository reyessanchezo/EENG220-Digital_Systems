/*
Oscar Reyes-Sanchez
Digital Systems
Same FSM as part 1, built using different code
*/

module part2 (SW, KEY0, LEDR, MAX10_CLK1_50);
	//Ports
	input [9:0] SW;
	input KEY0, MAX10_CLK1_50;
	output [9:0] LEDR;
	
	//wires and assignments
	wire w, clk, rst;
	reg z;
	assign rst = SW[0];
	assign w = SW[1];
	assign LEDR[9] = z;
	//reg [8:0] led;
	assign LEDR[3:0] = y_Q;
	
	//Debounce module cleans signal from pushbutton
	button_debouncer db (MAX10_CLK1_50, 1'b1, ~KEY0, clk);
	
	reg [3:0] y_Q, Y_D; // y_Q represents current state, Y_D represents next state
	
	parameter A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100,
	F = 4'b0101, G = 4'b0110, H = 4'b0111, I = 4'b1000;
	
	always @(posedge clk) begin
		if(rst)
				y_Q = A;
				
		//state transitions
		else begin: state_table
			case (y_Q)
				A: if (!w) y_Q = B;
					else y_Q = F;
				
				B: if (!w) y_Q = C;
					else y_Q = F;
				
				C: if (!w) y_Q = D;
					else y_Q = F;
				
				D: if (!w) y_Q = E;
					else y_Q = F;
					
				E: if (!w) y_Q = E;
					else y_Q = F;
					
				F: if (w) y_Q = G;
					else y_Q = B;
					
				G: if (w) y_Q = H;
					else y_Q = B;
					
				H: if (w) y_Q = I;
					else y_Q = B;
					
				I: if (w) y_Q = I;
					else y_Q = B;
				default: y_Q = A;
			endcase
		end // state_table
		
		//state actions
		case (y_Q)		
			A: begin
				z = 0;
			end
			B: begin
				z = 0;
			end
			C: begin
				z = 0;
			end
			D: begin
				z = 0;
			end
			E: begin
				z = 1;
			end
			F: begin
				z = 0;
			end
			G: begin
				z = 0;
			end
			H: begin
				z = 0;
			end
			I: begin
				z = 1;
			end
		endcase
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