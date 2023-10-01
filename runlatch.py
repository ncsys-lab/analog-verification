from core.fsmblock import *
import core.intervals as intervallib
import yaml
import matplotlib.pyplot as plt
import numpy as np
import core.fixedpoint as fixlib
import core.rtl as rtllib
import core.integer as intlib
import core.block as blocklib
from pymtl3 import *
from tqdm import tqdm


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
        VREF_to_tau = block.decl_param( ('VREF_to_tau_lh'), Constant(self.low_high_paramdict_tau['VREF_to_tau'] ) ) 
        VREG_to_tau = block.decl_param( ('VREG_to_tau_lh'), Constant(self.low_high_paramdict_tau['VREG_to_tau'] ) ) 
        const_tau   = block.decl_param( ('const_tau_lh'  ), Constant(self.low_high_paramdict_tau['const_tau'  ] ) )
        return VREF * VREF_to_tau + VREG * VREG_to_tau + const_tau

    def compute_low_high_response_time(self, block, VREF, VREG):
        VREF_to_response_time = block.decl_param( ('VREF_to_response_time_lh'), Constant(self.low_high_paramdict_resptime['VREF_to_response_time'] ) )
        VREG_to_response_time = block.decl_param( ('VREG_to_response_time_lh'), Constant(self.low_high_paramdict_resptime['VREG_to_response_time'] ) )
        const_response_time   = block.decl_param( ('const_response_time_lh'  ), Constant(self.low_high_paramdict_resptime['const_response_time'  ] ) )
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

        vref = precharge.block.decl_var('VREF', VarKind.Input, RealType(-1, 1.7, 0.01))
        vreg = precharge.block.decl_var('VREG', VarKind.Input, RealType(-1, 3.3, 0.01))
        o    = precharge.block.decl_var('o',  VarKind.StateVar, RealType(-1, 3.3, 0.01))  
        out  = precharge.block.decl_var('out',  VarKind.Output, o.type)

        precharge.block.decl_relation(VarAssign(o,Constant(3.3)))
        precharge.block.decl_relation(VarAssign(out,o))  
    
        return precharge
    
    def create_evaluate_wait_high_low_state(fsm):
        evaluate_wait_high_low = Node('evaluate_wait_high_low')
        vref = evaluate_wait_high_low.block.decl_var('VREF', VarKind.Input, RealType(-1, 3.3, 0.001))
        vreg = evaluate_wait_high_low.block.decl_var('VREG', VarKind.Input, RealType(-1, 3.3, 0.001))
        o    = evaluate_wait_high_low.block.decl_var('o',  VarKind.StateVar, RealType(-1, 3.3, 0.01))  
        out  = evaluate_wait_high_low.block.decl_var('out',  VarKind.Output, o.type)

        wait_time_exp = StateMaker.model_params.compute_high_low_response_time(evaluate_wait_high_low.block, vref, vreg)

        wait_time = evaluate_wait_high_low.block.decl_var('wait_time', VarKind.Transient, \
                                                    type=RealType(0,100000,1))
        
        evaluate_wait_high_low.block.decl_relation(VarAssign(wait_time, wait_time_exp * Constant(1 / fsm.evaluate_dt)))

        evaluate_wait_high_low.block.decl_relation(VarAssign(o,Constant(3.3)))
        evaluate_wait_high_low.block.decl_relation(VarAssign(out,o))
        ival_reg = intervallib.compute_intervals_for_block(evaluate_wait_high_low.block,rel_prec=0.001)
        return evaluate_wait_high_low

    def create_evaluate_low_high_low_state(timestep):
        evaluate_wait_high_low = Node('evaluate_low_high_low')
        vref = evaluate_wait_high_low.block.decl_var('VREF', VarKind.Input, RealType(-1, 3.3, 0.001))
        vreg = evaluate_wait_high_low.block.decl_var('VREG', VarKind.Input, RealType(-1, 3.3, 0.001))
        o    = evaluate_wait_high_low.block.decl_var('o',  VarKind.StateVar, RealType(-1, 3.3, 0.01))  
        out  = evaluate_wait_high_low.block.decl_var('out',  VarKind.Output, o.type)

        #print(vref)
        #print(vreg)

        tau_exp = StateMaker.model_params.compute_high_low_tau(evaluate_wait_high_low.block, vref, vreg)
        tau  = evaluate_wait_high_low.block.decl_var('tau', kind=VarKind.Transient,  \
            type=intervallib.real_type_from_expr(evaluate_wait_high_low.block, tau_exp , rel_prec=0.000001))
        #print("HEREHEREHERE")
        #print(tau.type)
        dvdt = evaluate_wait_high_low.block.decl_var("dvdt", kind=VarKind.Transient,  \
            type=intervallib.real_type_from_expr(evaluate_wait_high_low.block, - o * Reciprocal(tau), rel_prec=0.001))

        evaluate_wait_high_low.block.decl_relation(VarAssign(tau,tau_exp))
        evaluate_wait_high_low.block.decl_relation(VarAssign(out,o))
        evaluate_wait_high_low.block.decl_relation(VarAssign(dvdt, - o * Reciprocal(tau)))
        evaluate_wait_high_low.block.decl_relation(Integrate(o, dvdt, timestep=timestep))

        return evaluate_wait_high_low
    
    def create_evaluate_wait_low_high_state(fsm):
        evaluate_wait_low_high = Node('evaluate_wait_low_high')
        vref = evaluate_wait_low_high.block.decl_var('VREF', VarKind.Input, RealType (-1, 3.3, 0.01))
        vreg = evaluate_wait_low_high.block.decl_var('VREG', VarKind.Input, RealType (-1, 3.3, 0.01))
        o    = evaluate_wait_low_high.block.decl_var('o',  VarKind.StateVar, RealType(-1, 3.3, 0.1))  
        out  = evaluate_wait_low_high.block.decl_var('out',  VarKind.Output, o.type)

        wait_time_exp_lh = StateMaker.model_params.compute_low_high_response_time(evaluate_wait_low_high.block, vref, vreg)
        wait_time_lh = evaluate_wait_low_high.block.decl_var('wait_time_lh', VarKind.Transient, \
                                                          type=intervallib.real_type_from_expr(evaluate_wait_low_high.block, wait_time_exp_lh * Constant(1 / fsm.evaluate_dt), rel_prec = 0.001))
        
        evaluate_wait_low_high.block.decl_relation(VarAssign(wait_time_lh, wait_time_exp_lh * Constant(1 / fsm.evaluate_dt)))
        
        evaluate_wait_low_high.block.decl_relation(VarAssign(o, Constant(0.001)))
        evaluate_wait_low_high.block.decl_relation(VarAssign(out,o))

        ival_reg = intervallib.compute_intervals_for_block(evaluate_wait_low_high.block, rel_prec=0.001)
        return evaluate_wait_low_high
    
    def create_evaluate_low_low_high_state(timestep):
        evaluate_low_low_high = Node('evaluate_low_low_high')

        vref = evaluate_low_low_high.block.decl_var('VREF', VarKind.Input, RealType(-1, 3.3, 0.01))
        vreg = evaluate_low_low_high.block.decl_var('VREG', VarKind.Input, RealType(-1, 3.3, 0.01))
        o    = evaluate_low_low_high.block.decl_var('o',  VarKind.StateVar, RealType(-1, 3.7, 1e-9))  
        out  = evaluate_low_low_high.block.decl_var('out',  VarKind.Output, o.type)

        tau_exp = StateMaker.model_params.compute_low_high_tau( evaluate_low_low_high.block, vref, vreg )

        tau_lh = evaluate_low_low_high.block.decl_var('tau_lh', VarKind.Transient, \
                                                   type=intervallib.real_type_from_expr(evaluate_low_low_high.block, tau_exp, rel_prec = 0.00000001))
        
        dodt_expr = (Constant(3.3) - o) * Reciprocal( tau_lh )
        dodt = evaluate_low_low_high.block.decl_var('dodt', kind=VarKind.Transient, \
                                                     type=intervallib.real_type_from_expr(evaluate_low_low_high.block,dodt_expr, rel_prec=0.001)) #Changed precision

        evaluate_low_low_high.block.decl_relation(VarAssign(tau_lh, tau_exp))
        evaluate_low_low_high.block.decl_relation(VarAssign(out, o))
        evaluate_low_low_high.block.decl_relation(VarAssign(dodt, dodt_expr))
        evaluate_low_low_high.block.decl_relation(Integrate(o, dodt, timestep=timestep))

        ival_reg = intervallib.compute_intervals_for_block(evaluate_low_low_high.block, rel_prec=0.001)
        return evaluate_low_low_high
    


