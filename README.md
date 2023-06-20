# Analog Verification Pipeline

## Current Pipeline

The current pipeline is split into two parts:
* analog behavioral models: `models`
* an msdsl-to-verilog optimizing pass: `docker`

The analog behavioral models can be generated using a Python frontend, as in
`ode/main.py` (which is also `models/vco.py`).

### Differential Equation Frontend

The frontend in `ode/main.py` converts a behavioral model specified as a
differential equation into verilog, via [msdsl](msdsl) and [svreal](svreal).

It relies on the Python packages specified in `docker/requirements.txt`, which
are `msdsl`, `svreal`, and `sympy`.

### Docker

The Docker container wraps up a couple of different steps:
1. running the Python script provided over `stdin`, which should produce valid
   SystemVerilog that includes `svreal.sv` and `msdsl.sv`
2. converting the SystemVerilog to Verilog
3. converting the Verilog to FIRRTL
4. converting the FIRRTL to optimized SystemVerilog (using [LLVM
   `firtool`](circt))
5. converting the SystemVerilog back to Verilog
6. outputting the Verilog over `stdout`

It expects the name of the top-level module to be specified in the
`$MODEL_NAME` environment variable.  For example:

    docker run -e MODEL_NAME=vco -i msdsl-optimizer < input.py > output.v

## Old Pipeline: `pipeline`

This performs similar steps to the Docker pipeline, but uses a Makefile for
incremental compilation.  This folder additionally contains testbenches, both
for simulation with `iverilog` and verification with `btormc`.

## Fixture Setup: `fixture-setup`

This contains an incomplete Dockerfile to run [`fixture`](fixture), which can
extract a behavioral model from a component-level description of an analog
circuit.  It can be run on the provided examples thus:

    docker run -it -v.:/data fixture ctle.yaml

It uses `/data` as the working directory within the container.

[fixture]: https://github.com/standanley/fixture
[msdsl]: https://github.com/sgherbst/msdsl/tree/master
[svreal]: https://github.com/sgherbst/svreal
[circt]: https://github.com/llvm/circt
