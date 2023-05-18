#!/usr/bin/env bash

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

temp=$(mktemp --suffix=.f)

yosys >&2 << EOF
read_verilog -sv $1
hierarchy \
  -check \
  -top $2 \
  -chparam v_in_range_val $range \
  -chparam v_in_width_val $width \
  -chparam v_in_exponent_val $exponent
  # -chparam v_out_range_val $range \
  # -chparam v_out_width_val $width \
  # -chparam v_out_exponent_val $exponent
proc
flatten
opt -nosdff

write_firrtl $temp
EOF
sed -E 's/@\[\S*\]$//' $temp
rm -f $temp