SIM_TICKS     = 40000
TICK_DIVISION = 10000
SYSTEM_CLOCK = 1e-6


initial_conditions = Initializer({'VREF': 2, 'VREG': 1.6, 'o': 3.3})

comparator_latch_fsm = FSMAMSBlock(SYSTEM_CLOCK, TICK_DIVISION, initial_conditions, "comparator_latch")

# [precharge] [evaluate_wait] [evaluate_low] [evaluate_wait] [evaluate_low_high]
precharge = StateMaker.create_precharge_state()
evaluate_wait_high_low = StateMaker.create_evaluate_wait_high_low_state(comparator_latch_fsm)
evaluate_low_high_low = StateMaker.create_evaluate_low_high_low_state(comparator_latch_fsm.evaluate_dt)
evaluate_wait_low_high = StateMaker.create_evaluate_wait_low_high_state(comparator_latch_fsm)
evaluate_low_low_high = StateMaker.create_evaluate_low_low_high_state(comparator_latch_fsm.evaluate_dt)


#[precharge] -posedge clk-> [evaluate_wait] [evaluate_low] []
precharge_to_eval_w_hl = Edge(precharge, evaluate_wait_high_low, ClockCondition(ClockCondition.Transition.POSEDGE, AnalogSignalCondition( 'VREF', (comparator_latch_fsm.state_vars['VREG'],float('inf')) ) ) ) 
#[precharge] -posedge clk-> [evaluate_wait] -duration-> [evaluate_low] []
evaluate_wait_hl_to_evaluate_lhl = Edge(evaluate_wait_high_low, evaluate_low_high_low, AnalogTimeCondition(evaluate_wait_high_low.block.get_var('wait_time')))#need to convert this to int and not frac
#[precharge] -posedge clk-> [evaluate_wait] -duration-> [evaluate_low] -negedge clk-> [evalate_wait]
evaluate_lhl_to_wait_llh = Edge(evaluate_low_high_low, evaluate_wait_low_high, ClockCondition(ClockCondition.Transition.NEGEDGE))
#[precharge] -posedge clk-> [evaluate_wait] -duration-> [evaluate_low] -negedge clk-> [evalate_wait] -duration-> [evaluate_low_high]
evaluate_wait_llh_to_evaluate_llh = Edge(evaluate_wait_low_high, evaluate_low_low_high, AnalogTimeCondition(evaluate_wait_low_high.block.get_var('wait_time_lh')))
#[precharge] -posedge clk-> [evaluate_wait] -duration-> [evaluate_low] -negedge clk-> [evalate_wait] -duration-> [evaluate_low_high] -signal  < 'o'-> [precharge]
evaluate_llh_to_precharge = Edge(evaluate_low_low_high, precharge, AnalogSignalCondition('o', ( 3.29, float('inf') ) ) )

