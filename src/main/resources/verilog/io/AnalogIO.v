module AnalogIO #(
  parameter WIDTH = 1
) (
  input  [WIDTH-1:0] I,
  output [WIDTH-1:0] O,
  inout  [WIDTH-1:0] B,
  input  [WIDTH-1:0] T
);
`ifdef SYNTHESIS
  BB bb [WIDTH-1:0] (.I(I), .O(O), .B(B), .T(T));
`else
  genvar i;
  generate
    for (i = 0; i < WIDTH; i++) begin
      assign O[i] = B[i];
      assign B[i] = T[i] ? 1'bz : I[i];
    end
  endgenerate
`endif
endmodule
