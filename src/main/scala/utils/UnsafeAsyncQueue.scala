package utils

import chisel3._
import chisel3.util.{Counter, DeqIO, EnqIO}

// A really simple BRAM-backed async FIFO without any ready/valid logic
// This is meant to be used in SpiDevice, so there's no need for ready/valid stuff
class UnsafeAsyncQueue[T <: Data](gen: T, entries: Int) extends RawModule {
  val io = IO(new Bundle {
    val enq = Flipped(EnqIO(gen))
    val deq = Flipped(DeqIO(gen))
    val enqClock, deqClock = Input(Clock())
    val enqReset, deqReset = Input(Reset())
  })

  // ReadFirst seems to be needed to infer DP16KD
  val mem = SyncReadMem(entries, gen, SyncReadMem.ReadFirst)

  withClockAndReset(io.enqClock, io.enqReset) {
    val ptr = Counter(0 until entries, io.enq.fire)._1
    when(io.enq.fire) { mem.write(ptr, io.enq.bits) }
    io.enq.ready := true.B
  }

  withClockAndReset(io.deqClock, io.deqReset) {
    val ptr = Counter(0 until entries, io.deq.fire)._1
    io.deq.bits := mem.read(Mux(io.deq.fire, ptr + 1.U, ptr))
    io.deq.valid := true.B
  }
}
