from dataclasses import dataclass
from abc import ABC
from typing import List, Dict
import itertools
from math import log, isinf
import sympy as sym

@dataclass
class Bounds:
    minimum: float
    maximum: float
    precision: float

    def __post_init__(self):
        assert(self.minimum <= self.maximum)
        assert(self.precision >= 0)

    @property
    def range_size(self):
        return 2*max(abs(self.minimum), abs(self.maximum))

    @property
    def bits(self) -> float:
        values = self.range_size / self.precision
        if values == 0:
            return float('inf')
        return log(values, 2)

    @property
    def integer_bits(self) -> float:
        return log(self.range_size, 2)

    @property
    def fraction_bits(self) -> float:
        return self.bits - self.integer_bits

    def __add__(self, other: "Bounds") -> "Bounds":
        x1, x2 = self.minimum, self.maximum
        y1, y2 = other.minimum, other.maximum
        new_fraction_bits = min(self.fraction_bits, other.fraction_bits)
        return Bounds(x1 + y1, x2 + y2, 2**(-new_fraction_bits))

    def __mul__(self, other: "Bounds") -> "Bounds":
        x1, x2 = self.minimum, self.maximum
        y1, y2 = other.minimum, other.maximum
        options = itertools.product([x1, x2], [y1, y2])
        results = [x * y for x, y in options]
        upper = max(results)
        lower = min(results)
        size = 2*max(abs(upper), abs(lower))
        bits = min(self.bits, other.bits)
        precision = size/2**bits
        return Bounds(min(results), max(results), precision)

    def __neg__(self) -> "Bounds":
        return Bounds(-self.maximum, -self.minimum, self.precision)

    def reciprocal(self) -> "Bounds":
        y1, y2 = self.minimum, self.maximum
        upper, lower = 0, 0
        if y1 > 0 or y2 < 0:
            lower, upper = 1/y2, 1/y1
        elif y2 == 0:
            lower, upper = -float('inf'), 1/y1
        elif y1 == 0:
            lower, upper = 1/y2, float('inf')
        else:
            lower, upper = -float('inf'), float('inf')
        size = 2*max(abs(upper), abs(lower))
        if isinf(self.precision):
            precision = self.precision
        else:
            precision = size/2**self.bits
        return Bounds(lower, upper, precision)



class Expression:
    def __add__(self, other: "Expression | float | int") -> "Sum":
        if isinstance(other, int):
            other = Constant(float(other))
        if isinstance(other, float):
            other = Constant(other)
        return Sum(self, other)

    def __sub__(self, other: "Expression | float | int") -> "Sum":
        if isinstance(other, int):
            other = Constant(float(other))
        if isinstance(other, float):
            other = Constant(other)
        return Sum(self, Negation(other))

    def __mul__(self, other: "Expression | float | int") -> "Product":
        if isinstance(other, int):
            other = Constant(float(other))
        if isinstance(other, float):
            other = Constant(other)
        return Product(self, other)

    def __truediv__(self, other: "Expression | float | int") -> "Product":
        if isinstance(other, int):
            other = Constant(float(other))
        if isinstance(other, float):
            other = Constant(other)
        return Product(self, Reciprocal(other))

    def __pow__(self, other: "Expression | float | int") -> "Exponential":
        if isinstance(other, int):
            other = Constant(float(other))
        if isinstance(other, float):
            other = Constant(other)
        return Exponential(self, other)

    def __neg__(self) -> "Negation":
        return Negation(self)

    def diff(self) -> "Derivative":
        return Derivative(self)

    @property
    def bounds(self) -> Bounds:
        raise NotImplementedError

    @property
    def sympy(self) -> sym.Expr:
        raise NotImplementedError

@dataclass
class Time(Expression):
    pass

@dataclass
class Real(Expression):
    name: str
    real_bounds: Bounds

    @property
    def bounds(self) -> Bounds:
        return self.real_bounds

    @property
    def sympy(self) -> sym.Expr:
        return sym.Symbol(self.name, real=True)

@dataclass
class Constant(Expression):
    value: float

    @property
    def bounds(self) -> Bounds:
        return Bounds(self.value, self.value, float('inf'))

    @property
    def sympy(self) -> sym.Expr:
        return sym.RealNumber(self.value)

