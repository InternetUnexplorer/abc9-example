package primitives.pll

import chisel3._
import chisel3.experimental.ExtModule
import chisel3.util.HasExtModuleResource

// ecppll --clkin 25 --clkin_name clkIn \
//        --clkout0 140 --clkout0_name memClk \
//        --clkout1 140 --clkout1_name memClkExt \
//        --clkout2 80 --clkout2_name sysClk \
//        --module SysPll --file SysPll.v

class SysPll extends ExtModule with HasExtModuleResource {
  val clkIn = IO(Input(Clock()))
  val memClk, memClkExt, sysClk = IO(Output(Clock()))
  addResource("verilog/pll/SysPll.v")
}

object SysPll {
  def apply(clkIn: Clock): SysPll = {
    val module = Module(new SysPll)
    module.clkIn := clkIn; module
  }
}
