from veriloggen import *
from core.block import VarKind, VarInfo
from core.intexpr import *
from core.expr import *
from core.fpexpr import *
from pymtl3 import *
from itertools import count
from pymtl3.passes.backends.verilog import *
from types import FunctionType, CodeType
from dill.source import getsource
from pymtl3.stdlib.test_utils import mk_test_case_table, run_sim, config_model_with_cmdline_opts
import math
import inspect
from core.fsmblock import *

class RTLBlock:

    def __init__(self, block, initconditions):

        self.block = block

        self.name = block.name.replace('-', '_')

        self.m = Module(self.name)
        
        self.inputs  = {}
        self.wires   = {}
        self.regs    = {}
        self.outputs = {}

        self.params  = {}
        self.initconditions = initconditions

        self.inputs['clk'] = self.m.Input('sys_clk')#kludge for pymtl sim to be on eval_clk
        self.inputs['eval_clk'] = self.m.Input('clk')
        self.inputs['reset'] = self.m.Input('reset')

        self.seq = Seq(self.m, 'regassn', self.inputs['eval_clk'], self.inputs['reset'])

        if(isinstance(self.block, FSMAMSBlock)):
            self.regs['state_cycle_counter'] = self.m.Reg('state_cycle_counter', ceil(math.log2(10 * block.evaluate_dt_division))) #scales size based on clockdivision

            self.regs['prev_clk'] = self.m.Reg('prev_sys_clk', 1)

            self.seq(self.regs['prev_clk'](self.inputs['clk']))


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

        

        if( isinstance(block, AMSBlock)):
            for r in block.relations():
                if r.lhs.name in self.regs.keys():
                    if(isinstance(r,Accumulate)):
                        expression = self.regs[r.lhs.name]( self.regs[r.lhs.name] + self.traverse_expr_tree(r.rhs)[0])
                    else:
                        expression = self.regs[r.lhs.name](self.traverse_expr_tree(r.rhs)[0])

                    self.seq.If(self.inputs['reset'])(
                        self.regs[r.lhs.name](self.scale_value_to_int(self.initconditions[r.lhs.name], r.rhs.type)) 
                    ).Else(
                        expression
                    )
                elif r.lhs.name in self.wires.keys():
                    self.wires[r.lhs.name].assign(self.traverse_expr_tree(r.rhs)[0])
                elif r.lhs.name in self.outputs.keys():
                    self.outputs[r.lhs.name].assign(self.traverse_expr_tree(r.rhs)[0])
        elif( isinstance(block, FSMAMSBlock)):
            
            state_mapping = dict(zip( block.edges.keys(), range(len(block.edges.keys())) ))
            print(state_mapping)

            state_defined = []
            fsm = FSM(self.m, 'fsm', self.inputs['eval_clk'], self.inputs['reset'])
            self.fsm = fsm

            for state_name, edges in self.block.edges.items():
                print((edges))

                for edge in edges:
                    if(not (state_name in state_defined) ):
                        print(self.block.nodes[state_name].block.relations())

                        for r in self.block.nodes[state_name].block.relations():
                            print(r.lhs.type)
                            print(r.rhs.type)
                            print(r.pretty_print())

                            if r.lhs.name in self.regs.keys():
                                if(isinstance(r,Accumulate)):
                                    expression = self.regs[r.lhs.name]( self.regs[r.lhs.name] + self.traverse_expr_tree(r.rhs)[0])
                                else:
                                    expression = self.regs[r.lhs.name](self.traverse_expr_tree(r.rhs)[0])

                                fsm.add(If(self.inputs['reset'])(
                                    self.regs[r.lhs.name](Int(self.scale_value_to_int(self.initconditions[r.lhs.name], r.rhs.type), r.rhs.type.nbits))
                                ).Else(
                                    expression
                                ),index = state_mapping[state_name])
                            elif r.lhs.name in self.wires.keys():
                                print(self.wires[r.lhs.name])
                                self.wires[r.lhs.name].assign(self.traverse_expr_tree(r.rhs)[0])
                            elif r.lhs.name in self.outputs.keys():

                                try:
                                    
                                    self.outputs[r.lhs.name].assign(self.traverse_expr_tree(r.rhs)[0])
                                except:
                                    pass
                
                    state_defined.append(state_name)
                    print(edge)
                    fsm.goto_from(state_mapping[state_name], state_mapping[edge.dest_node.name], cond=self.extract_condition(edge.cond, state_mapping[state_name]))

    def extract_condition(self, condition, state_index):
        if( isinstance(condition, NoCondition)):
            return None
        elif( isinstance(condition, AnalogTimeCondition) ):
            print(condition.duration_var)
            eq = self.regs['state_cycle_counter'] > self.wires[condition.duration_var.name]
            self.fsm.add(If(eq)(self.regs['state_cycle_counter'](0)).Else(self.regs['state_cycle_counter'](self.regs['state_cycle_counter'] + 1)), index = state_index )
            return eq
        elif( isinstance(condition, ClockCondition)):
            if(condition.transition_type == ClockCondition.Transition.POSEDGE):
                if not isinstance(condition.extra_cond, NoCondition):
                    return And(And(Unot(self.regs['prev_clk']), self.inputs['clk']), self.extract_condition(condition.extra_cond, state_index))
                else:
                    return And(Unot(self.regs['prev_clk']), self.inputs['clk'])
            if (condition.transition_type == ClockCondition.Transition.NEGEDGE):
                if not isinstance(condition.extra_cond, NoCondition):
                    return And(And(self.regs['prev_clk'], Unot(self.inputs['clk'])), self.extract_condition(condition.extra_cond, state_index))
                else:
                    return And(self.regs['prev_clk'], Unot(self.inputs['clk']))
                
        elif( isinstance(condition, AnalogSignalCondition)):
            if(condition.expr in self.regs.keys()):
                var = self.regs[condition.expr]
            elif(condition.expr in self.wires.keys()):
                var = self.wires[condition.expr]
            else:
                var = self.inputs[condition.expr]

            print(self.block._vars[condition.expr].type.nbits)

            lb = Int(self.scale_value_to_int(condition.range[0], self.block._vars[condition.expr].type), width=self.block._vars[condition.expr].type.nbits)
            ub = Int(self.scale_value_to_int(condition.range[1], self.block._vars[condition.expr].type), width=self.block._vars[condition.expr].type.nbits)
            return And((var > lb),(var <= ub))
                
        else:
            print('[WARN] State transition condition may be unimplemented')
            return None


    def print_verilog_src(self):
        v = self.m.to_verilog()
        print(v)

    def generate_verilog_src(self, path : str):
        v = self.m.to_verilog(filename= path + self.name + '.v')

    def scale_value_to_int(self, value, type):
        if not isinstance(type, IntType):
            print(type)
            raise Exception('wrong type')
        #print(math.trunc(value / type.scale))
        if(value == float('inf')):
            return  2 ** (type.nbits - 1)
        elif(value == float('-inf')):
            return - 2 ** (type.nbits - 1)
        else:
            return math.trunc(value / type.scale)
        
    def scale_value_to_real(self, value, type):
        if not isinstance(type, IntType):
            print(type)
            raise Exception('wrong type')
        #print(math.trunc(value / type.scale))
        else:
            return  value * type.scale



    #This function pretty much traverses our expression tree and turns it into a veriloggen expression tree
    def traverse_expr_tree(self, relation):

        if(isinstance(relation, Constant)):
            const_wire = relation.op_name + "_" + str(next(self.namecounter))
            self.wires[const_wire] = self.m.Wire(const_wire, relation.type.nbits)
            self.wires[const_wire].assign(self.scale_value_to_int(relation.value, relation.type))
            return self.wires[const_wire], relation.type.nbits
        elif(isinstance(relation, Var)):
            if(relation.name in self.regs.keys()):
                return self.regs[relation.name], relation.type.nbits
            elif(relation.name in self.wires.keys()):
                return self.wires[relation.name], relation.type.nbits
            elif(relation.name in self.inputs.keys()):
                return self.inputs[relation.name], relation.type.nbits
            
        elif(isinstance(relation, Param)):
            wire_name = "param_" + str(next(self.namecounter))
            self.wires[wire_name] = self.m.Wire(wire_name, relation.type.nbits)
            self.wires[wire_name].assign(self.params[relation.name])
            return self.wires[wire_name], relation.type.nbits
        elif(isinstance(relation, Sum)):
            return self.traverse_expr_tree(relation.lhs)[0] + self.traverse_expr_tree(relation.rhs)[0], relation.type.nbits
        elif(isinstance(relation, Difference)):
            return self.traverse_expr_tree(relation.lhs)[0] - self.traverse_expr_tree(relation.rhs)[0], relation.type.nbits
        elif(isinstance(relation, Product)):
            return self.traverse_expr_tree(relation.lhs)[0] * self.traverse_expr_tree(relation.rhs)[0], relation.type.nbits
        elif(isinstance(relation, IntReciprocal)):
            expression = self.traverse_expr_tree(relation.expr)


            return   Int((2 ** expression[1]), width=expression[1] + 1)  / expression[0], relation.type.nbits
        elif(isinstance(relation, Negation)): #disgusting
            if(relation.expr.type.signed == True):
                imm_wire_debug_name = relation.op_name + "_imm_" + str(next(self.namecounter))
                self.wires[imm_wire_debug_name] = self.m.Wire(imm_wire_debug_name, relation.type.nbits)
                self.wires[imm_wire_debug_name].assign(- (self.traverse_expr_tree(relation.expr)[0]))
                return self.wires[imm_wire_debug_name], relation.type.nbits
            else:
                wire_name = relation.op_name + "_" + str(next(self.namecounter))
                self.wires[wire_name] = self.m.Wire(wire_name, relation.expr.type.nbits)
                
                var = self.traverse_expr_tree(relation.expr)
                self.wires[wire_name].assign(var[0])

                wire_name_two = relation.op_name + "_" + str(next(self.namecounter))
                self.wires[wire_name_two] = self.m.Wire(wire_name_two, 1)
                self.wires[wire_name_two](0)

                
                return - Cat( self.wires[wire_name_two], self.wires[wire_name]), relation.type.nbits + 1
        elif(isinstance(relation, Quotient)):
            return self.traverse_expr_tree(relation.lhs)[0] / self.traverse_expr_tree(relation.rhs)[0], relation.type.nbits
        elif(isinstance(relation, TruncR)):
            #You can't truncate epressions, only wires in verilog, so you need to create an intermediate wire
            
            if(relation.type.signed): #kludge
                wire_name = relation.op_name + "_" + str(next(self.namecounter))
                self.wires[wire_name] = self.m.Wire(wire_name, relation.expr.type.nbits)
                self.wires[wire_name].assign(self.traverse_expr_tree(relation.expr)[0])

                wire_name_shift = relation.op_name + "_shift_" + str(next(self.namecounter))
                self.wires[wire_name_shift] = self.m.Wire(wire_name_shift, relation.type.nbits)
                self.wires[wire_name_shift].assign(Sra(self.wires[wire_name],relation.nbits))

                wire_name_imm = relation.op_name + "_imm_" + str(next(self.namecounter))
                self.wires[wire_name_imm] = self.m.Wire(wire_name_imm, relation.type.nbits)
                
                print(relation.pretty_print())
                print(relation.nbits)
                input()
                self.wires[wire_name_imm].assign( 
                    Mux(self.wires[wire_name][-1], 
                        self.wires[wire_name_shift][:relation.expr.type.nbits - relation.nbits], 
                        self.wires[wire_name][relation.nbits:]))
                

                return self.wires[wire_name_imm], relation.type.nbits
            
            else:
                wire_name = relation.op_name + "_" + str(next(self.namecounter))
                self.wires[wire_name] = self.m.Wire(wire_name, relation.expr.type.nbits)
                self.wires[wire_name].assign(self.traverse_expr_tree(relation.expr)[0])
                return (self.wires[wire_name][relation.nbits:]), relation.type.nbits
        elif(isinstance(relation, ToUSInt)):
            
            if(not relation.expr.type.signed):
                raise Exception("This should not be called on unsigned types")
                retval = self.traverse_expr_tree(relation.expr)[0]
            else:
                toUSint_wire = relation.op_name + "_" + str(next(self.namecounter))
                self.wires[toUSint_wire] = self.m.Wire(toUSint_wire, relation.expr.type.nbits)
                self.wires[toUSint_wire].assign(self.traverse_expr_tree(relation.expr)[0])

            return self.wires[toUSint_wire][:relation.type.nbits - 2], relation.type.nbits
        
        elif(isinstance(relation, ToSInt)):
            if(relation.expr.type.signed):
                raise Exception("This should not be called on unsigned type")
            else:
                wire_name_two = relation.op_name + "_" + str(next(self.namecounter))
                self.wires[wire_name_two] = self.m.Wire(wire_name_two, 1)
                self.wires[wire_name_two].assign(0)

                imm_wire_debug_name = relation.op_name + "_imm_" + str(next(self.namecounter))
                self.wires[imm_wire_debug_name] = self.m.Wire(imm_wire_debug_name, relation.type.nbits)
                self.wires[imm_wire_debug_name].assign(Cat(self.wires[wire_name_two], self.traverse_expr_tree(relation.expr)[0]))

                return self.wires[imm_wire_debug_name], relation.type.nbits

        elif(isinstance(relation, TruncVal)):
            wire_name = relation.op_name + "_" + str(next(self.namecounter))
            self.wires[wire_name] = self.m.Wire(wire_name, relation.expr.type.nbits)
            self.wires[wire_name].assign(self.traverse_expr_tree(relation.expr)[0])
            return (self.wires[wire_name][:relation.expr.type.nbits - relation.nbits]), relation.type.nbits
        elif(isinstance(relation, PadR)):
            
            padr_wire_name = relation.op_name + "_" + str(next(self.namecounter))
            self.wires[padr_wire_name] = self.m.Wire(padr_wire_name, relation.type.nbits)

            bits_wire_name = relation.op_name + "_bits_" + str(next(self.namecounter))
            self.wires[bits_wire_name] = self.m.Wire(bits_wire_name, relation.nbits)

            self.wires[bits_wire_name].assign(0)

            self.wires[padr_wire_name].assign(Cat( self.traverse_expr_tree(relation.expr)[0], self.wires[bits_wire_name]))

            return self.wires[padr_wire_name], relation.type.nbits
        
        elif(isinstance(relation, PadL)):
            padr_wire_name = relation.op_name + "_" + str(next(self.namecounter))
            self.wires[padr_wire_name] = self.m.Wire(padr_wire_name, relation.type.nbits)

            bits_wire_name = relation.op_name + "_bits_" + str(next(self.namecounter))
            self.wires[bits_wire_name] = self.m.Wire(bits_wire_name, relation.expr.type.nbits)

            self.wires[bits_wire_name].assign(self.traverse_expr_tree(relation.expr)[0])
            
            if(relation.expr.type.signed):
                self.wires[padr_wire_name].assign(Cat(Repeat(self.wires[bits_wire_name][relation.expr.type.nbits - 1],relation.nbits), self.wires[bits_wire_name]))
            else:
                zero_wire_name = relation.op_name + "_bits_zero_" + str(next(self.namecounter))
                self.wires[zero_wire_name] = self.m.Wire(zero_wire_name, relation.nbits)
                self.wires[zero_wire_name].assign(0)
                self.wires[padr_wire_name].assign(Cat(self.wires[zero_wire_name], self.wires[bits_wire_name]))

            return self.wires[padr_wire_name], relation.type.nbits
        
        else:
            print("ERROR, {} IS NOT IMPLEMENTED!!!".format(relation))
            raise NotImplementedError
        
    
        
        
    def generate_pymtl_wrapper(self):
        
        codeobj = compile(self.generate_construct_string(),"<String>", "exec" )

        code = [c for c in codeobj.co_consts if isinstance(c, CodeType)][0]

        param_tuple = tuple(map(lambda v: v,[c for c in codeobj.co_consts if isinstance(c, int)]))

        funcobj = FunctionType(code, globals(), "construct", argdefs=param_tuple) #Used https://gist.github.com/dhagrow/d3414e3c6ae25dfa606238355aea2ca5


        self.pymtl_object_class = type( self.name, (VerilogPlaceholder, Component), {"construct" : funcobj})
    
    def pymtl_sim_begin(self):
        dut = self.pymtl_object_class()
        cmdline_opts = {'dump_textwave'      : False,
                                  'dump_vcd'           : self.name,
                                  'test_verilog'       : False,
                                  'test_yosys_verilog' : False,
                                  'max_cycles'         : None,
                                  'dump_vtb'           : ''}
        self.dut = config_model_with_cmdline_opts(dut, cmdline_opts, duts =[])
        self.dut.apply( DefaultPassGroup(linetrace=False))
        self.dut.sim_reset()

    def pymtl_sim_tick(self, inputs):

        returndict = {}

        for v in self.block.vars():
            if v.kind == VarKind.Input:
                srcstring  = '\nself.dut.' + v.name + ' @= ' + 'inputs[\'{}\']'.format(v.name) + '\n'
                #srcstring = 'print(self.dut.w)'
                #srcstring = 'print(inputs[\'{}\'])'.format(v.name)
                #print(srcstring)
                #print(srcstring)

                srcex = compile(srcstring, '<String>', 'exec') #was 'eval' insted of 'exec'
                exec(srcex)
            if v.kind == VarKind.Output:
                if(v.type.signed):
                    returndict[v.name] = getattr(self.dut, v.name).int()
                else:
                    returndict[v.name] = int(getattr(self.dut, v.name))
        
        self.dut.sys_clk @= inputs['sys_clk']
                
        
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
