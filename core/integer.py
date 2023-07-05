import core.intervals as intervallib
from dataclasses import dataclass, field
import core.expr as exprlib
import core.fpexpr as fpexprlib
import core.block as blocklib
from core.intexpr import *
import sympy
import math

def get_int_var_and_type(node):
    if isinstance(node, fpexprlib.FPBox): 
        if isinstance(node.expr, exprlib.Constant):
            name = node.expr.value

        elif isinstance(node.expr, exprlib.Var):
            name = node.expr.name
        else:
            ident = node.expr.ident
            name = "%s%d" % (node.expr.op_name, ident)

        int_sc = 2**(-node.type.int_bits)
        if node.type.signed:
            typ = SignedIntType(node.type.int_bits, scale=node.type.scale*int_sc)
        else:
            typ = UnsignedIntType(node.type.int_bits, scale=node.type.scale*int_sc)

        return name,typ

    else:
        raise Exception("can only resolve boxed variables")

def constval_to_int(value,typ):
    unsc_val = value/typ.scale
    intval = round(unsc_val)
    return intval 

def fpexpr_to_intexpr(blk,expr):
    def rec(e):
        return fpexpr_to_intexpr(blk,e)

    if isinstance(expr, exprlib.Var):
        info = blk.get_var(expr.name)
        return exprlib.Var(expr.name, type=info.type)

    elif isinstance(expr, exprlib.Constant):
        print(expr)
        raise NotImplementedError
    elif isinstance(expr, fpexprlib.FPBox) and  \
        not isinstance(expr.expr, exprlib.Constant):
        name,typ = get_int_var_and_type(expr)
        return exprlib.Var(name=name, type=typ)
    elif isinstance(expr, fpexprlib.FPBox) and  \
    isinstance(expr.expr, exprlib.Constant):
        _,typ = get_int_var_and_type(expr)
        new_value = constval_to_int(expr.expr.value, typ)
        return exprlib.Constant(new_value)
   
    elif isinstance(expr, exprlib.Product):
        nlhs = rec(expr.lhs)
        nrhs = rec(expr.rhs)
        return exprlib.Product(nlhs,nrhs)
    elif isinstance(expr, fpexprlib.FPPadRight):
        newe = rec(expr.expr)
        return PadR(newe,nbits=int(expr.nbits),value=0)
    elif isinstance(expr,fpexprlib.FPToSigned):
        newe = rec(expr.expr)
        return PadL(newe,nbits=1,value=0)
    elif isinstance(expr, fpexprlib.FPScale):
        typ = expr.fp_type()
        newe = rec(expr.expr)
        if expr.nbits < 0 and typ.signed:
            return SHRArith(newe,nbits=abs(expr.nbits))
        elif expr.nbits > 0 and typ.signed:
            return SHLArith(newe,nbits=abs(expr.nbits))
        elif expr.nbits < 0 and not typ.signed:
            return SHRLogic(newe,nbits=abs(expr.nbits))
        elif expr.nbits > 0 and not typ.signed:
            return SHLLogic(newe,nbits=abs(expr.nbits))
    else:
        raise Exception("unhandled: %s" % expr)


def build_interim_variable_assign(int_blk,expr):
    assert(isinstance(expr, fpexprlib.FPBox))
    name,typ = get_int_var_and_type(expr)
    if isinstance(expr.expr, exprlib.Constant):
        newE = exprlib.Constant(constval_to_int(expr.expr.value,typ))
    else:
        newE = fpexpr_to_intexpr(int_blk, expr.expr)

    rel = exprlib.VarAssign(exprlib.Var(name,type=typ), newE)
    int_blk.decl_relation(rel)

def decl_relations(int_blk,fp_block):
    for rel in fp_block.relations():
        for node in rel.nodes():
            if isinstance(node, fpexprlib.FPBox) and not isinstance(node.expr, exprlib.Var):
                name,typ = get_int_var_and_type(node)
                vn = int_blk.decl_var(name=name, kind=blocklib.VarKind.Transient, type=typ)

            if isinstance(node, fpexprlib.FPBox):
                build_interim_variable_assign(int_blk,node)

    for rel in fp_block.relations():
        if isinstance(rel, exprlib.VarAssign):
            name,typ = get_int_var_and_type(rel.lhs)
            newrhs = fpexpr_to_intexpr(int_blk, rel.rhs)
            int_blk.decl_relation(VarAssign(exprlib.Var(name,typ), newrhs))

        elif isinstance(rel, exprlib.Integrate):
            name,typ = get_int_var_and_type(rel.lhs)
            newrhs = fpexpr_to_intexpr(rel.rhs)
            int_blk.decl_relation(Accumulate(exprlib.Var(name,typ), newrhs))


def to_integer(fp_block):
    int_blk = blocklib.AMSBlock(fp_block.name+'-int')

    for v in fp_block.vars():
        name,typ = get_int_var_and_type(fpexprlib.FPBox(exprlib.Var(v.name,v.type),v.type))
        vn = int_blk.decl_var(name=name, kind=v.kind, type=typ)
       
    decl_relations(int_blk, fp_block)
    return int_blk 
    
    raise NotImplementedError