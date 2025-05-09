interface miim_intf();
 
// MII Management interface
bit          md_pad_i;      // MII data input (from I/O cell)
bit          mdc_pad_o;     // MII Management data clock (to PHY)
bit          md_pad_o;      // MII data output (to I/O cell)
bit          md_padoe_o;    // MII data output enable (to I/O cell)
//bit          int_o;

endinterface
