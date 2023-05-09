TARGETS=rc vco
.PHONY: all clean tags
.SUFFIXES:

DEPS=svreal.sv msdsl.sv

%.model.sv: %.model.py Makefile
	# echo '`define CLK_MSDSL clk' > $@ && \
	# echo '`define RST_MSDSL rst' >> $@ && \
	# ./$< >> $@
	./$< > $@

%.v: %.sv Makefile
	sv2v $< > $@

%.model.f: %.model.sv sv2f.sh $(DEPS) Makefile
	./sv2f.sh $< $*_model > $@

%.f.sv: %.f Makefile
	firtool -O=release -format=fir -o $@ $<

# %.f.sv: %.sv Makefile
# 	./sv2sv.sh $< $*_model > $@

%.vvp: %.tb.sv %.model.f.v Makefile
	iverilog -g2005-sv $< -o $@

%.btor: %.assert.sv sv2btor.sh %.model.f.v Makefile
	./sv2btor.sh $< $*_assert > $@

%.vcd: %.vvp Makefile
	./$<

all: $(TARGETS:=.vcd)

tags:
	ctags -R .

clean:
	rm -f *.vcd *.vvp *.f.v *.f.sv *.f *.v *.btor *.model.sv tags
