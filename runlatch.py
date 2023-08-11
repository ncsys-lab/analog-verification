from core.fsmblock import *
import core.intervals as intervallib
import yaml
import matplotlib.pyplot as plt
import numpy as np
import core.fixedpoint as fixlib
import core.rtl as rtllib
import core.integer as intlib

def read_yaml( f ):
    with open(f, 'r') as stream:
        return yaml.safe_load(stream)

class ModelParams:
    def __init__(self, low_high_param_yaml_path = "./regression_results_zero_one.yaml", high_low_param_yaml_path = "./regression_results_one_zero.yaml" ):
        low_high_param = read_yaml(low_high_param_yaml_path)
        high_low_param = read_yaml(high_low_param_yaml_path)

        self.high_low_paramdict_tau      = dict(map(lambda p:(p[0],p[1]['const_1']), high_low_param['tau'].items()))          
        self.high_low_paramdict_resptime = dict(map(lambda p:(p[0],p[1]['const_1']), high_low_param['response_time'].items()))

        self.low_high_paramdict_tau      = dict(map(lambda p:(p[0],p[1]['const_1']), low_high_param['tau'].items()))
        self.low_high_paramdict_resptime = dict(map(lambda p:(p[0],p[1]['const_1']), low_high_param['response_time'].items()))

    def compute_high_low_tau(self, block, VREF, VREG):
        VREF_to_tau = block.decl_param('VREF_to_tau', Constant(self.high_low_paramdict_tau['VREF_to_tau']))
        VREG_to_tau = block.decl_param('VREG_to_tau', Constant(self.high_low_paramdict_tau['VREG_to_tau']))
        const_tau   = block.decl_param('const_tau'  , Constant(self.high_low_paramdict_tau['const_tau'])  )
        #print(VREF_to_tau)
        #print(VREG_to_tau)
        #print(const_tau)       
        return VREF * VREF_to_tau  + VREG * VREG_to_tau  + const_tau

    def compute_high_low_response_time(self, block, VREF, VREG):
        VREF_to_response_time = block.decl_param('VREF_to_response_time',  Constant(self.high_low_paramdict_resptime['VREF_to_response_time']))
        VREG_to_response_time = block.decl_param('VREG_to_response_time',  Constant(self.high_low_paramdict_resptime['VREG_to_response_time']))
        const_to_response_time = block.decl_param('const_response_time'  , Constant(self.high_low_paramdict_resptime['const_response_time'  ]))
        return VREF * VREF_to_response_time + VREG * VREG_to_response_time + const_to_response_time

    def compute_low_high_tau(self, block, VREF, VREG):
        VREF_to_tau = block.decl_param( ('VREF_to_tau'), Constant(self.low_high_paramdict_tau['VREF_to_tau'] ) ) 
        VREG_to_tau = block.decl_param( ('VREG_to_tau'), Constant(self.low_high_paramdict_tau['VREG_to_tau'] ) ) 
        const_tau   = block.decl_param( ('const_tau'  ), Constant(self.low_high_paramdict_tau['const_tau'  ] ) )
        return VREF * VREF_to_tau + VREG * VREG_to_tau + const_tau

    def compute_low_high_response_time(self, block, VREF, VREG):
        VREF_to_response_time = block.decl_param( ('VREF_to_response_time'), Constant(self.low_high_paramdict_resptime['VREF_to_response_time'] ) )
        VREG_to_response_time = block.decl_param( ('VREG_to_response_time'), Constant(self.low_high_paramdict_resptime['VREG_to_response_time'] ) )
        const_response_time   = block.decl_param( ('const_response_time'  ), Constant(self.low_high_paramdict_resptime['const_response_time'  ] ) )
        return VREF * VREF_to_response_time + VREG * VREG_to_response_time + const_response_time
    


