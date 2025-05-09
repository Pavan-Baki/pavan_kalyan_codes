class phy_rx_agent extends uvm_agent;
phy_rx_drv drv;
phy_rx_sqr sqr;
phy_rx_mon mon;

`uvm_component_utils(phy_rx_agent)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	drv = phy_rx_drv::type_id::create("drv", this);
	sqr = phy_rx_sqr::type_id::create("sqr", this);
	mon = phy_rx_mon::type_id::create("mon", this);
endfunction

function void connect_phase(uvm_phase phase);
	drv.seq_item_port.connect(sqr.seq_item_export);
endfunction 
 
endclass
