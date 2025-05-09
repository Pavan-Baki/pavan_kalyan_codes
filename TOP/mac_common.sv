//new component
`define NEW_COMP \
function new(string name, uvm_component parent); \
	super.new(name, parent); \
endfunction 

//new object 
`define NEW_OBJ \
function new(string name = ""); \
	super.new(name); \
endfunction

typedef bit [3:0] nibble_t;

class mac_common;

static bit [31:0] regmaskA[20:0];
static bit int_o_asserted;
static bit int_o_asserted_sbd;
static bit [6:0] exp_isrc_val;
static int num_matches;
static int num_mismatches;

function new();

	regmaskA[0]  = {15'h0, 17'h1FFFF};
	regmaskA[1]  = {25'h0, 7'h7F};
	regmaskA[2]  = {25'h0, 7'h7F};
	regmaskA[3]  = {25'h0, 7'h7F};
	regmaskA[4]  = {25'h0, 7'h7F};
	regmaskA[5]  = {25'h0, 7'h7F};
	regmaskA[6]  = {32'hFFFF_FFFF};
	regmaskA[7]  = {12'h0, 4'hF, 10'h0, 6'h3F};
	regmaskA[8]  = {24'h0, 8'hFF};
	regmaskA[9]  = {29'h0, 3'h7};
	regmaskA[10] = {23'h0, 9'h1FF};
	regmaskA[11] = {29'h0, 3'h7};
	regmaskA[12] = {19'h0, 5'h1F, 3'h0, 5'h1F};
	regmaskA[13] = {16'h0, 16'hFFFF};
	regmaskA[14] = {16'h0, 16'hFFFF};
	regmaskA[15] = {29'h0, 3'h7};
	regmaskA[16] = {32'hFFFF_FFFF};
	regmaskA[17] = {16'h0, 16'hFFFF};
	regmaskA[18] = {32'hFFFF_FFFF};
	regmaskA[19] = {32'hFFFF_FFFF};
	regmaskA[20] = {15'h0, 17'h1FFFF};

endfunction

endclass 

