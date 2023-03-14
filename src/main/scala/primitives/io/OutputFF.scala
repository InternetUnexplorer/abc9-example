package primitives.io

import chisel3._
import chisel3.experimental.ExtModule
import chisel3.util.{HasExtModuleResource, ShiftRegister}

class OutputFF(width: Int, resetValue: Boolean)
    extends ExtModule(
      Map("WIDTH" -> width, "RESET" -> (if (resetValue) 1 else 0))
    )
    with HasExtModuleResource {
  val clock = IO(Input(Clock()))
  val reset = IO(Input(Reset()))
  val D = IO(Input(UInt(width.W)))
  val Q = IO(Output(UInt(width.W)))

  addResource("verilog/io/OutputFF.v")
}

object OutputFF {
  def apply(Q: UInt, extraFFs: Int = 0, resetValue: Boolean = false): UInt = {
    val module = Module(new OutputFF(Q.getWidth, resetValue))
    module.clock := Module.clock
    module.reset := Module.reset
    val D = Wire(chiselTypeOf(Q))
    module.D <> ShiftRegister(D, extraFFs); Q <> module.Q
    D
  }
}
