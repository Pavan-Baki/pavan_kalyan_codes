#compilation 
vlog  +incdir+../../RTL ../TOP/top_tb.sv \
+incdir+/home/tools/mentor/MENTOR_INSTALL/questa2022_2/questasim/verilog_src/uvm-1.2/src \
+incdir+../TOP \
+incdir+../PHY \
+incdir+../MII \
+incdir+../WB \
+incdir+../MEM \
+incdir+../SBD

#regression run command by tcl script 
set fp [open "testlist.txt" r]
while {[gets $fp testname] >= 0} {
	variable time [format "%s" [clock format [clock seconds] -format %Y%m%d_%H%M%S]]
	set log_f "$testname\_$time\.log"
	set ucdb_f "$testname\.ucdb"

	#optimization
   vopt top +cover=fcbest -o $testname
	
	vsim -novopt -suppress 12110\
	-coverage $testname -suppress 16132\
	-sv_lib /home/tools/mentor/MENTOR_INSTALL/questa2022_2/questasim/uvm-1.2/linux_x86_64/uvm_dpi\
	+UVM_TESTNAME=$testname +UVM_VERBOSITY=UVM_LOW -l $log_f

	#save coverage database
	coverage save -onexit $ucdb_f
	
	#to add waveform 
	#do wave.do
	
	#run -all
	
	#run 11400
	force -freeze sim:/top/dut/macstatus1/LatchedCrcError 1'h0 0
	#force -deposit sim:/top/dut/macstatus1/LatchedCrcError 1'h0 0
	run -all
}

