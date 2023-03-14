module UnsafeAsyncQueue(
  output        io_enq_ready,
  input         io_enq_valid,
  input  [63:0] io_enq_bits,
  input         io_deq_ready,
  output        io_deq_valid,
  output [63:0] io_deq_bits,
  input         io_enqClock,
  input         io_deqClock,
  input         io_enqReset,
  input         io_deqReset
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] mem [0:255]; // @[UnsafeAsyncQueue.scala 17:24]
  wire  mem_io_deq_bits_MPORT_en; // @[UnsafeAsyncQueue.scala 17:{24,24} 27:{28,28}]
  wire [7:0] mem_io_deq_bits_MPORT_addr; // @[UnsafeAsyncQueue.scala 17:24 27:32]
  reg [63:0] mem_io_deq_bits_MPORT_data; // @[UnsafeAsyncQueue.scala 17:24]
  wire [63:0] mem_MPORT_data; // @[UnsafeAsyncQueue.scala 17:24 21:23]
  wire [7:0] mem_MPORT_addr; // @[UnsafeAsyncQueue.scala 17:24 21:23]
  wire  mem_MPORT_mask; // @[UnsafeAsyncQueue.scala 17:24 21:23]
  wire  mem_MPORT_en; // @[UnsafeAsyncQueue.scala 17:24 Decoupled.scala 51:35]
  wire  _ptr_T = io_enq_ready & io_enq_valid; // @[Decoupled.scala 51:35]
  reg [7:0] ptr; // @[Counter.scala 61:40]
  wire [7:0] _ptr_wrap_value_T_1 = ptr + 8'h1; // @[Counter.scala 77:24]
  wire  _ptr_T_1 = io_deq_ready & io_deq_valid; // @[Decoupled.scala 51:35]
  reg [7:0] ptr_1; // @[Counter.scala 61:40]
  wire [7:0] _ptr_wrap_value_T_3 = ptr_1 + 8'h1; // @[Counter.scala 77:24]
  assign mem_io_deq_bits_MPORT_en = 1'h1; // @[UnsafeAsyncQueue.scala 17:24 27:{28,28}]
  assign mem_io_deq_bits_MPORT_addr = _ptr_T_1 ? _ptr_wrap_value_T_3 : ptr_1; // @[UnsafeAsyncQueue.scala 27:32]
  assign mem_MPORT_data = io_enq_bits; // @[UnsafeAsyncQueue.scala 21:23]
  assign mem_MPORT_addr = ptr; // @[UnsafeAsyncQueue.scala 21:23]
  assign mem_MPORT_mask = 1'h1; // @[UnsafeAsyncQueue.scala 21:23]
  assign mem_MPORT_en = io_enq_ready & io_enq_valid; // @[Decoupled.scala 51:35]
  assign io_enq_ready = 1'h1; // @[UnsafeAsyncQueue.scala 22:18]
  assign io_deq_valid = 1'h1; // @[UnsafeAsyncQueue.scala 28:18]
  assign io_deq_bits = mem_io_deq_bits_MPORT_data; // @[UnsafeAsyncQueue.scala 27:17]
  always @(posedge io_deqClock) begin
    if (mem_io_deq_bits_MPORT_en) begin
      mem_io_deq_bits_MPORT_data <= mem[mem_io_deq_bits_MPORT_addr]; // @[UnsafeAsyncQueue.scala 17:24]
    end
    if (io_deqReset) begin // @[Counter.scala 61:40]
      ptr_1 <= 8'h0; // @[Counter.scala 61:40]
    end else if (_ptr_T_1) begin // @[Counter.scala 136:24]
      ptr_1 <= _ptr_wrap_value_T_3; // @[Counter.scala 77:15]
    end
  end
  always @(posedge io_enqClock) begin
    if (mem_MPORT_en & mem_MPORT_mask) begin
      mem[mem_MPORT_addr] <= mem_MPORT_data; // @[UnsafeAsyncQueue.scala 17:24]
    end
  end
  always @(posedge io_enqClock or posedge io_enqReset) begin
    if (io_enqReset) begin // @[Counter.scala 136:24]
      ptr <= 8'h0; // @[Counter.scala 77:15]
    end else if (_ptr_T) begin // @[Counter.scala 61:40]
      ptr <= _ptr_wrap_value_T_1;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  mem_io_deq_bits_MPORT_data = _RAND_0[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
