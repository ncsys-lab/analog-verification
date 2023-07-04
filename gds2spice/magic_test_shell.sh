export PDK_ROOT=~/Desktop/AchourLab/open_pdks/sky130/sky130A/libs.tech/magic/sky130A.tech
export GDS=~/Desktop/AchourLab/OpenFASOC/openfasoc/generators/ldo-gen/blocks/sky130hvl/gds/LDO_COMPARATOR_LATCH.gds
#runs magic in terminal

tclsh magictest.tcl $PDK_ROOT $GDS
