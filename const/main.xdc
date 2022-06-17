set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 6 [current_design]

set_property -dict { PACKAGE_PIN "AM39"  IOSTANDARD LVCMOS18 } [ get_ports {led[0]} ];
set_property -dict { PACKAGE_PIN "AN39"  IOSTANDARD LVCMOS18 } [ get_ports {led[1]} ];
set_property -dict { PACKAGE_PIN "AR37"  IOSTANDARD LVCMOS18 } [ get_ports {led[2]} ];
set_property -dict { PACKAGE_PIN "AT37"  IOSTANDARD LVCMOS18 } [ get_ports {led[3]} ];
set_property -dict { PACKAGE_PIN "AR35"  IOSTANDARD LVCMOS18 } [ get_ports {led[4]} ];
set_property -dict { PACKAGE_PIN "AP41"  IOSTANDARD LVCMOS18 } [ get_ports {led[5]} ];
set_property -dict { PACKAGE_PIN "AP42"  IOSTANDARD LVCMOS18 } [ get_ports {led[6]} ];
set_property -dict { PACKAGE_PIN "AU39"  IOSTANDARD LVCMOS18 } [ get_ports {led[7]} ];
set_property -dict { PACKAGE_PIN "AV30"  IOSTANDARD LVCMOS18 } [ get_ports {dip[0]} ];
set_property -dict { PACKAGE_PIN "AY33"  IOSTANDARD LVCMOS18 } [ get_ports {dip[1]} ];
set_property -dict { PACKAGE_PIN "BA31"  IOSTANDARD LVCMOS18 } [ get_ports {dip[2]} ];
set_property -dict { PACKAGE_PIN "BA32"  IOSTANDARD LVCMOS18 } [ get_ports {dip[3]} ];
set_property -dict { PACKAGE_PIN "AW30"  IOSTANDARD LVCMOS18 } [ get_ports {dip[4]} ];
set_property -dict { PACKAGE_PIN "AY30"  IOSTANDARD LVCMOS18 } [ get_ports {dip[5]} ];
set_property -dict { PACKAGE_PIN "BA30"  IOSTANDARD LVCMOS18 } [ get_ports {dip[6]} ];
set_property -dict { PACKAGE_PIN "BB31"  IOSTANDARD LVCMOS18 } [ get_ports {dip[7]} ];
set_property -dict { PACKAGE_PIN "AR40"  IOSTANDARD LVCMOS18 } [ get_ports sw_n ];
set_property -dict { PACKAGE_PIN "AU38"  IOSTANDARD LVCMOS18 } [ get_ports sw_e ];
set_property -dict { PACKAGE_PIN "AP40"  IOSTANDARD LVCMOS18 } [ get_ports sw_s ];
set_property -dict { PACKAGE_PIN "AW40"  IOSTANDARD LVCMOS18 } [ get_ports sw_w ];
set_property -dict { PACKAGE_PIN "AV39"  IOSTANDARD LVCMOS18 } [ get_ports sw_c ];
set_property -dict { PACKAGE_PIN "AT40"  IOSTANDARD LVCMOS18 } [ get_ports {lcd[0]} ]; # LCD_E_LS
set_property -dict { PACKAGE_PIN "AN41"  IOSTANDARD LVCMOS18 } [ get_ports {lcd[1]} ]; # LCD_RS_LS
set_property -dict { PACKAGE_PIN "AR42"  IOSTANDARD LVCMOS18 } [ get_ports {lcd[2]} ]; # LCD_RW_LS
set_property -dict { PACKAGE_PIN "AT42"  IOSTANDARD LVCMOS18 } [ get_ports {lcd[3]} ]; # LCD_DB4_LS
set_property -dict { PACKAGE_PIN "AR38"  IOSTANDARD LVCMOS18 } [ get_ports {lcd[4]} ]; # LCD_DB5_LS
set_property -dict { PACKAGE_PIN "AR39"  IOSTANDARD LVCMOS18 } [ get_ports {lcd[5]} ]; # LCD_DB6_LS
set_property -dict { PACKAGE_PIN "AN40"  IOSTANDARD LVCMOS18 } [ get_ports {lcd[6]} ]; # LCD_DB7_LS

