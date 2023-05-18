#!/usr/bin/env bash
temp=$(mktemp)
yosys >&2 << EOF
read_verilog -sv $1
hierarchy \
  -check \
  -top $2
proc
flatten
opt -nosdff
dffunmap

write_btor $temp
EOF
cat $temp
rm $temp
