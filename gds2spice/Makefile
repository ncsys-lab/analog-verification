export PDK_ROOT?=~/Desktop/AchourLab/open_pdks/sky130/sky130A/libs.tech/magic/sky130A.tech
#runs magic in terminal

%.spice: %.gds
	echo %
	tclsh magictest.tcl $(PDK_ROOT) ./$* 

clean: 
	rm *.ext