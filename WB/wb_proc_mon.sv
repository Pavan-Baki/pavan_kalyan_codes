class wb_proc_mon extends uvm_monitor;

virtual wb_proc_intf vif;
wb_tx tx;
uvm_analysis_port#(wb_tx) ap_port;

`uvm_component_utils(wb_proc_mon)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_resource_db#(virtual wb_proc_intf)::read_by_name("GLOBAL", "PROC_VIF", vif, this);
	ap_port = new("ap_port", this);
endfunction

task run_phase(uvm_phase phase);
	forever begin 
		@(vif.mon_cb); 
		if (vif.mon_cb.wb_stb_i && vif.mon_cb.wb_cyc_i && vif.mon_cb.wb_ack_o) begin 
			tx = wb_tx::type_id::create("tx");
			tx.addr  = vif.mon_cb.wb_adr_i;
			tx.data  = (vif.mon_cb.wb_we_i == 1'b1) ? vif.mon_cb.wb_dat_i : vif.mon_cb.wb_dat_o;
			tx.wr_rd = vif.mon_cb.wb_we_i;
			tx.sel   = vif.mon_cb.wb_sel_i;
			ap_port.write(tx);
		end 
	end 
endtask

endclass

