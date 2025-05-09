//memory interface 
interface wb_mem_intf(input logic wb_clk_i, input logic wb_rst_i);

// WISHBONE master (eth_mac => slave for memory)
bit [31:0]  m_wb_adr_o;
bit  [3:0]  m_wb_sel_o;
bit         m_wb_we_o;
bit [31:0]  m_wb_dat_i;
bit [31:0]  m_wb_dat_o;
bit         m_wb_cyc_o;
bit         m_wb_stb_o;
bit         m_wb_ack_i;
bit         m_wb_err_i;
bit [29:0]  m_wb_adr_tmp;
bit  [2:0]  m_wb_cti_o;   // Cycle Type Identifier
bit  [1:0]  m_wb_bte_o;   // Burst Type Extension

clocking slv_cb@(posedge wb_clk_i);
default input #0 output #1;
input    m_wb_adr_o;
input    m_wb_sel_o;
input    m_wb_we_o;
output   m_wb_dat_i;
input    m_wb_dat_o;
input    m_wb_cyc_o;
input    m_wb_stb_o;
output   m_wb_ack_i;
output   m_wb_err_i;
input    m_wb_adr_tmp;
input    m_wb_cti_o;   // Cycle Type Identifier
input    m_wb_bte_o;

endclocking 

endinterface
