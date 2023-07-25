#Pass techfile through command line!


set PDK_PATH [lindex $argv 0]
set GDS [lindex $argv 1]

puts $PDK_PATH

set file [file tail $GDS]

puts $file

set argc 2
set argv {-noconsole -dnull}
source /usr/local/lib/magic/tcl/magic.tcl 

tech load $PDK_PATH

gds read $GDS

cellname allcells

puts $file
puts [ expr { [string first "." $file]} ]
set filename [string range $file 0 [ expr { [string first "." $file]} ] ]

puts HERE
if {$filename == "vref_gen_nmos_with_trim"} {
    puts appears to be equal
} else {
    puts $filename
}

puts $filename
getcell $file
load $file

what

extract all 

ext2spice lvs 

ext2spice 

exit

