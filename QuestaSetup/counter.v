module counter (L, Clock, Data, Q);
input L, Clock;
input [2:0] Data;
output reg [2:0] Q;
wire E;
always @(posedge Clock)
if (!L)
Q <= Data;
else if (E)
Q <= Q - 3'b1;
assign E = (Q != 3'b0);
endmodule
