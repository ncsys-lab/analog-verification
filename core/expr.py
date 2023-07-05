from dataclasses import dataclass, field
from abc import ABC
from typing import List, Dict, Set, Optional, ClassVar
import itertools
from math import log, isinf, isnan, ceil
import sympy as sym
import copy
import msdsl as M
from itertools import count

@dataclass(frozen=True)
class VarType:
    type_name : str 

    def isType(self,other):
        return self.type_name == other.type_name


    def from_value(self,v):
        raise Exception("from_value: override me <%s>" % self)

@dataclass(frozen=True)
class RealType(VarType):
    lower : float
    upper : float
    prec : float
    type_name : ClassVar[str]= "real"

    @property
    def interval(self):
        return [self.lower,self.upper]

    def from_value(self,v):
        return min(max(self.lower,v),self.upper)

@dataclass(frozen=True)
class TimeType(VarType):
    type_name : ClassVar[str] = "time"
 

@dataclass
class Expression:
    ident : int = field(default_factory=count().__next__,init=False)

    def children(self):
        return []

    def get_by_id(self,idx):
        matches = list(filter(lambda n : n.ident == idx, self.nodes()))
        assert(len(matches) == 1)
        return matches[0]

    def nodes(self):
        for ch in self.children():
            for n in ch.nodes():
                yield n
        yield self


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


@dataclass
class Var(Expression):
    name: str
    type: VarType
    op_name : ClassVar[str]= "var"

    @property
    def isReal(self):
        return isinstance(self.type, RealType) 

    @property
    def sympy(self) -> sym.Expr:
        return sym.Symbol(self.name, real=True)

    @property
    def variables(self) -> "Set[Real]":
        return set([self])

    def execute(self,args):
        value = args[self.name]
        return self.type.from_value(value)

@dataclass
class Constant(Expression):
    value: float
    op_name : ClassVar[str]= "const"

    @property
    def sympy(self) -> sym.Expr:
        return sym.RealNumber(self.value)

    @property
    def variables(self) -> "Set[Real]":
        return set()

    def execute(self,args):
        return self.value

@dataclass
class Sum(Expression):
    lhs: Expression
    rhs: Expression
    op_name : ClassVar[str]= "sum"

    def children(self):
        return [self.lhs, self.rhs]

    @property
    def sympy(self) -> sym.Expr:
        return self.lhs.sympy + self.rhs.sympy

    @property
    def variables(self) -> "Set[Real]":
        return self.lhs.variables | self.rhs.variables

@dataclass
class Difference(Expression):
    lhs: Expression
    rhs: Expression
    op_name : ClassVar[str]= "diff"


    def children(self):
        return [self.lhs, self.rhs]



    @property
    def sympy(self) -> sym.Expr:
        return self.lhs.sympy - self.rhs.sympy

    @property
    def variables(self) -> "Set[Real]":
        return self.lhs.variables | self.rhs.variables

@dataclass
class Product(Expression):
    lhs: Expression
    rhs: Expression
    op_name : ClassVar[str]= "mul"

    def children(self):
        return [self.lhs, self.rhs]

    @property
    def sympy(self) -> sym.Expr:
        return self.lhs.sympy * self.rhs.sympy

    @property
    def variables(self) -> "Set[Real]":
        return self.lhs.variables | self.rhs.variables

    def execute(self,args):
        return self.lhs.execute(args)*self.rhs.execute(args)

@dataclass
class Negation(Expression):
    expr: Expression
    op_name : ClassVar[str]= "neg"

    def children(self):
        return [self.expr]

    @property
    def sympy(self) -> sym.Expr:
        return -self.expr.sympy

    @property
    def variables(self) -> "Set[Real]":
        return self.expr.variables

    def execute(self,args):
        return -1*(self.expr.execute(args))

@dataclass
class Quotient(Expression):
    lhs: Expression
    rhs: Expression
    op_name : ClassVar[str]= "div"

    def children(self):
        return [self.lhs, self.rhs]

    @property
    def sympy(self) -> sym.Expr:
        return self.lhs.sympy / self.rhs.sympy

    @property
    def variables(self) -> "Set[Real]":
        return self.lhs.variables | self.rhs.variables

@dataclass
class VarAssign(Expression):
    lhs : Var
    rhs : Expression
    op_name : ClassVar[str]= "asgn"

    def children(self):
        return [self.lhs, self.rhs]

    @property
    def variables(self) -> "Set[Real]":
        return self.lhs.variables | self.rhs.variables

    @property
    def sympy(self) -> sym.Expr:
        raise Exception("cannot turn first order derivative into sympy expression")


@dataclass
class Integrate(Expression):
    ddt_var : Var
    rhs_var : Var
    timestep : float
    op_name : ClassVar[str]= "integ"

    def __post_init__(self):
        self.lhs = self.ddt_var
        self.rhs = Product(Constant(self.timestep),self.rhs_var)


    def children(self):
        return [self.lhs, self.rhs]




@dataclass
class Accumulate(Expression):
    lhs: Expression
    rhs: Expression