`include "mac.svh"

module top;

//clk and rst signal 
reg wb_clk_i;
reg wb_rst_i;

//interface instantiation 
wb_proc_intf proc_pif(wb_clk_i, wb_rst_i);
wb_mem_intf mem_pif(wb_clk_i, wb_rst_i);
phy_intf phy_pif();
miim_intf mii_pif();

mac_common common = new(); //for new gets called for common class 

//dut instntiation 
ethmac dut(

  // WISHBONE common
	.wb_clk_i(wb_clk_i),
 	.wb_rst_i(wb_rst_i), 
	.wb_dat_i(proc_pif.wb_dat_i), 
	.wb_dat_o(proc_pif.wb_dat_o), 

  // WISHBONE slave
	.wb_adr_i(proc_pif.wb_adr_i), 
	.wb_sel_i(proc_pif.wb_sel_i), 
	.wb_we_i (proc_pif.wb_we_i), 
	.wb_cyc_i(proc_pif.wb_cyc_i), 
	.wb_stb_i(proc_pif.wb_stb_i), 
	.wb_ack_o(proc_pif.wb_ack_o), 
	.wb_err_o(proc_pif.wb_err_o), 
  	.int_o   (proc_pif.int_o),

  // WISHBONE master
 	.m_wb_adr_o(mem_pif.m_wb_adr_o), 
	.m_wb_sel_o(mem_pif.m_wb_sel_o), 
	.m_wb_we_o (mem_pif.m_wb_we_o), 
  	.m_wb_dat_o(mem_pif.m_wb_dat_o), 
	.m_wb_dat_i(mem_pif.m_wb_dat_i), 
	.m_wb_cyc_o(mem_pif.m_wb_cyc_o), 
 	.m_wb_stb_o(mem_pif.m_wb_stb_o), 
	.m_wb_ack_i(mem_pif.m_wb_ack_i), 
	.m_wb_err_i(mem_pif.m_wb_err_i),
	.m_wb_cti_o(mem_pif.m_wb_cti_o), 
	.m_wb_bte_o(mem_pif.m_wb_bte_o), 

  //TX
 	.mtx_clk_pad_i(phy_pif.mtx_clk_pad_i), 
	.mtxd_pad_o   (phy_pif.mtxd_pad_o), 
	.mtxen_pad_o  (phy_pif.mtxen_pad_o), 
	.mtxerr_pad_o (phy_pif.mtxerr_pad_o),

  //RX
 	.mrx_clk_pad_i(phy_pif.mrx_clk_pad_i), 
	.mrxd_pad_i   (phy_pif.mrxd_pad_i), 
	.mrxdv_pad_i  (phy_pif.mrxdv_pad_i), 
	.mrxerr_pad_i (phy_pif.mrxerr_pad_i), 
	.mcoll_pad_i  (phy_pif.mcoll_pad_i), 
	.mcrs_pad_i   (phy_pif.mcrs_pad_i),
  
  // MIIM
  	.mdc_pad_o (mii_pif.mdc_pad_o), 
	.md_pad_i  (mii_pif.md_pad_i), 
	.md_pad_o  (mii_pif.md_pad_o), 
	.md_padoe_o(mii_pif.md_padoe_o)


);

//Wb clk
initial begin
	wb_clk_i=1'b0;
	forever #5 wb_clk_i=~wb_clk_i;
end

//Reset
initial begin
	wb_rst_i=1'b1;
	repeat(2)@(posedge wb_clk_i);
	wb_rst_i=1'b0;
	#500000;
	$finish();
end

// Interface handle passing using config db
initial begin 
	uvm_resource_db#(virtual wb_proc_intf)::set("GLOBAL", "PROC_VIF", proc_pif, null);
	uvm_resource_db#(virtual wb_mem_intf)::set("GLOBAL", "MEM_VIF", mem_pif, null);
	uvm_resource_db#(virtual phy_intf)::set("GLOBAL", "PHY_VIF", phy_pif, null);
	uvm_resource_db#(virtual miim_intf)::set("GLOBAL", "MIIM_VIF", mii_pif, null);
end 

//Run test
initial	begin
	run_test("mac_base_test");
end

endmodule

