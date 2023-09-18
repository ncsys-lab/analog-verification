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
    
def mult_type_match(e,t):
    #print(e.type,t)

    if e.type.nbits == t.nbits:
        return e
    else:
        if(e.type.nbits < t.nbits):
            nbits = t.nbits - e.type.nbits
            return mult_type_match(PadL(nbits = nbits, expr = e, value=0), t)
        else:
            nbits = e.type.nbits - t.nbits
            return mult_type_match(TruncVal(nbits = nbits, expr = e), t)
        
def scale_type_match(e, t):
    print("potential infinite loop in scale_type_match")

    
    if e.type.scale == t.scale:
        print('here')
        return e
    else:
        if(math.log2(e.type.scale) <= 0 and math.log2(t.scale) <= 0 ):
            print(e.type)
            print(t)
            input()
            if( abs(math.log2(e.type.scale)) < abs(math.log2(t.scale)) ):
                nbits = round(abs(math.log2(t.scale))) - round(abs(math.log2(e.type.scale)))
                return scale_type_match(PadR(nbits = nbits, expr = e, value = 0), t)
            else:
                nbits = round(abs(math.log2(e.type.scale))) - round(abs(math.log2(t.scale)))
                return scale_type_match(TruncR(nbits = nbits, expr = e), t )
        else:
            print(e.type)
            print(t)
            input()
            if( abs(math.log2(e.type.scale)) < abs(math.log2(t.scale)) ):
                nbits = round(abs(math.log2(t.scale))) - round(abs(math.log2(e.type.scale)))
                return scale_type_match(TruncR(nbits = nbits, expr = e), t)
            else:
                nbits = round(abs(math.log2(e.type.scale))) - round(abs(math.log2(t.scale)))
                return scale_type_match(PadR(nbits = nbits, expr = e, value = 0), t )



        

