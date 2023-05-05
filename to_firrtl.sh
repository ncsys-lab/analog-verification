#!/usr/bin/env bash

set -e

iverilog -E rc.model.sv -o rc_model.processed.sv
sed -i '/^\s*$/d' rc_model.processed.sv

range=256
width=8
exponent=$(
python3 << EOF
from math import ceil, log
numerator = $range
denominator = (2**($width-1)-1)
ratio = numerator/denominator
value = ceil(log(ratio, 2))
print(value)
EOF
)
yosys << EOF
read_verilog -sv rc.model.sv
hierarchy \
  -check \
  -top rc_model \
  -chparam v_in_range_val $range \
  -chparam v_in_width_val $width \
  -chparam v_in_exponent_val $exponent \
  -chparam v_out_range_val $range \
  -chparam v_out_width_val $width \
  -chparam v_out_exponent_val $exponent
proc
flatten
opt -nosdff

write_firrtl rc_model.f
EOF

sed -i -E 's/@\[\S*\]$//' rc_model.f

firtool -O=release -format=fir -o rc_model.f.sv rc_model.f
sv2v rc_model.f.sv > rc_model.f.v

# sed -i -E 's/automatic//' rc_model.simple.v
iverilog -g2005-sv rc.tb.sv -o rc_tb.vvp
vvp rc_tb.vvp

rm -f after.txt
yosys << EOF
read_verilog rc_model.simple.v
synth -top rc_model
abc -g NAND
tee -o after.txt stat
EOF
