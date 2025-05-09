onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/proc_pif/wb_clk_i
add wave -noupdate /top/proc_pif/wb_rst_i
add wave -noupdate /top/proc_pif/wb_adr_i
add wave -noupdate /top/proc_pif/wb_sel_i
add wave -noupdate /top/proc_pif/wb_we_i
add wave -noupdate /top/proc_pif/wb_cyc_i
add wave -noupdate /top/proc_pif/wb_stb_i
add wave -noupdate /top/proc_pif/wb_ack_o
add wave -noupdate /top/proc_pif/wb_dat_i
add wave -noupdate /top/proc_pif/wb_dat_o
add wave -noupdate /top/proc_pif/wb_err_o
add wave -noupdate /top/proc_pif/int_o
add wave -noupdate /top/mem_pif/wb_clk_i
add wave -noupdate /top/mem_pif/wb_rst_i
add wave -noupdate /top/mem_pif/m_wb_adr_o
add wave -noupdate /top/mem_pif/m_wb_sel_o
add wave -noupdate /top/mem_pif/m_wb_we_o
add wave -noupdate /top/mem_pif/m_wb_dat_i
add wave -noupdate /top/mem_pif/m_wb_dat_o
add wave -noupdate /top/mem_pif/m_wb_cyc_o
add wave -noupdate /top/mem_pif/m_wb_stb_o
add wave -noupdate /top/mem_pif/m_wb_ack_i
add wave -noupdate /top/mem_pif/m_wb_err_i
add wave -noupdate /top/mem_pif/m_wb_adr_tmp
add wave -noupdate /top/mem_pif/m_wb_cti_o
add wave -noupdate /top/mem_pif/m_wb_bte_o
add wave -noupdate /top/phy_pif/mtx_clk_pad_i
add wave -noupdate /top/phy_pif/mtxd_pad_o
add wave -noupdate /top/phy_pif/mtxen_pad_o
add wave -noupdate /top/phy_pif/mtxerr_pad_o
add wave -noupdate /top/phy_pif/mrx_clk_pad_i
add wave -noupdate /top/phy_pif/mrxd_pad_i
add wave -noupdate /top/phy_pif/mrxdv_pad_i
add wave -noupdate /top/phy_pif/mrxerr_pad_i
add wave -noupdate /top/phy_pif/mcoll_pad_i
add wave -noupdate /top/phy_pif/mcrs_pad_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
