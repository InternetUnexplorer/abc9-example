package primitives.io

import chisel3._
import chisel3.experimental.{Analog, ExtModule}
import chisel3.util.HasExtModuleResource

class AnalogIO(width: Int)
    extends ExtModule(Map("WIDTH" -> width))
    with HasExtModuleResource {
  val I = IO(Input(UInt(width.W)))
  val O = IO(Output(UInt(width.W)))
  val B = IO(Analog(width.W))
  val T = IO(Input(UInt(width.W)))

  addResource("verilog/io/AnalogIO.v")
}

object AnalogIO {
  def apply(B: Analog): (UInt, UInt, UInt) = {
    val analog = Module(new AnalogIO(B.getWidth))
    B <> analog.B; (analog.I, analog.O, analog.T)
  }
}
