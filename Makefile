OUTPUT_DIR ?= target
SCALA_SRCS := $(shell find src -name "*.scala")

FIRRTL_FLAGS ?= --target:fpga --emission-options disableMemRandomization,disableRegisterRandomization --emit-modules verilog
YOSYS_FLAGS ?= -q -l $(OUTPUT_DIR)/yosys.log
SYNTH_FLAGS ?= -top SpiDevice -abc9

.PHONY: default clean

default: $(OUTPUT_DIR)/SpiDevice.json

$(OUTPUT_DIR)/SpiDevice.v: $(SCALA_SRCS)
	sbt "runMain SpiDevice --target-dir $(OUTPUT_DIR) $(FIRRTL_FLAGS)"

$(OUTPUT_DIR)/SpiDevice.json: $(OUTPUT_DIR)/SpiDevice.v
	yosys -p "synth_ecp5 $(SYNTH_FLAGS) -json $@" target/*.v \
		$(YOSYS_FLAGS)

clean:
	rm -rf $(OUTPUT_DIR)
