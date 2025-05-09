//processor interface
interface wb_proc_intf(input logic wb_clk_i, input logic wb_rst_i); //two data signal will be added later 

// WISHBONE slave
bit  [11:2]  wb_adr_i;     // WISHBONE address input, 1:0 is always 00 => word aligned
bit   [3:0]  wb_sel_i;     // WISHBONE byte select input
bit          wb_we_i;      // WISHBONE write enable input
bit          wb_cyc_i;     // WISHBONE cycle input
bit          wb_stb_i;     // WISHBONE strobe input
bit          wb_ack_o;     // WISHBONE acknowledge output
bit   [31:0] wb_dat_i;
bit   [31:0] wb_dat_o;
bit          wb_err_o;
bit          int_o;      // Burst Type Extension

clocking mon_cb@(posedge wb_clk_i);
	default input #1 output #0;
	input   wb_dat_i;
	input   wb_dat_o;
	input   wb_err_o;
	input   wb_adr_i;   
	input   wb_sel_i;   
	input   wb_we_i;    
	input   wb_cyc_i;   
	input   wb_stb_i;   
	input   wb_ack_o;    
	input   int_o;
endclocking

endinterface

