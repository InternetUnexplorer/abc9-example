module Funnel_1(
  input         clock,
  input         reset,
  output        io_enq_ready,
  input  [63:0] io_enq_bits,
  input         io_deq_ready,
  output        io_deq_valid,
  output [3:0]  io_deq_bits
);
  reg [59:0] mem; // @[Funnel.scala 32:18]
  wire  _T = io_deq_ready & io_deq_valid; // @[Decoupled.scala 51:35]
  wire [63:0] _mem_T_1 = io_enq_ready ? io_enq_bits : {{4'd0}, mem}; // @[Funnel.scala 34:17]
  reg [3:0] ptr; // @[Counter.scala 61:40]
  wire [3:0] _ptr_wrap_value_T_1 = ptr + 4'h1; // @[Counter.scala 77:24]
  assign io_enq_ready = ptr == 4'h0 & io_deq_ready; // @[Funnel.scala 38:33]
  assign io_deq_valid = 1'h1; // @[Funnel.scala 39:34]
  assign io_deq_bits = _mem_T_1[3:0]; // @[Funnel.scala 40:{70,70}]
  always @(posedge clock) begin
    if (_T) begin // @[Funnel.scala 33:23]
      mem <= _mem_T_1[63:4]; // @[Funnel.scala 34:11]
    end
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[Counter.scala 136:24]
      ptr <= 4'h0; // @[Counter.scala 77:15]
    end else if (_T) begin // @[Counter.scala 61:40]
      ptr <= _ptr_wrap_value_T_1;
    end
  end
endmodule
