typedef enum bit [1:0] {
	ETH_FRAME,
	COLL_DET,
	PAUSE_FRAME
} frame_type_t;

class eth_frame extends uvm_sequence_item;
rand frame_type_t frame_type;
rand bit [55:0] preamble; 
rand bit [7:0]  sfd;
rand int        len;
rand bit [7:0]  payload[$];
bit      [31:0] crc;
rand int coll_det_delay;

//pause frame fields
rand bit [47:0] da;
rand bit [47:0] sa;
rand bit [15:0] opcode;
rand bit [15:0] type_len;
rand bit [15:0] pausetimer;
rand bit [7:0]  rsved [41:0];
rand int pause_frame_delay;

`uvm_object_utils_begin(eth_frame)
	`uvm_field_int(preamble, UVM_ALL_ON)
	`uvm_field_int(sfd, UVM_ALL_ON)
	`uvm_field_int(len, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_queue_int(payload, UVM_ALL_ON)
	`uvm_field_int(crc, UVM_ALL_ON)
	`uvm_field_int(opcode, UVM_ALL_ON)
	`uvm_field_int(pausetimer, UVM_ALL_ON)
`uvm_object_utils_end

`NEW_OBJ

/*
function void post_randomize();
	//crc = 32'h1234_5678;//we should write logic for crc generation so this is temporary solution  
	//crc = 32'hc704dd7b;

	//polynomial for 32 bit CRC generation => x32+x26+x23+x22+x16+x12+x11+x10+x8+x7+x5+x4+x2+x+1 


	bit [31:0]t_crc,n_crc;
   bit [3:0]Data;
	bit [7:0]data1;

	t_crc=32'hFFFF_FFFF; //default value of crc 

	foreach(payload[i]) begin
		data1=payload[i];
		for(int i=0; i<2 ;i++) begin
			if(i==0)
				Data[3:0]=data1[3:0];
			else 
				Data[3:0]=data1[7:4];
		
			n_crc[0] =(Data[0] ^ t_crc[28]); 
			n_crc[1] =(Data[1] ^ Data[0] ^ t_crc[28] ^ t_crc[29]); 
			n_crc[2] =(Data[2] ^ Data[1] ^ Data[0] ^ t_crc[28] ^ t_crc[29] ^ t_crc[30]); 
			n_crc[3] =(Data[3] ^ Data[2] ^ Data[1] ^ t_crc[29] ^ t_crc[30] ^ t_crc[31]); 
			n_crc[4] =(Data[3] ^ Data[2] ^ Data[0] ^ t_crc[28] ^ t_crc[30] ^ t_crc[31]) ^ t_crc[0]; 
			n_crc[5] =(Data[3] ^ Data[1] ^ Data[0] ^ t_crc[28] ^ t_crc[29] ^ t_crc[31]) ^ t_crc[1]; 
			n_crc[6] =(Data[2] ^ Data[1] ^ t_crc[29] ^ t_crc[30]) ^ t_crc[ 2]; 
			n_crc[7] =(Data[3] ^ Data[2] ^ Data[0] ^ t_crc[28] ^ t_crc[30] ^ t_crc[31]) ^ t_crc[3]; 
			n_crc[8] =(Data[3] ^ Data[1] ^ Data[0] ^ t_crc[28] ^ t_crc[29] ^ t_crc[31]) ^ t_crc[4]; 
			n_crc[9] =(Data[2] ^ Data[1] ^ t_crc[29] ^ t_crc[30]) ^ t_crc[5]; 
			n_crc[10] =(Data[3] ^ Data[2] ^ Data[0] ^ t_crc[28] ^ t_crc[30] ^ t_crc[31]) ^ t_crc[6]; 
			n_crc[11] =(Data[3] ^ Data[1] ^ Data[0] ^ t_crc[28] ^ t_crc[29] ^ t_crc[31]) ^ t_crc[7]; 
			n_crc[12] =(Data[2] ^ Data[1] ^ Data[0] ^ t_crc[28] ^ t_crc[29] ^ t_crc[30]) ^ t_crc[8]; 
			n_crc[13] =(Data[3] ^ Data[2] ^ Data[1] ^ t_crc[29] ^ t_crc[30] ^ t_crc[31]) ^ t_crc[9]; 
			n_crc[14] =(Data[3] ^ Data[2] ^ t_crc[30] ^ t_crc[31]) ^ t_crc[10]; 
			n_crc[15] =(Data[3] ^ t_crc[31]) ^ t_crc[11]; 
			n_crc[16] =(Data[0] ^ t_crc[28]) ^ t_crc[12]; 
			n_crc[17] =(Data[1] ^ t_crc[29]) ^ t_crc[13]; 
			n_crc[18] =(Data[2] ^ t_crc[30]) ^ t_crc[14]; 
			n_crc[19] =(Data[3] ^ t_crc[31]) ^ t_crc[15]; 
			n_crc[20] = t_crc[16]; 
			n_crc[21] = t_crc[17]; 
			n_crc[22] =(Data[0] ^ t_crc[28]) ^ t_crc[18]; 
			n_crc[23] =(Data[1] ^ Data[0] ^ t_crc[29] ^ t_crc[28]) ^ t_crc[19]; 
			n_crc[24] =(Data[2] ^ Data[1] ^ t_crc[30] ^ t_crc[29]) ^ t_crc[20]; 
			n_crc[25] =(Data[3] ^ Data[2] ^ t_crc[31] ^ t_crc[30]) ^ t_crc[21]; 
			n_crc[26] =(Data[3] ^ Data[0] ^ t_crc[31] ^ t_crc[28]) ^ t_crc[22]; 
			n_crc[27] =(Data[1] ^ t_crc[29]) ^ t_crc[23]; 
			n_crc[28] =(Data[2] ^ t_crc[30]) ^ t_crc[24]; 
			n_crc[29] =(Data[3] ^ t_crc[31]) ^ t_crc[25]; 
			n_crc[30] = t_crc[26]; 
			n_crc[31] = t_crc[27]; 
		end
		t_crc=n_crc;
	end
	this.crc=n_crc;
	

endfunction 
*/


//xor shifting logic => CRC 
function void post_randomize();
bit [32:0] poly = 33'b1_0000_0100_1100_0001_0001_1101_1011_0111; //polynomial value for 32 bit CRC
bit [32:0] rmd;
bit [32:0] div;
int num_bits_to_shift;
bit payload_bitvetcor[$];
int shift_count, queue_size;

	payload_bitvetcor = {>>bit{payload}};
	
	//$display("payload = %p",payload_bitvetcor);
	
	for(int i=32; i>=0; i--)begin 
		div[i] = payload_bitvetcor.pop_front();
		//$display("divident = %b",div[i]);
	end 
	queue_size = payload_bitvetcor.size();

	while(queue_size > 0) begin 
		queue_size = payload_bitvetcor.size();

		//xor operation with polynomial 
		rmd = div ^ poly;
	
		//check how many 0 present at MSB
		for(int i=32; i>=0; i--)begin 
				if(rmd[i] == 0) num_bits_to_shift++;
			//else break;
			   else i=-1;
		end 
		
		shift_count = (num_bits_to_shift > queue_size) ? queue_size : num_bits_to_shift;
		//$display("shift_count = %d", shift_count);
      num_bits_to_shift=0;
		
		//shift the div = num_bits_to_shift
		rmd <<= shift_count;
		for(int i=shift_count; i>0; i--)begin 
			rmd[i-1] = payload_bitvetcor.pop_front();
		end 
		div=rmd;
		//$display("rmd=%b",rmd);
	end
		crc = rmd;
		$display("crc = %b", crc);
endfunction


/*
localparam CRC_BW       = 32;
localparam CRCXPOLYREV  = 33'b0_1111_1011_0011_1110_1110_0010_0100_1000;     
localparam CRCXPOLY     = 33'b1_0000_0100_1100_0001_0001_1101_1011_0111;    

function automatic logic[CRC_BW-1:0] generateCRC_X(
     logic [3:0] databyte_stream[],
     input logic reversed_poly=0,
     input logic[CRC_BW-1:0] start_crc_value='1, 
     input logic[CRC_BW-1:0] final_crc_xor_value='0,
     input logic do_end_crc_reversebits=0);
	  
    int unsigned i, j;
    bit [CRC_BW-1:0] crcx_tmp,crcx_val = start_crc_value;  
    bit [3:0]  data;


    for (i = 0; i < databyte_stream.size; i++) 
	 begin
        if (reversed_poly==1) begin
            data = databyte_stream[i];

            for (j=0; j < 4; j++) 
            begin
                if ((crcx_val[0]) != (data[0]))
                    crcx_val = (crcx_val >> 1) ^ CRCXPOLYREV;
                else
                    crcx_val >>= 1;

                data >>= 1;
            end
        end else begin
            data = databyte_stream[i];
            for (j=0; j < 4; j++) 
				begin
                if ((crcx_val[CRC_BW-1]) != (data[3]))
                    crcx_val = (crcx_val << 1) ^ CRCXPOLY;
                else
                    crcx_val <<= 1;

                data <<= 1;
            end
        end
    end
    crcx_val ^= final_crc_xor_value; 
    if (do_end_crc_reversebits==1) begin
        for (j=0; j < CRC_BW; j++) 
		  begin
            crcx_tmp[CRC_BW-1-j]=crcx_val[j];//reversed
        end
        crcx_val=crcx_tmp;
    end
    return crcx_val;
	 $display("crcx_val = %h", crcx_val);
endfunction : generateCRC_X
*/

constraint soft_c{
	soft preamble == 56'h55_5555_5555_5555;
	soft sfd == 8'hd5;
	soft len inside {[46:1500]};
	soft frame_type == ETH_FRAME; 
	soft da == 48'h01_80_c2_00_00_01;
	soft sa == 48'h11_22_33_44_55_66;
}

constraint payload_c{
	payload.size() == len;
}

constraint opcode_c{
	(frame_type == PAUSE_FRAME) -> (opcode == 16'h0001);
	(frame_type == PAUSE_FRAME) -> (type_len == 16'h8808);
}

endclass

