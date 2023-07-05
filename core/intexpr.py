
from core.expr import Expression,VarType
from typing import ClassVar
from dataclasses import dataclass, field
import math


@dataclass(frozen=True)
class UnsignedIntType(VarType):
    nbits: int
    scale: float
    type_name : ClassVar[str] = "uint"

    def from_value(self,v):
        unsc = v/self.scale
        return round(unsc)


@dataclass(frozen=True)
class SignedIntType(UnsignedIntType):
    type_name : ClassVar[str] = "sint"

@dataclass
class IntOp(Expression):
    expr : Expression

    def children(self):
        return [self.expr]

    def execute(self,args):
        self.expr.execute(args)
        raise Exception("not implemented: %s" % (self))

@dataclass
class SHLLogic(IntOp):
    nbits : int

@dataclass
class SHLArith(IntOp):
    nbits : int

@dataclass
class SHRLogic(IntOp):
    nbits : int

@dataclass
class SHRArith(IntOp):
    nbits : int

    def execute(self,args):
        val = self.expr.execute(args)
        return math.floor(val*(2**(-self.nbits)))



@dataclass
class PadR(IntOp):
    nbits : int
    value : int

    def execute(self,args):
        val = self.expr.execute(args)
        return val*(2**self.nbits)


@dataclass
class SEPadL(IntOp):
    nbits : int
    value : int

    def execute(self,args):
        val = self.expr.execute(args)
        return val

@dataclass
class PadL(IntOp):
    nbits : int
    value : int

    def execute(self,args):
        val = self.expr.execute(args)
        return val

