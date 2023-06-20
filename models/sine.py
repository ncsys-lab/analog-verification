#!/usr/bin/env python3.9
from msdsl import *
import numpy as np

k = 1
dt=1e-5
m = MixedSignalModel('sine')
v_in = m.add_digital_input('v_in', width=8)
v_out = m.add_digital_output('v_out', width=8, signed=True)

a_in = m.add_analog_state('a_in', range_=1)
clk = m.add_digital_input('clk')
rst = m.add_digital_input('rst')

A = 2048

a_out = m.add_analog_state('a_out', range_=1)
y = m.add_analog_state('y', range_=np.pi, init=0)
dy = m.add_analog_state('dy', range_=A * np.pi, init=1)
ddy = m.add_analog_state('ddy', range_=A**2 * np.pi, init=0)

m.set_next_cycle(y, y + dy * dt, clk=clk, rst=rst)
m.set_next_cycle(dy, dy + ddy * dt, clk=clk, rst=rst)
m.set_next_cycle(ddy, -A**2 * y, clk=clk, rst=rst)
m.set_next_cycle(a_out, 256*(A*y+1.5), clk=clk, rst=rst)

m.set_this_cycle(a_in, to_real(v_in)/255)
m.set_this_cycle(v_out, to_sint(a_out*127))

m.compile_and_print(VerilogGenerator())
