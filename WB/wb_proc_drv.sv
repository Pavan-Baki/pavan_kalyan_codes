class wb_proc_drv extends uvm_driver#(wb_tx);

virtual wb_proc_intf vif;
wb_tx tx;

`uvm_component_utils(wb_proc_drv)

`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_resource_db#(virtual wb_proc_intf)::read_by_name("GLOBAL", "PROC_VIF", vif, this);
endfunction

task run_phase(uvm_phase phase);
fork
forever begin 
	//`uvm_info("DRIVE_F", "Inside Drive forever loop", UVM_LOW)
	seq_item_port.get_next_item(req);
	//req.print();
	drive_tx(req);
	seq_item_port.item_done();
end

forever begin 
	@(posedge vif.int_o);
	mac_common::int_o_asserted = 1;
	mac_common::int_o_asserted_sbd = 1;
end 
join

endtask

task drive_tx(wb_tx tx);
	@(posedge vif.wb_clk_i);
	vif.wb_adr_i = tx.addr;
	vif.wb_we_i  = tx.wr_rd;
	vif.wb_sel_i = 4'hF; //1'b1 is also fine (all data is valid it is same as strb signal in AXI)
	if(tx.wr_rd == 1'b1) vif.wb_dat_i = tx.data;
	vif.wb_cyc_i = 1'b1;
	vif.wb_stb_i = 1'b1;
	wait(vif.wb_ack_o == 1);
	if(tx.wr_rd == 1'b0) begin
		tx.data = vif.wb_dat_o;
		//`uvm_info("REG_TEST", $psprintf("READ : addr = %h, data = %h", tx.addr, tx.data), UVM_LOW)
	end
	reset_all_inputs();	
endtask

task reset_all_inputs();
	@(posedge vif.wb_clk_i);
	vif.wb_adr_i = 0;
	vif.wb_sel_i = 0;
	vif.wb_we_i  = 0;
	vif.wb_cyc_i = 0;
	vif.wb_stb_i = 0;
	vif.wb_dat_i = 0;

endtask

endclass

