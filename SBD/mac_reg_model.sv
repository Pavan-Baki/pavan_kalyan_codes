class moder_reg extends uvm_reg;

`uvm_object_utils(moder_reg)
	uvm_reg_field recsmall;
	uvm_reg_field pad;
	uvm_reg_field hugen;
	uvm_reg_field crcen;
	uvm_reg_field dlycrcen;
	uvm_reg_field rsvd;
	uvm_reg_field fulld;
	uvm_reg_field exdfren;
	uvm_reg_field nobckof;
	uvm_reg_field loopbck;
	uvm_reg_field ifg;
	uvm_reg_field pro;
	uvm_reg_field iam;
	uvm_reg_field bro;
	uvm_reg_field nopre;
	uvm_reg_field txen;
	uvm_reg_field rxen;

//uvm register model hjas a mechanism which enables automatic sampling of below covergroups whenever moder register write happens 
covergroup moder_cg;
	RECSMALL_CP : coverpoint recsmall.value{
		bins RECSMALL_1 = {1'b1};
		bins RECSMALL_0 = {1'b0};
	}

	FULLD_CP : coverpoint fulld.value{
		bins FD = {1'b1};
		bins HD = {1'b0};
	}

	TXEN_CP : coverpoint txen.value{
		bins TXEN = {1'b1};
		ignore_bins ignore = {1'b0}; //not interested in this scenarios so ignore this 
	}

	RXEN_CP : coverpoint rxen.value{
		bins RXEN = {1'b1};
		ignore_bins ignore = {1'b0}; //not interested in this scenarios so ignore this 
	}

endgroup 


function new(string name = "moder_reg");
   super.new(name, 17, build_coverage(UVM_CVR_FIELD_VALS)); //upper 15 bits reserved
	if(has_coverage(UVM_CVR_FIELD_VALS))begin 
		moder_cg = new();
		set_coverage(UVM_CVR_FIELD_VALS);
	end 
endfunction

//sample only if this register is accessed 
function void sample(uvm_reg_data_t data,
							uvm_reg_data_t	byte_en,
							bit            is_read,
							uvm_reg_map    map);
	$display("In sample coverage enable bit is %0b", get_coverage(UVM_CVR_FIELD_VALS));
	if(get_coverage(UVM_CVR_FIELD_VALS)) begin 
		moder_cg.sample();
	end 
	
endfunction 

// build method 
virtual function void build();
	recsmall = uvm_reg_field::type_id::create("recsmall");
	pad 	 = uvm_reg_field::type_id::create("pad");
	hugen 	 = uvm_reg_field::type_id::create("hugen");
	crcen    = uvm_reg_field::type_id::create("crcen");
	dlycrcen = uvm_reg_field::type_id::create("dlycrcen");
	rsvd     = uvm_reg_field::type_id::create("rsvd"); //it is design bug *
	fulld    = uvm_reg_field::type_id::create("fulld");
	exdfren  = uvm_reg_field::type_id::create("exdfren");
	nobckof  = uvm_reg_field::type_id::create("nobckof");
	loopbck  = uvm_reg_field::type_id::create("loopbck");
	ifg      = uvm_reg_field::type_id::create("ifg");
	pro      = uvm_reg_field::type_id::create("pro");
	iam      = uvm_reg_field::type_id::create("iam");
	bro      = uvm_reg_field::type_id::create("bro");
	nopre    = uvm_reg_field::type_id::create("nopre");
	txen     = uvm_reg_field::type_id::create("txen");
	rxen     = uvm_reg_field::type_id::create("rxen");

   recsmall.configure(	this, 1, 16, "RW", 1, 1'b0, 1, 1, 0);
	pad.configure(	   	this, 1, 15, "RW", 1, 1'b1, 1, 1, 0);
	hugen.configure(	this, 1, 14, "RW", 1, 1'b0, 1, 1, 0);
	crcen.configure(	this, 1, 13, "RW", 1, 1'b1, 1, 1, 0);
	dlycrcen.configure(	this, 1, 12, "RW", 1, 1'b0, 1, 1, 0);
	rsvd.configure(	        this, 1, 11, "RW", 1, 1'b0, 1, 1, 0); //it is design bug *
	fulld.configure(	this, 1, 10, "RW", 1, 1'b0, 1, 1, 0);
	exdfren.configure(	this, 1, 9,  "RW", 1, 1'b0, 1, 1, 0);
	nobckof.configure(	this, 1, 8,  "RW", 1, 1'b0, 1, 1, 0);
	loopbck.configure(	this, 1, 7,  "RW", 1, 1'b0, 1, 1, 0);
	ifg.configure(		this, 1, 6,  "RW", 1, 1'b0, 1, 1, 0);
	pro.configure(		this, 1, 5,  "RW", 1, 1'b0, 1, 1, 0);
	iam.configure(		this, 1, 4,  "RW", 1, 1'b0, 1, 1, 0);
	bro.configure(		this, 1, 3,  "RW", 1, 1'b0, 1, 1, 0);
	nopre.configure(	this, 1, 2,  "RW", 1, 1'b0, 1, 1, 0);
	txen.configure(		this, 1, 1,  "RW", 1, 1'b0, 1, 1, 0);
	rxen.configure(		this, 1, 0,  "RW", 1, 1'b0, 1, 1, 0);
endfunction
endclass

class intsrc_reg extends uvm_reg;
`uvm_object_utils(intsrc_reg)
uvm_reg_field rxc;
uvm_reg_field txc;
uvm_reg_field busy;
uvm_reg_field rxe;
uvm_reg_field rxb;
uvm_reg_field txe;
uvm_reg_field txb;

