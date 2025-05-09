class ethmac_env extends uvm_env;

wb_proc_agent	proc_agent_i;
wb_mem_agent 	mem_agent_i;
phy_tx_agent 	tx_agent_i;
phy_rx_agent 	rx_agent_i;
miim_agent   	miim_agent_i;
mac_sbd        sbd;

mac_reg_block   reg_block; //reg model instantiation
wb_adapter      adapter;

`uvm_component_utils(ethmac_env)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	proc_agent_i	= wb_proc_agent::type_id::create("proc_agent_i", this);
	mem_agent_i 	= wb_mem_agent::type_id::create("mem_agent_i", this);
	tx_agent_i  	= phy_tx_agent::type_id::create("tx_agent_i", this);
	rx_agent_i 	   = phy_rx_agent::type_id::create("rx_agent_i", this);
	miim_agent_i 	= miim_agent::type_id::create("miim_agent_i", this);
	reg_block   	= mac_reg_block::type_id::create("reg_block", this);
	adapter        = wb_adapter::type_id::create("adapter", this);
	sbd            = mac_sbd::type_id::create("sbd", this);
	reg_block.build();
	uvm_resource_db#(mac_reg_block)::set("GLOBAL", "MAC_RM", reg_block, this);
endfunction

//connect phase 
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	reg_block.wb_map.set_sequencer(proc_agent_i.sqr, adapter);
	proc_agent_i.mon.ap_port.connect(sbd.imp_proc);//proc mon connect with sbd 
	mem_agent_i.mon.ap_port.connect(sbd.imp_mem);//proc mon connect with sbd 
	tx_agent_i.mon.ap_port.connect(sbd.imp_tx);//proc mon connect with sbd 
	rx_agent_i.mon.ap_port.connect(sbd.imp_rx);//proc mon connect with sbd 
endfunction 
 
endclass