set_property PACKAGE_PIN AH8 [ get_ports sgmii_clk_p ];
set_property PACKAGE_PIN AH7 [ get_ports sgmii_clk_n ];
set_property PACKAGE_PIN AN2 [ get_ports sgmii_txp ];
set_property PACKAGE_PIN AN1 [ get_ports sgmii_txn ];
set_property PACKAGE_PIN AM8 [ get_ports sgmii_rxp ];
set_property PACKAGE_PIN AM7 [ get_ports sgmii_rxn ];

set_property -dict { PACKAGE_PIN "AJ33"  IOSTANDARD LVCMOS18 } [ get_ports phy_rstn ];
set_property -dict { PACKAGE_PIN "AH31"  IOSTANDARD LVCMOS18 } [ get_ports gmii_mdc ];
set_property -dict { PACKAGE_PIN "AK33"  IOSTANDARD LVCMOS18 } [ get_ports gmii_mdio_in ];
set_property -dict { PACKAGE_PIN "AU32"  IOSTANDARD LVCMOS18 } [ get_ports i2c_sda ];
set_property -dict { PACKAGE_PIN "AT35"  IOSTANDARD LVCMOS18 } [ get_ports i2c_scl ];

set_property -dict { PACKAGE_PIN "AK32"  IOSTANDARD LVCMOS18 } [ get_ports trigger_in ];
set_property -dict { PACKAGE_PIN "AN31"  IOSTANDARD LVCMOS18 } [ get_ports trigger_sync ];
set_property -dict { PACKAGE_PIN "AP31"  IOSTANDARD LVCMOS18 } [ get_ports trigger_out ];

# DCOA-/DCOA+: Data Clock Outputs for Channles 1, 4, 5 and 8.
set_property -dict { PACKAGE_PIN "J40" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_clk_in_p[0]} ];
set_property -dict { PACKAGE_PIN "J41" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_clk_in_n[0]} ];
# DCOB-/DCOB+: Data Clock Outputs for Channles 2, 3, 6 and 7.
set_property -dict { PACKAGE_PIN "L31" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_clk_in_p[1]} ];
set_property -dict { PACKAGE_PIN "K32" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_clk_in_n[1]} ];

# FRB-/FRB+: Frame Start Outputs for Channels 2, 3, 6 and 7.
set_property -dict { PACKAGE_PIN "K39" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {frame_in_p[0]} ];
set_property -dict { PACKAGE_PIN "K40" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {frame_in_n[0]} ];
# FRA-/FRA+: Frame Start Outputs for Channels 1, 4, 5 and 8.
set_property -dict { PACKAGE_PIN "M32" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {frame_in_p[1]} ];
set_property -dict { PACKAGE_PIN "L32" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {frame_in_n[1]} ];

# OUT2A-/OUT2A+: Serial Data Outputs for Channel 2. In 1-lane output mode only OUT2A-/OUT2A+ are used.
set_property -dict { PACKAGE_PIN "H40" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[0][0]} ];
set_property -dict { PACKAGE_PIN "H41" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[0][0]} ];
# OUT2B-/OUT2B+: Serial Data Outputs for Channel 2. In 1-lane output mode only OUT2A-/OUT2A+ are used.
set_property -dict { PACKAGE_PIN "G41" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[0][1]} ];
set_property -dict { PACKAGE_PIN "G42" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[0][1]} ];

# OUT3A-/OUT3A+: Serial Data Outputs for Channel 3. In 1-lane output mode only OUT3A-/OUT3A+ are used.
set_property -dict { PACKAGE_PIN "F40" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[1][0]} ];
set_property -dict { PACKAGE_PIN "F41" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[1][0]} ];
# OUT3B-/OUT3B+: Serial Data Outputs for Channel 3. In 1-lane output mode only OUT3A-/OUT3A+ are used.
set_property -dict { PACKAGE_PIN "M36" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[1][1]} ];
set_property -dict { PACKAGE_PIN "L37" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[1][1]} ];