comparator_latch_fsm.addNode(precharge)
comparator_latch_fsm.addNode(evaluate_wait_high_low)
comparator_latch_fsm.addNode(evaluate_low_high_low)
comparator_latch_fsm.addNode(evaluate_wait_low_high)
comparator_latch_fsm.addNode(evaluate_low_low_high)

print(comparator_latch_fsm.edges)
input()
comparator_latch_fsm.addEdge(precharge_to_eval_w_hl)
comparator_latch_fsm.addEdge(evaluate_wait_hl_to_evaluate_lhl)
comparator_latch_fsm.addEdge(evaluate_lhl_to_wait_llh)
comparator_latch_fsm.addEdge(evaluate_wait_llh_to_evaluate_llh)
comparator_latch_fsm.addEdge(evaluate_llh_to_precharge)

print(comparator_latch_fsm.edges)
input()

comparator_latch_fsm.starting_state = precharge
comparator_latch_fsm.reset()


def validate_model(blk,timestep,figname):
    #print(blk)
    
    os = []
    dodts = []
    tau = []
    ts = []
    oi = 3.3
    cycles_per_sec = round(1/timestep)
    print(cycles_per_sec)
    values = blocklib.execute_block(blk,{'VREF': 2, 'VREG': 1.6, 'o': oi})
    for t in tqdm(range(SIM_TICKS)):
    
        values = blocklib.execute_block(blk,values)
        
        ts.append(t*timestep)
        os.append(oi)
        #dodts.append(values['dvdt'])
        #tau.append(values['tau'])


        oi = values["o"]
        #print('dodt')
        #print("%e" % values['dodt'])
        #print('o')
        #print("%e" % values['o'])clk_period


    

    #os.append(oi)
    #ts.append(SIM_TICKS*timestep)\
    #dodts.append(0)

    plt.plot(ts,os, label='os')
    #plt.plot(ts, dodts, label='dodt')
    plt.legend(loc='best')
    plt.show()
    plt.clf()
    #plt.plot(ts, tau, label='tau')
    #plt.legend(loc='best')
    #plt.show()

