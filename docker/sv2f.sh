#!/usr/bin/env bash

temp=$(mktemp --suffix=.f)

yosys >&2 << EOF
read_verilog -defer -sv $1
hierarchy \
  -check \
  -top $2
proc
flatten
opt -nosdff

write_firrtl $temp
EOF
sed -E 's/@\[\S*\]$//' $temp
rm -f $temp
