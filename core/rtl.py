from veriloggen import *
from core.block import VarKind, VarInfo
from core.intexpr import *
from core.expr import *
from core.fpexpr import *
from pymtl3 import *
from itertools import count

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

        self.namecounter = count()

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
            self.params[p.name] = self.m.Parameter(p.name, self.scale_value_to_int(p.constant.value, p.constant.type) )

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

    def scale_value_to_int(self, value, type):
        if not isinstance(type, IntType):
            print(type)
            raise Exception('wrong type')
        return round(value / type.scale)


    #This function pretty much traverses our expression tree and turns it into a veriloggen expression tree
    def traverse_expr_tree(self, relation):
        print(relation)
        if(isinstance(relation, Constant)):
            print('type')
            print(relation.value)
            return self.scale_value_to_int(relation.value, relation.type), relation.type.nbits
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
            #You can't truncate epressions, only wires in verilog, so you need to create an intermediate wire
            wire_name = relation.op_name + "_" + str(next(self.namecounter))
            print(wire_name)
            self.wires[wire_name] = self.m.Wire(wire_name, relation.expr.type.nbits)
            self.wires[wire_name].assign(self.traverse_expr_tree(relation.expr)[0])
            return (self.wires[wire_name][relation.nbits:]), relation.type.nbits
        elif(isinstance(relation, ToUSInt)):
            
            if(relation.type.signed):
                retval = self.traverse_expr_tree(relation.expr)[0]
            else:
                retval = self.traverse_expr_tree(relation.expr)[0][relation.type.nbits - 1:]
            return retval, relation.type.nbits
        
        else:
            print("ERROR, {} IS NOT IMPLEMENTED!!!".format(relation))
            raise NotImplementedError
        
    def generate_pymtl_wrapper(self):
        raise NotImplementedError
        pass

        
        


        
            
            

