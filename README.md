# abc9-example

Running `synth_ecp5 -abc9` is causing ABC to crash for me. I was able to narrow it down to this part of my design:
```text
$ yosys --version
Yosys unstable-2023-03-11 (git sha1 101d19bb6ae, gcc 12.2.0 -fPIC -Os)
$ make
sbt "runMain SpiDevice --target-dir target --target:fpga --emission-options disableMemRandomization,disableRegisterRandomization --emit-modules verilog"
[info] welcome to sbt 1.7.3 (N/A Java 19.0.2)
...
[success] Total time: 11 s, completed Mar 14, 2023, 3:47:21 PM
yosys -p "synth_ecp5 -top SpiDevice -abc9 -json target/SpiDevice.json" target/*.v \
	-q -l target/yosys.log
Warning: ABC: execution of command ""/nix/store/ffb4gq7jbndxvr3qqaaflq015749j5p0-abc-verifier-unstable-2023-02-23/bin/abc" -s -f /tmp/yosys-abc-axehP0/abc.script 2>&1" failed: return code 139.
```
This isn't the same error as https://github.com/berkeley-abc/abc/issues/84; I get that error if I run `synth_ecp5 -abc9` on the module that uses this module (`SpiDevice`). But I suspect that this error probably causes that error.

The Verilog is included, so all you should need to do is run `make`. The Chisel source that the Verilog is generated from has also been included just in case.
