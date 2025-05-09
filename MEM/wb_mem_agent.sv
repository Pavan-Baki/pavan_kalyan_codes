class wb_mem_agent extends uvm_agent;

memory mem;
wb_mem_mon mon;

`uvm_component_utils(wb_mem_agent)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	mem = memory::type_id::create("mem", this);
	mon = wb_mem_mon::type_id::create("mon", this);
endfunction
 
endclass
