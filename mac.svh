//Design files
`include "timescale.v"
`include "eth_clockgen.v"
`include "eth_cop.v"
`include "eth_crc.v"
`include "eth_fifo.v"
`include "eth_maccontrol.v"
`include "eth_macstatus.v"
`include "eth_miim.v"
`include "eth_outputcontrol.v"
`include "eth_random.v"
`include "eth_receivecontrol.v"
`include "eth_register.v"
`include "eth_registers.v"
`include "eth_rxaddrcheck.v"
`include "eth_rxcounters.v"
`include "eth_rxethmac.v"
`include "eth_rxstatem.v"
`include "eth_shiftreg.v"
`include "eth_spram_256x32.v"
//`include "eth_top.v"
`include "eth_transmitcontrol.v"
`include "eth_txcounters.v"
`include "eth_txethmac.v"
`include "eth_txstatem.v"
`include "eth_wishbone.v"
`include "ethmac.v"
`include "ethmac_defines.v"
//`include "xilinx_dist_ram_16x32.v"

//testbench files
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "mac_common.sv"
`include "mac_reg_model.sv"
`include "eth_frame.sv"
`include "wb_tx.sv"
`include "wb_adapter.sv"
`include "wb_proc_intf.sv"
`include "wb_mem_intf.sv"
`include "phy_intf.sv"
`include "miim_intf.sv"

`include "wb_proc_cov.sv"
`include "wb_proc_mon.sv"
`include "wb_proc_drv.sv"
`include "wb_proc_sqr.sv"
`include "wb_proc_seq_lib.sv"
`include "wb_proc_agent.sv"

`include "memory.sv"
`include "wb_mem_mon.sv"
`include "wb_mem_agent.sv"

`include "phy_tx_mon.sv"
`include "phy_tx_drv.sv"
`include "phy_tx_agent.sv"

`include "phy_rx_mon.sv"
`include "phy_rx_drv.sv"
`include "phy_rx_sqr.sv"
`include "phy_rx_seq_lib.sv"
`include "phy_rx_agent.sv"

`include "miim_agent.sv"

`include "mac_sbd.sv"

`include "ethmac_env.sv"
`include "test_lib.sv"
 


