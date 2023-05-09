#!/usr/bin/env python3.9
from msdsl import *
import numpy as np

k = 1
dt=1e-5
m = MixedSignalModel('vco_model')
v_in = m.add_analog_input('v_in')
clk = m.add_digital_input('clk')
rst = m.add_digital_input('rst')

A = 3

v_out = m.add_analog_output('v_out')
y = m.add_analog_state('y', range_=np.pi, init=0)
dy = m.add_analog_state('dy', range_=A * np.pi, init=1)
ddy = m.add_analog_state('ddy', range_=A**2 * np.pi, init=0)

m.set_next_cycle(y, y + dy * dt, clk=clk, rst=rst)
m.set_next_cycle(dy, dy + ddy * dt, clk=clk, rst=rst)
m.set_next_cycle(ddy, -A**2 * y, clk=clk, rst=rst)
m.set_next_cycle(v_out, 128*y+128, clk=clk, rst=rst)

m.compile_and_print(VerilogGenerator())