class StateMaker:
    """
    'evaluate_high' :         
    'evaluate_low_high_low' : 
    'evaluate_low_stable' :   
    'evaluate_low_low_high' : 
    'evaluate_wait_low_high': 
    'evaluate_wait_high_low':
    """

    model_params = ModelParams()
    
    def create_precharge_state():
        precharge = Node('precharge')

        vref = precharge.block.decl_var('VREF', VarKind.Input, RealType(0.0, 1.7, 0.01))
        vreg = precharge.block.decl_var('VREG', VarKind.Input, RealType(0.0, 3.3, 0.01))
        o    = precharge.block.decl_var('o',  VarKind.StateVar, RealType(0, 3.3, 0.1))  
        out  = precharge.block.decl_var('out',  VarKind.Output, o.type)

        precharge.block.decl_relation(VarAssign(o,Constant(3.3)))
        precharge.block.decl_relation(VarAssign(out,o))  
    
        return precharge
    
    def create_evaluate_wait_high_low_state():
        evaluate_wait_high_low = Node('evaluate_wait_high_low')
        vref = evaluate_wait_high_low.block.decl_var('VREF', VarKind.Input, RealType(0.0, 1.7, 0.01))
        vreg = evaluate_wait_high_low.block.decl_var('VREG', VarKind.Input, RealType(0.0, 3.3, 0.01))
        o    = evaluate_wait_high_low.block.decl_var('o',  VarKind.StateVar, RealType(0, 3.3, 0.1))  
        out  = evaluate_wait_high_low.block.decl_var('out',  VarKind.Output, o.type)

        wait_time_exp = StateMaker.model_params.compute_high_low_response_time(evaluate_wait_high_low.block, vref, vreg)

        wait_time = evaluate_wait_high_low.block.decl_var('wait_time', VarKind.Transient, \
                                                    type=intervallib.real_type_from_expr(evaluate_wait_high_low.block, wait_time_exp, rel_prec = 0.01))
        
        evaluate_wait_high_low.block.decl_relation(VarAssign(wait_time, wait_time_exp))

        evaluate_wait_high_low.block.decl_relation(VarAssign(o,Constant(3.3)))
        evaluate_wait_high_low.block.decl_relation(VarAssign(out,o))
        ival_reg = intervallib.compute_intervals_for_block(evaluate_wait_high_low.block,rel_prec=0.01)
        return evaluate_wait_high_low

    def create_evaluate_low_high_low_state(timestep):
        evaluate_wait_high_low = Node('evaluate_low_high_low')
        vref = evaluate_wait_high_low.block.decl_var('VREF', VarKind.Input, RealType(0.0, 1.7, 0.01))
        vreg = evaluate_wait_high_low.block.decl_var('VREG', VarKind.Input, RealType(0.0, 3.3, 0.01))
        o    = evaluate_wait_high_low.block.decl_var('o',  VarKind.StateVar, RealType(0, 3.3, 0.1))  
        out  = evaluate_wait_high_low.block.decl_var('out',  VarKind.Output, o.type)

        #print(vref)
        #print(vreg)

        tau_exp = StateMaker.model_params.compute_high_low_tau(evaluate_wait_high_low.block, vref, vreg)
        tau  = evaluate_wait_high_low.block.decl_var('tau', kind=VarKind.Transient,  \
            type=intervallib.real_type_from_expr(evaluate_wait_high_low.block, tau_exp , rel_prec=0.01))
        #print("HEREHEREHERE")
        #print(tau.type)
        dodt = evaluate_wait_high_low.block.decl_var("dvdt", kind=VarKind.Transient,  \
            type=intervallib.real_type_from_expr(evaluate_wait_high_low.block, - o / tau, rel_prec=0.01))

        evaluate_wait_high_low.block.decl_relation(VarAssign(tau,tau_exp))
        evaluate_wait_high_low.block.decl_relation(VarAssign(out,o))
        evaluate_wait_high_low.block.decl_relation(VarAssign(dodt, - o / tau))
        evaluate_wait_high_low.block.decl_relation(Integrate(o, dodt, timestep=timestep))

        ival_reg = intervallib.compute_intervals_for_block(evaluate_wait_high_low.block,rel_prec=0.01)
        return evaluate_wait_high_low
    
    def create_evaluate_wait_low_high_state():
        evaluate_wait_low_high = Node('evaluate_wait_low_high')
        vref = evaluate_wait_low_high.block.decl_var('VREF', VarKind.Input, RealType(0.0, 1.7, 0.01))
        vreg = evaluate_wait_low_high.block.decl_var('VREG', VarKind.Input, RealType(0.0, 3.3, 0.01))
        o    = evaluate_wait_low_high.block.decl_var('o',  VarKind.StateVar, RealType(0, 3.3, 0.1))  
        out  = evaluate_wait_low_high.block.decl_var('out',  VarKind.Output, o.type)

        wait_time_exp = StateMaker.model_params.compute_low_high_response_time(evaluate_wait_low_high.block, vref, vreg)
        wait_time = evaluate_wait_low_high.block.decl_var('wait_time', VarKind.Transient, \
                                                          type=intervallib.real_type_from_expr(evaluate_wait_low_high.block, wait_time_exp, rel_prec = 0.01))
        
        evaluate_wait_low_high.block.decl_relation(VarAssign(wait_time, wait_time_exp))
        
        evaluate_wait_low_high.block.decl_relation(VarAssign(o, Constant(3.3)))
        evaluate_wait_low_high.block.decl_relation(VarAssign(out,o))

        ival_reg = intervallib.compute_intervals_for_block(evaluate_wait_low_high.block, rel_prec=0.01)
        return evaluate_wait_low_high
    
    def create_evaluate_low_low_high_state(timestep):
        evaluate_low_low_high = Node('evaluate_low_low_high')

        vref = evaluate_low_low_high.block.decl_var('VREF', VarKind.Input, RealType(0.0, 1.7, 0.01))
        vreg = evaluate_low_low_high.block.decl_var('VREG', VarKind.Input, RealType(0.0, 3.3, 0.01))
        o    = evaluate_low_low_high.block.decl_var('o',  VarKind.StateVar, RealType(0, 3.3, 0.1))  
        out  = evaluate_low_low_high.block.decl_var('out',  VarKind.Output, o.type)

        tau_exp = StateMaker.model_params.compute_low_high_tau( evaluate_low_low_high.block, vref, vreg )

        tau = evaluate_low_low_high.block.decl_var('tau', VarKind.Transient, \
                                                   type=intervallib.real_type_from_expr(evaluate_low_low_high.block, tau_exp, rel_prec = 0.01))

        dodt = evaluate_low_low_high.block.decl_var('dodt', kind=VarKind.Transient, \
                                                     type=intervallib.real_type_from_expr(evaluate_low_low_high.block, (Constant(3.3) - o) / tau, rel_prec=0.01))
        
        evaluate_low_low_high.block.decl_relation(VarAssign(tau, tau_exp))
        evaluate_low_low_high.block.decl_relation(VarAssign(out, o))
        evaluate_low_low_high.block.decl_relation(VarAssign(dodt, (Constant(3.3) - o) / tau))
        evaluate_low_low_high.block.decl_relation(Integrate(o, dodt, timestep=timestep))

        ival_reg = intervallib.compute_intervals_for_block(evaluate_low_low_high.block, rel_prec=0.01)
        return evaluate_low_low_high
    

    

    








