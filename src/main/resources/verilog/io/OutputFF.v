module OutputFF #(
  parameter WIDTH = 1,
  parameter RESET = 0
) (
  input              clock,
  input              reset,
  input  [WIDTH-1:0] D,
  output [WIDTH-1:0] Q
);
  generate
    if (RESET == 1)
      OFS1P3BX ff [WIDTH-1:0] (.D(D), .SP({WIDTH{1'b1}}), .SCLK(clock), .PD(reset), .Q(Q));
    else
      OFS1P3DX ff [WIDTH-1:0] (.D(D), .SP({WIDTH{1'b1}}), .SCLK(clock), .CD(reset), .Q(Q));
  endgenerate
endmodule
