#!/usr/bin/env bash

if [[ "$MODEL_NAME" == "" ]]
then
  echo 'Error: $MODEL_NAME not specified.' > /dev/stderr
  exit 1
fi

set -e
# Read the model (as Python) from STDIN
cat > model.py
# Convert the model to SystemVerilog
python3.9 model.py > model.sv
if $USE_FIRRTL
then
  # Convert to Verilog and extract top-level name
  sv2v model.sv > model.v
  # Convert to FIRRTL
  ./sv2f.sh model.v $MODEL_NAME > model.f
  # Convert back to SystemVerilog
  firtool -O=release -format=fir -o model.f.sv model.f
else
  # Skip FIRRTL
  cp model.sv model.f.sv
fi
# SystemVerilog to Verilog
sv2v model.f.sv > model.f.v
# Echo to output
cat model.f.v
