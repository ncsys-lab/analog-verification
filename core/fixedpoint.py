import core.intervals as intervallib
from dataclasses import dataclass, field
import core.expr as exprlib
import core.block as blocklib
from core.fpexpr import *
import sympy
import math
# todo, solve intervals and precisions on intervals.

class FixedPointTypeRegistry:

    def __init__(self):
        self.types = {}

    def set_type(self,id,fpr):
        assert(not fpr is None)
        self.types[id] = fpr

    def get_type(self,x):
        if not x in self.types:
            print("no information: req=%s in-rep=%s" % (x, self.types.keys()))
        return self.types[x]

def fixed_point_reprs(ival_reg):
    def get_fpr(info): 
        fpr = FixedPointType.from_interval_precision(info.lower, info.upper, info.precision)
        return fpr 


    reg = FixedPointTypeRegistry()
    for name in ival_reg.variables():
        fpr = get_fpr(ival_reg.get_info(name))
        reg.set_type(name, fpr)


    for ident in ival_reg.expr_ids():
        fpr = get_fpr(ival_reg.get_info(ident))
        reg.set_type(ident,fpr)
    
    return reg

def type_relax(t1,t2):
    if t1.match(t2):
        return t1

    sign = t1.signed or t2.signed

    if t1.scale == t2.scale:
        int_bits = max(t1.int_bits,t2.int_bits)
        return FixedPointType(int_bits=int_bits, signed=sign, scale_bits=t1.scale_bits)
    elif t1.int_bits < t2.int_bits:
        new_int_bits = abs(t2.scale - t1.scale) + t1.int_bits
        t1new = FixedPointType(int_bits=new_int_bits, scale_bits=t2.scale_bits, signed=t1.signed)
        return type_relax(t1new,t2)
    else:
        new_int_bits = abs(t1.scale - t2.scale) + t2.int_bits
        t2new = FixedPointType(int_bits=new_int_bits, scale_bits=t1.scale_bits, signed=t2.signed)
        return type_relax(t1new,t2)

# make 
def type_match(e,t):
    if e.fp_type().match(t):
        return e

    if e.fp_type().signed and not t.signed:
        return type_match(FPToUnsigned(expr=e),t)

    if not e.fp_type().signed and t.signed:
        return type_match(FPToSigned(expr=e),t)

    if e.fp_type().int_bits < t.int_bits:
        # pad from right, 
        npad = t.int_bits - e.fp_type().int_bits
        newe = FPPadRight(expr=e, nbits=npad)
        return type_match(newe,t)

    if e.fp_type().int_bits > t.int_bits:
        # shift left k, scaling up by 2^k. truncate from right
        ntrunc = e.fp_type().int_bits-t.int_bits
        newe = FPTruncRight(expr=e, nbits=ntrunc)
        return type_match(newe,t)

    if e.fp_type().scale_bits != t.scale_bits:
        scale_adjust = t.scale_bits-e.fp_type().scale_bits
        newe = FPScale(e,nbits=scale_adjust)
        return type_match(newe, t)


    raise Exception("unhandled type nudge: expr=%s targ_type=%s" % (e,t))

    
def fixed_point_expr(reg,expr):
    def rec(e):
        new_e = fixed_point_expr(reg,e)
        return new_e

    if isinstance(expr, exprlib.Product):
        lhse =  rec(expr.lhs)
        rhse = rec(expr.rhs)
        expr_type = reg.get_type(expr.ident)
        targ_type = type_relax(lhse.fp_type(), rhse.fp_type())

        lhse_tm = type_match(lhse,targ_type)
        rhse_tm = type_match(rhse,targ_type)
        prod = FPBox(expr=exprlib.Product(lhse_tm, rhse_tm), type=targ_type)
        prod_typematch = type_match(prod, expr_type)
        return prod_typematch

    elif isinstance(expr, exprlib.Constant):
        tol = 1e-3
        scale = math.ceil(math.log2(expr.value))
        scaled_val = abs(expr.value/(2**scale))
        signed = expr.value <= 0
        nint_bits = 1
        while scaled_val > tol:
            scaled_val -= 2**(-nint_bits)
            nint_bits += 1

        constfp = FPBox(expr=expr, type=FixedPointType(int_bits=nint_bits,signed=signed,scale_bits=scale))
        return constfp 

    elif isinstance(expr, exprlib.Negation):
        new_expr = rec(expr.expr)
        return FPToSigned(new_expr) if new_expr.fp_type().signed else new_expr 
        

    elif isinstance(expr, exprlib.Var):
        return FPBox(expr=expr,type=reg.get_type(expr.name))

    elif isinstance(expr, exprlib.VarAssign):
        lhse =  rec(expr.lhs)
        rhse = rec(expr.rhs)
        rhse_tm = type_match(rhse,lhse.fp_type())
        return exprlib.VarAssign(lhse, rhse_tm)

    elif isinstance(expr, exprlib.Integrate):
        lhse =  rec(expr.lhs)
        rhse = rec(expr.rhs)
        rhse_tm = type_match(rhse,lhse.fp_type())
        return exprlib.Accumulate(lhse, rhse_tm)

    else:
        print(expr)
        raise NotImplementedError

def fixed_point_var(reg,var):
    if var.type.isType(exprlib.RealType):
        typ = reg.get_type(var.name)
        return typ
    else:
        return var_t

def fixed_point_block(reg,block):
    fp_block = blocklib.AMSBlock(block.name + "_fp")
    for v in block.vars():
        typ = fixed_point_var(reg,v)
        fp_block.decl_var(name=v.name, type=typ, kind=v.kind)
  
    for rel in block.relations():
        if isinstance(rel,exprlib.VarAssign):
            eq_expr = fixed_point_expr(reg,rel)
            fp_block.decl_relation(eq_expr)
        elif isinstance(rel, exprlib.Integrate):
            int_expr = fixed_point_expr(reg,rel)
            fp_block.decl_relation(int_expr)

        else:
            raise NotImplementedError
    return fp_block

def to_fixed_point(block, rel_prec=0.001):
    ival_reg = intervallib.compute_intervals_for_block(block,rel_prec=rel_prec)
    fp_reg = fixed_point_reprs(ival_reg)
    fp_blk = fixed_point_block(fp_reg, block)
    return fp_blk