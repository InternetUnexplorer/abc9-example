import chisel3._
import chisel3.experimental.{Analog, ChiselEnum}
import chisel3.util._
import primitives.io.{AnalogIO, OutputFF}
import utils.{Funnel, ReverseBy, Timeout, UnsafeAsyncQueue}

class QioSpiIO extends Bundle {
  val sclk = Input(Clock())
  val cs = Input(Bool())
  val data = Analog(4.W)
  val ready = Output(Bool())
}

class SpiDevice(
    cmdWidth: Int = 36,
    rxdWidth: Int = 64,
    txdWidth: Int = 64,
    rxdEntries: Int = 256,
    txdEntries: Int = 256
) extends Module {
  require(cmdWidth % 4 == 0 && rxdWidth % 4 == 0 && txdWidth % 4 == 0)

  val io = IO(new Bundle {
    val spi = new QioSpiIO
    val cmd = Irrevocable(UInt(cmdWidth.W))
    val rxd = Flipped(DeqIO(UInt(rxdWidth.W)))
    val txd = Flipped(EnqIO(UInt(txdWidth.W)))
    val enterDownload = Input(Bool())
  })

  object SpiDeviceState extends ChiselEnum {
    val ReadyToRx, ReadyToTx, WorkingOnRx, WorkingOnTx = Value
  }

  import SpiDeviceState._

  val state = RegInit(ReadyToRx)

  val rxdMem = Module(new UnsafeAsyncQueue(UInt(rxdWidth.W), rxdEntries))
  val txdMem = Module(new UnsafeAsyncQueue(UInt(txdWidth.W), txdEntries))

  // The ESP32 provides the SPI clock here, so we have to send/receive data on
  // the positive edge of SCLK.
  val (spiClock, spiReset) = (io.spi.sclk, io.spi.cs.asAsyncReset)
  withClockAndReset(spiClock, spiReset) {
    // SCLK does not run when CS is high, so we use CS as an async reset to
    // detect the start of a new transaction. This is safe because CS goes
    // high at least one clock cycle after the last positive edge of SCLK.
    val init = RegInit(true.B); init := false.B

    val (dataI_, dataO, dataT) = AnalogIO(io.spi.data)

    // Add a FF on the data output path (I). We cannot add a FF on T because it
    // needs to be able to change when SCLK is not running to enter download
    // mode, but this is safe because it only changes at the start of a
    // transaction. We cannot add a FF on O because there seems to be no nice
    // way to add dummy bits at the end of a transaction on the ESP32, but it
    // seems to work without for now.
    val dataI = OutputFF(dataI_, 1) // +1 extra FF for timing

    // We need to hold GPIO2 low to enter download mode.
    dataI := 0.U
    dataT := "b111".U ## !io.enterDownload

    val command = Reg(UInt(cmdWidth.W))

    rxdMem.io.enq.noenq()
    rxdMem.io.enqClock := spiClock; rxdMem.io.enqReset := spiReset
    txdMem.io.deq.nodeq()
    txdMem.io.deqClock := spiClock; txdMem.io.deqReset := spiReset

    val rxdFunnel = Funnel(chiselTypeOf(dataO), chiselTypeOf(io.rxd.bits))
    rxdFunnel.io.deq <> rxdMem.io.enq; rxdFunnel.io.enq.noenq()
    val txdFunnel = Funnel(chiselTypeOf(io.txd.bits), chiselTypeOf(dataI))
    txdFunnel.io.enq <> txdMem.io.deq; txdFunnel.io.deq.nodeq()

    when(RegEnable(state === ReadyToTx, false.B, init)) {
      val data = txdFunnel.io.deq.deq()
      dataI := Cat(data(0), data(1), data(3), data(2))
      dataT := "b0000".U
    }.otherwise {
      when(!Timeout(cmdWidth / 4)) {
        command := command ## Cat(dataO(1), dataO(0), dataO(2), dataO(3))
      }.otherwise {
        rxdFunnel.io.enq.enq(Cat(dataO(1), dataO(0), dataO(2), dataO(3)))
      }
    }

    io.cmd.bits := ReverseBy(command, 4)
  }

  val csSync = ShiftRegister(io.spi.cs, 3, true.B, true.B)
  val csRose = csSync && !RegNext(csSync, true.B)

  // TODO: document why reset is connected to `!csSync` and not `csRose`
  rxdMem.io.deqClock := clock; rxdMem.io.deqReset := !csSync
  txdMem.io.enqClock := clock; txdMem.io.enqReset := !csSync

  when(csRose) {
    state := Mux(state === ReadyToRx, WorkingOnRx, ReadyToRx)
  }
  when(io.txd.fire) {
    state := WorkingOnTx
  }
  when(io.cmd.fire) {
    state := Mux(state === WorkingOnTx || io.txd.fire, ReadyToTx, ReadyToRx)
  }

  io.spi.ready := state === ReadyToRx || state === ReadyToTx
  io.cmd.valid := state === WorkingOnRx || state === WorkingOnTx

  io.rxd <> rxdMem.io.deq
  io.txd <> txdMem.io.enq
}

////////////////////////////////////////////////////////////////

import chisel3.stage.ChiselStage

object SpiDevice extends App {
  (new ChiselStage).emitVerilog(new SpiDevice, args)
}
