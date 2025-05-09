class wb_proc_base_seq extends uvm_sequence#(wb_tx);

uvm_phase phase;

`uvm_object_utils(wb_proc_base_seq)

`NEW_OBJ

task pre_body();
	//phase = get_starting_phase;
	if(phase != null) phase.raise_objection(this);
endtask

task post_body();
	if(phase != null) phase.drop_objection(this);
endtask

endclass

//read sequence for Registers 
class wb_reg_read_seq extends wb_proc_base_seq;

`uvm_object_utils(wb_reg_read_seq)

`NEW_OBJ

task body();
	for(int i=0; i<21; i++) begin 
		`uvm_do_with(req, {req.wr_rd == 1'b0; req.addr == i;})
	end 
endtask

endclass

//in order write read sequence for Registers 
class wb_reg_write_read_seq extends wb_proc_base_seq;

`uvm_object_utils(wb_reg_write_read_seq)

`NEW_OBJ

task body();
	//Writing to all registers
	bit [31:0] data_t;
	for(int i=0; i<21; i++) begin
		data_t = $random & mac_common::regmaskA[i]; //with masking bit of registers 
		`uvm_do_with(req, {req.wr_rd == 1'b1; req.addr == i; req.data == data_t;})
		`uvm_info("REG_TEST", $psprintf("WRITE : addr = %h, data = %h", req.addr, req.data), UVM_LOW)
	end
 
	//Reading from all registers
	for(int i=0; i<21; i++) begin 
		`uvm_do_with(req, {req.wr_rd == 1'b0; req.addr == i;})
	end 
endtask

endclass

//random reg write read sequence for Registers 
class wb_reg_rand_write_read_seq extends wb_proc_base_seq;

`uvm_object_utils(wb_reg_rand_write_read_seq)

`NEW_OBJ

task body();
	bit [31:0] addr_t;
	bit [31:0] data_t;

	//Writing to all registers
	for(int i=0; i<21; i++) begin
		data_t = $random & mac_common::regmaskA[i]; //with masking bit of registers
		addr_t=$urandom_range(0,20);
		`uvm_do_with(req, {req.wr_rd == 1'b1; req.addr == addr_t; req.data == data_t;})
		`uvm_info("REG_TEST", $psprintf("WRITE : addr = %h, data = %h", req.addr, req.data), UVM_LOW)
	end
 
	//Reading from all registers
	for(int i=0; i<21; i++) begin 
		addr_t=$urandom_range(0,20);
		`uvm_do_with(req, {req.wr_rd == 1'b0; req.addr == addr_t;})
	end 
endtask

endclass


//random reg write read sequence for Registers(with no addr repetition) 
class wb_reg_rand_wr_nr_seq extends wb_proc_base_seq;

`uvm_object_utils(wb_reg_rand_wr_nr_seq)

`NEW_OBJ

task body();
	bit [31:0] addr_t;
	bit [31:0] data_t;
	static int A[$], B[$];
	
	//unique address
	//Writing to all registers
	for(int i=0; i<21; i++)begin
    		A.push_back(i);
  	end
  	$display("A = %p", A);
  	A.shuffle();
  	$display("A = %p", A);
	foreach(A[i])begin 
		B[i] = A[i];
	end 

	//Writing to all registers
	for(int i=0; i<21; i++) begin
		//`uvm_info("REG_TEST", $psprintf("DATA : data = %h", data_t), UVM_LOW)
		addr_t = A.pop_front();
		data_t = $random & mac_common::regmaskA[addr_t]; //with masking bit of registers
		$display("regmaskA[%0d]", i, mac_common::regmaskA[i]);
		`uvm_do_with(req, {req.wr_rd == 1'b1; req.addr == addr_t; req.data == data_t; })
		`uvm_info("REG_TEST", $psprintf("WRITE : addr = %h, data = %h", req.addr, req.data), UVM_LOW)
	end

	//Reading from all registers
	for(int i=0; i<21; i++) begin 
		addr_t = B.pop_front();
		`uvm_do_with(req, {req.wr_rd == 1'b0; req.addr == addr_t;})
	end 
endtask

endclass


//write read sequence for Registers using register model
class wb_reg_write_read_reg_model_seq extends wb_proc_base_seq;

uvm_reg mac_regs[$]; //queue of reg
uvm_reg_data_t ref_data; //will be used for compare purpose 
rand uvm_reg_data_t data; //will be used for compare purpose 
uvm_status_e status;

`uvm_object_utils(wb_reg_write_read_reg_model_seq)

`NEW_OBJ

task body();
	int errors; //used for counting errors 
	mac_reg_block mac_rm;
	string reg_name;
	uvm_reg_addr_t addr;
	uvm_reg_data_t miicommand_data;

	super.body();

	uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RM", mac_rm, this);
	mac_rm.get_registers(mac_regs); //getting all reg handles in mac_regs 
	errors = 0;
	
	//writing to the registers
	repeat(5)begin 
		mac_regs.shuffle();
		foreach(mac_regs[i]) begin 
			if(!this.randomize()) begin 
				`uvm_error("body", "randomization error")
			end
	
			//reg_name = mac_regs[i].get_name(); //here basically i understood the interdependancy between the register **
			//if(reg_name == "miicommand") begin //to fix the issue with miicommand it leads to change the data in miistatus
			//	data[0] = 0;
			//end
	 
			//addr = mac_regs[i].get_address(); //here basically i understood the interdependancy between the register **
			//if(reg_name == 32'hb) begin //to fix the issue with miicommand it leads to change the data in miistatus
			//	data[0] = 0;
			//end

			reg_name = mac_regs[i].get_name(); //here basically i understood the interdependancy between the register **
			if(reg_name == "miicommand") begin //to fix the issue with miicommand it leads to change the data in miistatus
				miicommand_data = data;
			end

			reg_name = mac_regs[i].get_name(); //here basically i understood the interdependancy between the register **
			if(reg_name == "txbdnum") begin //to fix the issue with miicommand it leads to change the data in miistatus
				if(data > 8'h80) data = 8'h7F;
			end
	                
			mac_regs[i].write(status, data, .parent(this)); //performing write to the registers
                        
		end
			//when 0th bit is high of miicommand => it leads to Nvalid_stat and busy_stat to high 
			if(miicommand_data[0] == 1) begin 
				mac_rm.miistatus.predict(3'b110); //updating the value of miistatus reg value 
			end
	//end 
	
	//reading from registers
	//repeat(5)begin  
		mac_regs.shuffle();
		foreach(mac_regs[i]) begin 
			ref_data = mac_regs[i].get();
			mac_regs[i].read(status, data, .parent(this)); //performing read to the registers
			if(ref_data != data) begin 
				`uvm_error("REG_TEST_SEQ:", $sformatf("get/read: read error %s: Expected : %0h  actual : %0h", mac_regs[i].get_name(), ref_data, data))
				errors++;
			end 
			else begin 	
				`uvm_info("REG_TEST_SEQ:", $psprintf("Register comparison is passed %s: Expected : %0h  actual : %0h", mac_regs[i].get_name(), ref_data, data), UVM_LOW)
			end
	 	end 
	end
endtask:body

endclass



//Backdoor write read sequence for Registers using register model
class wb_reg_bd_wr_rd_rm_seq extends wb_proc_base_seq;

uvm_reg mac_regs[$]; //queue of reg
uvm_reg_data_t ref_data; //will be used for compare purpose 
rand uvm_reg_data_t data; //will be used for compare purpose 
uvm_status_e status;

`uvm_object_utils(wb_reg_bd_wr_rd_rm_seq)

`NEW_OBJ

task body();
	int errors; //used for counting errors 
	mac_reg_block mac_rm;
	wb_tx tx = new();

	super.body();

	uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RM", mac_rm, this);
	mac_rm.get_registers(mac_regs); //getting all reg handles in mac_regs 
	errors = 0;
	
	//writing to the registers
	mac_regs.shuffle();
	foreach(mac_regs[i]) begin 
		if(!this.randomize()) begin 
			`uvm_error("body", "randomization error")
		end
		//$display("data = %h", tx.data);
		mac_regs[i].poke(status, data, .parent(this)); //performing write to the registers
		//`uvm_error("REG_TEST_SEQ:", $sformatf("get/write: write error %s: Expected : %0h  actual : %0h", mac_regs[i].get_name(), ref_data, data))
	end

	//reading from registers  
	mac_regs.shuffle();
	foreach(mac_regs[i]) begin 
		ref_data = mac_regs[i].get();
		mac_regs[i].peek(status, data, .parent(this)); //performing read from the registers
		if(ref_data != data) begin 
			`uvm_error("REG_TEST_SEQ:", $sformatf("get/read: read error %s: Expected : %0h  actual : %0h", mac_regs[i].get_name(), ref_data, data))
			errors++;
		end 	
		else begin 	
			`uvm_info("REG_TEST_SEQ:", $psprintf("Register comparison is passed %s: Expected : %0h  actual : %0h", mac_regs[i].get_name(), ref_data, data), UVM_LOW)
		end
 	end 
endtask:body

endclass



//Read sequence for Registers using register model(Reset value read)
class wb_reg_rd_rm_seq extends wb_proc_base_seq;

uvm_reg mac_regs[$]; //queue of reg
uvm_reg_data_t ref_data; //will be used for compare purpose 
uvm_reg_data_t data; //will be used for compare purpose 
uvm_status_e status;

`uvm_object_utils(wb_reg_rd_rm_seq)

`NEW_OBJ

task body();
	int errors; //used for counting errors 
	mac_reg_block mac_rm;

	super.body();

	uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RM", mac_rm, this);
	mac_rm.get_registers(mac_regs); //getting all reg handles in mac_regs 
	errors = 0;
	
	//reading from registers  
	mac_regs.shuffle();
	foreach(mac_regs[i]) begin 
		ref_data = mac_regs[i].get_reset();
		mac_regs[i].read(status, data, .parent(this)); //performing read from the registers
		if(ref_data != data) begin 
			`uvm_error("REG_TEST_SEQ:", $sformatf("get/read: read error %s: Expected : %0h  actual : %0h", mac_regs[i].get_name(), ref_data, data))
			errors++;
		end 
		//else begin 	
		//	`uvm_info("REG_TEST_SEQ:", $psprintf("Reset value of %s: Expected : %0h  actual : %0h", mac_regs[i].get_name(), ref_data, data), UVM_LOW)
		//end
 	end 
endtask:body

endclass


//full duplex 10 and 100 Mbps sequence 
class wb_fd_tx_seq extends wb_proc_base_seq;
uvm_reg_data_t moder_data;
uvm_reg_data_t int_mask_data;
rand uvm_reg_data_t data_t;
uvm_status_e status;

`uvm_object_utils(wb_fd_tx_seq)
`NEW_OBJ

task body;
  mac_reg_block reg_block;
  uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RM", reg_block, this);
 
  //super.body();

 
  //write int_mask_reg(solution for int_o)
  int_mask_data[0] = 1;
  reg_block.intmask.write(status, int_mask_data);

  //write moder register 
  moder_data[16] =0;//recsmall
  moder_data[15] =0;//padding enable
  moder_data[14] =0;//huge enable
  moder_data[13] =0;//crc enable
  moder_data[12] =0;//delayed crc enable
  moder_data[11] =0;//rsvd
  moder_data[10] =1;//full duplex
  moder_data[9]  =0;//excess defer enable
  moder_data[8]  =0;//no backoff
  moder_data[7]  =0;//loop back
  moder_data[6]  =0;//interframe gap
  moder_data[5]  =0;//promiscuous
  moder_data[4]  =0;//individual addr mode
  moder_data[3]  =0;//broadcast addr
  moder_data[2]  =0;//no preamble
  moder_data[1]  =0;//transmit
  moder_data[0]  =0;//receive enable

  //we are performing write to the moder register by using register model
  reg_block.moder.write(status, moder_data);
  
  //load TX_BD
  //the bd is a 64 bit long and each register is 32 bit so we need to write 2 times to load the bd 
   data_t = {16'h200, 1'b1, 1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0};//512 bytes
  `uvm_do_with(req, {req.addr==10'h100; req.data==data_t; req.wr_rd==1'b1;}) //2 bit of addr is rsvd so that 400 addr become 100 
  
  data_t = 32'h1000_0000;
  `uvm_do_with(req, {req.addr==10'h101; req.data==data_t; req.wr_rd==1'b1;})
  
  moder_data[1] = 1; //tx enable 
  reg_block.moder.write(status, moder_data);

endtask: body

endclass


//interrupt source register sequence 
class wb_isr_seq extends wb_proc_base_seq;
uvm_status_e status;
uvm_reg_data_t isrc_data;

`uvm_object_utils(wb_isr_seq)
`NEW_OBJ

task body;
  	mac_reg_block reg_block;
  	uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RM", reg_block, this);
 
  	forever begin
  		wait(mac_common::int_o_asserted == 1'b1);
		//`uvm_warning("INT_SRC", "int_o asserted")
  	 	//mac_common::int_o_asserted = 0;
  	 	reg_block.intsrc.read(status, isrc_data); //read isrc to know the reason behind why interrupt asserted
  	 	mac_common::int_o_asserted = 0;
		if(isrc_data != mac_common::exp_isrc_val)begin 
			`uvm_error("INT_SRC", "Int_src data does not match with exp value")
		end
		else begin 
  	 		reg_block.intsrc.write(status, isrc_data); //to clear the interrupt write 1 to it 
		end 
  	end 
endtask: body

endclass



//rx full duplex 10 and 100 Mbps sequence 
class wb_fd_rx_seq extends wb_proc_base_seq;
uvm_reg_data_t moder_data;
uvm_reg_data_t int_mask_data;
rand uvm_reg_data_t data_t;
uvm_status_e status;

`uvm_object_utils(wb_fd_rx_seq)
`NEW_OBJ

task body;
  mac_reg_block reg_block;
  uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RM", reg_block, this);
 
  //write int_mask_reg(solution for int_o)
  int_mask_data[2] = 1;//enable rx int.
  reg_block.intmask.write(status, int_mask_data);

  //write moder register
  moder_data     = 17'h0;
  moder_data[10] = 1;//full duplex
  moder_data[5]  = 1;//promiscus mode(Receive the frame regardless of its address)(Debug point)
  moder_data[13]  = 1;//crc enable bit 

  //we are performing write to the moder register by using register model
  reg_block.moder.write(status, moder_data);
  
  //load RX_BD
  //the bd is a 64 bit long and each register is 32 bit so we need to write 2 times to load the bd 
   data_t = {16'h80, 1'b1, 1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0};//512 bytes
  `uvm_do_with(req, {req.addr==10'h180; req.data==data_t; req.wr_rd==1'b1;}) //2 bit of addr is rsvd so that 600 addr become 180 (len => 128)
  
  data_t = 32'h2000_0000;
  `uvm_do_with(req, {req.addr==10'h181; req.data==data_t; req.wr_rd==1'b1;})//604 => 181
  
  moder_data[0] = 1; //rx enable 
  reg_block.moder.write(status, moder_data);

endtask: body

endclass



//FD Tx and Rx sequence(Concurrent) 
class wb_fd_tx_rx_seq extends wb_proc_base_seq;
uvm_reg_data_t moder_data;
uvm_reg_data_t int_mask_data;
rand uvm_reg_data_t data_t;
uvm_status_e status;

`uvm_object_utils(wb_fd_tx_rx_seq)

`NEW_OBJ

task body;
  mac_reg_block reg_block;
  uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RM", reg_block, this);
 
  //write int_mask_reg(solution for int_o)
  int_mask_data[2] = 1;//enable int.
  int_mask_data[0] = 1;//enable tx int.
  reg_block.intmask.write(status, int_mask_data);

  //write moder register
  moder_data     = 17'h0;
  moder_data[10] = 1;//full duplex
  moder_data[5]  = 1;//promiscus mode(Receive the frame regardless of its address)(Debug point)
  moder_data[13]  = 1;//crc enable bit 

  //we are performing write to the moder register by using register model
  reg_block.moder.write(status, moder_data);
  
  //load TX_BD
  //the bd is a 64 bit long and each register is 32 bit so we need to write 2 times to load the bd 
   data_t = {16'h200, 1'b1, 1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0};//512 bytes
  `uvm_do_with(req, {req.addr==10'h100; req.data==data_t; req.wr_rd==1'b1;}) //2 bit of addr is rsvd so that 400 addr become 100(len => 512) 
  
  data_t = 32'h1000_0000;
  `uvm_do_with(req, {req.addr==10'h101; req.data==data_t; req.wr_rd==1'b1;})

  //load RX_BD
  //the bd is a 64 bit long and each register is 32 bit so we need to write 2 times to load the bd 
   data_t = {16'h80, 1'b1, 1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0};//512 bytes
  `uvm_do_with(req, {req.addr==10'h180; req.data==data_t; req.wr_rd==1'b1;}) //2 bit of addr is rsvd so that 600 addr become 180 (len => 128)
  
  data_t = 32'h2000_0000;
  `uvm_do_with(req, {req.addr==10'h181; req.data==data_t; req.wr_rd==1'b1;})//604 => 181
  
  moder_data[0] = 1; //rx enable 
  moder_data[1] = 1; //tx enable 
  reg_block.moder.write(status, moder_data);

endtask: body

endclass

//MII wctrldata Tx sequence 
class mii_wctrl_data_tx_seq extends wb_proc_base_seq;
uvm_status_e status;
rand uvm_reg_data_t miimoder_data;
rand uvm_reg_data_t miicommand_data;
rand uvm_reg_data_t miistatus_data;
rand uvm_reg_data_t miiaddress_data;
rand uvm_reg_data_t miitx_data;
rand uvm_reg_data_t miirx_data;

`uvm_object_utils(mii_wctrl_data_tx_seq)

`NEW_OBJ

task body;
  mac_reg_block reg_block;
  uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RM", reg_block, this);
 
  //write miimoder register
  miimoder_data  = 9'h0;
  miimoder_data[8] = 1;//no preamble(it is not for eth_frame), it is for mii frame 
  miimoder_data[7:0] = 4; //clock divider  
  reg_block.miimoder.write(status, miimoder_data);

  //write to miicommand reg
  miicommand_data = 3'b0;
  miicommand_data[2] = 1'b1; //wctrl data
  reg_block.miicommand.write(status, miicommand_data);
  
  //write to miiaddress reg
  miiaddress_data = 32'b0;
  miiaddress_data[4:0] = 5'h10; //FIAD(phy addr)
  miiaddress_data[12:8] = 5'h07; //RGAD(reg addr)
  reg_block.miiaddress.write(status, miiaddress_data);
  
  //write to miitx_data reg
  miitx_data = 32'b0;
  miitx_data[15:0] = 16'hAA33; //1010_1010_001_0011
  reg_block.miitx_data.write(status, miitx_data);
  
  //miistatus data reg 
  reg_block.miistatus.read(status, miistatus_data);
  while (miistatus_data[1] == 1)begin 
  		reg_block.miistatus.read(status, miistatus_data);
  end
  //1st bit is zero so link is not busy
  if(miistatus_data[0] == 1)begin 
  		`uvm_error("MII", "Link Failed")
  end 

endtask: body

endclass

//Half duplex 10 and 100 Mbps sequence 
class wb_hd_tx_seq extends wb_proc_base_seq;
uvm_reg_data_t moder_data;
uvm_reg_data_t collcnf_data;
uvm_reg_data_t int_mask_data;
rand uvm_reg_data_t data_t;
uvm_status_e status;

`uvm_object_utils(wb_hd_tx_seq)

`NEW_OBJ

task body;
  mac_reg_block reg_block;
  uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RM", reg_block, this);
 
  //write int_mask_reg(solution for int_o)
  int_mask_data[0] = 1;
  reg_block.intmask.write(status, int_mask_data);

  //write moder register 
  moder_data[15:0] =16'b0;//HD Mode 
  //moder_data[8] =1'b1;//retransmission starts after the collision detected  
  moder_data[8] =1'b0;//no backoff    
  reg_block.moder.write(status, moder_data);
  
  //write moder register 
  collcnf_data[19:0] =19'b0; 
  collcnf_data[19:16] =4'hF; 
  collcnf_data[5:0] =6'h3F; 
  reg_block.collconf.write(status, collcnf_data);
  
  //load TX_BD
  //the bd is a 64 bit long and each register is 32 bit so we need to write 2 times to load the bd 
   data_t = {16'h200, 1'b1, 1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0};//512 bytes
  `uvm_do_with(req, {req.addr==10'h100; req.data==data_t; req.wr_rd==1'b1;}) //2 bit of addr is rsvd so that 400 addr become 100 
  
  data_t = 32'h1000_0000;
  `uvm_do_with(req, {req.addr==10'h101; req.data==data_t; req.wr_rd==1'b1;})
  
  moder_data[1] = 1; //tx enable 
  reg_block.moder.write(status, moder_data);

endtask: body

endclass


//fd pause frame sequence 
class wb_fd_tx_pf_seq extends wb_proc_base_seq;
rand uvm_reg_data_t moder_data;
rand uvm_reg_data_t ctrlmoder_data;
rand uvm_reg_data_t int_mask_data;
rand uvm_reg_data_t data_t;
uvm_status_e status;

`uvm_object_utils(wb_fd_tx_pf_seq)
`NEW_OBJ

task body;
  mac_reg_block reg_block;
  uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL", "MAC_RM", reg_block, this);
 
  //write int_mask_reg(solution for int_o)
  int_mask_data[0] = 1;
  reg_block.intmask.write(status, int_mask_data);

  //write moder register 
  moder_data[10]    = 1'b1;
  reg_block.moder.write(status, moder_data);
  
  //ctrl moder reg 
  ctrlmoder_data[1] = 1'b1;
  reg_block.ctrlmoder.write(status, ctrlmoder_data);
  
  //load TX_BD
  //the bd is a 64 bit long and each register is 32 bit so we need to write 2 times to load the bd 
   data_t = {16'h200, 1'b1, 1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0};//512 bytes
  `uvm_do_with(req, {req.addr==10'h100; req.data==data_t; req.wr_rd==1'b1;}) //2 bit of addr is rsvd so that 400 addr become 100 
  
  data_t = 32'h1000_0000;
  `uvm_do_with(req, {req.addr==10'h101; req.data==data_t; req.wr_rd==1'b1;})
  
  moder_data[1] = 1; //tx enable 
  moder_data[0] = 1; //rx enable 
  reg_block.moder.write(status, moder_data);

endtask: body

endclass