# OUT6A-/OUT6A+: Serial Data Outputs for Channel 6. In 1-lane output mode only OUT6A-/OUT6A+ are used.
set_property -dict { PACKAGE_PIN "N28" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[2][0]} ];
set_property -dict { PACKAGE_PIN "N29" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[2][0]} ];
# OUT6B-/OUT6B+: Serial Data Outputs for Channel 6. In 1-lane output mode only OUT6A-/OUT6A+ are used.
set_property -dict { PACKAGE_PIN "R30" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[2][1]} ];
set_property -dict { PACKAGE_PIN "P31" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[2][1]} ];

# OUT7A-/OUT7A+: Serial Data Outputs for Channel 7. In 1-lane output mode only OUT7A-/OUT7A+ are used.
set_property -dict { PACKAGE_PIN "L29" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[3][0]} ];
set_property -dict { PACKAGE_PIN "L30" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[3][0]} ];
# OUT7B-/OUT7B+: Serial Data Outputs for Channel 7. In 1-lane output mode only OUT7A-/OUT7A+ are used.
set_property -dict { PACKAGE_PIN "V30" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[3][1]} ];
set_property -dict { PACKAGE_PIN "V31" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[3][1]} ];

# OUT1A-/OUT1A+: Serial Data Outputs for Channel 1. In 1-lane output mode only OUT1A-/OUT1A+ are used.
set_property -dict { PACKAGE_PIN "M42" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[4][0]} ];
set_property -dict { PACKAGE_PIN "L42" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[4][0]} ];
# OUT1B-/OUT1B+: Serial Data Outputs for Channel 1. In 1-lane output mode only OUT1A-/OUT1A+ are used.
set_property -dict { PACKAGE_PIN "M37" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[4][1]} ];
set_property -dict { PACKAGE_PIN "M38" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[4][1]} ];

# OUT4A-/OUT4A+: Serial Data Outputs for Channel 4. In 1-lane output mode only OUT4A-/OUT4A+ are used.
set_property -dict { PACKAGE_PIN "R40" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[5][0]} ];
set_property -dict { PACKAGE_PIN "P40" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[5][0]} ];
# OUT4B-/OUT4B+: Serial Data Outputs for Channel 4. In 1-lane output mode only OUT4A-/OUT4A+ are used.
set_property -dict { PACKAGE_PIN "K37" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[5][1]} ];
set_property -dict { PACKAGE_PIN "K38" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[5][1]} ];

# OUT5A-/OUT5A+: Serial Data Outputs for Channel 5. In 1-lane output mode only OUT5A-/OUT5A+ are used.
set_property -dict { PACKAGE_PIN "R28" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[6][0]} ];
set_property -dict { PACKAGE_PIN "P28" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[6][0]} ];
# OUT5B-/OUT5B+: Serial Data Outputs for Channel 5. In 1-lane output mode only OUT5A-/OUT5A+ are used.
set_property -dict { PACKAGE_PIN "K29" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[6][1]} ];
set_property -dict { PACKAGE_PIN "K30" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[6][1]} ];

# OUT8A-/OUT8A+: Serial Data Outputs for Channel 8. In 1-lane output mode only OUT8A-/OUT8A+ are used.
set_property -dict { PACKAGE_PIN "T29" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[7][0]} ];
set_property -dict { PACKAGE_PIN "T30" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[7][0]} ];
# OUT8B-/OUT8B+: Serial Data Outputs for Channel 8. In 1-lane output mode only OUT8A-/OUT8A+ are used.
set_property -dict { PACKAGE_PIN "M28" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_p[7][1]} ];
set_property -dict { PACKAGE_PIN "M29" DIFF_TERM TRUE IOSTANDARD LVDS } [ get_ports {data_in_n[7][1]} ];

create_clock -name sys_diff_clock_clk_p -period 5.000 -waveform {0.000 2.500} [get_ports sys_diff_clock_clk_p]
create_clock -name sys_diff_clock_clk_n -period 5.000 -waveform {0.000 2.500} [get_ports sys_diff_clock_clk_n]

