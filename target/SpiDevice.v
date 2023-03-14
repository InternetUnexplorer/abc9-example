module SpiDevice(
  input         clock,
  input         reset,
  input         io_spi_sclk,
  input         io_spi_cs,
  inout  [3:0]  io_spi_data,
  output        io_spi_ready,
  input         io_cmd_ready,
  output        io_cmd_valid,
  output [35:0] io_cmd_bits,
  input         io_rxd_ready,
  output        io_rxd_valid,
  output [63:0] io_rxd_bits,
  output        io_txd_ready,
  input         io_txd_valid,
  input  [63:0] io_txd_bits,
  input         io_enterDownload
);
  wire  rxdMem_io_enq_ready; // @[SpiDevice.scala 39:22]
  wire  rxdMem_io_enq_valid; // @[SpiDevice.scala 39:22]
  wire [63:0] rxdMem_io_enq_bits; // @[SpiDevice.scala 39:22]
  wire  rxdMem_io_deq_ready; // @[SpiDevice.scala 39:22]
  wire  rxdMem_io_deq_valid; // @[SpiDevice.scala 39:22]
  wire [63:0] rxdMem_io_deq_bits; // @[SpiDevice.scala 39:22]
  wire  rxdMem_io_enqClock; // @[SpiDevice.scala 39:22]
  wire  rxdMem_io_deqClock; // @[SpiDevice.scala 39:22]
  wire  rxdMem_io_enqReset; // @[SpiDevice.scala 39:22]
  wire  rxdMem_io_deqReset; // @[SpiDevice.scala 39:22]
  wire  txdMem_io_enq_ready; // @[SpiDevice.scala 40:22]
  wire  txdMem_io_enq_valid; // @[SpiDevice.scala 40:22]
  wire [63:0] txdMem_io_enq_bits; // @[SpiDevice.scala 40:22]
  wire  txdMem_io_deq_ready; // @[SpiDevice.scala 40:22]
  wire  txdMem_io_deq_valid; // @[SpiDevice.scala 40:22]
  wire [63:0] txdMem_io_deq_bits; // @[SpiDevice.scala 40:22]
  wire  txdMem_io_enqClock; // @[SpiDevice.scala 40:22]
  wire  txdMem_io_deqClock; // @[SpiDevice.scala 40:22]
  wire  txdMem_io_enqReset; // @[SpiDevice.scala 40:22]
  wire  txdMem_io_deqReset; // @[SpiDevice.scala 40:22]
  wire [3:0] analog_I; // @[AnalogIO.scala 20:24]
  wire [3:0] analog_O; // @[AnalogIO.scala 20:24]
  wire [3:0] analog_T; // @[AnalogIO.scala 20:24]
  wire  dataI_module_clock; // @[OutputFF.scala 22:24]
  wire  dataI_module_reset; // @[OutputFF.scala 22:24]
  wire [3:0] dataI_module_D; // @[OutputFF.scala 22:24]
  wire [3:0] dataI_module_Q; // @[OutputFF.scala 22:24]
  wire  rxdFunnel_clock; // @[Funnel.scala 56:11]
  wire  rxdFunnel_reset; // @[Funnel.scala 56:11]
  wire  rxdFunnel_io_enq_ready; // @[Funnel.scala 56:11]
  wire  rxdFunnel_io_enq_valid; // @[Funnel.scala 56:11]
  wire [3:0] rxdFunnel_io_enq_bits; // @[Funnel.scala 56:11]
  wire  rxdFunnel_io_deq_valid; // @[Funnel.scala 56:11]
  wire [63:0] rxdFunnel_io_deq_bits; // @[Funnel.scala 56:11]
  wire  txdFunnel_clock; // @[Funnel.scala 56:11]
  wire  txdFunnel_reset; // @[Funnel.scala 56:11]
  wire  txdFunnel_io_enq_ready; // @[Funnel.scala 56:11]
  wire [63:0] txdFunnel_io_enq_bits; // @[Funnel.scala 56:11]
  wire  txdFunnel_io_deq_ready; // @[Funnel.scala 56:11]
  wire  txdFunnel_io_deq_valid; // @[Funnel.scala 56:11]
  wire [3:0] txdFunnel_io_deq_bits; // @[Funnel.scala 56:11]
  reg [1:0] state; // @[SpiDevice.scala 37:22]
  reg  init; // @[SpiDevice.scala 49:23]
  reg [3:0] dataI_module_D_r; // @[Reg.scala 19:16]
  reg  r; // @[Reg.scala 35:20]
  wire [3:0] _dataI_T_4 = {txdFunnel_io_deq_bits[0],txdFunnel_io_deq_bits[1],txdFunnel_io_deq_bits[3],
    txdFunnel_io_deq_bits[2]}; // @[Cat.scala 33:92]
  wire  _analog_dataT_T = ~io_enterDownload; // @[SpiDevice.scala 63:26]
  wire [3:0] _analog_dataT_T_1 = {3'h7,_analog_dataT_T}; // @[SpiDevice.scala 63:23]
  reg [35:0] command; // @[SpiDevice.scala 65:22]
  wire  _T = state == 2'h1; // @[SpiDevice.scala 77:26]
  reg [3:0] counter; // @[Counter.scala 61:40]
  wire  done = counter == 4'h9; // @[Timeout.scala 11:21]
  wire  _counter_T = ~done; // @[Timeout.scala 10:40]
  wire [3:0] _counter_wrap_value_T_1 = counter + 4'h1; // @[Counter.scala 77:24]
  wire [1:0] command_lo = {analog_O[2],analog_O[3]}; // @[Cat.scala 33:92]
  wire [1:0] command_hi = {analog_O[1],analog_O[0]}; // @[Cat.scala 33:92]
  wire [39:0] _command_T_5 = {command,analog_O[1],analog_O[0],analog_O[2],analog_O[3]}; // @[SpiDevice.scala 83:28]
  wire [39:0] _GEN_7 = _counter_T ? _command_T_5 : {{4'd0}, command}; // @[SpiDevice.scala 82:36 83:17 65:22]
  wire  _GEN_8 = _counter_T ? 1'h0 : 1'h1; // @[Decoupled.scala 64:20 73:20 SpiDevice.scala 82:36]
  wire [39:0] _GEN_13 = r ? {{4'd0}, command} : _GEN_7; // @[SpiDevice.scala 65:22 77:57]
  wire [15:0] io_cmd_bits_lo = {command[23:20],command[27:24],command[31:28],command[35:32]}; // @[Cat.scala 33:92]
  wire [19:0] io_cmd_bits_hi = {command[3:0],command[7:4],command[11:8],command[15:12],command[19:16]}; // @[Cat.scala 33:92]
  reg  csSync_r; // @[Reg.scala 35:20]
  reg  csSync_r_1; // @[Reg.scala 35:20]
  reg  csSync; // @[Reg.scala 35:20]
  reg  csRose_REG; // @[SpiDevice.scala 93:34]
  wire  csRose = csSync & ~csRose_REG; // @[SpiDevice.scala 93:23]
  wire  _state_T = state == 2'h0; // @[SpiDevice.scala 100:24]
  wire [1:0] _state_T_1 = state == 2'h0 ? 2'h2 : 2'h0; // @[SpiDevice.scala 100:17]
  wire  _T_7 = io_txd_ready & io_txd_valid; // @[Decoupled.scala 51:35]
  wire  _T_8 = io_cmd_ready & io_cmd_valid; // @[Decoupled.scala 51:35]
  wire  _state_T_2 = state == 2'h3; // @[SpiDevice.scala 106:24]
  wire  _state_T_4 = state == 2'h3 | _T_7; // @[SpiDevice.scala 106:40]
  UnsafeAsyncQueue rxdMem ( // @[SpiDevice.scala 39:22]
    .io_enq_ready(rxdMem_io_enq_ready),
    .io_enq_valid(rxdMem_io_enq_valid),
    .io_enq_bits(rxdMem_io_enq_bits),
    .io_deq_ready(rxdMem_io_deq_ready),
    .io_deq_valid(rxdMem_io_deq_valid),
    .io_deq_bits(rxdMem_io_deq_bits),
    .io_enqClock(rxdMem_io_enqClock),
    .io_deqClock(rxdMem_io_deqClock),
    .io_enqReset(rxdMem_io_enqReset),
    .io_deqReset(rxdMem_io_deqReset)
  );
  UnsafeAsyncQueue_1 txdMem ( // @[SpiDevice.scala 40:22]
    .io_enq_ready(txdMem_io_enq_ready),
    .io_enq_valid(txdMem_io_enq_valid),
    .io_enq_bits(txdMem_io_enq_bits),
    .io_deq_ready(txdMem_io_deq_ready),
    .io_deq_valid(txdMem_io_deq_valid),
    .io_deq_bits(txdMem_io_deq_bits),
    .io_enqClock(txdMem_io_enqClock),
    .io_deqClock(txdMem_io_deqClock),
    .io_enqReset(txdMem_io_enqReset),
    .io_deqReset(txdMem_io_deqReset)
  );
  AnalogIO #(.WIDTH(4)) analog ( // @[AnalogIO.scala 20:24]
    .I(analog_I),
    .O(analog_O),
    .B(io_spi_data),
    .T(analog_T)
  );
  OutputFF #(.WIDTH(4), .RESET(0)) dataI_module ( // @[OutputFF.scala 22:24]
    .clock(dataI_module_clock),
    .reset(dataI_module_reset),
    .D(dataI_module_D),
    .Q(dataI_module_Q)
  );
  Funnel rxdFunnel ( // @[Funnel.scala 56:11]
    .clock(rxdFunnel_clock),
    .reset(rxdFunnel_reset),
    .io_enq_ready(rxdFunnel_io_enq_ready),
    .io_enq_valid(rxdFunnel_io_enq_valid),
    .io_enq_bits(rxdFunnel_io_enq_bits),
    .io_deq_valid(rxdFunnel_io_deq_valid),
    .io_deq_bits(rxdFunnel_io_deq_bits)
  );
  Funnel_1 txdFunnel ( // @[Funnel.scala 56:11]
    .clock(txdFunnel_clock),
    .reset(txdFunnel_reset),
    .io_enq_ready(txdFunnel_io_enq_ready),
    .io_enq_bits(txdFunnel_io_enq_bits),
    .io_deq_ready(txdFunnel_io_deq_ready),
    .io_deq_valid(txdFunnel_io_deq_valid),
    .io_deq_bits(txdFunnel_io_deq_bits)
  );
  assign io_spi_ready = _state_T | _T; // @[SpiDevice.scala 109:39]
  assign io_cmd_valid = state == 2'h2 | _state_T_2; // @[SpiDevice.scala 110:41]
  assign io_cmd_bits = {io_cmd_bits_hi,io_cmd_bits_lo}; // @[Cat.scala 33:92]
  assign io_rxd_valid = 1'h1; // @[SpiDevice.scala 112:10]
  assign io_rxd_bits = rxdMem_io_deq_bits; // @[SpiDevice.scala 112:10]
  assign io_txd_ready = 1'h1; // @[SpiDevice.scala 113:10]
  assign rxdMem_io_enq_valid = rxdFunnel_io_deq_valid; // @[SpiDevice.scala 73:22]
  assign rxdMem_io_enq_bits = rxdFunnel_io_deq_bits; // @[SpiDevice.scala 73:22]
  assign rxdMem_io_deq_ready = io_rxd_ready; // @[SpiDevice.scala 112:10]
  assign rxdMem_io_enqClock = io_spi_sclk; // @[SpiDevice.scala 68:24]
  assign rxdMem_io_deqClock = clock; // @[SpiDevice.scala 96:22]
  assign rxdMem_io_enqReset = io_spi_cs; // @[SpiDevice.scala 44:54]
  assign rxdMem_io_deqReset = ~csSync; // @[SpiDevice.scala 96:54]
  assign txdMem_io_enq_valid = io_txd_valid; // @[SpiDevice.scala 113:10]
  assign txdMem_io_enq_bits = io_txd_bits; // @[SpiDevice.scala 113:10]
  assign txdMem_io_deq_ready = txdFunnel_io_enq_ready; // @[SpiDevice.scala 75:22]
  assign txdMem_io_enqClock = clock; // @[SpiDevice.scala 97:22]
  assign txdMem_io_deqClock = io_spi_sclk; // @[SpiDevice.scala 70:24]
  assign txdMem_io_enqReset = ~csSync; // @[SpiDevice.scala 97:54]
  assign txdMem_io_deqReset = io_spi_cs; // @[SpiDevice.scala 44:54]
  assign analog_I = dataI_module_Q; // @[OutputFF.scala 26:47]
  assign analog_T = r ? 4'h0 : _analog_dataT_T_1; // @[SpiDevice.scala 63:11 77:57 80:13]
  assign dataI_module_clock = io_spi_sclk; // @[OutputFF.scala 23:18]
  assign dataI_module_reset = io_spi_cs; // @[SpiDevice.scala 44:54]
  assign dataI_module_D = dataI_module_D_r; // @[OutputFF.scala 26:14]
  assign rxdFunnel_clock = io_spi_sclk;
  assign rxdFunnel_reset = io_spi_cs; // @[SpiDevice.scala 44:54]
  assign rxdFunnel_io_enq_valid = r ? 1'h0 : _GEN_8; // @[Decoupled.scala 73:20 SpiDevice.scala 77:57]
  assign rxdFunnel_io_enq_bits = {command_hi,command_lo}; // @[Cat.scala 33:92]
  assign txdFunnel_clock = io_spi_sclk;
  assign txdFunnel_reset = io_spi_cs; // @[SpiDevice.scala 44:54]
  assign txdFunnel_io_enq_bits = txdMem_io_deq_bits; // @[SpiDevice.scala 75:22]
  assign txdFunnel_io_deq_ready = r; // @[SpiDevice.scala 77:57 Decoupled.scala 82:20 89:20]
  always @(posedge clock) begin
    if (reset) begin // @[SpiDevice.scala 37:22]
      state <= 2'h0; // @[SpiDevice.scala 37:22]
    end else if (_T_8) begin // @[SpiDevice.scala 105:21]
      state <= {{1'd0}, _state_T_4}; // @[SpiDevice.scala 106:11]
    end else if (_T_7) begin // @[SpiDevice.scala 102:21]
      state <= 2'h3; // @[SpiDevice.scala 103:11]
    end else if (csRose) begin // @[SpiDevice.scala 99:16]
      state <= _state_T_1; // @[SpiDevice.scala 100:11]
    end
    csSync_r <= reset | io_spi_cs; // @[Reg.scala 35:{20,20}]
    csSync_r_1 <= reset | csSync_r; // @[Reg.scala 35:{20,20}]
    csSync <= reset | csSync_r_1; // @[Reg.scala 35:{20,20}]
    csRose_REG <= reset | csSync; // @[SpiDevice.scala 93:{34,34,34}]
  end
  always @(posedge io_spi_sclk) begin
    if (r) begin // @[SpiDevice.scala 77:57]
      dataI_module_D_r <= _dataI_T_4; // @[SpiDevice.scala 79:13]
    end else begin
      dataI_module_D_r <= 4'h0; // @[SpiDevice.scala 62:11]
    end
    command <= _GEN_13[35:0];
  end
  always @(posedge io_spi_sclk or posedge io_spi_cs) begin
    if (io_spi_cs) begin // @[SpiDevice.scala 49:23]
      init <= 1'h1; // @[SpiDevice.scala 49:23]
    end else begin
      init <= 1'h0; // @[SpiDevice.scala 49:38]
    end
  end
  always @(posedge io_spi_sclk or posedge io_spi_cs) begin
    if (io_spi_cs) begin // @[Reg.scala 36:18]
      r <= 1'h0; // @[Reg.scala 36:22]
    end else if (init) begin // @[Reg.scala 35:20]
      r <= _T;
    end
  end
  always @(posedge io_spi_sclk or posedge io_spi_cs) begin
    if (io_spi_cs) begin // @[Counter.scala 136:24]
      counter <= 4'h0; // @[Counter.scala 77:15 87:{20,28}]
    end else if (_counter_T) begin // @[Counter.scala 61:40]
      if (done) begin
        counter <= 4'h0;
      end else begin
        counter <= _counter_wrap_value_T_1;
      end
    end
  end
endmodule
