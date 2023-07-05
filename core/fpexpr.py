
from core.expr import Expression,VarType
from typing import ClassVar
from dataclasses import dataclass, field
import math


@dataclass(frozen=True)
class FixedPointType(VarType):
    int_bits : int
    scale_bits : int
    signed:  bool
    type_name : ClassVar[str] = "fixed_point"

    @classmethod
    def from_interval_precision(self,lower,upper,precision):
        is_signed = lower < 0.0
        nvals = (upper - lower)/precision
        int_bits = math.ceil(math.log2(nvals))
        scale_bits = math.floor(math.log2(precision))
        return FixedPointType(int_bits=int_bits,scale_bits=scale_bits, signed=is_signed)

    @property
    def scale(self):
        return 2**(self.scale_bits)

    @property
    def nbits(self):
        return self.int_bits + (1 if self.signed else 0)

    def match(self,fpe):
        return fpe.int_bits == self.int_bits and \
            fpe.scale_bits == self.scale_bits and \
            fpe.signed == self.signed

@dataclass
class FPExpression(Expression):

    def fp_type(self):
        raise NotImplementedError

@dataclass
class FPOp(FPExpression):
    expr : FPExpression

    def children(self):
        return [self.expr]



@dataclass
class FPBox(FPOp):
    type : FixedPointType

    def fp_type(self):
        return self.type

    def execute(self,args):
        value = self.expr.execute(args)
        typ = self.fp_type()
        fixpt_value = typ.from_value(value)

@dataclass
class FPScale(FPOp):
    nbits : int

    def scale(self):
        return 2**self.nbits

    def fp_type(self):
        fpt = self.expr.fp_type()
        return FixedPointType(int_bits=fpt.int_bits, scale_bits=fpt.scale_bits+self.nbits, signed=fpt.signed)
 
@dataclass
class FPPadRight(FPOp):
    nbits : int

    def scale(self):
        return 2**(nbits)


    def fp_type(self):
        fpt = self.expr.fp_type()
        return FixedPointType(int_bits=fpt.int_bits+self.nbits, scale_bits=fpt.scale_bits+self.nbits, signed=fpt.signed)
 
@dataclass
class FPTruncRight(FPOp):
    nbits : int

    def scale(self):
        return 2**(-nbits)


    def fp_type(self):
        fpt = self.expr.fp_type()
        return FixedPointType(int_bits=fpt.int_bits-self.nbits, scale_bits=fpt.scale_bits-self.nbits, signed=fpt.signed)

    def execute(self,args):
        value = self.expr.execute(args)
        print(value)
        raise NotImplementedError

@dataclass
class FPToSigned(FPOp):
    expr : Expression

    def fp_type(self):
        fpt = self.expr.fp_type()
        return FixedPointType(int_bits=fpt.int_bits, scale_bits=fpt.scale_bits, signed=True)



@dataclass
class FPToUnsigned(FPOp):
    expr : Expression


    def fp_type(self):
        fpt = self.expr.fp_type()
        return FixedPointType(int_bits=fpt.int_bits, scale_bits=fpt.scale_bits, signed=False)


