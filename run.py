import models.vco as vco
import core.fixedpoint as fixlib
import core.integer as intlib
import core.block as blocklib
import matplotlib.pyplot as plt

def validate_model(blk,figname):
    print(blk)
    xi,vi = 0.0,1.0
    xs = []
    vs = []
    for t in range(10000):
        values = blocklib.execute_block(blk,{"w":0.5, "x": xi, "v": vi})
        xs.append(xi)
        vs.append(vi)
        xi = values["x"]
        vi = values["v"]

    xs.append(xi)
    vs.append(vi)

    plt.plot(xs)
    plt.plot(vs)
    plt.savefig(figname)
    plt.clf()

block = vco.make_vco(timestep=1e-2)
validate_model(block, "orig_dynamics.png")
fp_block = fixlib.to_fixed_point(block)
validate_model(fp_block, "fp_dynamics.png")
int_block = intlib.to_integer(fp_block)
validate_model(int_block, "int_dynamics.png")