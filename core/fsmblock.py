from enum import Enum
from core.block import *
from core.expr import *
from copy import *

class FSMAMSBlock:

    #In reality, evaluate_dt_division should be a factor of 2**n, othewise it becomes hairy to divide the clock.
    def __init__(self, system_dt, evaluate_dt_division, initializer, starting_state = None, ):
        self.nodes = {}
        self.edges  = {}
        self.starting_state = starting_state

        self.system_dt   = system_dt
        self.evaluate_dt = system_dt / evaluate_dt_division
        self.evaluate_dt_division = evaluate_dt_division #must be even for posedge and negedge

        self.evaluate_cycles = 0

        self.state = self.starting_state
        self.state_vars = initializer.conditions

        self.event_this_cycle = None
        
    
    def addNode(self, node):
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


            
    def addEdge(self, edge):
        self.edges[edge.src_node.name].append(edge)
        

    def setStartingState(self, node):
        self.starting_state = node

    def evaluationClockTick(self):
        #This will be triggered by the external system clock in reality. Here it is represented by an event-based trigger.
        if(self.evaluate_cycles == self.evaluate_dt_division):
            self.event_this_cycle = ClockCondition.Transition.POSEDGE
        elif(self.evaluate_cycles == self.evaluate_dt_division // 2):
            self.event_this_cycle = ClockCondition.Transition.NEGEDGE

        self.state_vars = execute_block(self.state.block, self.state_vars)

        for edge in self.edges[self.state.name]:
            print(self._conditionTrue(edge))
            if( self._conditionTrue(edge) ):
                self.state = edge.dest_node
                break
        
        self.evaluate_cycles = self.evaluate_cycles + 1
        self.event_this_cycle = None

    def _conditionTrue(self, edge):
        if(isinstance(edge.cond, ClockCondition)):
            return (edge.cond.transition_type == self.event_this_cycle)
        elif(isinstance(edge.cond, NoCondition)):
            return True
        elif(isinstance(edge.cond, AnalogSignalCondition)):
            return True
        
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

    def __init__(self, transition_type):
        self.transition_type = transition_type

    

class AnalogSignalCondition:

    def __init__(self, expr, range):
        self.expr = expr 
        self.range = range

"""
'evaluate_high' :         
'evaluate_low_high_low' : 
'evaluate_low_stable' :   
'evaluate_low_low_high' : 
'evaluate_wait_low_high': 
'evaluate_wait_high_low':
"""
