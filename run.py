import models.vco as vco
import core.fixedpoint as fixlib
import core.integer as intlib
import core.intervals as intervallib
import core.block as blocklib
import matplotlib.pyplot as plt
import core.rtl as rtllib
from pymtl3 import *

def validate_model(blk,timestep,figname):
    print(blk)
    xi,vi = 1.0,0.0
    xs = []
    vs = []
    ts = []
    cycles_per_sec = round(1/timestep)
    max_cycles = 30*cycles_per_sec
    for t in range(max_cycles):
        values = blocklib.execute_block(blk,{"w":0.5, "x": xi, "v": vi})
        ts.append(t*timestep)
        xs.append(xi)
        vs.append(vi)
        xi = values["x"]
        vi = values["v"]

    xs.append(xi)
    vs.append(vi)
    ts.append(max_cycles*timestep)

    plt.plot(ts,xs)
    plt.plot(ts,vs)
    plt.savefig(figname)
    plt.clf()


def validate_pymtl_model(rtlblk,timestep,figname):
    print(rtlblk)
    outs = []
    ts = []
    cycles_per_sec = round(1/timestep)
    max_cycles = 30*cycles_per_sec
    for t in range(max_cycles):
        values = rtlblk.pymtl_sim_tick({"w":Bits(rtlblk.block.get_var('w').type.nbits, v=rtlblk.scale_value_to_int(0.75,rtlblk.block.get_var('w').type))})
        ts.append(t*timestep)
        outi = values["out"]
        outs.append(outi)

   

    plt.plot(ts,outs)
    plt.show()
    #plt.savefig(figname)
    #plt.clf()

rel_prec=0.0001
timestep=1e-2
block = vco.make_vco(timestep=timestep,rel_prec=rel_prec)
ival_reg = intervallib.compute_intervals_for_block(block,rel_prec=rel_prec)
print("------ Real-valued AMS Block -----")
print(block)
print("\n")
input("press any key to run simulation..")
validate_model(block, timestep, "orig_dynamics.png")


fp_block = fixlib.to_fixed_point(ival_reg, block)
print("------ Fixed Point AMS Block -----")
print(fp_block)
print("\n")
input("press any key to run simulation..")
validate_model(fp_block, timestep, "fp_dynamics.png")

int_block = intlib.to_integer(fp_block)
print("------ Integer AMS Block -----")
print(int_block)
print("\n")
input("press any key to run simulation..")
validate_model(int_block, timestep, "int_dynamics.png")


rtl_block = rtllib.RTLBlock(int_block)

rtl_block.generate_verilog_src("./core/")
rtl_block.generate_pymtl_wrapper()
rtl_block.pymtl_sim_begin()
validate_pymtl_model(rtl_block,timestep,"rtl_dynamics.png")