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
    
    print(t1, t2)
    if t1.match(t2):
        return t1

    sign = t1.signed or t2.signed

    if t1.log_scale == t2.log_scale:
        integer = max(t1.integer,t2.integer)
        return FixedPointType.from_integer_scale(integer=integer, signed=sign, log_scale=t1.log_scale)

    elif t1.log_scale > 0 and t2.log_scale  > 0:
        print(t1,t2)
        raise NotImplementedError

    elif t1.log_scale < 0 and t2.log_scale  < 0:
        integer = max(t1.integer,t2.integer)
        log_scale = min(t1.log_scale,t2.log_scale)
        return FixedPointType.from_integer_scale(integer=integer, signed=sign, log_scale=log_scale)

    else:
        raise NotImplementedError

def sign_match(e,signed):
    if not e.type.signed and signed:
        return FPToSigned(expr=e)
    if e.type.signed and not signed:
        raise NotImplementedError


# make 
def type_match(e,t):
    
    print(e.type,t)
    if e.type.match(t):
        return e

    if not e.type.signed and t.signed:
        return type_match(FPToSigned(expr=e),t)
    
    if e.type.signed and not t.signed:
        return type_match(FPToUnsigned(expr=e),t)

    if e.type.fractional < t.fractional:
        return type_match(FPExtendFrac(expr=e,nbits=t.fractional - e.type.fractional), t)

    if e.type.fractional > t.fractional:
        nbits_trunc = e.type.fractional-t.fractional
        if e.type.fractional - nbits_trunc >= 0:
            return type_match(FPTruncFrac(expr=e, nbits=nbits_trunc), t)
        else:
            rem_trunc = nbits_trunc - e.type.fractional
            return type_match(FPTruncInt(FPTruncFrac(expr=e, nbits=e.type.fractional), nbits=rem_trunc), t)


    # risky will addition
    if e.type.integer != t.integer:
        if(e.type.integer < t.integer):
            nbits = t.integer
            return type_match(FPExtendInt(nbits = nbits, expr = e), t)
        else:
            nbits = e.type.integer - t.integer
            return type_match(FPTruncInt(nbits = nbits, expr = e), t)

    if e.type.scale != t.scale:
        raise NotImplementedError

    if e.type.fractional > t.fractional:
        raise NotImplementedError

    print('idkwyn')
    raise NotImplementedError

    
def fixed_point_expr(reg,expr):
    def rec(e):
        new_e = fixed_point_expr(reg,e)
        return new_e
    


    if isinstance(expr, exprlib.Product):
        lhse =  rec(expr.lhs)
        rhse = rec(expr.rhs)
        rhse_tm = sign_match(rhse,signed=rhse.type.signed or lhse.type.signed)
        lhse_tm = sign_match(lhse,signed=rhse.type.signed or lhse.type.signed)
        expr_type = reg.get_type(expr.ident)
        prod = exprlib.Product(lhse, rhse)
        prod.type = FixedPointType.from_integer_scale(integer=rhse.type.integer+lhse.type.integer, \
                    log_scale=rhse.type.log_scale+lhse.type.log_scale, \
                    signed=expr_type.signed)
        print('e: {}'.format(prod))
        print('t: {}'.format(expr_type))
        prod_typematch = type_match(prod, expr_type)
        return prod_typematch
    
    if isinstance(expr, exprlib.Quotient): #added by will
        lhse =  rec(expr.lhs)
        rhse = rec(expr.rhs)
        rhse_tm = sign_match(rhse,signed=rhse.type.signed or lhse.type.signed)
        lhse_tm = sign_match(lhse,signed=rhse.type.signed or lhse.type.signed)
        expr_type = reg.get_type(expr.ident)
        prod = exprlib.Quotient(lhse, rhse)
        prod.type = FixedPointType.from_integer_scale(integer=lhse.type.integer - rhse.type.integer, \
                    log_scale=lhse.type.log_scale - rhse.type.log_scale, \
                    signed=expr_type.signed)
        print('e: {}'.format(prod))
        print('t: {}'.format(expr_type))
        prod_typematch = type_match(prod, expr_type)
        return prod_typematch

    elif isinstance(expr, exprlib.Sum): #improved by will
        lhse = rec(expr.lhs)
        rhse = rec(expr.rhs)
        print(lhse)
        print(rhse)

        print("entering type_relax")
        targ_type = type_relax(lhse.type, rhse.type)
        lhse_tm = type_match(lhse,targ_type)
        rhse_tm = type_match(rhse,targ_type)
        prod = exprlib.Sum(lhse_tm, rhse_tm)
        prod.type = targ_type
        return prod
    
    elif isinstance(expr, exprlib.Difference): #improved by will
        lhse = rec(expr.lhs)
        rhse = rec(expr.rhs)
        print(lhse)
        print(rhse)

        print("entering type_relax")
        targ_type = type_relax(lhse.type, rhse.type)
        lhse_tm = type_match(lhse,targ_type)
        rhse_tm = type_match(rhse,targ_type)
        prod = exprlib.Difference(lhse_tm, rhse_tm)
        prod.type = targ_type
        return prod

    elif isinstance(expr, exprlib.Constant):
        expr.type = reg.get_type(expr.ident)
        return expr 

    elif isinstance(expr, exprlib.Negation):
        new_expr = rec(expr.expr)
        if not new_expr.type.signed:
            neg_expr = exprlib.Negation(FPToSigned(new_expr)) 
            neg_expr.expr.type = reg.get_type(expr.ident)
        else:
            neg_expr = exprlib.Negation(new_expr)
        neg_expr.type = reg.get_type(expr.ident)
        return neg_expr

    elif isinstance(expr, exprlib.Var):
        expr.type = reg.get_type(expr.name)
        return expr
    
    elif isinstance(expr, exprlib.Param):
        expr.type = reg.get_type(expr.name)
        return expr

    elif isinstance(expr, exprlib.VarAssign):
        lhse =  rec(expr.lhs)
        rhse = rec(expr.rhs)
        rhse_tm = type_match(rhse,lhse.type)
        return exprlib.VarAssign(lhse, rhse_tm)

    elif isinstance(expr, exprlib.Integrate):
        lhse =  rec(expr.lhs)
        rhse = rec(expr.rhs)
        rhse_tm = type_match(rhse,lhse.type)
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

    for p in block.params():
        typ = fixed_point_var(reg,p)
        print(typ)
        fp_block.decl_param(name=p.name, value=p.constant)
        fp_block._params[p.name].constant.type = typ
        fp_block._params[p.name].type = typ
        

    for rel in block.relations():
        print("stariting relation {}: {}".format(rel.ident, rel))
        if isinstance(rel,exprlib.VarAssign):
            eq_expr = fixed_point_expr(reg,rel)
            fp_block.decl_relation(eq_expr)
        elif isinstance(rel, exprlib.Integrate):
            int_expr = fixed_point_expr(reg,rel)
            fp_block.decl_relation(int_expr)

        else:
            raise NotImplementedError
    return fp_block

def to_fixed_point(ival_reg, block):
    fp_reg = fixed_point_reprs(ival_reg)
    fp_blk = fixed_point_block(fp_reg, block)
    return fp_blk