class phy_tx_mon extends uvm_monitor;

virtual phy_intf vif;
eth_frame frame;

uvm_analysis_port#(eth_frame) ap_port;

`uvm_component_utils(phy_tx_mon)

`NEW_COMP

function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   uvm_resource_db#(virtual phy_intf)::read_by_name("GLOBAL","PHY_VIF", vif, this);
   ap_port = new("ap_port", this);
endfunction

task run_phase(uvm_phase phase);
	bit ignore_initial_0s = 1;
	bit nibbleQ_data_valid;
	nibble_t nibbleQ[$];
	nibble_t temp;
	int queue_size_in_bytes;

	forever begin
	   @(vif.tx_mon_cb);
	   if(vif.tx_mon_cb.mtxen_pad_o)begin
	      nibbleQ_data_valid = 1;
	      if(ignore_initial_0s && vif.tx_mon_cb.mtxd_pad_o == 4'h0)begin
			end
			else begin
			     ignore_initial_0s = 0;
				 //$display("%t : pushing %h into nibbleQ", $time, vif.tx_mon_cb.mtxd_pad_o);
				 nibbleQ.push_back(vif.tx_mon_cb.mtxd_pad_o);
			end
	   end
	   else begin
	     if (nibbleQ_data_valid == 1)begin
		 		frame = eth_frame::type_id::create("frame");
	     	 	queue_size_in_bytes=nibbleQ.size()/2 -4 -7 -1;//4 is for crc ,7 is for preamble 1 is for sfd
		 		//nibble should interchanges (even to odd, odd to even)
		 		for (int i = 0; i<nibbleQ.size()/2; i=i+1)begin
		    		temp = nibbleQ[2*i];
			 		nibbleQ[2*i] = nibbleQ[2*i+1];
			 		nibbleQ[2*i+1] = temp;
		 		end
		    	//{frame.preamble, frame.sfd, frame.payload} = {<<nibble_t{nibbleQ}};
	       	frame.preamble = {nibbleQ[0],
		            				nibbleQ[1],
		            				nibbleQ[2],
		            				nibbleQ[3],
		            				nibbleQ[4],
		            				nibbleQ[5],
		            				nibbleQ[6],
		            				nibbleQ[7],
		            				nibbleQ[8],
		            				nibbleQ[9],
		            				nibbleQ[10],
		            				nibbleQ[11],
		            				nibbleQ[12],
		             				nibbleQ[13]
					 					};
	
		   	frame.sfd = {nibbleQ[14], nibbleQ[15]};
	
		   	for(int i=0; i<queue_size_in_bytes;i++) begin
					frame.payload.push_back({nibbleQ[16+2*i],nibbleQ[16+2*i+1]});
	      	end 

		 		frame.crc = {
		   	     				nibbleQ[16+queue_size_in_bytes*2],
		   	     				nibbleQ[16+queue_size_in_bytes*2+1],
		   	     				nibbleQ[16+queue_size_in_bytes*2+2],
		   	     				nibbleQ[16+queue_size_in_bytes*2+3],
		   	     				nibbleQ[16+queue_size_in_bytes*2+4],
		   	     				nibbleQ[16+queue_size_in_bytes*2+5],
		   	     				nibbleQ[16+queue_size_in_bytes*2+6],
		   	     				nibbleQ[16+queue_size_in_bytes*2+7]
		   					};

		   	nibbleQ_data_valid = 0;
		   	//frame.print();
		   	ap_port.write(frame);
		  end
	   end
	end
endtask

endclass

