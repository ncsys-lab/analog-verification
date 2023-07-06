from core.expr import *
from core.block import AMSBlock, VarKind
import core.intervals as intervallib

import core.fixedpoint as fixlib

def make_vco(timestep=1e-3,rel_prec=0.001):
    vco = AMSBlock("vco")

    #w = vco.decl_input(Real("w"))
    #out = vco.decl_output(Real("out"))

    w = vco.decl_var("w", kind=VarKind.Input, type=RealType(lower=0,upper=1,prec=rel_prec*1.0))
    x = vco.decl_var("x", kind=VarKind.StateVar, type=RealType(lower=-1,upper=1,prec=rel_prec*2.0))
    v = vco.decl_var("v", kind=VarKind.StateVar, type=RealType(lower=-1,upper=1,prec=rel_prec*2.0)) 
    out = vco.decl_var("out", kind=VarKind.Output, type=x.type)

    dvdt = vco.decl_var("dvdt", kind=VarKind.Transient,  \
            type=intervallib.real_type_from_expr(vco, -(w*w)*x, rel_prec=rel_prec))
    dxdt = vco.decl_var("dxdt", kind=VarKind.Transient, \
            type=intervallib.real_type_from_expr(vco, x, rel_prec=rel_prec))

    expr = VarAssign(dvdt, -(w*w)*x)
    vco.decl_relation(expr)
    vco.decl_relation(VarAssign(dxdt, v))
    vco.decl_relation(VarAssign(out, x))

    vco.decl_relation(Integrate(v, dvdt, timestep=timestep))
    vco.decl_relation(Integrate(x, dxdt, timestep=timestep))

    return vco

def old():
    w = Real("w")
    x = Real("x")
    v = x.diff()
    v_ = v.diff()
    eq = Equality(v_, -(w * w) * x)
    integrator = eq.integrate(
        inputs=[w],
        outputs=[x],
        frequency=1e3,
        intervals={
            w: IntervalSet([Interval(0, 1, 1/255)]),
            x: IntervalSet([Interval(-1, 1, 1/127)]),
            x.diff().real: IntervalSet([Interval(0, 1, 1/255)]),
        },
    )
    integrator.to_msdsl(
        "vco",
        inputs=[w],
        outputs=[x],
        init={
            x.diff().real: 1,
        },
    )