def validate_pymtl_model(rtlblk,timestep,clk_period):
    outs = []
    ts = []
    clk_arr = []
    cycles_per_sec = round(1/timestep)
    max_cycles = 30*cycles_per_sec
    clk = 0
    for t in tqdm(range(SIM_TICKS)):
        
        values = rtlblk.pymtl_sim_tick({"VREG":Bits(rtlblk.block.get_var('VREG').type.nbits, v=rtlblk.scale_value_to_int(1.7,rtlblk.block.get_var('VREG').type)),
                                        "VREF":Bits(rtlblk.block.get_var('VREF').type.nbits, v=rtlblk.scale_value_to_int(2,rtlblk.block.get_var('VREF').type)),
                                        "sys_clk":Bits(1,v=clk)})
        print(values)

        if(clk == 1 and math.fmod(t * timestep, clk_period ) < clk_period / 2):   
            clk = 0
        elif(clk == 0 and math.fmod(t * timestep, clk_period ) > clk_period / 2):
            clk = 1
        
        clk_arr.append(clk * 3.3)
        ts.append(t*timestep)
        outi = values["out"]
        print(outi)

        outs.append(rtlblk.scale_value_to_real(outi, rtlblk.block.get_var('out').type))

    plt.plot(ts,outs, label='out')
    plt.plot(ts,clk_arr, label='clk')
    plt.legend(loc='best')
    plt.show()
    #plt.savefig(figname)
    #plt.clf()


o = np.zeros(SIM_TICKS)
t = np.linspace(0, SYSTEM_CLOCK * SIM_TICKS / TICK_DIVISION, SIM_TICKS)



    
#plt.plot(t,o)
#plt.xlabel('')
#plt.savefig("resp.png")


ival_reg = intervallib.compute_intervals_for_block(precharge.block, rel_prec = 0.001)
#validate_model(precharge.block, SYSTEM_CLOCK/TICK_DIVISION, "low_low_high_intmodel")

#evaluate_low_low_high.block.pretty_print_relations()

fp_block = fixlib.to_fixed_point(ival_reg,precharge.block)
#validate_model(fp_block, SYSTEM_CLOCK/TICK_DIVISION, "low_low_high_intmodel")

fp_block.pretty_print_relations()

int_block = intlib.to_integer(fp_block)
#validate_model(int_block, SYSTEM_CLOCK/TICK_DIVISION, "low_low_high_intmodel")
int_block.pretty_print_relations()
int_block.pretty_print_types()


rtl_block = rtllib.RTLBlock(int_block,{'o':3.3})

rtl_block.generate_verilog_src("./core/")
rtl_block.generate_pymtl_wrapper()
rtl_block.pymtl_sim_begin()
#validate_pymtl_model(rtl_block, SYSTEM_CLOCK/TICK_DIVISION, SYSTEM_CLOCK)

"""
rtl_block = rtllib.RTLBlock(int_block,{'o':0})

rtl_block.generate_verilog_src("./core/")
rtl_block.generate_pymtl_wrapper()
rtl_block.pymtl_sim_begin()
"""
comparator_latch_fsm.preprocessHierarchy(rel_prec = 0.0001, override_dict = {'wait_time':IntType(nbits = 32, scale = 1.0, signed = 0)})
rtl_fsm = rtllib.RTLBlock(comparator_latch_fsm,{'o':3.3})
rtl_fsm.generate_verilog_src("./core/")
rtl_fsm.generate_pymtl_wrapper()
rtl_fsm.pymtl_sim_begin()
print(rtl_fsm.block.get_var('out').type)


validate_pymtl_model(rtl_fsm, SYSTEM_CLOCK/TICK_DIVISION, SYSTEM_CLOCK)


