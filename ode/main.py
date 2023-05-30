from dataclasses import dataclass, field
from abc import ABC
from typing import List, Dict, Set, Optional
import itertools
from math import log, isinf, isnan
import sympy as sym
import copy
import msdsl as M


class Expression:
    def __add__(self, other: "Expression | float | int") -> "Sum":
        if isinstance(other, int):
            other = Constant(float(other))
        if isinstance(other, float):
            other = Constant(other)
        return Sum(self, other)

    def __sub__(self, other: "Expression | float | int") -> "Difference":
        if isinstance(other, int):
            other = Constant(float(other))
        if isinstance(other, float):
            other = Constant(other)
        return Difference(self, other)

    def __mul__(self, other: "Expression | float | int") -> "Product":
        if isinstance(other, int):
            other = Constant(float(other))
        if isinstance(other, float):
            other = Constant(other)
        return Product(self, other)

    def __truediv__(self, other: "Expression | float | int") -> "Quotient":
        if isinstance(other, int):
            other = Constant(float(other))
        if isinstance(other, float):
            other = Constant(other)
        return Quotient(self, other)

    def __neg__(self) -> "Negation":
        return Negation(self)

    def diff(self) -> "Derivative":
        return Derivative(self)

    @property
    def sympy(self) -> sym.Expr:
        raise NotImplementedError

    def solve_intervals(self, intervals: "Dict[Real, IntervalSet]") -> "IntervalSet":
        raise NotImplementedError

    @property
    def variables(self) -> "Set[Real]":
        raise NotImplementedError

    def msdsl(self, mapping: "Dict[Real, M.AnalogSignal]"):
        raise NotImplementedError


@dataclass(frozen=True)
class Time(Expression):
    pass


@dataclass(frozen=True)
class Real(Expression):
    name: str

    @property
    def sympy(self) -> sym.Expr:
        return sym.Symbol(self.name, real=True)

    def solve_intervals(self, intervals: "Dict[Real, IntervalSet]") -> "IntervalSet":
        return intervals.get(self, IntervalSet([Interval()]))

    @property
    def variables(self) -> "Set[Real]":
        return set([self])

    def msdsl(self, mapping: "Dict[Real, M.AnalogSignal]"):
        return mapping[self]


@dataclass(frozen=True)
class Constant(Expression):
    value: float

    @property
    def sympy(self) -> sym.Expr:
        return sym.RealNumber(self.value)

    def solve_intervals(self, intervals: "Dict[Real, IntervalSet]") -> "IntervalSet":
        return IntervalSet([Interval(self.value, self.value)])

    @property
    def variables(self) -> "Set[Real]":
        return set()

    def msdsl(self, mapping: "Dict[Real, M.AnalogSignal]"):
        return self.value


@dataclass(frozen=True)
class Sum(Expression):
    lhs: Expression
    rhs: Expression

    @property
    def sympy(self) -> sym.Expr:
        return self.lhs.sympy + self.rhs.sympy

    def solve_intervals(self, intervals: "Dict[Real, IntervalSet]") -> "IntervalSet":
        return self.lhs.solve_intervals(intervals) + self.rhs.solve_intervals(intervals)

    @property
    def variables(self) -> "Set[Real]":
        return self.lhs.variables | self.rhs.variables

    def msdsl(self, mapping: "Dict[Real, M.AnalogSignal]"):
        return self.lhs.msdsl(mapping) + self.rhs.msdsl(mapping)


@dataclass(frozen=True)
class Difference(Expression):
    lhs: Expression
    rhs: Expression

    @property
    def sympy(self) -> sym.Expr:
        return self.lhs.sympy - self.rhs.sympy

    def solve_intervals(self, intervals: "Dict[Real, IntervalSet]") -> "IntervalSet":
        raise NotImplementedError
        return self.lhs.solve_intervals(intervals) - self.rhs.solve_intervals(intervals)

    @property
    def variables(self) -> "Set[Real]":
        return self.lhs.variables | self.rhs.variables

    def msdsl(self, mapping: "Dict[Real, M.AnalogSignal]"):
        return self.lhs.msdsl(mapping) - self.rhs.msdsl(mapping)


