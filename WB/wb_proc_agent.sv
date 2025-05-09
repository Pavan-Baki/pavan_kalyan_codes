class wb_proc_agent extends uvm_agent;

wb_proc_drv drv;
wb_proc_sqr sqr;
wb_proc_mon mon;
wb_proc_cov cov;

`uvm_component_utils(wb_proc_agent)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	drv = wb_proc_drv::type_id::create("drv", this);
	sqr = wb_proc_sqr::type_id::create("sqr", this);
	mon = wb_proc_mon::type_id::create("mon", this);
	cov = wb_proc_cov::type_id::create("cov", this);
endfunction

function void connect_phase(uvm_phase phase);
	drv.seq_item_port.connect(sqr.seq_item_export);
	mon.ap_port.connect(cov.analysis_export);
endfunction  
 
endclass

