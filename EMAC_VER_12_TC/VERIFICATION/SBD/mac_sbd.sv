`uvm_analysis_imp_decl(_proc)
     //above defines a class by name uvm_analysis_imp_proc
	 //provides a method by name write_proc
`uvm_analysis_imp_decl(_mem)
     //above defines a class by name uvm_analysis_imp_mem
	 //provides a method by name write_mem
`uvm_analysis_imp_decl(_tx)
`uvm_analysis_imp_decl(_rx)

class mac_sbd extends uvm_scoreboard;
//TLM implementation port declaration 
uvm_analysis_imp_proc#(wb_tx, mac_sbd) imp_proc;
uvm_analysis_imp_mem#(wb_tx, mac_sbd)  imp_mem;
uvm_analysis_imp_tx#(eth_frame, mac_sbd) imp_tx;
uvm_analysis_imp_rx#(eth_frame, mac_sbd) imp_rx;

eth_frame txframe_i;
eth_frame rxframe_i;
byte memrddataQ[$];
byte memwrdataQ[$];

`uvm_component_utils(mac_sbd)

`NEW_COMP

function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   imp_proc = new("imp_proc", this);
   imp_mem  = new("imp_mem", this);
   imp_tx   = new("imp_tx", this);
   imp_rx   = new("imp_rx", this);
endfunction

function void write_proc(wb_tx tx);//this will get txs from processor to monitor
     `uvm_info("SBD", "printing Proc wb_tx", UVM_LOW)
     //tx.print();
endfunction

function void write_mem(wb_tx tx);//this will get txs from mem to monitor
      `uvm_info("SBD", "printing mem wb_tx", UVM_LOW)
      //tx.print();
      if(tx.wr_rd == 1) begin //this is the data received from phy BFM
	     $display("%t : pushing data to memwrdataQ", $time);
	     memwrdataQ.push_back(tx.data[31:24]);
	     memwrdataQ.push_back(tx.data[23:16]);
	     memwrdataQ.push_back(tx.data[15:8]);
	     memwrdataQ.push_back(tx.data[7:0]);
	   end
	   else begin //this is the transmitted to phy BFM
	      $display("%t : pushing data to memrddataQ", $time);
	      memrddataQ.push_back(tx.data[31:24]);
	      memrddataQ.push_back(tx.data[23:16]);
	      memrddataQ.push_back(tx.data[15:8]);
	      memrddataQ.push_back(tx.data[7:0]);
	   end
endfunction

function void write_tx(eth_frame frame);//this will get txs from txs from phy tx to monitor
    `uvm_info("SBD", "printing phy tx frame", UVM_LOW)
    //frame.print();
	 $cast(txframe_i, frame);
	 //preamble ,sfd, payload
endfunction

function void write_rx(eth_frame frame);//this will get txs from phy rx to monitor
    `uvm_info("SBD", "printing phy rx frame", UVM_LOW)
    //frame.print();
	 $cast(rxframe_i, frame);
endfunction

task run_phase(uvm_phase phase);
forever begin
   $display("SBD COMPARE Check started - 1");

   wait (mac_common::int_o_asserted_sbd == 1'b1
                     &&
        ((txframe_i != null && memrddataQ.size() > 0)
                      ||
         (rxframe_i != null && memwrdataQ.size() > 0))
		 );

   $display("SBD COMPARE Check started - 2");
   mac_common::int_o_asserted_sbd = 0;
   if(txframe_i != null) begin
     foreach(txframe_i.payload[i])begin
	    if(txframe_i.payload[i] == memrddataQ[i]) begin
		  `uvm_info("SBD_CHECK", "Compare passing", UVM_NONE)
		  mac_common::num_matches++;
		  `uvm_info("SBD_CHECK", $psprintf("txframe check : num_matches = %0d", mac_common::num_matches), UVM_NONE)
		 end
		 else begin
		    `uvm_error("SBD_CHECK", $psprintf("txframe check : Data mismatch : mem_rd_data=%h, frame_data=%h", memrddataQ[i], txframe_i.payload[i]));
			mac_common::num_mismatches++;
		  `uvm_info("SBD_CHECK", $psprintf("txframe check : num_mismatches = %0d", mac_common::num_mismatches), UVM_NONE)
		 end
	 end
	 txframe_i = null;
	 memrddataQ.delete();
   end 
 
   if(rxframe_i != null) begin
     foreach(rxframe_i.payload[i])begin
	     if(rxframe_i.payload[i] == memwrdataQ[i]) begin
		  `uvm_info("SBD_CHECK", "Compare passing", UVM_NONE)
		   mac_common::num_matches++;
		  `uvm_info("SBD_CHECK", $psprintf("rxframe check : num_matches = %0d", mac_common::num_matches), UVM_NONE)
		 end
		 else begin
		    `uvm_error("SBD_CHECK", $psprintf("rxframe check : Data mismatch : mem_wr_data=%h, frame_data=%h", memwrdataQ[i], rxframe_i.payload[i]));
			mac_common::num_mismatches++;
		  `uvm_info("SBD_CHECK", $psprintf("rxframe check : num_mismatches = %0d", mac_common::num_mismatches), UVM_NONE)
		 end
	 end
	 rxframe_i = null;
	 memwrdataQ.delete();
   end 

end
endtask
endclass

