from veriloggen import *
from core.block import VarKind, VarInfo
from core.intexpr import *
from core.expr import *
from core.fpexpr import *
from pymtl3 import *
from itertools import count
from pymtl3.passes.backends.verilog import *
from types import FunctionType
from dill.source import getsource
from pymtl3.stdlib.test_utils import mk_test_case_table, run_sim, config_model_with_cmdline_opts

class RTLBlock:

    def __init__(self, block):

        self.block = block

        self.name = block.name.replace('-', '_')

        self.m = Module(self.name)
        
        self.inputs  = {}
        self.wires   = {}
        self.regs    = {}
        self.outputs = {}

        self.params  = {}

        self.inputs['clk'] = self.m.Input('sys_clk')#kludge for pymtl sim to be on eval_clk
        self.inputs['eval_clk'] = self.m.Input('clk')#
        self.inputs['reset'] = self.m.Input('reset')

        self.namecounter = count()

        for v in block.vars():
            if v.kind == VarKind.Input:
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
        v = self.m.to_verilog(filename= path + self.name + '.v')

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
            self.wires[wire_name] = self.m.Wire(wire_name, relation.expr.type.nbits)
            self.wires[wire_name].assign(self.traverse_expr_tree(relation.expr)[0])
            return (self.wires[wire_name][relation.nbits:]), relation.type.nbits
        elif(isinstance(relation, ToUSInt)):
            
            if(relation.type.signed):
                retval = self.traverse_expr_tree(relation.expr)[0]
            else:
                retval = self.traverse_expr_tree(relation.expr)[0][relation.type.nbits - 1:]
            return retval, relation.type.nbits
        elif(isinstance(relation, TruncVal)):
            wire_name = relation.op_name + "_" + str(next(self.namecounter))
            self.wires[wire_name] = self.m.Wire(wire_name, relation.expr.type.nbits)
            self.wires[wire_name].assign(self.traverse_expr_tree(relation.expr)[0])
            return (self.wires[wire_name][relation.nbits:]), relation.type.nbits
        elif(isinstance(relation, PadR)):
            raise NotImplementedError
        
        else:
            print("ERROR, {} IS NOT IMPLEMENTED!!!".format(relation))
            raise NotImplementedError
        
        
    def generate_pymtl_wrapper(self):

        codeobj = compile(self.generate_construct_string(),"<String>", "exec" )
        funcobj = FunctionType(codeobj.co_consts[0], globals(), "construct")
        self.pymtl_object_class = type( self.name, (VerilogPlaceholder, Component), {"construct" : funcobj})
    
    def pymtl_sim_begin(self):
        dut = self.pymtl_object_class()
        cmdline_opts = {}
        self.dut = config_model_with_cmdline_opts(dut, cmdline_opts, duts =[])
        self.dut.apply( DefaultPassGroup(linetrace=False))
        self.dut.sim_reset()

    def pymtl_sim_tick(self, inputs):

        returndict = {}

        for v in self.block.vars():
            if v.kind == VarKind.Input:
                print(v.name)
                print(type(self.dut.w))
                srcstring  = 'self.dut.' + v.name + ' @= ' + 'inputs[\'{}\']'.format(v.name)
                #srcstring = 'print(self.dut.w)'
                #srcstring = 'print(inputs[\'{}\'])'.format(v.name)
                #print(srcstring)
                #print(srcstring)
                srcex = compile(srcstring, '<String>', 'eval')
                exec(srcex)
            if v.kind == VarKind.Output:
                returndict[v.name] = getattr(self.dut, v.name)
        
        self.dut.sim_tick()

        return returndict


    def generate_construct_string(self):
        final_string = "def construct(self"
        
        for p in self.block.params():
            final_string = final_string + ', ' + p.name + " = " + str(self.scale_value_to_int(p.constant.value, p.constant.type))
        
        final_string = final_string + ' ):\n\n'
        for v in self.block.vars():
            if v.kind == VarKind.Input:
                final_string = final_string + '    self.' + v.name + ' = InPort(mk_bits( {} ))\n'.format(v.type.nbits)
            elif v.kind == VarKind.Output:
                final_string = final_string + '    self.' + v.name + ' = OutPort(mk_bits( {} ))\n'.format(v.type.nbits)

        final_string = final_string + '    self.' + 'sys_clk' + ' = InPort(mk_bits( {} ))\n'.format(1)
        print(final_string)
        return final_string



        
        


        
            
            

