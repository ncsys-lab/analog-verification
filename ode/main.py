import sympy as sym
from dataclasses import dataclass
from typing import *
import msdsl as M

Real = lambda x: sym.Symbol(x, real=True)
Positive = lambda x: sym.Symbol(x, real=True, positive=True)
Function = lambda x: sym.Function(x)

w = Real('w')
t = Real('t')
x = Function('x')(t)
v = x.diff(t)
v_ = v.diff(t)
eq = sym.Eq(v_, -(w**2)*x)

@dataclass
class System:
    equations: List[sym.Eq]
    time: sym.Symbol
    inputs: List[sym.Symbol]
    outputs: List[sym.Symbol]

sys = System([eq], t, [w], [x])

@dataclass
class Integrator:
    transformations: Dict[sym.Symbol, sym.Expr]
    time: sym.Symbol
    dt: sym.Symbol
    inputs: List[sym.Symbol]
    outputs: List[sym.Symbol]
    states: List[sym.Symbol]

def integrate(sys: System) -> Integrator:
    transformations = {}
    derivatives = {}
    handled_derivatives = set()
    needed_derivatives = {(x, 0) for x in sys.outputs}
    dt = Real(f'__internal_d{sys.time.name}')

    def get_name(target_name, n):
        num = str(n) if n != 1 else ''
        return f'__internal_d{num}{target_name}_d{sys.time}{num}'

    def get_derivative(target, n):
        if n == 0:
            derivatives[target.name][0] = target
            return target
        try:
            this_target = derivatives[target.name]
        except KeyError:
            derivatives[target.name] = {}
            this_target = derivatives[target.name]
        try:
            dsym = this_target[n]
        except KeyError:
            dsym = Real(get_name(target.name, n)) 
            this_target[n] = dsym
        return dsym

    for eqn in sys.equations:
        lhs = eqn.lhs
        rhs = eqn.rhs
        assert(type(lhs) == sym.Derivative)
        ode_vars = set(lhs.variables)
        assert(len(ode_vars) == 1)
        ode_var = list(ode_vars)[0]
        assert(ode_var == sys.time)
        derivative = len(lhs.variables)
        dsym = get_derivative(lhs.expr, derivative)
        handled_derivatives.add((lhs.expr, derivative))
        transformations[dsym] = rhs

    while len(needed_derivatives - handled_derivatives) != 0:
        f, n = next(iter(needed_derivatives - handled_derivatives))
        s = get_derivative(f, n)
        d = get_derivative(f, n + 1)
        handled_derivatives.add((f, n))
        needed_derivatives.add((f, n + 1))
        transformations[s] = s + d*dt

    states = set()
    for t in transformations:
        states |= t.free_symbols
    states -= set(sys.inputs)
    states -= set(sys.outputs)
    states -= set([sys.time, dt])
    return Integrator(transformations, sys.time, dt, sys.inputs, sys.outputs, states)

def convert_to_msdsl(mapping, expr: sym.Expr):
    expr = expr.simplify()
    c = lambda x: convert_to_msdsl(mapping, x)
    if expr in mapping:
        return mapping[expr]
    if isinstance(expr, sym.Number):
        return float(expr.evalf())
    if isinstance(expr, sym.Mul):
        x = 1
        for arg in expr.args:
            x *= c(arg)
        return x
    if isinstance(expr, sym.Add):
        x = 0
        for arg in expr.args:
            x += c(arg)
        return x
    if isinstance(expr, sym.Pow):
        assert(len(expr.args) == 2)
        b = c(expr.args[0])
        e = c(expr.args[1])
        if type(e) == float and abs(e - int(e)) < 1e-12:
            e = int(e)
        assert(type(e) == int)
        x = 1
        for i in range(0, e):
            x *= b
        return x
    raise NotImplementedError(expr, type(expr))

def print_verilog(name: str, i: Integrator):
    mapping = {}
    model = M.MixedSignalModel(name)
    mapping[i.dt] = 1e-9
    clk = model.add_digital_input('__internal_clk')
    rst = model.add_digital_input('__internal_rst')
    convert = lambda x: convert_to_msdsl(mapping, x)
    for s in i.states:
        mapping[s] = model.add_analog_state(s.name, range_=5)
    for s in i.inputs:
        mapping[s] = model.add_analog_input(s.name)
    for s in i.outputs:
        mapping[s] = model.add_analog_output(s.name)
    for target, source in i.transformations.items():
        model.set_next_cycle(convert(target), convert(source), clk=clk, rst=rst)
    model.compile_and_print(M.VerilogGenerator())

print_verilog("vco", integrate(sys))
