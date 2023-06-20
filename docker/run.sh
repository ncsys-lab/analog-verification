#!/usr/bin/env bash

set -e
# Read the model (as Python) from STDIN
cat > model.py
# Convert the model to SystemVerilog
python3.9 model.py > model.sv
if $USE_FIRRTL
then
  # Convert to Verilog and extract top-level name
  sv2v model.sv > model.v
  model_name=$(grep "MixedSignalModel" model.py | sed -E "s/.*'(.*)'.*/\1/")
  # Convert to FIRRTL
  ./sv2f.sh model.v $model_name > model.f
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