@dataclass
class Sum(Expression):
    lhs: Expression
    rhs: Expression

    @property
    def bounds(self) -> Bounds:
        return self.lhs.bounds + self.rhs.bounds

    @property
    def sympy(self) -> sym.Expr:
        return self.lhs.sympy + self.rhs.sympy

@dataclass
class Product(Expression):
    lhs: Expression
    rhs: Expression

    @property
    def bounds(self) -> Bounds:
        return self.lhs.bounds * self.rhs.bounds

    @property
    def sympy(self) -> sym.Expr:
        return self.lhs.sympy * self.rhs.sympy

@dataclass
class Exponential(Expression):
    lhs: Expression
    rhs: Expression

    @property
    def bounds(self) -> Bounds:
        if not isinstance(self.rhs, Constant):
            raise NotImplementedError
        rhs = self.rhs.value
        if rhs < 0:
            raise NotImplementedError
        b = self.lhs.bounds
        return Bounds(b.minimum**rhs, b.maximum**rhs, b.precision)

    @property
    def sympy(self) -> sym.Expr:
        return self.lhs.sympy ** self.rhs.sympy

@dataclass
class Negation(Expression):
    expr: Expression

    @property
    def bounds(self) -> Bounds:
        return -self.expr.bounds

    @property
    def sympy(self) -> sym.Expr:
        return -self.expr.sympy

@dataclass
class Reciprocal(Expression):
    expr: Expression

    @property
    def bounds(self) -> Bounds:
        return self.expr.bounds.reciprocal()

    @property
    def sympy(self) -> sym.Expr:
        return -self.expr.sympy

@dataclass
class Derivative(Expression):
    expr: Expression

    @property
    def sympy(self) -> sym.Expr:
        return self.expr.sympy.diff(Time().sympy)

    @property
    def depth(self) -> int:
        if isinstance(self.expr, Derivative):
            return self.expr.depth + 1
        else:
            return 1

    @property
    def target(self) -> Expression:
        if isinstance(self.expr, Derivative):
            return self.expr.target
        else:
            return self.expr

    def nth_child(self, n: int) -> Expression:
        if n == 0:
            return self
        elif n == 1:
            return self.expr
        else:
            return self.expr.nth_child(n - 1)


@dataclass
class Integrator:
    symbols: List[Real]
    transitions: Dict[Real, Expression]

@dataclass
class Equality:
    lhs: Expression
    rhs: Expression

    def _name_of_deriv(symbol: Real, depth: int) -> str:
        x = "" if depth == 1 else str(depth)
        return f"_d{x}{symbol.name}_dt{x}"

    def _name(diff: Derivative) -> Real:
        assert(isinstance(diff.target, Real))
        return Equality._name_of_deriv(diff.target, diff.depth)

    def integrate(self, inputs: List[Real], outputs: List[Real], frequency: int) -> Integrator:
        transitions = {}

        dt = Constant(1.0/frequency)

        assert(isinstance(self.lhs, Derivative))

        name = Equality._name(self.lhs)
        real = Real(name, self.rhs.bounds)
        transitions[name] = self.rhs

        # for output in outputs:
        #     current = output
        #     bounds = output.bounds
        #     while True:
        #         if isinstance(current, Real):
        #             name = current.name
        #         elif isinstance(current, Derivative):
        #             name = Equality._name(current)
        #         if name in transitions:
        #             break
        #         print(name, bounds)
        #         next = current.diff()
        #         current = next

        for i in range(0, self.lhs.depth):
            print(i + 1)
            current = self.lhs.nth_child(i + 1)
            if isinstance(current, Derivative):
                prior_name = Equality._name(current.diff())
                prior = transitions[prior_name]
                prior_bounds = transitions[prior_name].bounds
                fd = prior * dt
                new_bounds = fd.bounds

                name = Equality._name(current)
                real = Real(name, new_bounds)
                print(real)

                # rhs = current + dt*current.diff()
                # print(rhs.bounds)


w = Real('w', Bounds(0, 1.0, 1e-8))
x = Real('x', Bounds(-1.0, 1.0, 1e-8))
v = x.diff()
v_ = v.diff()
eq = Equality(v_, -(w**2)*x)
eq.integrate([w], [x], 1e6)
print((x - x).bounds)
