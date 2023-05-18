#!/usr/bin/env python3.9
from msdsl import *
import numpy as np

w = 10
k = w**2

dt=1e-5
m = MixedSignalModel('vco_model')
v_in = m.add_analog_input('v_in')
clk = m.add_digital_input('clk')
rst = m.add_digital_input('rst')

A = 2048

v_out = m.add_digital_output('v_out', width=25, signed=True, min_val=-1.5, max_val=1.5)
x = m.add_analog_state('x', range_=1.5, init=0)
v = m.add_analog_state('v', range_=(w**2)*1.5, init=1)
v_prime = m.add_analog_state('v_prime', range_=(w**2)*1.5, init=0)

m.set_next_cycle(v_prime, -(w**2)*x, clk=clk, rst=rst)
m.set_next_cycle(v, v + v_prime * dt, clk=clk, rst=rst)
m.set_next_cycle(x, x + v * dt, clk=clk, rst=rst)
m.set_this_cycle(v_out, to_sint(x, width=25))

m.compile_and_print(VerilogGenerator())
