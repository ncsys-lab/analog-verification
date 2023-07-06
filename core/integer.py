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

def typecheck_int_type(node,intt,fpt):
    infer_intt = IntType.from_fixed_point_type(fpt)
    if not intt.matches(infer_intt):
        raise Exception("mismatch %s: int-type=%s | fp-type=%s (scale=%f) int-type=%s" \
                    % (node.op_name, intt,fpt,fpt.scale, infer_intt))

def fpexpr_to_intexpr(blk,expr):
    def rec(e):
        return fpexpr_to_intexpr(blk,e)

    if isinstance(expr, exprlib.Var):
        newV = exprlib.Var(expr.name)
        newV.type = IntType.from_fixed_point_type(expr.type)
        return newV

    elif isinstance(expr, exprlib.Constant):
        constE = exprlib.Constant(expr.value)
        constE.type = IntType.from_fixed_point_type(expr.type)
        return constE
   
    elif isinstance(expr, exprlib.Product):
        nlhs = rec(expr.lhs)
        nrhs = rec(expr.rhs)
        nexpr = exprlib.Product(nlhs,nrhs)
        nexpr.type = IntType.from_fixed_point_type(expr.type)
        return nexpr

    elif isinstance(expr, exprlib.Negation):
        nexpr = rec(expr.expr)
        neg = exprlib.Negation(nexpr)
        neg.type = IntType.from_fixed_point_type(expr.type)
        return neg

    elif isinstance(expr, fpexprlib.FPToSigned):
        orig_type = expr.type
        nexpr = rec(expr.expr)
        tosgn = ToSInt(PadL(nexpr, nbits=1, value=0))
        typecheck_int_type(tosgn,tosgn.type, expr.type)
        return tosgn

    elif isinstance(expr, fpexprlib.FPExtendFrac):
        nexpr = rec(expr.expr)
        xtendF = PadR(nexpr,nbits=expr.nbits,value=0)
        typecheck_int_type(xtendF,xtendF.type, expr.type)
        return xtendF
 
    elif isinstance(expr, fpexprlib.FPTruncFrac):
        nexpr = rec(expr.expr)
        truncF = TruncR(nexpr,nbits=expr.nbits)
        typecheck_int_type(truncF,truncF.type, expr.type)
        return truncF
        
    else:
        raise Exception("unhandled: %s" % expr.op_name)


def expr_to_var_name(e):
    return "%s%d" % (e.op_name, e.ident)


def decl_relations(int_blk,fp_block):
    
    for rel in fp_block.relations():
        if isinstance(rel, exprlib.VarAssign):
            newlhs = fpexpr_to_intexpr(int_blk, rel.lhs)
            newrhs = fpexpr_to_intexpr(int_blk, rel.rhs)
            int_blk.decl_relation(exprlib.VarAssign(newlhs, newrhs))

        elif isinstance(rel, exprlib.Accumulate):
            newlhs = fpexpr_to_intexpr(int_blk, rel.lhs)
            newrhs = fpexpr_to_intexpr(int_blk, rel.rhs)
            int_blk.decl_relation(exprlib.Accumulate(newlhs, newrhs))

        else:
            raise Exception("not supported.")




def to_integer(fp_block):
    int_blk = blocklib.AMSBlock(fp_block.name+'-int')

    for v in fp_block.vars():
        typ = IntType.from_fixed_point_type(v.type)
        int_blk.decl_var(name=v.name, kind=v.kind, type=typ)
       
    decl_relations(int_blk, fp_block)
    return int_blk 
    