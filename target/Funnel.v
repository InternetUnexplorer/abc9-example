module Funnel(
  input         clock,
  input         reset,
  output        io_enq_ready,
  input         io_enq_valid,
  input  [3:0]  io_enq_bits,
  output        io_deq_valid,
  output [63:0] io_deq_bits
);
  reg [3:0] mem_0; // @[Funnel.scala 24:18]
  reg [3:0] mem_1; // @[Funnel.scala 24:18]
  reg [3:0] mem_2; // @[Funnel.scala 24:18]
  reg [3:0] mem_3; // @[Funnel.scala 24:18]
  reg [3:0] mem_4; // @[Funnel.scala 24:18]
  reg [3:0] mem_5; // @[Funnel.scala 24:18]
  reg [3:0] mem_6; // @[Funnel.scala 24:18]
  reg [3:0] mem_7; // @[Funnel.scala 24:18]
  reg [3:0] mem_8; // @[Funnel.scala 24:18]
  reg [3:0] mem_9; // @[Funnel.scala 24:18]
  reg [3:0] mem_10; // @[Funnel.scala 24:18]
  reg [3:0] mem_11; // @[Funnel.scala 24:18]
  reg [3:0] mem_12; // @[Funnel.scala 24:18]
  reg [3:0] mem_13; // @[Funnel.scala 24:18]
  reg [3:0] mem_14; // @[Funnel.scala 24:18]
  wire  _T = io_enq_ready & io_enq_valid; // @[Decoupled.scala 51:35]
  reg [3:0] ptr; // @[Counter.scala 61:40]
  wire  wrap_wrap = ptr == 4'hf; // @[Counter.scala 73:24]
  wire [3:0] _wrap_value_T_1 = ptr + 4'h1; // @[Counter.scala 77:24]
  wire [27:0] io_deq_bits_lo = {mem_6,mem_5,mem_4,mem_3,mem_2,mem_1,mem_0}; // @[Funnel.scala 30:47]
  wire [59:0] _io_deq_bits_T = {mem_14,mem_13,mem_12,mem_11,mem_10,mem_9,mem_8,mem_7,io_deq_bits_lo}; // @[Funnel.scala 30:47]
  assign io_enq_ready = 1'h1; // @[Funnel.scala 28:40]
  assign io_deq_valid = _T & wrap_wrap; // @[Counter.scala 136:24 137:12 132:24]
  assign io_deq_bits = {io_enq_bits,_io_deq_bits_T}; // @[Funnel.scala 30:40]
  always @(posedge clock) begin
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'h0 == ptr) begin // @[Funnel.scala 26:34]
        mem_0 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'h1 == ptr) begin // @[Funnel.scala 26:34]
        mem_1 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'h2 == ptr) begin // @[Funnel.scala 26:34]
        mem_2 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'h3 == ptr) begin // @[Funnel.scala 26:34]
        mem_3 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'h4 == ptr) begin // @[Funnel.scala 26:34]
        mem_4 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'h5 == ptr) begin // @[Funnel.scala 26:34]
        mem_5 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'h6 == ptr) begin // @[Funnel.scala 26:34]
        mem_6 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'h7 == ptr) begin // @[Funnel.scala 26:34]
        mem_7 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'h8 == ptr) begin // @[Funnel.scala 26:34]
        mem_8 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'h9 == ptr) begin // @[Funnel.scala 26:34]
        mem_9 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'ha == ptr) begin // @[Funnel.scala 26:34]
        mem_10 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'hb == ptr) begin // @[Funnel.scala 26:34]
        mem_11 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'hc == ptr) begin // @[Funnel.scala 26:34]
        mem_12 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'hd == ptr) begin // @[Funnel.scala 26:34]
        mem_13 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
    if (_T) begin // @[Funnel.scala 26:23]
      if (4'he == ptr) begin // @[Funnel.scala 26:34]
        mem_14 <= io_enq_bits; // @[Funnel.scala 26:34]
      end
    end
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[Counter.scala 136:24]
      ptr <= 4'h0; // @[Counter.scala 77:15]
    end else if (_T) begin // @[Counter.scala 61:40]
      ptr <= _wrap_value_T_1;
    end
  end
endmodule