create_clock -period 8.000 -name sgmii_clk_p -waveform {0.000 4.000} [get_ports sgmii_clk_p]
create_clock -period 8.000 -name sgmii_clk_n -waveform {0.000 4.000} [get_ports sgmii_clk_n]

set_max_delay  5 -datapath_only -from [get_ports {i2c_sda}]
set_min_delay  0                -from [get_ports {i2c_sda}]
set_max_delay  5 -datapath_only -from [get_clocks {sys_diff_clock_clk_p}] -to [get_ports {i2c_sda}]
set_max_delay  5 -datapath_only -from [get_clocks {sys_diff_clock_clk_p}] -to [get_ports {i2c_scl}]
set_max_delay 20 -datapath_only -from [get_clocks {sys_diff_clock_clk_p}] -to [get_ports {led*}]
set_max_delay 20 -datapath_only -from [get_clocks {sys_diff_clock_clk_p}] -to [get_ports {phy_rstn}]

set_max_delay 20 -datapath_only -from [get_ports {sw_n}]
set_min_delay  0                -from [get_ports {sw_n}]
set_max_delay 20 -datapath_only -from [get_ports {sw_e}]
set_min_delay  0                -from [get_ports {sw_e}]
set_max_delay 20 -datapath_only -from [get_ports {sw_s}]
set_min_delay  0                -from [get_ports {sw_s}]
set_max_delay 20 -datapath_only -from [get_ports {sw_w}]
set_min_delay  0                -from [get_ports {sw_w}]
set_max_delay 20 -datapath_only -from [get_ports {sw_c}]
set_min_delay  0                -from [get_ports {sw_c}]

set_max_delay 20 -datapath_only -from [get_ports {dip*}]
set_min_delay  0                -from [get_ports {dip*}]

set SiPDMIN [expr [get_property -min PERIOD [get_clocks -of_objects [get_pins -hier -filter {name =~ */GMII/*}]]] - 1.5]

set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */GMII_RXBUF/cmpWrAddr*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXBUF/smpWrStatusAddr*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */GMII_TXBUF/orRdAct*/C}] -to [get_pins -hier -filter {name =~ */GMII_TXBUF/irRdAct*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */GMII_TXBUF/muxEndTgl/C}] -to [get_pins -hier -filter {name =~ */GMII_TXBUF/rsmpMuxTrnsEnd*/D}] 

set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX10Data*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/irMacFlowEnb/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX12Data*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/muxMyMac*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX13Data*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/muxMyMac*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX14Data*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/muxMyMac*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX15Data*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/muxMyMac*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX16Data*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/muxMyMac*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX17Data*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/muxMyMac*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX18Data*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/muxMyIp*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX19Data*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/muxMyIp*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX1AData*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/muxMyIp*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX1BData*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/muxMyIp*/D}] 

set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */GMII_TXBUF/dlyBank0LastWrAddr*/C}]  -to [get_pins -hier -filter {name =~ */GMII_TXBUF/rsmpBank0LastWrAddr*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */GMII_TXBUF/dlyBank1LastWrAddr*/C}]  -to [get_pins -hier -filter {name =~ */GMII_TXBUF/rsmpBank1LastWrAddr*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */GMII_TXBUF/memRdReq*/C}]            -to [get_pins -hier -filter {name =~ */GMII_TXBUF/irMemRdReq*/D}] 

set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */GMII_RXCNT/orMacTim*/C}]  -to [get_pins -hier -filter {name =~ */GMII_TXCNT/irMacPauseTime*/D}] 
set_max_delay $SiPDMIN -datapath_only -from [get_pins -hier -filter {name =~ */GMII_RXCNT/orMacPause/C}] -to [get_pins -hier -filter {name =~ */GMII_TXCNT/irMacPauseExe_0/D}]

set_false_path -from [get_pins -hier -filter {name =~ */SiTCP_INT/SiTCP_RESET_OUT/C}]

