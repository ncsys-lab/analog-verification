from veriloggen import *
from core.block import VarKind, VarInfo
from core.intexpr import *
from core.expr import *
from core.fpexpr import *
from pymtl3 import *

class RTLBlock:

    def __init__(self, block):
        self.m = Module(block.name)

        self.inputs  = {}
        self.wires   = {}
        self.regs    = {}
        self.outputs = {}

        self.params  = {}

        self.inputs['clk'] = self.m.Input('clk')
        self.inputs['eval_clk'] = self.m.Input('eval_clk')
        self.inputs['reset'] = self.m.Input('reset')

        for v in block.vars():
            if v.kind ==  VarKind.Input:
                self.inputs[v.name] = self.m.Input(v.name, v.type.nbits)
            elif v.kind == VarKind.Output:
                self.outputs[v.name] = self.m.Output(v.name, v.type.nbits)
            elif v.kind == VarKind.Transient:
                self.wires[v.name] = self.m.Wire(v.name, v.type.nbits)
            elif v.kind == VarKind.StateVar:
                self.regs[v.name] = self.m.Reg(v.name, v.type.nbits)

        for p in block.params():
            self.params[p.name] = self.m.Parameter(p.name, p.variable.type.value)

        self.seq = Seq(self.m, 'regassn', self.inputs['eval_clk'], self.inputs['reset'])

        for r in block.relations():
            if r.lhs.name in self.regs.keys():
                self.seq(self.regs[r.lhs.name](self.traverse_expr_tree(r.rhs)[0]))
            elif r.lhs.name in self.wires.keys():
                self.wires[r.lhs.name].assign(self.traverse_expr_tree(r.rhs)[0])
    
    def print_verilog_src(self):
        v = self.m.to_verilog()
        print(v)

    def generate_verilog_src(self, path : str):
        v = self.m.to_verilog(filename=path)

    #This function pretty much traverses our expression tree and turns it into a veriloggen expression tree
    def traverse_expr_tree(self, relation):
        print(relation)
        if(isinstance(relation, Constant)):
            print('type')
            print(relation.value)
            return relation.value, relation.type.nbits
        elif(isinstance(relation, Var)):
            if(relation.name in self.regs.keys()):
                print('type')
                print(self.regs[relation.name])
                return self.regs[relation.name], relation.type.nbits
            elif(relation.name in self.wires.keys()):
                print('type')
                print(self.wires[relation.name])
                return self.wires[relation.name], relation.type.nbits
            elif(relation.name in self.inputs.keys()):
                print('type')
                print(self.inputs[relation.name])
                return self.inputs[relation.name], relation.type.nbits
            
        elif(isinstance(relation, Param)):
            return self.params[relation.name], relation.type.nbits
        elif(isinstance(relation, Sum)):
            return self.traverse_expr_tree(relation.lhs)[0] + self.traverse_expr_tree(relation.rhs)[0], relation.type.nbits
        elif(isinstance(relation, Difference)):
            return self.traverse_expr_tree(relation.lhs)[0] - self.traverse_expr_tree(relation.rhs)[0], relation.type.nbits
        elif(isinstance(relation, Product)):
            return self.traverse_expr_tree(relation.lhs)[0] * self.traverse_expr_tree(relation.rhs)[0], relation.type.nbits
        elif(isinstance(relation, Negation)):
            print(relation)
            return - (self.traverse_expr_tree(relation.expr)[0]), relation.type.nbits
        elif(isinstance(relation, Quotient)):
            return self.traverse_expr_tree(relation.lhs)[0] / self.traverse_expr_tree(relation.rhs)[0], relation.type.nbits
        elif(isinstance(relation, TruncR)):
            return self.traverse_expr_tree(relation.expr)[0], relation.type.nbits
        elif(isinstance(relation, FPExtendFrac)):
            return self.traverse_expr_tree(relation.expr)[0], relation.type.nbits
        else:
            print(relation)
            raise NotImplementedError
        
    def generate_pymtl_wrapper(self):
        raise NotImplementedError
        pass

        
        


        
            
            