@dataclass(frozen=True)
class Product(Expression):
    lhs: Expression
    rhs: Expression

    @property
    def sympy(self) -> sym.Expr:
        return self.lhs.sympy * self.rhs.sympy

    def solve_intervals(self, intervals: "Dict[Real, IntervalSet]") -> "IntervalSet":
        return self.lhs.solve_intervals(intervals) * self.rhs.solve_intervals(intervals)

    @property
    def variables(self) -> "Set[Real]":
        return self.lhs.variables | self.rhs.variables

    def msdsl(self, mapping: "Dict[Real, M.AnalogSignal]"):
        return self.lhs.msdsl(mapping) * self.rhs.msdsl(mapping)


@dataclass(frozen=True)
class Negation(Expression):
    expr: Expression

    @property
    def sympy(self) -> sym.Expr:
        return -self.expr.sympy

    def solve_intervals(self, intervals: "Dict[Real, IntervalSet]") -> "IntervalSet":
        return -self.expr.solve_intervals(intervals)

    @property
    def variables(self) -> "Set[Real]":
        return self.expr.variables

    def msdsl(self, mapping: "Dict[Real, M.AnalogSignal]"):
        return -self.expr.msdsl(mapping)


@dataclass(frozen=True)
class Quotient(Expression):
    lhs: Expression
    rhs: Expression

    @property
    def sympy(self) -> sym.Expr:
        return self.lhs.sympy / self.rhs.sympy

    def solve_intervals(self, intervals: "Dict[Real, IntervalSet]") -> "IntervalSet":
        raise NotImplementedError
        return self.lhs.solve_intervals(intervals) / self.rhs.solve_intervals(intervals)

    @property
    def variables(self) -> "Set[Real]":
        return self.lhs.variables | self.rhs.variables

    def msdsl(self, mapping: "Dict[Real, M.AnalogSignal]"):
        return self.lhs.msdsl(mapping) / self.rhs.msdsl(mapping)


@dataclass(frozen=True)
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
            assert isinstance(self.expr, Derivative)
            return self.expr.nth_child(n - 1)

    @property
    def name(self) -> str:
        assert isinstance(self.target, Real)
        x = "" if self.depth == 1 else str(self.depth)
        return f"_d{x}{self.target.name}_dt{x}"

    @property
    def real(self) -> Real:
        return Real(self.name)

    @property
    def variables(self) -> "Set[Real]":
        return self.expr.variables


@dataclass(frozen=True, order=True)
class Interval:
    lower: float = float("-inf")
    upper: float = float("inf")

    def __post_init__(self):
        assert self.lower <= self.upper or isnan(self.lower) or isnan(self.upper)

    def __add__(self, other: "Interval") -> "Interval":
        return Interval(self.lower + other.lower, self.upper + other.upper)

    def __mul__(self, other: "Interval") -> "Interval":
        x1, x2 = self.lower, self.upper
        y1, y2 = other.lower, other.upper
        pairs = itertools.product([x1, x2], [y1, y2])
        products = [x * y for x, y in pairs]
        return Interval(min(products), max(products))

    def __and__(self, other: "Interval") -> "Optional[Interval]":
        x1, x2 = self.lower, self.upper
        y1, y2 = other.lower, other.upper
        if x1 > y1:
            return other & self
        if x2 >= y1:
            return Interval(y1, min(x2, y2))
        return None

    @property
    def isinf(self) -> bool:
        return isinf(self.upper) or isinf(self.lower)

    @property
    def bounds(self) -> float:
        return max(abs(self.lower), abs(self.upper))

    def approx(self, other: "Interval") -> bool:
        return max(abs(self.lower - other.lower), abs(self.upper - other.upper)) < 1e-12


