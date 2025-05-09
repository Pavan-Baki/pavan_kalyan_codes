class phy_tx_agent extends uvm_agent;
phy_tx_drv drv;
phy_tx_mon mon;

`uvm_component_utils(phy_tx_agent)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	drv = phy_tx_drv::type_id::create("drv", this);
	mon = phy_tx_mon::type_id::create("mon", this);
endfunction
 
endclass

