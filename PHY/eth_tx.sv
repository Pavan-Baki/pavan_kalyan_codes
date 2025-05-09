class eth_tx;

rand bit [55:0] preamble;
rand bit [7:0] sfd;
rand bit [47:0] da;
rand bit [47:0] sa;
rand bit [15:0] len;
rand bit [7:0] payload[$];
rand bit [31:0] crc;
rand pkt_type len_1;

`uvm_object_utils_begin(eth_tx)
	`uvm_field_int(preamble, UVM_ALL_ON)	
	`uvm_field_int(sfd, UVM_ALL_ON)	
	`uvm_field_int(da, UVM_ALL_ON)	
	`uvm_field_int(sa, UVM_ALL_ON)	
	`uvm_field_int(len, UVM_ALL_ON)	
	`uvm_field_queue_int(payload, UVM_ALL_ON)	
	`uvm_field_int(crc, UVM_ALL_ON)	
`uvm_object_utils_end

function new(string = "name");
	super.new("name");
endfunction

/*
constraint pkt_type_c{
	if(len_1 == small_c) len inside {[1:15]};
	if(len_1 == medium_c) len inside {[16:50]};
	if(len_1 == large_c) len inside {[50:100]};
}
*/

constraint payload_c{
	payload.size() == len;
}

constraint len_c{
	len>=42;
	len<=1500;	
}

constraint sbc_c{
	solve len before payload;
}

endclass