def fpexpr_to_intexpr(blk,expr):
    #print(expr)
    def rec(e):
        #print("entering recursion for op: {}".format(e.op_name))
        return fpexpr_to_intexpr(blk,e)

    if isinstance(expr, exprlib.Var):
        newV = exprlib.Var(expr.name)
        newV.type = IntType.from_fixed_point_type(expr.type)
        #print("type_result Var: {}".format(newV.type))
        return newV

    elif isinstance(expr, exprlib.Constant):
        constE = exprlib.Constant(expr.value)
        constE.type = IntType.from_fixed_point_type(expr.type)
        return constE
    
    elif isinstance(expr, exprlib.Param):
        paramE = exprlib.Param(name=expr.name, value=expr.value)
        paramE.type = IntType.from_fixed_point_type(expr.type)
        return paramE
   
    elif isinstance(expr, exprlib.Product):
        nlhs = rec(expr.lhs)
        nrhs = rec(expr.rhs)
        #nlhs and nrhs really need to be the same n_bits

        nexpr = exprlib.Product(nlhs,nrhs)
        nexpr.type = IntType.from_fixed_point_type(expr.type)
        nexpr.lhs = mult_type_match(nexpr.lhs,nexpr.type)
        nexpr.rhs = mult_type_match(nexpr.rhs,nexpr.type)

        typecheck_int_type(nexpr, nexpr.type, expr.type)
        #print("type_result Prod: {}".format(nexpr.type))
        #print(nexpr.lhs)
        #print(nexpr.rhs)
        return nexpr

    elif isinstance(expr, exprlib.Difference):
        nlhs = rec(expr.lhs)
        nrhs = rec(expr.rhs)
        nexpr = exprlib.Difference(nlhs,nrhs)
        nexpr.type = IntType.from_fixed_point_type(expr.type)
        #print("type_result Prod: {}".format(nexpr.type))
        typecheck_int_type(nexpr, nexpr.type, expr.type)
        return nexpr
    
    elif isinstance(expr, fpexprlib.FpQuotient):
        nlhs = rec(expr.lhs)
        nrhs = rec(expr.rhs)
        
        scale = exprlib.Constant( int( 1 / nrhs.type.scale ) )
        scale.type = nlhs.type
        scale = rec(scale)

        norm_expr = exprlib.Product( nlhs, scale )
        norm_expr.type = IntType( nbits = 2 * nlhs.type.nbits + 2 * int(nlhs.type.signed), scale = nlhs.type.scale, signed = nlhs.type.signed)

        norm_expr.lhs = mult_type_match(norm_expr.lhs, norm_expr.type)
        norm_expr.rhs = mult_type_match(norm_expr.rhs, norm_expr.type)

        nexpr = IntQuotient( mult_type_match(scale_type_match(norm_expr, IntType.from_fixed_point_type(expr.type)), IntType.from_fixed_point_type(expr.type)), nrhs )
        nexpr.type = IntType.from_fixed_point_type(expr.type)
        nexpr.lhs = mult_type_match(nexpr.lhs,nexpr.type)
        nexpr.rhs = mult_type_match(nexpr.rhs,nexpr.type)

        typecheck_int_type(nexpr, nexpr.type, expr.type)
        return nexpr
    
    elif isinstance(expr, fpexprlib.FpReciprocal):
        nexpr = rec(expr.expr)

        recip = IntReciprocal(expr = nexpr)
        recip.type = IntType.from_fixed_point_type(expr.type)
        print(recip.type)
        
        typecheck_int_type(recip, recip.type, expr.type)
        return recip
    

    elif isinstance(expr, exprlib.Negation):
        nexpr = rec(expr.expr)
        neg = exprlib.Negation(nexpr)
        neg.type = IntType.from_fixed_point_type(expr.type)
        typecheck_int_type(neg, neg.type. expr.type)
        return neg

    elif isinstance(expr, fpexprlib.FPToSigned):
        orig_type = expr.type
        nexpr = rec(expr.expr)
        
        tosgn = ToSInt(expr = nexpr)
        typecheck_int_type(tosgn,tosgn.type, expr.type)
        return tosgn

    elif isinstance(expr, fpexprlib.FPExtendFrac):
        nexpr = rec(expr.expr)
        xtendF = PadR(expr=nexpr,nbits=expr.nbits,value=0)
        expected_type = IntType.from_fixed_point_type(expr.type)
        sexpr = mult_type_match(scale_type_match(xtendF, expected_type), expected_type)
        print(sexpr)
        print(xtendF.type)
        print(xtendF.expr.type)
        print((xtendF.expr))
        typecheck_int_type(sexpr,sexpr.type, expr.type)
        return sexpr
 
    elif isinstance(expr, fpexprlib.FPTruncFrac):
        nexpr = rec(expr.expr)
        truncExpr = TruncR(expr = nexpr,nbits=expr.nbits)

        expected_type = IntType.from_fixed_point_type(expr.type)
        scaledexpr = mult_type_match(scale_type_match(truncExpr, expected_type), expected_type)
        typecheck_int_type(scaledexpr, scaledexpr.type, expr.type)
        #print("type_result TruncF: {}".format(truncF.type))
        return scaledexpr
    
    elif isinstance(expr, fpexprlib.FPToUnsigned):#added by will
        nexpr = rec(expr.expr)
        usignF= ToUSInt(expr=nexpr)
        #print("type_result usignF: {}".format(usignF.type))
        #print(expr.type)
        #print("child expr:", expr.expr)
        typecheck_int_type(usignF,usignF.type, expr.type)
        return usignF

    elif isinstance(expr, exprlib.Sum):
        expr_lhs = rec(expr.lhs)
        expr_rhs = rec(expr.rhs)
        sumop = exprlib.Sum(expr_lhs, expr_rhs)
        sumop.type = IntType.from_fixed_point_type(expr.type)
        #print("=== lhs ===")
        #print(expr.lhs)
        #print(expr.lhs.type)
        #print(expr_lhs.type)

        #print("=== rhs ===")
        #print(expr.rhs)
        #print(expr.rhs.type)
        #print(expr_rhs.type)

        #print('===expr===')
        #print(expr.type)
        #print(sumop.type)
        assert(expr_lhs.type.nbits == expr_rhs.type.nbits)
        typecheck_int_type(sumop,sumop.type, expr.type)
        return sumop

    elif isinstance(expr, fpexprlib.FPExtendInt):
        
        eexpr = rec(expr.expr)
        exint = PadL(expr=eexpr,nbits=expr.nbits,value=0)
        #print('===expr===')
        #print(eexpr.type)
        #print(exint.type)
        expected_type = IntType.from_fixed_point_type(expr.type)
        scaledexpr = mult_type_match(scale_type_match(exint, expected_type),expected_type)
        typecheck_int_type(scaledexpr,scaledexpr.type,expr.type)
        return exint
    
    elif isinstance(expr, fpexprlib.FPTruncInt):
        eexpr = rec(expr.expr)
        exint = TruncVal(expr=eexpr,nbits=eexpr.type.nbits - expr.type.nbits)
        #print("type_result TruncInt: {}".format(exint.type))
        expected_type = IntType.from_fixed_point_type(expr.type)
        scaledexpr = mult_type_match(scale_type_match(exint, expected_type),expected_type)
        typecheck_int_type(scaledexpr, scaledexpr.type, expr.type)
        
        return exint
    
    elif isinstance(expr, fpexprlib.FPTruncL):
        eexpr = rec(expr.expr)
        exint = TruncL(expr=eexpr,nbits=eexpr.type.nbits - expr.type.nbits)
        #print("type_result TruncInt: {}".format(exint.type))
        exint.expr = mult_type_match(scale_type_match(exint.expr, exint.type),exint.type)
        typecheck_int_type(exint, exint.type, expr.type)
        print("TruncL")
        return exint
    
    elif isinstance(expr, fpexprlib.FPIncreaseScale):
        eexpr = rec(expr.expr)
        exint = IntIncreaseScale(expr = eexpr, nbits=expr.nbits)
        exint.type = IntType(nbits = eexpr.type.nbits, scale = 2**(round(math.log2(eexpr.type.scale)) + expr.nbits), signed = expr.type.signed)
        exint.expr = mult_type_match(scale_type_match(exint.expr, exint.type),exint.type)
        typecheck_int_type(exint, exint.type, expr.type)
        return exint
    
    else:
        raise Exception("unhandled: %s" % expr.op_name)