#-----------------------------------------------------------
# PCS/PMA Clock period Constraints: please do not relax    -
#-----------------------------------------------------------
# Clock period for the Txout clock
create_clock  -period 16.000 [get_pins -hier -filter {name =~  *pcs_pma_block_i/transceiver_inst/gtwizard_inst/*/gtwizard_i/gt0_GTWIZARD_i/gtxe2_i/TXOUTCLK}]

#-----------------------------------------------------------
# Receive Clock period Constraint: please do not relax
#-----------------------------------------------------------
# Clock period for the recovered Rx clock
create_clock  -period 16.000 [get_pins -hier -filter { name =~ *pcs_pma_block_i/transceiver_inst/gtwizard_inst/*/gtwizard_i/gt0_GTWIZARD_i/gtxe2_i/RXOUTCLK}]

set_false_path  -to [get_pins -hier -filter {name =~  *core_resets_i/pma_reset_pipe_reg*/PRE}]
set_false_path  -to [get_pins -hier -filter {name =~  *core_resets_i/pma_reset_pipe*[0]/D}]

#***********************************************************
# The following constraints target the Transceiver Physical*
# Interface which is instantiated in the Example Design.   *
#***********************************************************
#-----------------------------------------------------------
# PCS/PMA Clock period Constraints: please do not relax    -
#-----------------------------------------------------------
# Control Gray Code delay and skew across clock boundary
set_max_delay -from [get_cells -hier -filter {name =~ *pcs_pma_block_i/transceiver_inst/rx_elastic_buffer_inst/wr_addr_*_reg[*]}] -to [get_pins -hier -filter { name =~ *reclock_wr_addrgray[*].sync_wr_addrgray/data_sync*/D}] 16 -datapath_only 
set_max_delay -from [get_cells -hier -filter {name =~  *pcs_pma_block_i/transceiver_inst/rx_elastic_buffer_inst/rd_addr_*_reg[*]}] -to [get_pins -hier -filter { name =~ *reclock_rd_addrgray[*].sync_rd_addrgray/data_sync*/D}] 8 -datapath_only

# Constrain between Distributed Memory (output data) and the 1st set of flip-flops
set_false_path  -from [get_clocks -of [get_pins  -hier -filter { name =~ *pcs_pma_block_i/transceiver_inst/gtwizard_inst/*/gtwizard_i/gt0_GTWIZARD_i/gt*e2_i/RXOUTCLK}]] -to [get_pins -hierarchical -filter { name =~ *rx_elastic_buffer_inst/rd_data_reg*/D } ]
set_false_path  -from [get_pins  -hierarchical -filter { name =~  *transceiver_inst/rx_elastic_buffer_inst/initialize_ram_complete_reg/C}] -to [get_pins -hierarchical -filter { name =~ *rx_elastic_buffer_inst/sync_initialize_ram_comp/data_sync_reg*/D } ] 

#-----------------------------------------------------------
# GT Initialization circuitry clock domain crossing
#-----------------------------------------------------------
set_false_path -to [get_pins -hier -filter { name =~ */gtwizard_inst/*/gt0_txresetfsm_i/sync_*/*D } ]
set_false_path -to [get_pins -hier -filter { name =~ */gtwizard_inst/*/gt0_rxresetfsm_i/sync_*/*D } ]
set_false_path -to [get_pins -hier -filter { name =~ */gtwizard_inst/*/sync_*/*D } ]

# false path constraints to async inputs coming directly to synchronizer
set_false_path -to [get_pins -hier -filter {name =~ *SYNC_*/data_sync*/D }]
set_false_path -to [get_pins -hier -filter {name =~ *pcs_pma_block_i/transceiver_inst/sync_block_data_valid/data_sync*/D }]
set_false_path -to [get_pins -hier -filter {name =~ *sync_block_tx_reset_done/data_sync*/D }]
set_false_path -to [get_pins -hier -filter {name =~ *sync_block_rx_reset_done/data_sync*/D }]
set_false_path -to [get_pins -hier -filter {name =~ */*sync_speed_10*/data_sync*/D }]
set_false_path -to [get_pins -hier -filter {name =~ */*gen_sync_reset/reset_sync*/PRE }]
set_false_path -to [get_pins -hier -filter {name =~ *reset_sync*/PRE }]