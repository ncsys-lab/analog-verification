from enum import Enum
from typing import List
from dataclasses import dataclass, field
from core.expr import VarType, Var, VarAssign, Integrate, Accumulate, Param, Constant
import core.fpexpr as fplib
import core.intexpr as intlib

class VarKind(Enum):
    Input = "input"
    Output = "output"
    StateVar = "reg"
    Transient = "wire"
    Time = "time"

@dataclass
class VarInfo:
    name : str
    type : VarType
    kind : VarKind
    variable: Var = None

    def __post_init__(self):
        self.variable = Var(self.name)
        self.variable.type = self.type
        #print("Variable Type: {}".format(self.variable.type))

    @property 
    def stateful(self):
        return self.kind == VarKind.StateVar

    def pretty_print(self):
        return "%s %s : %s" % (self.kind.value, self.name, self.type)

@dataclass
class ParamInfo:
    name : str
    constant : Constant

    def __post_init__(self):
        self.variable = Param(self.name, self.constant.value)
        self.variable.type = self.constant.type
        #print("Param Variable Type: {}".format(self.variable.type))
        self.type = self.constant.type
        #print(self.type)
        self.kind = VarKind.Transient

class AMSBlock:

    def __init__(self,name):
        self.name = name
        self._vars = {}
        self._params = {}
        self._relations = []

    def get_var(self, v):
        return self._vars[v]

    def interval(self,v):
        return self._vars[v.name].intervals

    def _filter_variables(self,k:VarKind):
        return filter(lambda v: v.kind == k, self._vars.values())

    def vars(self):
        return self._vars.values()
    
    def params(self):
        return self._params.values()

    def outputs(self):
        return self._filter_variables(VarKind.Output)

    def inputs(self):
        return self._filter_variables(VarKind.Input)

    def statevars(self):
        return self._filter_variables(VarKind.StateVar)


    def relations(self):
        return self._relations

    def set_intervals(self,v,ivals):
        self._intervals[v.name].add_intervals(ivals)

    def decl_relation(self,eq):
        assert(not eq is None)
        self._relations.append(eq)

    def decl_var(self,name:str,kind:VarKind,type:VarType):
        assert(isinstance(type, VarType))
        assert(isinstance(kind,VarKind))
        self._vars[name] = VarInfo(name=name,kind=kind,type=type)
        return self._vars[name].variable

    def decl_param(self, name : str, value : Constant):
        assert(isinstance(value, Constant))
        self._params[name] = ParamInfo(name = name, constant = value)
        return self._params[name].variable


    def __repr__(self):
        stmts = []
        def q(s):
            stmts.append(s)
        for v in self.vars():
            q("var "+v.pretty_print())
        q("")
        for r in self.relations():
            q(r.pretty_print())
        return "\n".join(stmts)
    
    def pretty_print_relations(self):
        print("block {}".format(self.name))
        for r in self.relations():
            print(r.pretty_print())
    
    def pretty_print_types(self):
        print("block {}".format(self.name))
        for v in self.vars():
            print(v)


def execute_block(blk, args):
    vals = dict(args)

    print(vals)

    for rel in blk.relations():

        if isinstance(rel, VarAssign):
      
            rhs_val = rel.rhs.execute(vals)
            if(rel.lhs.name == 'dodt'):
                obj = rel.rhs
                print(obj.pretty_print())
                print(obj.type)
                print(obj.op_name)
                print(obj.execute(vals))

                


            vals[rel.lhs.name] = rel.rhs.type.to_real(rhs_val)
        elif isinstance(rel,Integrate):
            rhs_val = rel.rhs.execute(vals)
            vals[rel.lhs.name] += rel.rhs.type.to_real(rhs_val)
        elif isinstance(rel,Accumulate):
            rhs_val = rel.rhs.execute(vals)
            
            if(rel.lhs.name == 'o'):
                print('o:')
                obj = rel.rhs.expr.expr.expr.expr.expr.rhs.expr.expr
                print(obj.pretty_print())
                print(obj.type)
                print(obj.op_name)
                print(obj.execute(vals))

            vals[rel.lhs.name] += rel.rhs.type.to_real(rhs_val)

        else:
            raise Exception("not supported: %s" % rel)
    return vals
