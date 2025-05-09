class phy_rx_drv extends uvm_driver#(eth_frame);
virtual phy_intf vif;
real clk_tp;

`uvm_component_utils(phy_rx_drv)

`NEW_COMP

function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_resource_db#(virtual phy_intf)::read_by_name("GLOBAL", "PHY_VIF", vif, this);
		if (!uvm_resource_db#(int)::read_by_name("GLOBAL", "CLK_TP", clk_tp, this)) begin 
			clk_tp = 40;
		end 
endfunction

task run_phase(uvm_phase phase);
fork
	forever begin
		#(clk_tp/2.0) vif.mrx_clk_pad_i = ~vif.mrx_clk_pad_i;
	end

	forever begin 
		seq_item_port.get_next_item(req);
		req.print();
		case(req.frame_type)
				ETH_FRAME 		: drive_frame(req);
				COLL_DET  		: drive_coll_det(req.coll_det_delay);
				PAUSE_FRAME 	: drive_pause_frame(req, req.pause_frame_delay);
		endcase
		seq_item_port.item_done();
	end
join
endtask

task drive_coll_det(int delay);
	#delay;
	vif.mcoll_pad_i = 1'b1;
	#50;
	vif.mcoll_pad_i = 1'b0;
endtask

task drive_pause_frame(eth_frame frame, int delay);
	nibble_t nibbleQ[$];
	nibble_t temp;

	#delay;

	//pack frame in nibble queue(lower nibble packed first)
	nibbleQ = {>>nibble_t {frame.preamble, frame.sfd, frame.da, frame.sa, frame.type_len, frame.opcode, frame.pausetimer, frame.rsved, frame.crc}};
	$display("nibleQ= %p", nibbleQ);

	//logic for write lower nibble first and upper
	for(int i=0; i < nibbleQ.size()/2; i = i+1)begin 
		temp = nibbleQ[2*i];//even
      nibbleQ[2*i] = nibbleQ[2*i+1];
		nibbleQ[2*i+1] = temp;
	end
	
	//idle cycle(it is not mentioned in the rtl* => we need to approach the RTL Engineer)
	repeat(8) begin 
		@(posedge vif.mrx_clk_pad_i);
			vif.mrxd_pad_i = 0;
			vif.mrxdv_pad_i = 1;
	end

	//driving nibble to the MAC
	foreach(nibbleQ[i])begin 
		@(posedge vif.mrx_clk_pad_i);
		vif.mrxd_pad_i = nibbleQ[i];
		vif.mrxdv_pad_i = 1;
	end 
		@(posedge vif.mrx_clk_pad_i);
		vif.mrxd_pad_i = 0;
		vif.mrxdv_pad_i = 0;
endtask


task drive_frame(eth_frame frame);
	nibble_t nibbleQ[$];
	nibble_t temp;

	//pack frame in nibble queue(lower nibble packed fisrt)
	nibbleQ = {>>nibble_t {frame.preamble, frame.sfd, frame.payload, frame.crc}};
	$display("nibleQ= %p", nibbleQ);

	//logic for write lower nibble first and upper
	for(int i=0; i < nibbleQ.size()/2; i = i+2)begin 
		temp = nibbleQ[2*i];//even
      nibbleQ[2*i] = nibbleQ[2*i+1];
		nibbleQ[2*i+1] = temp;
	end
	//$display("nibleQ= %p", nibbleQ);
	
	//startidle -> startpreamble -> startsfd -> startdata[0] -> startdata[1] -> startcrc (we should follow this hierarchy)

	//idle cycle(it is not mentioned in the rtl* => we need to approach the RTL Engineer)
	repeat(8) begin 
		@(posedge vif.mrx_clk_pad_i);
			vif.mrxd_pad_i = 0;
			vif.mrxdv_pad_i = 1;
	end

	//driving nibble to the MAC
	foreach(nibbleQ[i])begin 
		@(posedge vif.mrx_clk_pad_i);
		vif.mrxd_pad_i = nibbleQ[i];
		vif.mrxdv_pad_i = 1;
	end 
		@(posedge vif.mrx_clk_pad_i);
		vif.mrxd_pad_i = 0;
		vif.mrxdv_pad_i = 0;
endtask


/*
function void pack_frame(input eth_frame tx, output bit [3:0]nibbleQ[$]);
	bit [3:0]lower_nibble;
	bit [3:0]upper_nibble;
	//Preamble packing
		for(int i=0;i<7;i++) begin
			lower_nibble=tx.preamble[51:48];
			upper_nibble=tx.preamble[55:52];
			nibbleQ.push_back(lower_nibble);
			nibbleQ.push_back(upper_nibble);
			tx.preamble<<=8;
		end
	//SFD
			nibbleQ.push_back(tx.sfd[3:0]);
			nibbleQ.push_back(tx.sfd[7:4]);

	//PAYLOAD
		for(int i=0;i<tx.len;i++) begin
			lower_nibble=tx.payload[i][3:0];
			upper_nibble=tx.payload[i][7:4];
			nibbleQ.push_back(lower_nibble);
			nibbleQ.push_back(upper_nibble);
		end
	//CRC
			nibbleQ.push_back(tx.crc[31:28]);
			nibbleQ.push_back(tx.crc[27:24]);
			nibbleQ.push_back(tx.crc[23:20]);
			nibbleQ.push_back(tx.crc[19:16]);
			nibbleQ.push_back(tx.crc[15:12]);
			nibbleQ.push_back(tx.crc[11:8]);
			nibbleQ.push_back(tx.crc[7:4]);
			nibbleQ.push_back(tx.crc[3:0]);
endfunction

task drive_frame(eth_frame tx);
	bit [3:0]nibbleQ[$];
	pack_frame(tx, nibbleQ);

//	foreach(tx.payload[i]) begin
//	if(tx.payload[i]!=0)
//		`uvm_info("PHY_RX:DRV",$psprintf("\ntx.payload[%0d]=%h",i,tx.payload[i]),UVM_LOW);
//	end

	//idle cycle(it is not mentioned in the rtl* => we need to approach the RTL Engineer)
	repeat(8) begin 
		@(posedge vif.mrx_clk_pad_i);
			vif.mrxd_pad_i = 0;
			vif.mrxdv_pad_i = 1;
	end

	$display("nibleQ= %p", nibbleQ);

	//Drive Nibble queque
	foreach(nibbleQ[i]) begin
			@(posedge vif.mrx_clk_pad_i);
			vif.mrxd_pad_i<=nibbleQ[i]; 
			vif.mrxdv_pad_i<=1'b1;
		  	vif.mrxerr_pad_i<=1'b0; 
	end
			@(posedge vif.mrx_clk_pad_i);
			vif.mrxd_pad_i<=1'b0; 
			vif.mrxdv_pad_i<=1'b0;
		  	vif.mrxerr_pad_i<=1'b0; 
endtask
*/

endclass
