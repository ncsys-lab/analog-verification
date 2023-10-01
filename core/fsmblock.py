from enum import Enum
from core.block import *
from core.expr import *
from copy import *
import core.fixedpoint as fixlib
import core.integer as intlib
import core.intervals as intervallib
from core.intexpr import *

class FSMAMSBlock:

    #In reality, evaluate_dt_division should be a factor of 2**n, othewise it becomes hairy to divide the clock.
    def __init__(self, system_dt, evaluate_dt_division, initializer, name, starting_state = None):
        self.nodes = {}
        self.edges  = {}
        self.starting_state = starting_state

        self.system_dt   = system_dt
        self.evaluate_dt = system_dt / evaluate_dt_division
        print(self.evaluate_dt)
        input()
        self.evaluate_dt_division = evaluate_dt_division #must be even for posedge and negedge

        self.evaluate_cycles = 0

        self.state = self.starting_state
        self.state_vars = initializer.conditions

        self.event_this_cycle = None

        #stuff to appear like it has the same variable interface as the standard AMSBlock.
        self.name = name
        self._vars = {}
        self._params = {}
        self._relations_dict = {}

    def vars(self):
        return self._vars.values()
    
    def params(self):
        return self._params.values()
        
    def get_var(self, v):
        return self._vars[v]
    
    def addNode(self, node):
        assert not (node.name in self.nodes.keys())
        self.nodes[node.name] = node
        self.edges[node.name] = []

    def addNodeEdgeCopies(self, src, node, edge, duration):
        
        new_node_arr = []
        for i in range(duration // self.evaluate_dt):
            node_copy = copy.deepcopy(node)
            node_copy.name = node_copy.name + str(i)
            new_node_arr.append(node_copy)
            self.nodes[node_copy.name] = node_copy
            self.edges[node_copy.name] = []

        for i in range( ( duration // self.evaluate_dt ) - 1):
            edge_copy = copy.deepcopy(edge)
            src_name = self.new_node_arr[i].name
            snk_name = self.new_node_arr[i + 1].name
            edge_copy.src = self.nodes[src_name]
            edge_copy.snk = self.nodes[snk_name]
            

        return node_copy


            
    def addEdge(self, edge):
        self.edges[edge.src_node.name].append(edge)
        

    def setStartingState(self, node):
        self.starting_state = node

    def evaluationClockTick(self):
        #This will be triggered by the external system clock in reality. Here it is represented by an event-based trigger.
        self.evaluate_cycles = self.evaluate_cycles + 1
        self.event_this_cycle = None

        if(self.evaluate_cycles % self.evaluate_dt_division == 0):
            self.event_this_cycle = ClockCondition.Transition.POSEDGE
            
        elif(self.evaluate_cycles % (self.evaluate_dt_division // 2) == 0):
            self.event_this_cycle = ClockCondition.Transition.NEGEDGE

        self.state_vars = execute_block(self.state.block, self.state_vars)

        for edge in self.edges[self.state.name]:
            #print(self._conditionTrue(edge))
            if( self._conditionTrue(edge.cond) ):
                
                self.state = edge.dest_node
                self.evaluate_cycles = 0
                self.event_this_cycle = None
                return
            
    def preprocessHierarchy(self, rel_prec = 0.01, override_dict = {}):

        for name, node in self.nodes.items(): #iterate through all blocks in the FSM and convert to integer model, extracting relations.
            ival_reg = intervallib.compute_intervals_for_block(node.block, rel_prec)
            fp_block = fixlib.to_fixed_point(ival_reg,node.block)

            int_block = intlib.to_integer(fp_block)
            node.block = int_block


            for v in node.block.vars():
                if( not ( v.name in list(override_dict.keys()))):
                    if( not ( v.name in list(map(lambda vec: vec.name, self._vars.values())) ) ):
                        self._vars[v.name] = v

                    else:
                        stored_var = self._vars[v.name]


                        if(stored_var.type.scale > v.type.scale):
                            shift = round(math.log2(stored_var.type.scale)) - round(math.log2(v.type.scale))
                            print(shift)
                            if(shift > 0):
                                self._vars[v.name] = VarInfo(name=v.name, kind=v.kind, type = intlib.IntType(nbits = stored_var.type.nbits + shift, scale = v.type.scale, signed = stored_var.type.signed or v.type.signed))
                                stored_var = self._vars[v.name]
                            else:
                                raise Exception("This should never happen")

                            print('NEW RANGE for {}'.format(v.name))
                            print(2 ** self._vars[v.name].type.nbits * self._vars[v.name].type.scale)
                            input()

                        if(stored_var.type.nbits < v.type.nbits ):
                            self._vars[v.name] = VarInfo(name=v.name, kind=v.kind, type = intlib.IntType(nbits = v.type.nbits, scale = stored_var.type.scale, signed = stored_var.type.signed or v.type.signed))
                        else:
                            print("datatypes match")


                        node.block._vars[v.name] = deepcopy(self._vars[v.name])
                else:
                    self._vars[v.name] = VarInfo(name=v.name, kind=v.kind, type = override_dict[v.name])
                    node.block._vars[v.name] = deepcopy(self._vars[v.name])
                    

        
        for name, fsm_v in self._vars.items():
            for node in self.nodes.values():
                if name in node.block._vars.keys():
                        print('assigned new type')
                        node.block._vars[name] = deepcopy(fsm_v)
        
        print("BLOCK_VAR")
        print(self._vars['o'])
        input()
        for name, node in self.nodes.items():
            print('==========NODE {}=========='.format(name))
            input()
            for i, rel in enumerate(node.block.relations()):
                
                print(rel)
                print(node.block.get_var(rel.lhs.name))
                rel.lhs.type = node.block.get_var(rel.lhs.name).type # Assign type of lhs of expression to proper type
                if isinstance(rel, VarAssign):
                    print(rel.lhs.type)

                    node.block._relations[i] = rel
                    prev_type = deepcopy(rel.lhs.type)
                    print(prev_type)
                    
                    if(not isinstance(rel.rhs, Var) ):
                        print("====Top====")
                        print(node.block._relations[i].lhs.type)
                        print(node.block._relations[i].rhs.type)
                        print(node.block._relations[i].pretty_print())
                        print(node.block._relations[i])

                        self._change_relation_reference_datatypes(node.block._relations[i].rhs)
                        print(node.block._relations[i].lhs.type)
                        print(node.block._relations[i].rhs.type)
                        print(node.block._relations[i].pretty_print())
                        print(node.block._relations[i])
                        self._change_relation_reference_datatypes(node.block._relations[i].rhs)
                        print('entering recursion for ')
                        print(node.block._relations[i])
                        print(node.block._relations[i].lhs.type)
                        print(node.block._relations[i].lhs.name)

                        print("top^")
                    else:
                        print(node.block._relations[i])
                        node.block._relations[i].lhs.type = deepcopy(prev_type)
                        
                        print(prev_type)
                        print(self._vars[node.block._relations[i].rhs.name].type)
                        node.block._relations[i].rhs.type = deepcopy(self._vars[node.block._relations[i].rhs.name].type)
                        print(self._vars[node.block._relations[i].rhs.name])
                        



                    newrhs = intlib.mult_type_match(intlib.scale_type_match(intlib.sign_type_match(node.block._relations[i].rhs, node.block._relations[i].lhs.type), node.block._relations[i].lhs.type), node.block._relations[i].lhs.type)
                    node.block._relations[i] = VarAssign(node.block._relations[i].lhs, newrhs)
                    self._relations_dict[name] = node.block._relations[i]

                    print(node.block._relations[i])
                    print(node.block._relations[i].pretty_print())
                    print(node.block._relations[i].lhs.type)
                    print(node.block._relations[i].rhs.type)
                    print("bottom^")
                    """
                    if(rel.lhs.name == 'o' and name == 'precharge'):
                    print('OUT')
                    print(node.block._relations[i])
                    print(rel.lhs.type)
                    print(rel.rhs.type)
                    raise Exception()
                    """
                    
                elif isinstance(rel, Accumulate):
                    print(rel.lhs.type)

                    newrhs = intlib.mult_type_match(intlib.scale_type_match(rel.rhs, rel.lhs.type), rel.lhs.type)
                    node.block._relations[i] = Accumulate(rel.lhs, newrhs)
                    print(node.block._relations[i].pretty_print())
                    self._change_relation_reference_datatypes(node.block._relations[i].rhs)
                    print(node.block._relations[i].pretty_print())


                    self._relations_dict[name] = node.block._relations[i]
                print(rel.pretty_print())
                print(node.block.get_var(rel.lhs.name))
            
            for p in node.block.params():
                self._params[p.name] = p
        


    def _change_relation_reference_datatypes(self, expr): #DFSdr
        
        print(expr)
        
        assert expr.type.nbits > 0
        if(isinstance(expr, Constant)):
            return
        if( hasattr(expr, "rhs") ):
            if(isinstance(expr.lhs, Var)):
                if(expr.lhs.type != self._vars[expr.lhs.name].type):
                    prev_type = deepcopy(expr.type)
                    print()
                    expr.lhs.type = deepcopy(self._vars[expr.rhs.name].type)
                    print(expr.pretty_print())
                    print(expr.type)
                    print(expr.lhs.type)
                    input()
                    expr.lhs = intlib.mult_type_match(intlib.scale_type_match(intlib.sign_type_match(expr.lhs, prev_type), prev_type), prev_type)
                    print(expr.pretty_print())
                    print(expr.type)
                    print(expr.lhs.type)
                    input()
            else:
                self._change_relation_reference_datatypes(expr.lhs) 
            if(isinstance(expr.rhs, Var)):
                if(expr.rhs.type != self._vars[expr.rhs.name].type):
                    prev_type = deepcopy(expr.type)
                    expr.rhs.type = deepcopy(self._vars[expr.rhs.name].type)
                    print(expr.pretty_print())
                    print(expr.type)
                    print(expr.rhs.type)
                    input()
                    expr.rhs = intlib.mult_type_match(intlib.scale_type_match(intlib.sign_type_match(expr.rhs, prev_type), prev_type), prev_type)
                    print(expr.pretty_print())
                    print(expr.type)
                    print(expr.rhs.type)
                    input()
            else:
                self._change_relation_reference_datatypes(expr.lhs)
          
        else:
            if(isinstance(expr.expr, Var)):
                if(expr.expr.type != self._vars[expr.expr.name].type):
                    prev_type = deepcopy(expr.type)
                    expr.expr.type = deepcopy(self._vars[expr.expr.name].type)
                    print(expr.pretty_print())
                    print(expr.type)
                    print(expr.expr.type)
                    input()
                    expr.expr = intlib.mult_type_match(intlib.scale_type_match(intlib.sign_type_match(expr.expr, prev_type), prev_type), prev_type)
                    print(expr.pretty_print())
                    print(expr.type)
                    print(expr.expr.type)
                    input()                    
            else:
                self._change_relation_reference_datatypes(expr.expr)





    def _conditionTrue(self, cond):
        if(isinstance(cond, ClockCondition)):
            return (cond.transition_type == self.event_this_cycle) and self._conditionTrue(cond.extra_cond)
        elif(isinstance(cond, NoCondition)):
            return True
        elif(isinstance(cond, AnalogSignalCondition)):
            return ( self.state_vars[cond.expr] > cond.range[0] ) and ( self.state_vars[cond.expr] <= cond.range[1])
        elif(isinstance(cond, AnalogTimeCondition)):
            return(self.evaluate_cycles * self.evaluate_dt >= cond.duration_var.variable.execute(self.state_vars))
        
    def setEvent(self, event):
        self.event_this_cycle = event

    def reset(self):
        self.state = self.starting_state

class Node:

    def __init__(self, name):
        self.block = AMSBlock(name)
        self.name = name

class Edge:

    def __init__(self, src, dest, cond):
        self.src_node = src
        self.dest_node = dest
        self.cond = cond

@dataclass
class Initializer:
    conditions : dict
    


#Condition Classes
class NoCondition:
    def __init__(self):
        pass
    

class ClockCondition:
    class Transition(Enum):
        POSEDGE = 0
        NEGEDGE = 1

    def __init__(self, transition_type, extra_cond = NoCondition()):
        self.transition_type = transition_type
        self.extra_cond = extra_cond


class AnalogSignalCondition:

    def __init__(self, expr : str, range): #if variable falls within range, we transition. 
        assert isinstance(expr, str)
        self.expr = expr 
        self.range = range

class AnalogTimeCondition:
    def __init__(self, duration_var): #If the time we are in a state exceeds duration_var, we transition
        assert isinstance(duration_var, VarInfo)
        self.duration_var = duration_var

"""
'evaluate_high' :         
'evaluate_low_high_low' : 
'evaluate_low_stable' :   
'evaluate_low_low_high' : 
'evaluate_wait_low_high': 
'evaluate_wait_high_low':
"""
