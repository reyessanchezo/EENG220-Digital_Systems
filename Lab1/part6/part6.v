/*
Oscar Reyes-Sanchez, CMPE
Digital Systems
September 15, 2022
7SD rotating word using all displays
*/

module part6(SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, r, t, u, v, w, x, y, z);

	input  [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	output [2:0] r, t, u, v, w, x, y, z;
	
	assign LEDR = 10'b0;
	assign r = 3'b000; 
	assign t = 3'b001;
	assign u = 3'b010;
	assign v = 3'b011; //problem
	assign w = 3'b100;
	assign x = 3'b101;
	assign y = 3'b110;
	assign z = 3'b111; 
	
	/*
	r	t	u	v	w	x	y	z
		b	o	o	P		~	~
	*/
	
	wire [2:0] M5, M4, M3, M2, M1, M0;
	
	mux_3bit_8to1 mux5(SW[9:7], r, t, u, v, w, x, y, z, M5);
	decoder disp5(M5, HEX5);

	mux_3bit_8to1 mux4(SW[9:7], t, u, v, w, x, r, y, z, M4);
	decoder disp4(M4, HEX4);
	
	mux_3bit_8to1 mux3(SW[9:7], u, v, w, r, t, x, y, z, M3);
	decoder disp3(M3, HEX3);

	mux_3bit_8to1 mux2(SW[9:7], v, w, x, r, t, u, y, z, M2);
	decoder disp2(M2, HEX2);
	
	mux_3bit_8to1 mux1(SW[9:7], w, x, r, t, u, v, y, z, M1);
	decoder disp1(M1, HEX1);
	
	mux_3bit_8to1 mux0(SW[9:7], x, r, t, u, v, w, y, z, M0);
	decoder disp0(M0, HEX0);
	
endmodule

module decoder(c, disp);
	input [2:0] c;
	output [6:0] disp;
	
	assign disp[0] = ~(c[2] & ~c[1] & ~c[0]);
	assign disp[1] = ~(c[2] & ~c[1] & ~c[0]);
	assign disp[2] = (c[2]  & ~c[1]) | (~c[1] & ~c[0]);
	assign disp[3] = (c[2]  & ~c[1]) | (~c[1] & ~c[0]);
	assign disp[4] = (~c[2] & ~c[1] & ~c[0]) | (c[2] & ~c[1] & c[0]);
	assign disp[5] = (~c[2] & ~c[0]) | (~c[2] & c[1]) | (c[2] & ~c[1] & c[0]);
	assign disp[6] = (~c[2] & ~c[1] & ~c[0]) | (c[2] & ~c[1] & c[0]);
	

endmodule


module mux_3bit_8to1 (s, r, t, u, v, w, x, y, z, Mout);

	input  [2:0] s, r, t, u, v, w, x, y, z;
	wire [2:0] m0, m1, m2, m3, m10, m11;
	output [2:0] Mout; //out
	//mux first level
	assign m0[0]  = (~s[0] & r[0]) | (s[0] & t[0]);  //mux 0
	assign m0[1]  = (~s[0] & r[1]) | (s[0] & t[1]);  //mux 0
 	assign m0[2]  = (~s[0] & r[2]) | (s[0] & t[2]);  //mux 0
	
	assign m1[0] = (~s[0] & u[0]) | (s[0] & v[0]);  //mux 1
	assign m1[1] = (~s[0] & u[1]) | (s[0] & v[1]);  //mux 1
	assign m1[2] = (~s[0] & u[2]) | (s[0] & v[2]);  //mux 1
	
	assign m2[0] = (~s[0] & w[0]) | (s[0] & x[0]);  //mux 2
	assign m2[1] = (~s[0] & w[1]) | (s[0] & x[1]);  //mux 2
	assign m2[2] = (~s[0] & w[2]) | (s[0] & x[2]);  //mux 2
	
	assign m3[0] = (~s[0] & y[0]) | (s[0] & z[0]);
	assign m3[1] = (~s[0] & y[1]) | (s[0] & z[1]);
	assign m3[2] = (~s[0] & y[2]) | (s[0] & z[2]);
	
	//mux second level
	
	assign m10[0] = (~s[1] & m0[0]) | (s[1] & m1[0]); //mux second
	assign m10[1] = (~s[1] & m0[1]) | (s[1] & m1[1]); //mux second
	assign m10[2] = (~s[1] & m0[2]) | (s[1] & m1[2]); //mux second
	
	assign m11[0] = (~s[1] & m2[0]) | (s[1] & m3[0]); //mux second 1
	assign m11[1] = (~s[1] & m2[1]) | (s[1] & m3[1]); //mux second 1
	assign m11[2] = (~s[1] & m2[2]) | (s[1] & m3[2]); //mux second 1
	
	//mux third level
	assign Mout[0] = (~s[2] & m10[0]) | (s[2] & m11[0]); //mux third
	assign Mout[1] = (~s[2] & m10[1]) | (s[2] & m11[1]); //mux third
	assign Mout[2] = (~s[2] & m10[2]) | (s[2] & m11[2]); //mux third
	
endmodule