package primitives.io

import chisel3._
import chisel3.experimental.ExtModule
import chisel3.util.{HasExtModuleResource, ShiftRegister}

class InputFF(width: Int, resetValue: Boolean)
    extends ExtModule(
      Map("WIDTH" -> width, "RESET" -> (if (resetValue) 1 else 0))
    )
    with HasExtModuleResource {
  val clock = IO(Input(Clock()))
  val reset = IO(Input(Reset()))
  val D = IO(Input(UInt(width.W)))
  val Q = IO(Output(UInt(width.W)))

  addResource("verilog/io/InputFF.v")
}

object InputFF {
  def apply(D: UInt, extraFFs: Int = 0, resetValue: Boolean = false): UInt = {
    val module = Module(new InputFF(D.getWidth, resetValue))
    module.clock := Module.clock
    module.reset := Module.reset
    D <> module.D; ShiftRegister(module.Q, extraFFs)
  }
}
