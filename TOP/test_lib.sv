class ethmac_base_test extends uvm_test;

ethmac_env env;

`uvm_component_utils(ethmac_base_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	env = ethmac_env::type_id::create("env", this);
endfunction
 
function void end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction

function void report_phase(uvm_phase phase);
	if(mac_common::num_mismatches == 0) begin 
		`uvm_info("STATUS", "Test is Passing", UVM_NONE)
	end
	else begin 
		`uvm_info("STATUS", "Test is Failing", UVM_NONE)
	end 
endfunction

endclass

//register rst value read testcase
class mac_reg_read_test extends ethmac_base_test;

`uvm_component_utils(mac_reg_read_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	wb_reg_read_seq read_seq;
	read_seq = wb_reg_read_seq::type_id::create("read_seq");
	phase.raise_objection(this);
	read_seq.start(env.proc_agent_i.sqr);
	phase.phase_done.set_drain_time(this, 100);
	phase.drop_objection(this);
endtask

endclass
 
//register write and read testcase
class mac_reg_write_read_test extends ethmac_base_test;

`uvm_component_utils(mac_reg_write_read_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	wb_reg_write_read_seq write_read_seq;
	write_read_seq = wb_reg_write_read_seq::type_id::create("write_read_seq");
	phase.raise_objection(this);
	write_read_seq.start(env.proc_agent_i.sqr);
	phase.phase_done.set_drain_time(this, 100);
	phase.drop_objection(this);
endtask

endclass
 
//random register write and read testcase
class mac_random_reg_write_read_test extends ethmac_base_test;

`uvm_component_utils(mac_random_reg_write_read_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	wb_reg_rand_write_read_seq write_read_seq;
	write_read_seq = wb_reg_rand_write_read_seq::type_id::create("write_read_seq");
	phase.raise_objection(this);
	write_read_seq.start(env.proc_agent_i.sqr);
	phase.phase_done.set_drain_time(this, 100);
	phase.drop_objection(this);
endtask

endclass

 
//random register write and read testcase(with unique addr)
class mac_random_reg_wr_nr_test extends ethmac_base_test;

`uvm_component_utils(mac_random_reg_wr_nr_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	wb_reg_rand_wr_nr_seq write_read_seq;
	write_read_seq = wb_reg_rand_wr_nr_seq::type_id::create("write_read_seq");
	phase.raise_objection(this);
	write_read_seq.start(env.proc_agent_i.sqr);
	phase.phase_done.set_drain_time(this, 100);
	phase.drop_objection(this);
endtask

endclass


//register write and read with register model testcase 
class mac_reg_write_read_reg_model_test extends ethmac_base_test;

`uvm_component_utils(mac_reg_write_read_reg_model_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	wb_reg_write_read_reg_model_seq write_read_seq;
	write_read_seq = wb_reg_write_read_reg_model_seq::type_id::create("write_read_seq");
	phase.raise_objection(this);
	write_read_seq.start(env.proc_agent_i.sqr);
	phase.phase_done.set_drain_time(this, 100);
	phase.drop_objection(this);
endtask

endclass 



//register backdoor write read with register model testcase 
class mac_bd_reg_wr_rd_rm_test extends ethmac_base_test;

`uvm_component_utils(mac_bd_reg_wr_rd_rm_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	wb_reg_bd_wr_rd_rm_seq write_read_seq;
	write_read_seq = wb_reg_bd_wr_rd_rm_seq::type_id::create("write_read_seq");
	phase.raise_objection(this);
	write_read_seq.start(env.proc_agent_i.sqr);
	phase.phase_done.set_drain_time(this, 100);
	phase.drop_objection(this);
endtask

endclass 



//register read with register model testcase(Reset value read)
class mac_reg_rd_rm_test extends ethmac_base_test;

`uvm_component_utils(mac_reg_rd_rm_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	wb_reg_rd_rm_seq rd_seq;
	rd_seq = wb_reg_rd_rm_seq::type_id::create("rd_seq");
	phase.raise_objection(this);
	rd_seq.start(env.proc_agent_i.sqr);
	phase.phase_done.set_drain_time(this, 100);
	phase.drop_objection(this);
endtask

endclass 


//full duplex 10 and 100 mbps  testcase
class mac_fd_test extends ethmac_base_test;

`uvm_component_utils(mac_fd_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	//uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 400, this); //10 Mbps speed (1/10*1024*1024 = 10**-7 => 4/10**7bps(for every +ve edge of clk we transmit 4 bit) = 0.4 micro sec => 400ns => 2.5 Mhz)(Mbps to Mhz conversion)
	uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 40, this); //100 Mbps speed (1/100*1024*1024 = 10**-8 => 4/10**8bps(for every +ve edge of clk we transmit 4 bit) = 0.04 micro sec => 40ns => 25 Mhz)(Mbps to Mhz conversion)

	mac_common::exp_isrc_val = 7'b000_0001;
endfunction

task run_phase(uvm_phase phase);
	wb_fd_tx_seq fd_seq = wb_fd_tx_seq::type_id::create("fd_seq");
	wb_isr_seq isr_seq  = wb_isr_seq::type_id::create("isr_seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 1500);
	//trigger the seq and move to the next statement using fork join none  
	fork
		isr_seq.start(env.proc_agent_i.sqr);
	join_none 	
	fd_seq.start(env.proc_agent_i.sqr);
	wait(mac_common::int_o_asserted == 1'b1);
	phase.drop_objection(this);
endtask

endclass


//rx => full duplex 10 and 100 mbps  testcase
class mac_fd_rx_test extends ethmac_base_test;

`uvm_component_utils(mac_fd_rx_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	//uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 400, this); //10 Mbps speed (1/10*1024*1024 = 10**-7 => 4/10**7bps(for every +ve edge of clk we transmit 4 bit) = 0.4 micro sec => 400ns => 2.5 Mhz)(Mbps to Mhz conversion)
	uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 40, this); //100 Mbps speed (1/100*1024*1024 = 10**-8 => 4/10**8bps(for every +ve edge of clk we transmit 4 bit) = 0.04 micro sec => 40ns => 25 Mhz)(Mbps to Mhz conversion)

	mac_common::exp_isrc_val = 7'b000_0001;
endfunction

task run_phase(uvm_phase phase);
	wb_fd_rx_seq fd_seq = wb_fd_rx_seq::type_id::create("fd_seq");
	wb_isr_seq isr_seq  = wb_isr_seq::type_id::create("isr_seq");
	phy_rx_gf_seq gf_seq = phy_rx_gf_seq::type_id::create("gf_seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 500);
	//trigger the seq and move to the next statement using fork join none  
	fork
		isr_seq.start(env.proc_agent_i.sqr);
	join_none 	
	fd_seq.start(env.proc_agent_i.sqr);
	gf_seq.start(env.rx_agent_i.sqr);
	wait(mac_common::int_o_asserted == 1'b1);
	phase.drop_objection(this);
endtask

endclass



//FD Tx and Rx testcase(Concurrent)
class mac_fd_tx_rx_test extends ethmac_base_test;

`uvm_component_utils(mac_fd_tx_rx_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	//uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 400, this); 
	uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 40, this); 
endfunction

task run_phase(uvm_phase phase);
	wb_fd_tx_rx_seq fd_seq = wb_fd_tx_rx_seq::type_id::create("fd_seq");
	wb_isr_seq isr_seq  = wb_isr_seq::type_id::create("isr_seq");
	phy_rx_gf_seq gf_seq = phy_rx_gf_seq::type_id::create("gf_seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 500);
	//trigger the seq and move to the next statement using fork join none  
	fork
		isr_seq.start(env.proc_agent_i.sqr);
	join_none 	
	fd_seq.start(env.proc_agent_i.sqr);
	gf_seq.start(env.rx_agent_i.sqr);
	mac_common::exp_isrc_val = 7'b000_0100;
	wait(mac_common::int_o_asserted == 1'b1);//rxb irq
	#100;
	mac_common::exp_isrc_val = 7'b000_0001;
	wait(mac_common::int_o_asserted == 1'b1);//txb irq
	phase.drop_objection(this);
endtask

endclass
    
//MII WCTRL DATA Tx testcase
class mac_mii_wctrl_data_tx_test extends ethmac_base_test;

`uvm_component_utils(mac_mii_wctrl_data_tx_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	//uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 400, this); 
	uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 40, this); 
endfunction

task run_phase(uvm_phase phase);
	mii_wctrl_data_tx_seq mii_tx_seq = mii_wctrl_data_tx_seq::type_id::create("mii_tx_seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 10000);
	mii_tx_seq.start(env.proc_agent_i.sqr);
	phase.drop_objection(this);
endtask

endclass

//Half duplex collision Detection (10 and 100 mbps) testcase
class mac_hd_tx_coll_det_test extends ethmac_base_test;

`uvm_component_utils(mac_hd_tx_coll_det_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_reg::include_coverage("*", UVM_CVR_ALL, this); //to include coverage from reg model 
	//uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 400, this); //10 Mbps speed (1/10*1024*1024 = 10**-7 => 4/10**7bps(for every +ve edge of clk we transmit 4 bit) = 0.4 micro sec => 400ns => 2.5 Mhz)(Mbps to Mhz conversion)
	uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 40, this); //100 Mbps speed (1/100*1024*1024 = 10**-8 => 4/10**8bps(for every +ve edge of clk we transmit 4 bit) = 0.04 micro sec => 40ns => 25 Mhz)(Mbps to Mhz conversion)

	mac_common::exp_isrc_val = 7'b000_0001;
endfunction

task run_phase(uvm_phase phase);
	wb_hd_tx_seq hd_seq = wb_hd_tx_seq::type_id::create("hd_seq");
	wb_isr_seq isr_seq  = wb_isr_seq::type_id::create("isr_seq");
	phy_coll_det_seq coll_det_seq  = phy_coll_det_seq::type_id::create("coll_det_seq");
	coll_det_seq.randomize() with {delay == 1700;};
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 100);
	fork
		isr_seq.start(env.proc_agent_i.sqr);
	join_none 	
	hd_seq.start(env.proc_agent_i.sqr);
	coll_det_seq.start(env.rx_agent_i.sqr);
	coll_det_seq  = new("coll_det_seq");
	//coll_det_seq.randomize() with {delay == 1700;}; //immediate retransmission 
	coll_det_seq.randomize() with {delay == 7500;}; // backoff algo, 2nd retry
	coll_det_seq.start(env.rx_agent_i.sqr);
	wait(mac_common::int_o_asserted == 1'b1);
	phase.drop_objection(this);
endtask

endclass


//pause frame testcase
class mac_fd_tx_pause_frame_test extends ethmac_base_test;

`uvm_component_utils(mac_fd_tx_pause_frame_test)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_reg::include_coverage("*", UVM_CVR_ALL, this); //to include coverage from reg model 
	//uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 400, this); //10 Mbps speed (1/10*1024*1024 = 10**-7 => 4/10**7bps(for every +ve edge of clk we transmit 4 bit) = 0.4 micro sec => 400ns => 2.5 Mhz)(Mbps to Mhz conversion)
	uvm_resource_db#(int)::set("GLOBAL", "CLK_TP", 40, this); //100 Mbps speed (1/100*1024*1024 = 10**-8 => 4/10**8bps(for every +ve edge of clk we transmit 4 bit) = 0.04 micro sec => 40ns => 25 Mhz)(Mbps to Mhz conversion)

	mac_common::exp_isrc_val = 7'b000_0001;
endfunction

task run_phase(uvm_phase phase);
	wb_fd_tx_pf_seq fd_seq = wb_fd_tx_pf_seq::type_id::create("fd_seq");
	wb_isr_seq isr_seq  = wb_isr_seq::type_id::create("isr_seq");
	phy_pause_frame_seq pause_frame_seq  = phy_pause_frame_seq::type_id::create("pause_frame_seq");
	pause_frame_seq.randomize() with {delay == 1700;};
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 100);
	fork
		isr_seq.start(env.proc_agent_i.sqr);
	join_none 	
	fd_seq.start(env.proc_agent_i.sqr);
	pause_frame_seq.start(env.rx_agent_i.sqr);
	wait(mac_common::int_o_asserted == 1'b1);
	phase.drop_objection(this);
endtask

endclass

