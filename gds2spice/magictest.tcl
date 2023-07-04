#Pass techfile through command line!


set PDK_PATH [lindex $argv 0]
set GDS [lindex $argv 1]

puts $PDK_PATH

set argc 2
set argv {-noconsole -dnull}
source /usr/local/lib/magic/tcl/magic.tcl 

tech load $PDK_PATH

gds read $GDS

cellname allcells

getcell LDO_COMPARATOR_LATCH
load LDO_COMPARATOR_LATCH

what

extract all 

ext2spice lvs 

ext2spice 

exit

