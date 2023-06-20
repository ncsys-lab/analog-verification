FROM fedora:latest
RUN dnf -y update && dnf install -y which git patch make python3.9 ngspice && dnf clean all
RUN python3.9 -m ensurepip
WORKDIR /app

RUN git clone https://github.com/standanley/fixture.git
RUN git clone https://github.com/standanley/fault.git -b fixture_additions
WORKDIR /app/fixture/sky130
RUN sh install.sh

WORKDIR /app
RUN python3.9 -m pip install -e /app/fault
RUN python3.9 -m pip install -r /app/fixture/requirements.txt
RUN python3.9 -m pip install -e /app/fixture

# the provided configs seem to have incorrect relative paths? replacing with absolute makes them work
RUN sed -i 's#"\.\./sky130#/app/fixture/sky130#' fixture/tests/configs/*.yaml
RUN sed -i 's#"\.\./sky130#/app/fixture/sky130#' fixture/tests/spice/*.sp

WORKDIR /data
ENTRYPOINT ["python3.9", "-m", "fixture.run"]
# ENTRYPOINT ["bash", "-i"]
