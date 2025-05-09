interface phy_intf();

// Tx
bit         mtx_clk_pad_i; // Transmit clock (from PHY)
bit  [3:0]     mtxd_pad_o;    // Transmit nibble (to PHY)
bit           mtxen_pad_o;   // Transmit enable (to PHY)
bit          mtxerr_pad_o;  // Transmit error (to PHY)

//Rx
bit          mrx_clk_pad_i; // Receive clock (from PHY)
bit  [3:0]      mrxd_pad_i;    // Receive nibble (from PHY)
bit            mrxdv_pad_i;   // Receive data valid (from PHY)
bit           mrxerr_pad_i;  // Receive data error (from PHY)

// Common Tx and Rx
bit          mcoll_pad_i;   // Collision (from PHY)
bit          mcrs_pad_i;    // Carrier sense (from PHY)

clocking rx_mon_cb@(posedge mrx_clk_pad_i);
	default input #1 output #0;
	input  mrx_clk_pad_i;
	input  mrxd_pad_i;   
	input  mrxdv_pad_i;  
	input  mrxerr_pad_i;
endclocking

clocking tx_mon_cb@(posedge mrx_clk_pad_i);
	default input #1 output #0;
	input  mtx_clk_pad_i;
	input  mtxd_pad_o;    
	input  mtxen_pad_o;   
	input  mtxerr_pad_o;  
endclocking

endinterface
