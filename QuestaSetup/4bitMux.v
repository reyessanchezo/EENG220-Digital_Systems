module Mux_4bit (X, Y, s, M);
input [3:0] X, Y; // input data
input s; // select signal
output [3:0] M; // output data
assign M[0] = (~s & X[0]) | (s & Y[0]);
assign M[1] = (~s & X[1]) | (s & Y[1]);
assign M[2] = (~s & X[2]) | (s & Y[2]);
assign M[3] = (~s & X[3]) | (s & Y[3]);
endmodule