package utils

import chisel3._
import chisel3.util.{Counter, DeqIO, EnqIO}

import scala.annotation.tailrec

// Funnel converts ready/valid data of width M into width N
// If M is not a multiple of N or vice-versa then two funnels are made:
// M -> LCM(M, N) -> N
class Funnel[E <: Data, D <: Data](enqGen: E, deqGen: D) extends Module {
  val io = IO(new Bundle {
    val enq = Flipped(EnqIO(enqGen))
    val deq = Flipped(DeqIO(deqGen))
  })

  val (enqWidth, deqWidth) = (enqGen.getWidth, deqGen.getWidth)

  if (enqWidth == deqWidth) {
    io.enq <> io.deq
  } else if (enqWidth < deqWidth && deqWidth % enqWidth == 0) {
    val memEntries = (deqWidth / enqWidth) - 1

    val mem = Reg(Vec(memEntries, enqGen))
    val (ptr, deq) = Counter(0 to memEntries, io.enq.fire)
    when(io.enq.fire) { mem(ptr) := io.enq.bits }

    io.enq.ready := ptr < memEntries.U || io.deq.ready
    io.deq.valid := deq
    io.deq.bits := (io.enq.bits.asUInt ## mem.asUInt).asTypeOf(deqGen)
  } else if (enqWidth > deqWidth && enqWidth % deqWidth == 0) {
    val mem = Reg(UInt((enqWidth - deqWidth).W))
    when(io.deq.fire) {
      mem := Mux(io.enq.fire, io.enq.bits.asUInt, mem) >> deqWidth
    }

    val ptr = Counter(0 until enqWidth / deqWidth, io.deq.fire)._1
    io.enq.ready := ptr === 0.U && io.deq.ready
    io.deq.valid := io.enq.valid || ptr =/= 0.U
    io.deq.bits := Mux(io.enq.fire, io.enq.bits.asUInt, mem).asTypeOf(deqGen)
  } else {
    @tailrec def gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)
    val lcmWidth = (enqWidth * deqWidth) / gcd(enqWidth, deqWidth)

    val funnelA = Module(new Funnel(enqGen, UInt(lcmWidth.W)))
    val funnelB = Module(new Funnel(UInt(lcmWidth.W), deqGen))

    io.enq <> funnelA.io.enq
    funnelA.io.deq <> funnelB.io.enq
    funnelB.io.deq <> io.deq
  }
}

object Funnel {
  def apply[E <: Data, D <: Data](enqGen: E, deqGen: D): Funnel[E, D] =
    Module(new Funnel(enqGen, deqGen))
}
