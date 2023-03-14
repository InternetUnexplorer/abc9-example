package utils

import chisel3._
import chisel3.util.Cat

object ReverseBy {
  def apply[T <: Data](gen: T, width: Int): Data = {
    require(gen.getWidth % width == 0)
    Cat(gen.asTypeOf(Vec(gen.getWidth / width, UInt(width.W))))
  }
}
