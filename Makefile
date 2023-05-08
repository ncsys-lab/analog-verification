.PHONY: all clean tags
.SUFFIXES:

DEPS=svreal.sv msdsl.sv

%.model.sv: %.model.py
	./$< > $@

%.v: %.sv
	sv2v $< > $@

%.model.f: %.model.sv sv2f.sh $(DEPS)
	./sv2f.sh $< $*_model > $@

%.f.sv: %.f
	firtool -O=release -format=fir -o $@ $<

%.vvp: %.tb.sv %.model.f.v
	iverilog -g2005-sv $< -o $@

%.btor: %.assert.sv sv2btor.sh %.model.f.v
	./sv2btor.sh $< $*_assert > $@

%.vcd: %.vvp
	./$<

all: rc.vcd rc.btor

tags:
	ctags -R .

clean:
	rm -f *.vcd *.vvp *.f.v *.f.sv *.f *.v *.btor *.model.sv tags
