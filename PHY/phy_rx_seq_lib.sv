class phy_rx_base_seq extends uvm_sequence#(eth_frame);

uvm_phase phase;

`uvm_object_utils(phy_rx_base_seq)

`NEW_OBJ

task pre_body();
	//phase = get_starting_phase;
	if(phase != null) phase.raise_objection(this);
endtask

task post_body();
	if(phase != null) phase.drop_objection(this);
endtask

endclass

//generate frame sequence (phy to MAC)
class phy_rx_gf_seq extends phy_rx_base_seq;
	
	`uvm_object_utils(phy_rx_gf_seq)
	
	`NEW_OBJ

	task body();
		`uvm_do_with(req, {req.len == 128;})//generating 128 frames 
	endtask

endclass

//coll det seq
class phy_coll_det_seq extends phy_rx_base_seq;
rand int delay;	
	`uvm_object_utils(phy_coll_det_seq)
	
	`NEW_OBJ

	task body();
		`uvm_do_with(req, {req.frame_type == COLL_DET; req.coll_det_delay == delay;})//COLL DET 
	endtask

endclass

//pause frame seq
class phy_pause_frame_seq extends phy_rx_base_seq;
rand int delay;	
	`uvm_object_utils(phy_pause_frame_seq)
	
	`NEW_OBJ

	task body();
		`uvm_do_with(req, {req.frame_type == PAUSE_FRAME; req.pausetimer == 5; req.pause_frame_delay == delay;})//pause frame -> pausetimer is 64 byte so it will take time as 5*64 = 320 clk cycle   
	endtask

endclass