SIM_TICKS     = 400000
TICK_DIVISION = 100000
SYSTEM_CLOCK = 1e-6


initial_conditions = Initializer({'VREF': 1.60000001, 'VREG': 1.6, 'o': 3.3})

comparator_latch_fsm = FSMAMSBlock(SYSTEM_CLOCK, TICK_DIVISION, initial_conditions)

# [precharge] [evaluate_wait] [evaluate_low] [evaluate_wait] [evaluate_low_high]
precharge = StateMaker.create_precharge_state()
evaluate_wait_high_low = StateMaker.create_evaluate_wait_high_low_state()
evaluate_low_high_low = StateMaker.create_evaluate_low_high_low_state(comparator_latch_fsm.evaluate_dt)
evaluate_wait_low_high = StateMaker.create_evaluate_wait_low_high_state()
evaluate_low_low_high = StateMaker.create_evaluate_low_low_high_state(comparator_latch_fsm.evaluate_dt)


#[precharge] -posedge clk-> [evaluate_wait] [evaluate_low] []
precharge_to_eval_w_hl = Edge(precharge, evaluate_wait_high_low, ClockCondition(ClockCondition.Transition.POSEDGE, AnalogSignalCondition( 'VREF', (comparator_latch_fsm.state_vars['VREG'],float('inf')) ) ) ) 
#[precharge] -posedge clk-> [evaluate_wait] -duration-> [evaluate_low] []
evaluate_wait_hl_to_evaluate_lhl = Edge(evaluate_wait_high_low, evaluate_low_high_low, AnalogTimeCondition(evaluate_wait_high_low.block.get_var('wait_time')))
#[precharge] -posedge clk-> [evaluate_wait] -duration-> [evaluate_low] -negedge clk-> [evalate_wait]
evaluate_lhl_to_wait_llh = Edge(evaluate_low_high_low, evaluate_wait_low_high, ClockCondition(ClockCondition.Transition.NEGEDGE))
#[precharge] -posedge clk-> [evaluate_wait] -duration-> [evaluate_low] -negedge clk-> [evalate_wait] -duration-> [evaluate_low_high]
evaluate_wait_llh_to_evaluate_llh = Edge(evaluate_wait_low_high, evaluate_low_low_high, AnalogTimeCondition(evaluate_wait_low_high.block.get_var('wait_time')))
#[precharge] -posedge clk-> [evaluate_wait] -duration-> [evaluate_low] -negedge clk-> [evalate_wait] -duration-> [evaluate_low_high] -signal  < 'o'-> [precharge]
evaluate_llh_to_precharge = Edge(evaluate_low_low_high, precharge, AnalogSignalCondition('out', ( 3.29, float('inf') ) ) )

