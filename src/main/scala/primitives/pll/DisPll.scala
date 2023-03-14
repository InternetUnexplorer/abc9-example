package primitives.pll

import chisel3._
import chisel3.experimental.ExtModule
import chisel3.util.HasExtModuleResource

// ecppll --clkin 25 --clkin_name clkIn \
//        --clkout0 315 --clkout0_name tmdsSdrClk \
//        --clkout1 157.5 --clkout1_name tmdsDdrClk \
//        --clkout2 31.5 --clkout2_name pixelClk \
//        --module DisPll --file DisPll.v

class DisPll extends ExtModule with HasExtModuleResource {
  val clkIn = IO(Input(Clock()))
  val tmdsSdrClk, tmdsDdrClk, pixelClk = IO(Output(Clock()))
  addResource("verilog/pll/DisPll.v")
}

object DisPll {
  def apply(clkIn: Clock): DisPll = {
    val module = Module(new DisPll)
    module.clkIn := clkIn; module
  }
}
