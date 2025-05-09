#compilation 
vlog  +incdir+../../RTL ../TOP/top_tb.sv \
+incdir+/C:/questasim64_10.6c/verilog_src/uvm-1.2/src \
+incdir+../TOP \
+incdir+../PHY \
+incdir+../MII \
+incdir+../WB \
+incdir+../MEM \
+incdir+../SBD

#to print log file with time format
set testname mac_fd_tx_pause_frame_test
variable time [format "%s" [clock format [clock seconds] -format %Y%m%d_%H%M%S]]
set log_f "$testname\_$time\.log"

#Elaboration and simulation  
#vsim -novopt -suppress 12110 -sv_lib /home/tools/mentor/MENTOR_INSTALL/questa2022_2/questasim/uvm-1.2/linux_x86_64/uvm_dpi top +UVM_TESTNAME=$testname +UVM_VERBOSITY=UVM_LOW -l $log_f
vsim -novopt -suppress 12110 -sv_lib top +UVM_TESTNAME=$testname +UVM_VERBOSITY=UVM_LOW -l $log_f

#to add waveform 
do wave.do

#run -all

#run 11400
force -freeze sim:/top/dut/macstatus1/LatchedCrcError 1'h0 0
#force -deposit sim:/top/dut/macstatus1/LatchedCrcError 1'h0 0
run -all