comparator_latch_fsm.addNode(precharge)
comparator_latch_fsm.addNode(evaluate_wait_high_low)
comparator_latch_fsm.addNode(evaluate_low_high_low)
comparator_latch_fsm.addNode(evaluate_wait_low_high)
comparator_latch_fsm.addNode(evaluate_low_low_high)

comparator_latch_fsm.addEdge(precharge_to_eval_w_hl)
comparator_latch_fsm.addEdge(evaluate_wait_hl_to_evaluate_lhl)
comparator_latch_fsm.addEdge(evaluate_lhl_to_wait_llh)
comparator_latch_fsm.addEdge(evaluate_wait_llh_to_evaluate_llh)
comparator_latch_fsm.addEdge(evaluate_llh_to_precharge)

comparator_latch_fsm.starting_state = precharge
comparator_latch_fsm.reset()



o = np.zeros(SIM_TICKS)
t = np.linspace(0, SYSTEM_CLOCK * SIM_TICKS / TICK_DIVISION, SIM_TICKS)


for i in range(SIM_TICKS):

    comparator_latch_fsm.evaluationClockTick()
    o[i] = comparator_latch_fsm.state_vars['o']
    #print(comparator_latch_fsm.state_vars)
    
plt.plot(t,o)
plt.xlabel('')
plt.savefig("resp.png")


ival_reg = intervallib.compute_intervals_for_block(evaluate_low_low_high.block, rel_prec = 0.01)

fp_block = fixlib.to_fixed_point(ival_reg,evaluate_low_low_high.block)

int_block = intlib.to_integer(fp_block)

rtl_block = rtllib.RTLBlock(int_block)

rtl_block.print_verilog_src()