def expr_to_var_name(e):
    return "%s%d" % (e.op_name, e.ident)


def decl_relations(int_blk,fp_block):
    
    for rel in fp_block.relations():
        if isinstance(rel, exprlib.VarAssign):
            newlhs = fpexpr_to_intexpr(int_blk, rel.lhs)
            #print(IntType.from_fixed_point_type(rel.lhs.type))
            desired_type = IntType.from_fixed_point_type(rel.lhs.type)
            newrhs = mult_type_match(scale_type_match(fpexpr_to_intexpr(int_blk, rel.rhs), desired_type), desired_type)
            int_blk.decl_relation(exprlib.VarAssign(newlhs, newrhs))

        elif isinstance(rel, exprlib.Accumulate):
            newlhs = fpexpr_to_intexpr(int_blk, rel.lhs)
            newrhs = scale_type_match(fpexpr_to_intexpr(int_blk, rel.rhs), IntType.from_fixed_point_type(rel.lhs.type))
            int_blk.decl_relation(exprlib.Accumulate(newlhs, newrhs))

        else:
            raise Exception("not supported.")




def to_integer(fp_block):
    int_blk = blocklib.AMSBlock(fp_block.name+'-int')

    for v in fp_block.vars():
        typ = IntType.from_fixed_point_type(v.type)
        int_blk.decl_var(name=v.name, kind=v.kind, type=typ)
    
    for p in fp_block.params():
        typ = IntType.from_fixed_point_type(p.type)
        int_blk.decl_param(name=p.name, value=p.constant)   
        #print(typ)
        int_blk._params[p.name].constant.type = typ
        int_blk._params[p.name].type = typ
       
    decl_relations(int_blk, fp_block)
    return int_blk 
    