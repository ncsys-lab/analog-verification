#!/usr/bin/env python3.9
from msdsl import *
from math import exp

r, c, dt = 1e3, 1e-9, 0.1e-6
m = MixedSignalModel('rc_model')
x = m.add_analog_input('v_in')
y = m.add_analog_output('v_out')
clk = m.add_digital_input('clk')
rst = m.add_digital_input('rst')
a = exp(-dt/(r*c))
m.set_next_cycle(y, a * y + (1-a) * x, clk=clk, rst=rst)
m.compile_and_print(VerilogGenerator())
