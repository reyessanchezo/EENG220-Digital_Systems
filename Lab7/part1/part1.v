/*
Oscar Reyes-Sanchez
Digital Systems
Finite-State Machine that sets z to 1 whenever the w input is constant for four or more clock pulses
*/

module part1 (SW, LEDR, KEY0, KEY1, MAX10_CLK1_50);

	//Ports
	input [9:0] SW;
	input KEY0, KEY1, MAX10_CLK1_50;
	output [9:0] LEDR;
	
	//wires and assignments
	wire z, w, clk, rst;
	assign rst = SW[0];
	assign w = SW[1];
	assign LEDR[9] = z;
	wire [8:0] Y;
	assign LEDR [8:0] = Y;
	wire [8:0] X;
	button_debouncer debounce (MAX10_CLK1_50, 1'b1, KEY0, clk);
	
	//assigning X values to feed into FFs
	assign X[0] = 1;
	assign X[1] = ~w & (~Y[0] | Y[5] | Y[6] | Y[7] | Y[8]);
	assign X[2] = ~w & Y[1];
	assign X[3] = ~w & Y[2];
	assign X[4] = ~w & (Y[3] | Y[4]);
	assign X[5] =  w & (~Y[0] | Y[1] | Y[2] | Y[3] | Y[4]);
	assign X[6] =  w & Y[5];
	assign X[7] =  w & Y[6];
	assign X[8] =  w & (Y[7] | Y[8]);
	
	DFlipFlop FF0 (clk, X[0], Y[0], rst, 1);
	DFlipFlop FF1 (clk, X[1], Y[1], rst, 1);
	DFlipFlop FF2 (clk, X[2], Y[2], rst, 1);
	DFlipFlop FF3 (clk, X[3], Y[3], rst, 1);
	DFlipFlop FF4 (clk, X[4], Y[4], rst, 1);
	DFlipFlop FF5 (clk, X[5], Y[5], rst, 1);
	DFlipFlop FF6 (clk, X[6], Y[6], rst, 1);
	DFlipFlop FF7 (clk, X[7], Y[7], rst, 1);
	DFlipFlop FF8 (clk, X[8], Y[8], rst, 1);
	
	assign z = Y[4] | Y[8];
	
	
endmodule

module DFlipFlop (clk, D, Q, Rst_n, Setn);

	input D, clk, Rst_n, Setn;
	output reg Q;

	always @(posedge clk) 
		if(Rst_n == 1'b0) //clear when SW[0] is 0
			Q <= 1'b0;
		else if (Setn == 1'b0)
			Q <= 1'b1;
		else 
			Q <= D;

endmodule
/*(clk, d, q);
	input clk, d;
	output q;
	
	wire Qm;
	
	gateddlatch master (~clk, d, Qm);
	gateddlatch slave (clk, Qm, q);


endmodule*/

module gateddlatch (Clk, D, Q); //Not used, this is just D latch, when I need D flip flop
	input Clk, D;
	output Q;
	
	wire R, S, R_g, S_g, Qa, Qb /* synthesis keep */ ;
	
	assign S = D;
	assign R = ~D;
	
	assign R_g = ~(R & Clk);
	assign S_g = ~(S & Clk);
	assign Qa = ~(S_g & Qb);
	assign Qb = ~(R_g & Qa);
	assign Q = Qa;

endmodule

module button_debouncer	(clk, rst_n, data_in, data_out);
					
	input clk;
	input	rst_n;
	input	data_in;
	output data_out;
									

//=======================================================
//  REG/WIRE declarations
//=======================================================
	parameter preset_val 	= 0;
	parameter counter_max = 100000; 


	reg data_out;									
	reg data_in_0;	
	reg data_in_1;
	reg data_in_2;
	reg data_in_3;
	reg [20:0] counter;
	
//=======================================================
//  Structural coding
//=======================================================

	always @(posedge clk or negedge rst_n)
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