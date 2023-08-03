from core.fsmblock import *
import core.intervals as intervallib
import yaml

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
        return VREF * VREF_to_tau  + VREG * VREG_to_tau  + const_tau

    def compute_high_low_response_time(self, VREF, VREG):
        return VREF * self.high_low_paramdict_resptime['VREF_to_response_time'] + VREG * self.high_low_paramdict_resptime['VREG_to_response_time'] + self.high_low_paramdict_resptime['const_response_time']

    def compute_low_high_tau(self, VREF, VREG):
        return VREF * self.low_high_paramdict_tau['VREF_to_tau'] + VREG * self.low_high_paramdict_tau['VREG_to_tau'] + self.low_high_paramdict_tau['const_tau']

    def compute_high_low_response_time(self, VREF, VREG):
        return VREF * self.low_high_paramdict_resptime['VREF_to_response_time'] + VREG * self.low_high_paramdict_resptime['VREG_to_response_time'] + self.low_high_paramdict_resptime['const_response_time']
    


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

        evaluate_wait_high_low.block.decl_relation(VarAssign(o,Constant(3.3)))
        evaluate_wait_high_low.block.decl_relation(VarAssign(out,o))
        return evaluate_wait_high_low

    def create_evaluate_low_high_low_state(timestep):
        evaluate_wait_high_low = Node('evaluate_low_high_low')
        vref = evaluate_wait_high_low.block.decl_var('VREF', VarKind.Input, RealType(0.0, 1.7, 0.01))
        vreg = evaluate_wait_high_low.block.decl_var('VREG', VarKind.Input, RealType(0.0, 3.3, 0.01))
        o    = evaluate_wait_high_low.block.decl_var('o',  VarKind.StateVar, RealType(0, 3.3, 0.1))  
        out  = evaluate_wait_high_low.block.decl_var('out',  VarKind.Output, o.type)

        tau_exp = StateMaker.model_params.compute_high_low_tau(evaluate_wait_high_low.block, vref, vreg)
        tau  = evaluate_wait_high_low.block.decl_var('tau', kind=VarKind.Transient,  \
            type=intervallib.real_type_from_expr(evaluate_wait_high_low.block, tau_exp , rel_prec=0.01))
        print("HEREHEREHERE")
        print(tau.type)
        dodt = evaluate_wait_high_low.block.decl_var("dvdt", kind=VarKind.Transient,  \
            type=intervallib.real_type_from_expr(evaluate_wait_high_low.block, o / tau, rel_prec=0.01))

        tau_exp = evaluate_wait_high_low.block.decl_relation(VarAssign(tau,tau_exp))
        evaluate_wait_high_low.block.decl_relation(VarAssign(out,o))
        evaluate_wait_high_low.block.decl_relation(VarAssign(dodt,o / tau))
        evaluate_wait_high_low.block.decl_relation(Integrate(o, dodt, timestep=timestep))
        return evaluate_wait_high_low


    




initial_conditions = Initializer({'VREF': 3.3, 'VREG': 1.6, 'o': 3.3})

comparator_latch_fsm = FSMAMSBlock(1e-6, 10, initial_conditions)


precharge = StateMaker.create_precharge_state()
evaluate_wait_high_low = StateMaker.create_evaluate_wait_high_low_state()
evaluate_low_high_low = StateMaker.create_evaluate_low_high_low_state(comparator_latch_fsm.evaluate_dt)


precharge_to_eval_w_hl = Edge(precharge, evaluate_wait_high_low, ClockCondition(ClockCondition.Transition.POSEDGE))
evaluate_wait_hl_to_evaluate_lhl = Edge(evaluate_wait_high_low, evaluate_low_high_low, NoCondition())

comparator_latch_fsm.addNode(precharge)
comparator_latch_fsm.addNode(evaluate_wait_high_low)
comparator_latch_fsm.addNode(evaluate_low_high_low)

comparator_latch_fsm.addEdge(precharge_to_eval_w_hl)
comparator_latch_fsm.addEdge(evaluate_wait_hl_to_evaluate_lhl)

comparator_latch_fsm.starting_state = precharge
comparator_latch_fsm.reset()


for _ in range(30):
    comparator_latch_fsm.evaluationClockTick()
    print(comparator_latch_fsm.state.name)



