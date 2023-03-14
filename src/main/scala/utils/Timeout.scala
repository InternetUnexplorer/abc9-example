package utils

import chisel3._
import chisel3.experimental.AffectsChiselPrefix
import chisel3.util.Counter

object Timeout extends AffectsChiselPrefix {
  def apply(cycles: Int): Bool = {
    val done = WireDefault(false.B)
    val counter = Counter(0 to cycles, !done)._1
    done := counter === cycles.U
    done
  }
}
