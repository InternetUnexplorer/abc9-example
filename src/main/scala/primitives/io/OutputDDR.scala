package primitives.io

import chisel3._
import chisel3.experimental.ExtModule
import chisel3.util.HasExtModuleResource

class OutputDDR extends ExtModule with HasExtModuleResource {
  val clock = IO(Input(Clock()))
  val reset = IO(Input(Reset()))
  val D = IO(Input(UInt(2.W)))
  val Q = IO(Output(Bool()))

  addResource("verilog/io/OutputDDR.v")
}

object OutputDDR {
  def apply(D: Data): Bool = {
    val module = Module(new OutputDDR)
    module.clock := Module.clock
    module.reset := Module.reset
    module.D := D; module.Q
  }
}
