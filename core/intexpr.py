
from core.expr import Expression,VarType
from typing import ClassVar
from dataclasses import dataclass, field
import math

@dataclass(frozen=True)
class IntType(VarType):
    nbits: int
    scale: float
    signed: bool
    type_name : ClassVar[str] = "int"

    @property
    def lower(self):
        if not self.signed:
            return 0
        else:
            return -2**(self.nbits-1)
            
    @property
    def upper(self):
        if not self.signed:
            return 2**self.nbits-1
        else:
            return 2**(self.nbits-1) - 1

    @classmethod
    def from_fixed_point_type(self,fpt):
        return IntType(nbits=fpt.nbits, signed=fpt.signed, scale=fpt.scale)

    @classmethod
    def nbits_int(self,v):
        return len(bin(v))-2


    def matches(self,other):
        assert(isinstance(other, IntType))
        return other.nbits == self.nbits \
                and other.scale == self.scale \
                and other.signed == self.signed

    def from_real(self,v):
        unsc = round(v/self.scale)
        v_tc = min(self.upper,max(self.lower,unsc))
        if(abs(self.to_real(v_tc) - v) > self.scale):
            print("[WARN] from_real %f => %f" % (v, self.to_real(v_tc)))
        return v_tc

    def to_real(self,v):
        v_tc = self.typecast_value(v)
        return v*self.scale

    def typecast_value(self,v):
        # always take the top K bits
        int_bits = IntType.nbits_int(v)
        v_tc = min(self.upper,max(self.lower,v))
        if(abs(v_tc - v) > 2**(-self.nbits)):
            raise Exception("typecast %f => %f" % (v, self.to_real(v_tc)))

        return v_tc

    def typecheck_value(self,v):
        assert(isinstance(v,int))
        assert(v <= self.upper)
        assert(v >= self.lower)



@dataclass
class IntOp(Expression):
    expr : Expression

    def children(self):
        return [self.expr]

    def execute(self,args):
        self.expr.execute(args)
        raise Exception("not implemented: %s" % (self))



class ToSInt(IntOp):
    op_name: ClassVar[str] = "toSInt"

    @property
    def type(self):
        typ = self.expr.type
        return IntType(nbits=typ.nbits, scale=typ.scale, signed=True)

    def pretty_print(self):
        return "sint(%s)" % (self.expr.pretty_print())

    def execute(self,args):
        val = self.expr.execute(args)
        val_tc = self.type.typecast_value(val)
        self.type.typecheck_value(val_tc)
        return val_tc
    
@dataclass
class ToUSInt(IntOp):
    op_name: ClassVar[str] = "toUsInt"

    @property
    def type(self):
        typ = self.expr.type
        return IntType(nbits=typ.nbits, scale=typ.scale, signed=False)


    def pretty_print(self):
        return "toUsInt(%s)" % (self.expr.pretty_print())

    def execute(self,args):
        val = self.expr.execute(args)
        val_tc = self.type.typecast_value(val)
        self.type.typecheck_value(val_tc)
        return val_tc



@dataclass
class TruncR(IntOp):
    nbits : int
    op_name : ClassVar[str]= "truncR"

    @property
    def type(self):
        typ = self.expr.type
        new_scale = typ.scale*(2**(self.nbits))
        assert(self.nbits > 0)
        return IntType(nbits=typ.nbits - self.nbits, scale=new_scale, signed=typ.signed)

    def pretty_print(self):
        return "truncr(%s,%s)" % (self.expr.pretty_print(), self.nbits)

    def execute(self,args):
        val = self.expr.execute(args)>>self.nbits
        val_tc = self.type.typecast_value(val)
        self.type.typecheck_value(val_tc)
        return val_tc




@dataclass
class PadR(IntOp):
    nbits : int
    value : int
    op_name : ClassVar[str]= "padr"

    @property
    def type(self):
        typ = self.expr.type
        new_scale = typ.scale*(2**(-self.nbits))
        return IntType(nbits=typ.nbits + self.nbits, scale=new_scale, signed=typ.signed)

    def pretty_print(self):
        return "padr(%s,%s,%d)" % (self.expr.pretty_print(), self.nbits, self.value)

    def execute(self,args):
        val = self.expr.execute(args) << self.nbits
        val_tc = self.type.typecast_value(val)
        self.type.typecheck_value(val_tc)
        return val_tc



@dataclass
class PadL(IntOp):
    nbits : int
    value : int
    op_name : ClassVar[str]= "padl"

    @property
    def type(self):
        typ = self.expr.type
        return IntType(nbits=typ.nbits + self.nbits, scale=typ.scale, signed=typ.signed)

    def execute(self,args):
        val = self.expr.execute(args)
        val_tc = self.type.typecast_value(val)
        self.type.typecheck_value(val_tc)
        return val_tc


    def pretty_print(self):
        return "padl(%s,%s,%d)" % (self.expr.pretty_print(), self.nbits, self.value)

@dataclass
class TruncVal(IntOp): #Will
    nbits : int 
    value : int
    op_name : ClassVar[str]= 'truncval'

    @property
    def type(self):
        typ = self.expr.type
        return IntType(nbits = typ.nbits - self.nbits, scale=typ.scale, signed = typ.signed)

    def execute(self,args):
        val = self.expr.execute(args)>>self.nbits
        val_tc = self.type.typecast_value(val)
        self.type.typecheck_value(val_tc)
        return val_tc

    def pretty_print(self):
        return 'truncval(%s,%s,%da)' % (self.expr.pretty_print(), self.nbits, self.value)