@dataclass
class IntervalSet:
    intervals: List[Interval] = field(default_factory=list)

    def __post_init__(self):
        self.simplify()

    def add(self, interval: Interval):
        self.intervals += [interval]
        self.intervals.sort()
        self.simplify()

    def simplify(self):
        if len(self.intervals) < 2:
            return
        i = 0
        while i < len(self.intervals):
            current = self.intervals[i]
            if i + 1 < len(self.intervals):
                next = self.intervals[i + 1]
                if current.lower == next.lower:
                    self.intervals[i] = Interval(
                        current.lower, max(current.upper, next.upper)
                    )
                    self.intervals.pop(i + 1)
                    continue
                if current.upper >= next.upper:
                    self.intervals.pop(i + 1)
                    continue
                if next.lower <= current.upper:
                    self.intervals[i] = Interval(current.lower, next.upper)
                    self.intervals.pop(i + 1)
                    continue
            i += 1

    def __or__(self, other: "IntervalSet") -> "IntervalSet":
        return IntervalSet(self.intervals + other.intervals)

    def __and__(self, other: "IntervalSet") -> "IntervalSet":
        sets = [
            a & b
            for a, b in itertools.product(self.intervals, other.intervals)
            if a & b != None
        ]
        return IntervalSet(sets) # type: ignore

    def __neg__(self) -> "IntervalSet":
        s = IntervalSet([Interval(-i.upper, -i.lower) for i in self.intervals])
        s.simplify()
        return s

    def __add__(self, other: "IntervalSet") -> "IntervalSet":
        s = IntervalSet(
            [a + b for a, b in itertools.product(self.intervals, other.intervals)]
        )
        s.simplify()
        return s

    def __mul__(self, other: "IntervalSet") -> "IntervalSet":
        s = IntervalSet(
            [a * b for a, b in itertools.product(self.intervals, other.intervals)]
        )
        s.simplify()
        return s

    @property
    def isinf(self) -> bool:
        return any([x.isinf for x in self.intervals])

    @property
    def bounds(self) -> float:
        return max([x.bounds for x in self.intervals])

    def approx(self, other: "IntervalSet") -> bool:
        return all([x.approx(y) for x, y in zip(self.intervals, other.intervals)])


@dataclass(frozen=True)
class Equality:
    lhs: Expression
    rhs: Expression

    def integrate(
        self,
        inputs: List[Real],
        outputs: List[Real],
        frequency: float,
        intervals: Dict[Real, IntervalSet] = {},
    ) -> "Integrator":
        transitions = {}

        dt = Constant(1.0 / frequency)

        assert isinstance(self.lhs, Derivative)

        transitions[Real(self.lhs.name)] = self.rhs

        for i in range(0, self.lhs.depth):
            assert isinstance(self.lhs, Derivative)
            current = self.lhs.nth_child(i + 1)

            assert isinstance(current, Real) or isinstance(current, Derivative)
            real = Real(current.name)
            prior = Real(current.diff().name)
            transitions[real] = real + prior * dt

        integrator = Integrator(transitions, intervals)
        integrator.contract_intervals()
        return integrator

@dataclass
class Integrator:
    transitions: Dict[Real, Expression]
    intervals: Dict[Real, IntervalSet]

    def contract_intervals(self):
        old_intervals = None
        new_intervals = self.intervals
        default = IntervalSet([Interval()])

        while old_intervals != new_intervals:
            if old_intervals is not None:
                if old_intervals.keys() == new_intervals.keys():
                    all_match = True
                    for key in old_intervals.keys():
                        old = old_intervals[key]
                        new = new_intervals[key]
                        if not old.approx(new):
                            all_match = False
                    if all_match:
                        break
            old_intervals = copy.copy(new_intervals)
            for symbol in self.transitions.keys():
                expr = self.transitions[symbol]
                new_intervals[symbol] = old_intervals.get(
                    symbol, default
                ) & expr.solve_intervals(old_intervals)

        self.intervals = new_intervals

    def to_msdsl(self, name, inputs, outputs):
        for symbol in self.intervals:
            if self.intervals[symbol].isinf:
                raise ValueError(f"found infinite range for {symbol}")

        model = M.MixedSignalModel(name)
        clk = model.add_digital_input('_clk')
        rst = model.add_digital_input('_rst')

        mapping = {}

        for i in inputs:
            mapping[i] = model.add_analog_input(i.name)
        for o in outputs:
            mapping[o] = model.add_analog_output(o.name)
        states = set(self.transitions.keys()) - set(inputs) - set(outputs)
        for s in states:
            mapping[s] = model.add_analog_state(s.name, range_=self.intervals[s].bounds)

        for t, expr in self.transitions.items():
            model.set_next_cycle(t.msdsl(mapping), expr.msdsl(mapping), clk=clk, rst=rst)
        model.compile_and_print(M.VerilogGenerator())



w = Real("w")
x = Real("x")
v = x.diff()
v_ = v.diff()
eq = Equality(v_, -(w*w) * x)
integrator = eq.integrate(
    [w],
    [x],
    1e6,
    {
        w: IntervalSet([Interval(0, 1)]),
        x: IntervalSet([Interval(0, 1)]),
        x.diff().real: IntervalSet([Interval(0, 1)]),
    },
)
integrator.to_msdsl("vco", [w], [x])