function new(string name = "intsrc_reg");
   super.new(name, 7, UVM_NO_COVERAGE); //upper 15 bits reserved
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	 rxc = uvm_reg_field::type_id::create("rxc");
	 txc = uvm_reg_field::type_id::create("txc");
	 busy = uvm_reg_field::type_id::create("busy");
	 rxe = uvm_reg_field::type_id::create("rxe");
	 rxb = uvm_reg_field::type_id::create("rxb");
	 txe = uvm_reg_field::type_id::create("txe");
	 txb = uvm_reg_field::type_id::create("txb");

   	rxc.configure(	this, 1, 6, "W1C", 1, 1'b0, 1, 1, 0);
   	txc.configure(	this, 1, 5, "W1C", 1, 1'b0, 1, 1, 0);
   	busy.configure(this, 1, 4, "W1C", 1, 1'b0, 1, 1, 0);
   	rxe.configure(	this, 1, 3, "W1C", 1, 1'b0, 1, 1, 0);
   	rxb.configure(	this, 1, 2, "W1C", 1, 1'b0, 1, 1, 0);
   	txe.configure(	this, 1, 1, "W1C", 1, 1'b0, 1, 1, 0);
   	txb.configure(	this, 1, 0, "W1C", 1, 1'b0, 1, 1, 0);
endfunction
endclass

class intmask_reg extends uvm_reg;
`uvm_object_utils(intmask_reg)
	uvm_reg_field rxc_m;
	uvm_reg_field txc_m;
	uvm_reg_field busy_m;
	uvm_reg_field rxe_m;
	uvm_reg_field rxf_m;
	uvm_reg_field txe_m;
	uvm_reg_field txb_m;

covergroup intmask_cg;
	RXC_CP : coverpoint rxc_m.value{
		bins RXC_INT_MASKED  = {1'b1};
		bins RXC_INT_ENABLED = {1'b0};
	}

	TXC_CP : coverpoint txc_m.value{
		bins TXC_INT_MASKED  = {1'b1};
		bins TXC_INT_ENABLED = {1'b0};
	}

	BUSY_CP : coverpoint busy_m.value{
		bins BUSY_INT_MASKED  = {1'b1};
		bins BUSY_INT_ENABLED = {1'b0};
	}

	RXE_CP : coverpoint rxe_m.value{
		bins RXE_INT_MASKED  = {1'b1};
		bins RXE_INT_ENABLED = {1'b0};
	}

	RXF_CP : coverpoint rxf_m.value{
		bins RXF_INT_MASKED  = {1'b1};
		bins RXF_INT_ENABLED = {1'b0};
	}

	TXE_CP : coverpoint txe_m.value{
		bins TXE_INT_MASKED  = {1'b1};
		bins TXE_INT_ENABLED = {1'b0};
	}
	TXB_CP : coverpoint txb_m.value{
		bins TXB_INT_MASKED  = {1'b1};
		bins TXB_INT_ENABLED = {1'b0};
	}

endgroup

function new(string name = "intmask_reg");
   super.new(name, 7, build_coverage(UVM_CVR_FIELD_VALS)); 
	if(has_coverage(UVM_CVR_FIELD_VALS))begin 
		intmask_cg = new();
		set_coverage(UVM_CVR_FIELD_VALS);
	end 
endfunction

//sample only if this register is accessed 
function void sample(uvm_reg_data_t data,
							uvm_reg_data_t	byte_en,
							bit            is_read,
							uvm_reg_map    map);
	$display("In sample coverage enable bit is %0b", get_coverage(UVM_CVR_FIELD_VALS));
	if(get_coverage(UVM_CVR_FIELD_VALS)) begin 
		intmask_cg.sample();
	end 
	
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	 rxc_m = uvm_reg_field::type_id::create("rxc_m");
	 txc_m = uvm_reg_field::type_id::create("txc_m");
	 busy_m = uvm_reg_field::type_id::create("busy_m");
	 rxe_m = uvm_reg_field::type_id::create("rxe_m");
	 rxf_m = uvm_reg_field::type_id::create("rxf_m");
	 txe_m = uvm_reg_field::type_id::create("txe_m");
	 txb_m = uvm_reg_field::type_id::create("txb_m");

   	rxc_m.configure(	this, 1, 6, "RW", 1, 1'b0, 1, 1, 0);
   	txc_m.configure(	this, 1, 5, "RW", 1, 1'b0, 1, 1, 0);
   	busy_m.configure(	this, 1, 4, "RW", 1, 1'b0, 1, 1, 0);
   	rxe_m.configure(	this, 1, 3, "RW", 1, 1'b0, 1, 1, 0);
   	rxf_m.configure(	this, 1, 2, "RW", 1, 1'b0, 1, 1, 0);
   	txe_m.configure(	this, 1, 1, "RW", 1, 1'b0, 1, 1, 0);
   	txb_m.configure(	this, 1, 0, "RW", 1, 1'b0, 1, 1, 0);
endfunction
endclass

class ipgt_reg extends uvm_reg;
`uvm_object_utils(ipgt_reg)
uvm_reg_field igpt;

function new(string name = "ipgt_reg");
   super.new(name, 7, UVM_NO_COVERAGE); //upper 15 bits reserved
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	igpt = uvm_reg_field::type_id::create("igpt");
   	igpt.configure(	this, 7, 0, "RW", 1, 7'h12, 1, 1, 0);
endfunction
endclass

class ipgr1_reg extends uvm_reg;
`uvm_object_utils(ipgr1_reg)
uvm_reg_field ipgr1;

function new(string name = "ipgr1_reg");
   super.new(name, 7, UVM_NO_COVERAGE); //upper 15 bits reserved
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	ipgr1 = uvm_reg_field::type_id::create("ipgr1");
   	ipgr1.configure(	this, 7, 0, "RW", 1, 7'hC, 1, 1, 0);
endfunction
endclass

class ipgr2_reg extends uvm_reg;
`uvm_object_utils(ipgr2_reg)
uvm_reg_field ipgr2;

function new(string name = "ipgr2_reg");
   super.new(name, 7, UVM_NO_COVERAGE); //upper 15 bits reserved
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	ipgr2 = uvm_reg_field::type_id::create("ipgr2");
   	ipgr2.configure(	this, 7, 0, "RW", 1, 7'h12, 1, 1, 0);
endfunction
endclass

class packetlen_reg extends uvm_reg;
`uvm_object_utils(packetlen_reg)
uvm_reg_field minfl;
uvm_reg_field maxfl;

function new(string name = "packetlen_reg");
   super.new(name, 32, UVM_NO_COVERAGE); //upper 15 bits reserved
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	minfl = uvm_reg_field::type_id::create("minfl");
	maxfl = uvm_reg_field::type_id::create("maxfl");
   	minfl.configure(this, 16, 16, "RW", 1, 16'h40, 1, 1, 0);
   	maxfl.configure(this, 16, 0, "RW", 1, 16'h600, 1, 1, 0);
endfunction
endclass

class collconf_reg extends uvm_reg;
`uvm_object_utils(collconf_reg)
uvm_reg_field maxret;
uvm_reg_field collvalid;
uvm_reg_field rsvd;

function new(string name = "collconf_reg");
   super.new(name, 20, UVM_NO_COVERAGE); //upper 15 bits reserved
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	maxret = uvm_reg_field::type_id::create("maxret");
	collvalid = uvm_reg_field::type_id::create("collvalid");
	rsvd = uvm_reg_field::type_id::create("rsvd");

   	maxret.configure(this, 4, 16, "RW", 1, 4'hF, 1, 1, 0);
   	rsvd.configure(this, 10, 6, "RW", 1, 10'h00, 1, 1, 0);
   	collvalid.configure(this, 6, 0, "RW", 1, 6'h3F, 1, 1, 0);
endfunction
endclass

class txbdnum_reg extends uvm_reg;
`uvm_object_utils(txbdnum_reg)
uvm_reg_field txbdnum;

function new(string name = "txbdnum_reg");
   super.new(name, 8, UVM_NO_COVERAGE);
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	txbdnum = uvm_reg_field::type_id::create("txbdnum");
   	txbdnum.configure(	this, 8, 0, "RW", 1, 8'h40, 1, 1, 0);
endfunction
endclass

class ctrlmoder_reg extends uvm_reg;
`uvm_object_utils(ctrlmoder_reg)
uvm_reg_field txflow;
uvm_reg_field rxflow;
uvm_reg_field passall;

function new(string name = "ctrlmoder_reg");
   super.new(name, 3, UVM_NO_COVERAGE);
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	txflow = uvm_reg_field::type_id::create("txflow");
	rxflow = uvm_reg_field::type_id::create("rxflow");
	passall = uvm_reg_field::type_id::create("passall");

   	txflow.configure(this, 1, 2, "RW", 1, 1'h0, 1, 1, 0);
   	rxflow.configure(this, 1, 1, "RW", 1, 1'h0, 1, 1, 0);
   	passall.configure(this, 1, 0, "RW", 1, 1'h0, 1, 1, 0);
endfunction
endclass

class miimoder_reg extends uvm_reg;
`uvm_object_utils(miimoder_reg)
uvm_reg_field miinopre;
uvm_reg_field clkdiv;

function new(string name = "miimoder_reg");
   super.new(name, 9, UVM_NO_COVERAGE);
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	miinopre = uvm_reg_field::type_id::create("miinopre");
	clkdiv = uvm_reg_field::type_id::create("clkdiv");

   	miinopre.configure(this, 1, 8, "RW", 1, 1'h0, 1, 1, 0);
   	clkdiv.configure(  this, 8, 0, "RW", 1, 8'h64, 1, 1, 0);
endfunction
endclass

class miicommand_reg extends uvm_reg;
`uvm_object_utils(miicommand_reg)
uvm_reg_field wctrldata;
uvm_reg_field rstat;
uvm_reg_field scanstat;

function new(string name = "miicommand_reg");
   super.new(name, 3, UVM_NO_COVERAGE);
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	wctrldata = uvm_reg_field::type_id::create("wctrldata");
	rstat = uvm_reg_field::type_id::create("rstat");
	scanstat = uvm_reg_field::type_id::create("scanstat");

   	wctrldata.configure(this, 1, 2, "RO", 1, 1'h0, 1, 1, 0);
   	rstat.configure(    this, 1, 1, "RO", 1, 1'h0, 1, 1, 0); //we need to confirm with RTL team 
   	scanstat.configure( this, 1, 0, "RW", 1, 1'h0, 1, 1, 0); //Confirm with RTL team
endfunction
endclass

class miiaddress_reg extends uvm_reg;
`uvm_object_utils(miiaddress_reg)
uvm_reg_field rgad;
uvm_reg_field fiad;
uvm_reg_field rsvd;
//uvm_reg_field rsvd1;

function new(string name = "miiaddress_reg");
   super.new(name, 13, UVM_NO_COVERAGE);
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	//rsvd1 = uvm_reg_field::type_id::create("rsvd1");
	rgad = uvm_reg_field::type_id::create("rgad");
	rsvd = uvm_reg_field::type_id::create("rsvd");
	fiad = uvm_reg_field::type_id::create("fiad");

   	//rsvd1.configure(this, 19, 9, "RW", 1, 19'h0, 1, 1, 0);
   	rgad.configure(this, 5, 8, "RW", 1, 5'h0, 1, 1, 0);
   	rsvd.configure(this, 3, 5, "RO", 1, 3'h0, 1, 1, 0);
   	fiad.configure(this, 5, 0, "RW", 1, 5'h0, 1, 1, 0);
endfunction
endclass

class miitx_data_reg extends uvm_reg;
`uvm_object_utils(miitx_data_reg)
uvm_reg_field ctrldata;

function new(string name = "miitx_data_reg");
   super.new(name, 16, UVM_NO_COVERAGE);
endfunction

//--------------------------------------------------------------------
// build
//--------------------------------------------------------------------
virtual function void build();
	ctrldata = uvm_reg_field::type_id::create("ctrldata");
   	ctrldata.configure(this, 16, 0, "RW", 1, 16'h0, 1, 1, 0);
endfunction
endclass

class miirx_data_reg extends uvm_reg;
`uvm_object_utils(miirx_data_reg)
uvm_reg_field prsd;

function new(string name = "miirx_data_reg");
   super.new(name, 16, UVM_NO_COVERAGE);
endfunction

virtual function void build();
	prsd = uvm_reg_field::type_id::create("prsd");
   	prsd.configure(this, 16, 0, "RO", 1, 16'h0, 1, 1, 0);
endfunction
endclass

class miistatus_reg extends uvm_reg;
`uvm_object_utils(miistatus_reg)
uvm_reg_field nvalid;
uvm_reg_field busy;
uvm_reg_field linkfail;

function new(string name = "miistatus_reg");
   super.new(name, 3, UVM_NO_COVERAGE);
endfunction

virtual function void build();
	nvalid = uvm_reg_field::type_id::create("nvalid");
	busy = uvm_reg_field::type_id::create("busy");
	linkfail = uvm_reg_field::type_id::create("linkfail");

   	nvalid.configure(	this, 1, 2, "RO", 1, 1'h0, 1, 1, 0);
   	busy.configure(		this, 1, 1, "RO", 1, 1'h0, 1, 1, 0);
   	linkfail.configure(	this, 1, 0, "RO", 1, 1'h0, 1, 1, 0);
endfunction
endclass

class macaddr0_reg extends uvm_reg;
`uvm_object_utils(macaddr0_reg)
uvm_reg_field byte2;
uvm_reg_field byte3;
uvm_reg_field byte4;
uvm_reg_field byte5;

function new(string name = "macaddr0_reg");
   super.new(name, 32, UVM_NO_COVERAGE);
endfunction

virtual function void build();
	byte2 = uvm_reg_field::type_id::create("byte2");
	byte3 = uvm_reg_field::type_id::create("byte3");
	byte4 = uvm_reg_field::type_id::create("byte4");
	byte5 = uvm_reg_field::type_id::create("byte5");
   	byte2.configure(this, 8, 24, "RW", 1, 1'h0, 1, 1, 0);
   	byte3.configure(this, 8, 16, "RW", 1, 1'h0, 1, 1, 0);
   	byte4.configure(this, 8, 8,  "RW", 1, 1'h0, 1, 1, 0);
   	byte5.configure(this, 8, 0,  "RW", 1, 1'h0, 1, 1, 0);
endfunction
endclass

class macaddr1_reg extends uvm_reg;
`uvm_object_utils(macaddr1_reg)
uvm_reg_field byte0;
uvm_reg_field byte1;

function new(string name = "macaddr1_reg");
   super.new(name, 16, UVM_NO_COVERAGE);
endfunction

virtual function void build();
	byte0 = uvm_reg_field::type_id::create("byte0");
	byte1 = uvm_reg_field::type_id::create("byte1");
   	byte0.configure(this, 8, 8, "RW", 1, 8'h0, 1, 1, 0);
   	byte1.configure(this, 8, 0, "RW", 1, 8'h0, 1, 1, 0);
endfunction
endclass

class hash0_reg extends uvm_reg;
`uvm_object_utils(hash0_reg)
uvm_reg_field hash0;

function new(string name = "hash0_reg");
   super.new(name, 32, UVM_NO_COVERAGE);
endfunction

virtual function void build();
	hash0 = uvm_reg_field::type_id::create("hash0");
   	hash0.configure(this, 32, 0, "RW", 1, 32'h0, 1, 1, 0);
endfunction
endclass

class hash1_reg extends uvm_reg;
`uvm_object_utils(hash1_reg)
uvm_reg_field hash1;

function new(string name = "hash1_reg");
   super.new(name, 32, UVM_NO_COVERAGE);
endfunction

virtual function void build();
	hash1 = uvm_reg_field::type_id::create("hash1");
   	hash1.configure(this, 32, 0, "RW", 1, 32'h0, 1, 1, 0);
endfunction
endclass

class txctrl_reg extends uvm_reg;
`uvm_object_utils(txctrl_reg)
uvm_reg_field txpausetv;
uvm_reg_field txpauserq;

function new(string name = "txctrl_reg");
   super.new(name, 17, UVM_NO_COVERAGE);
endfunction

virtual function void build();
	txpausetv = uvm_reg_field::type_id::create("txpausetv");
	txpauserq = uvm_reg_field::type_id::create("txpauserq");
   	txpausetv.configure(this, 16, 0, "RW", 1, 16'h0, 1, 1, 0);
   	txpauserq.configure(this, 1, 16, "RW", 1, 1'h0, 1, 1, 0);
endfunction
endclass

class mac_reg_block extends uvm_reg_block;
`uvm_object_utils(mac_reg_block)
moder_reg 	moder;
intsrc_reg 	intsrc;
intmask_reg intmask;
ipgt_reg 	ipgt;
ipgr1_reg 	ipgr1;
ipgr2_reg 	ipgr2;
packetlen_reg packetlen;
collconf_reg collconf;
txbdnum_reg txbdnum;
ctrlmoder_reg ctrlmoder;
miimoder_reg miimoder;
miicommand_reg miicommand;
miiaddress_reg miiaddress;
miitx_data_reg miitx_data;
miirx_data_reg miirx_data;
miistatus_reg miistatus;
macaddr0_reg macaddr0;
macaddr1_reg macaddr1;
hash0_reg hash0;
hash1_reg hash1;
txctrl_reg txctrl;

uvm_reg_map wb_map; //registers are accessing using WB interface.

function new(string name = "mac_reg_block");
   super.new(name, build_coverage(UVM_CVR_ADDR_MAP));
endfunction

virtual function void build();
string s;

moder = moder_reg::type_id::create("moder");
moder.configure(this, null, "");
moder.build();	 
for(int i = 0; i < 17; i++) begin  //For backdoor access
  $sformat(s, "MODEROut[%0d]", i);
  moder.add_hdl_path_slice(s, i, 1);  //csr[0], csr[1]... => offset 
end

intsrc = intsrc_reg::type_id::create("intsrc");
intsrc.configure(this, null, "");
intsrc.build();	 
for(int i = 0; i < 7; i++) begin
  $sformat(s, "INT_SOURCEOut[%0d]", i);  //top.dut.u4.funct_adr
  intsrc.add_hdl_path_slice(s, i, 1);
end

intmask = intmask_reg::type_id::create("intmask");
intmask.configure(this, null, "");
intmask.build();	 
for(int i = 0; i < 7; i++) begin
  $sformat(s, "INT_MASKOut[%0d]", i);
  intmask.add_hdl_path_slice(s, i, 1);
end

ipgt = ipgt_reg::type_id::create("ipgt");
ipgt.configure(this, null, "");
ipgt.build();	 
for(int i = 0; i < 7; i++) begin
  $sformat(s, "IPGTOut[%0d]", i);
  ipgt.add_hdl_path_slice(s, i, 1);
end


ipgr1 = ipgr1_reg::type_id::create("ipgr1");
ipgr1.configure(this, null, "");
ipgr1.build();	 
for(int i = 0; i < 7; i++) begin
  $sformat(s, "IPGR1Out[%0d]", i);
  ipgr1.add_hdl_path_slice(s, i, 1);
end


ipgr2 = ipgr2_reg::type_id::create("ipgr2");
ipgr2.configure(this, null, "");
ipgr2.build();	 
for(int i = 0; i < 7; i++) begin
  $sformat(s, "IPGR2Out[%0d]", i);
  ipgr2.add_hdl_path_slice(s, i, 1);
end


packetlen = packetlen_reg::type_id::create("packetlen");
packetlen.configure(this, null, "");
packetlen.build();	 
for(int i = 0; i < 32; i++) begin
  $sformat(s, "PACKETLENOut[%0d]", i);
  packetlen.add_hdl_path_slice(s, i, 1);
end


collconf = collconf_reg::type_id::create("collconf");
collconf.configure(this, null, "");
collconf.build();	 
for(int i = 0; i < 20; i++) begin
  $sformat(s, "COLLCONFOut[%0d]", i);
  collconf.add_hdl_path_slice(s, i, 1);
end


txbdnum = txbdnum_reg::type_id::create("txbdnum");
txbdnum.configure(this, null, "");
txbdnum.build();	 
for(int i = 0; i < 8; i++) begin
  $sformat(s, "TX_BD_NUMOut[%0d]", i);
  txbdnum.add_hdl_path_slice(s, i, 1);
end

ctrlmoder = ctrlmoder_reg::type_id::create("ctrlmoder");
ctrlmoder.configure(this, null, "");
ctrlmoder.build();	 
for(int i = 0; i < 3; i++) begin
  $sformat(s, "CTRLMODEROut[%0d]", i);
  ctrlmoder.add_hdl_path_slice(s, i, 1);
end

miimoder = miimoder_reg::type_id::create("miimoder");
miimoder.configure(this, null, "");
miimoder.build();	 
for(int i = 0; i < 9; i++) begin
  $sformat(s, "MIIMODEROut[%0d]", i);
  miimoder.add_hdl_path_slice(s, i, 1);
end


miicommand = miicommand_reg::type_id::create("miicommand");
miicommand.configure(this, null, "");
miicommand.build();	 
for(int i = 0; i < 3; i++) begin
  $sformat(s, "MIICOMMANDOut[%0d]", i);
  miicommand.add_hdl_path_slice(s, i, 1);
end

miiaddress = miiaddress_reg::type_id::create("miiaddress");
miiaddress.configure(this, null, "");
miiaddress.build();	 
for(int i = 0; i < 13; i++) begin
  $sformat(s, "MIIADDRESSOut[%0d]", i);
  miiaddress.add_hdl_path_slice(s, i, 1);
end



miitx_data = miitx_data_reg::type_id::create("miitx_data");
miitx_data.configure(this, null, "");
miitx_data.build();	 
for(int i = 0; i < 16; i++) begin
  $sformat(s, "MIITX_DATAOut[%0d]", i);
  miitx_data.add_hdl_path_slice(s, i, 1);
end

miirx_data = miirx_data_reg::type_id::create("miirx_data");
miirx_data.configure(this, null, "");
miirx_data.build();	 
for(int i = 0; i < 16; i++) begin
  $sformat(s, "MIIRX_DATAOut[%0d]", i);
  miirx_data.add_hdl_path_slice(s, i, 1);
end

miistatus = miistatus_reg::type_id::create("miistatus");
miistatus.configure(this, null, "");
miistatus.build();	 
for(int i = 0; i < 3; i++) begin
  $sformat(s, "MIISTATUSOut[%0d]", i);
  miistatus.add_hdl_path_slice(s, i, 1);
end


macaddr0 = macaddr0_reg::type_id::create("macaddr0");
macaddr0.configure(this, null, "");
macaddr0.build();	 
for(int i = 0; i < 32; i++) begin
  $sformat(s, "MAC_ADDR0Out[%0d]", i);
  macaddr0.add_hdl_path_slice(s, i, 1);
end


macaddr1 = macaddr1_reg::type_id::create("macaddr1");
macaddr1.configure(this, null, "");
macaddr1.build();	 
for(int i = 0; i < 16; i++) begin
  $sformat(s, "MAC_ADDR1Out[%0d]", i);
  macaddr1.add_hdl_path_slice(s, i, 1);
end

hash0 = hash0_reg::type_id::create("hash0");
hash0.configure(this, null, "");
hash0.build();	 
for(int i = 0; i < 32; i++) begin
  $sformat(s, "HASH0Out[%0d]", i);
  hash0.add_hdl_path_slice(s, i, 1);
end


hash1 = hash1_reg::type_id::create("hash1");
hash1.configure(this, null, "");
hash1.build();	 
for(int i = 0; i < 32; i++) begin
  $sformat(s, "HASH1Out[%0d]", i);
  hash1.add_hdl_path_slice(s, i, 1);
end

txctrl = txctrl_reg::type_id::create("txctrl");
txctrl.configure(this, null, "");
txctrl.build();	 
for(int i = 0; i < 17; i++) begin
  $sformat(s, "TXCTRLOut[%0d]", i);
  txctrl.add_hdl_path_slice(s, i, 1);
end


wb_map = create_map("wb_map", 'h0, 4, UVM_LITTLE_ENDIAN);
wb_map.set_auto_predict(); //to call the auto_predict function in src file for coverage 
wb_map.add_reg(moder, 32'h0, "RW");
wb_map.add_reg(intsrc, 32'h1, "RW");
wb_map.add_reg(intmask, 32'h2, "RW");
wb_map.add_reg(ipgt, 32'h3, "RW");
wb_map.add_reg(ipgr1, 32'h4, "RW");
wb_map.add_reg(ipgr2, 32'h5, "RW");
wb_map.add_reg(packetlen, 32'h6, "RW");
wb_map.add_reg(collconf, 32'h7, "RW");
wb_map.add_reg(txbdnum, 32'h8, "RW");
wb_map.add_reg(ctrlmoder, 32'h9, "RW");
wb_map.add_reg(miimoder, 32'hA, "RW");
wb_map.add_reg(miicommand, 32'hB, "RW");
wb_map.add_reg(miiaddress, 32'hC, "RW");
wb_map.add_reg(miitx_data, 32'hD, "RW");
wb_map.add_reg(miirx_data, 32'hE, "RW");
wb_map.add_reg(miistatus, 32'hF, "RO");
wb_map.add_reg(macaddr0, 32'h10, "RW");
wb_map.add_reg(macaddr1, 32'h11, "RW");
wb_map.add_reg(hash0, 32'h12, "RW");
wb_map.add_reg(hash1, 32'h13, "RW");
wb_map.add_reg(txctrl, 32'h14, "RW");

add_hdl_path("top.dut.ethreg1", "RTL");
lock_model();
endfunction

endclass

