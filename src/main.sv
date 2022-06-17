module daq_main #(
    parameter dummy = 0
) (
    // System I/F
    input logic sys_diff_clock_clk_p,
    input logic sys_diff_clock_clk_n,
    input logic reset,

    output logic [ 13:0]   ddr3_sdram_addr,
    output logic [  2:0]   ddr3_sdram_ba,
    output logic           ddr3_sdram_cas_n,
    output logic [  0:0]   ddr3_sdram_ck_n,
    output logic [  0:0]   ddr3_sdram_ck_p,
    output logic [  0:0]   ddr3_sdram_cke,
    output logic [  0:0]   ddr3_sdram_cs_n,
    output logic [  7:0]   ddr3_sdram_dm,
    inout  logic [ 63:0]   ddr3_sdram_dq,
    inout  logic [  7:0]   ddr3_sdram_dqs_n,
    inout  logic [  7:0]   ddr3_sdram_dqs_p,
    output logic [  0:0]   ddr3_sdram_odt,
    output logic           ddr3_sdram_ras_n,
    output logic           ddr3_sdram_reset_n,
    output logic           ddr3_sdram_we_n,

    // Trigger I\F
    input  logic trigger_in,
    input  logic trigger_sync,
    output logic trigger_out,

    // Input signal from adc (DC1884A-A Analog Devices, Inc.)
    input logic [1:0]      data_clk_in_p, 
    input logic [1:0]      data_clk_in_n, 
    input logic [1:0]      frame_in_p, 
    input logic [1:0]      frame_in_n, 
    input logic [7:0][1:0] data_in_p, 
    input logic [7:0][1:0] data_in_n,

    // Ethernet phys ports
    input  logic sgmii_clk_p,
    input  logic sgmii_clk_n,
    output logic phy_rstn,
    output logic sgmii_txp,
    output logic sgmii_txn,
    input  logic sgmii_rxp,
    input  logic sgmii_rxn,

    // Management interface
    output logic gmii_mdc,
    inout  logic gmii_mdio_in,

    // connect EEPROM
    inout  logic i2c_sda,
    output logic i2c_scl,

    // Onboard general purpose input/output (GPIO)
    input  logic       sw_n,
    input  logic       sw_e,
    input  logic       sw_s,
    input  logic       sw_w,
    input  logic       sw_c,
    input  logic [7:0] dip,
    output logic [7:0] led,
    output logic [6:0] lcd
);
    parameter integer DATA_LANE     = 2;
    parameter integer DATA_CHANNEL  = 8;
    parameter integer DATA_WIDTH    = 16;
    parameter integer SERDES_FACTOR = 8;

    parameter IP_ADDRESS  = 32'd0;
    parameter TCP_PORT    = 16'd0;
    parameter RBCP_PORT   = 16'd0;
    parameter PHY_ADDRESS = 5'd0;

    logic ref_clk_200mhz;
    logic ref_clk_100mhz;
    logic ref_clk_50mhz;

    logic sdram_mmcm_locked;
    logic sdram_calib_complete;
    logic gmii_mdio_out;

    logic [ 31:0]   S_AXI_0_araddr;
    logic [  1:0]   S_AXI_0_arburst;
    logic [  3:0]   S_AXI_0_arcache;
    logic [  0:0]   S_AXI_0_arid;
    logic [  7:0]   S_AXI_0_arlen;
    logic           S_AXI_0_arlock;
    logic [  2:0]   S_AXI_0_arprot;
    logic [  3:0]   S_AXI_0_arqos;
    logic           S_AXI_0_arready;
    logic [  2:0]   S_AXI_0_arsize;
    logic           S_AXI_0_arvalid;
    logic [ 31:0]   S_AXI_0_awaddr;
    logic [  1:0]   S_AXI_0_awburst;
    logic [  3:0]   S_AXI_0_awcache;
    logic [  0:0]   S_AXI_0_awid;
    logic [  7:0]   S_AXI_0_awlen;
    logic           S_AXI_0_awlock;
    logic [  2:0]   S_AXI_0_awprot;
    logic [  3:0]   S_AXI_0_awqos;
    logic           S_AXI_0_awready;
    logic [  2:0]   S_AXI_0_awsize;
    logic           S_AXI_0_awvalid;
    logic [  0:0]   S_AXI_0_bid;
    logic           S_AXI_0_bready;
    logic [  1:0]   S_AXI_0_bresp;
    logic           S_AXI_0_bvalid;
    logic [511:0]   S_AXI_0_rdata;
    logic [  0:0]   S_AXI_0_rid;
    logic           S_AXI_0_rlast;
    logic           S_AXI_0_rready;
    logic [  1:0]   S_AXI_0_rresp;
    logic           S_AXI_0_rvalid;
    logic [511:0]   S_AXI_0_wdata;
    logic           S_AXI_0_wlast;
    logic           S_AXI_0_wready;
    logic [ 63:0]   S_AXI_0_wstrb;
    logic           S_AXI_0_wvalid;

    logic           aresetn_0;

    logic [DATA_CHANNEL-1:0][DATA_WIDTH-1:0] adc_data_out;
    logic [DATA_CHANNEL-1:0] adc_data_clk;
    logic [DATA_CHANNEL-1:0] adc_system_clk;

    logic [127:0] data_pre_packet;
    logic [  7:0] data_packet;
    logic [ 31:0] data_number;
    logic [  7:0] channel_ctrl;
    logic         trigger_cmd;

    logic trigger_is_sync;
    logic trigger;

    initial begin
        data_packet = 8'b0;
    end

    assign trigger_out = trigger_in | trigger_cmd;
    assign trigger_is_sync = trigger_in & trigger_sync;
    assign trigger = trigger_is_sync | trigger_cmd;
    assign led[0] = trigger;

    adc_capture_wrap adc_inst (
        // Reference input
        .ref_clk        (ref_clk_200mhz),
        .ref_rst        (reset),
        // ADC input
        .data_clk_in_p  (data_clk_in_p), 
        .data_clk_in_n  (data_clk_in_n), 
        .frame_in_p     (frame_in_p), 
        .frame_in_n     (frame_in_n), 
        .data_in_p      (data_in_p), 
        .data_in_n      (data_in_n),
        // Deserialized output
        .adc_data_out   (adc_data_out),
        .adc_data_clk   (adc_data_clk),
        .adc_system_clk (adc_system_clk)
    );

    sitcp_wrap #(
        .IP_ADDRESS  (IP_ADDRESS),
        .TCP_PORT    (TCP_PORT),
        .RBCP_PORT   (RBCP_PORT),
        .PHY_ADDRESS (PHY_ADDRESS)
    ) sitcp_inst (
        // System ports
        .clk_200mhz  (ref_clk_200mhz),
        .sys_rst     (reset),
        // Ethernet phys ports
        .sgmii_clk_p (sgmii_clk_p),
        .sgmii_clk_n (sgmii_clk_n),
        .phy_rstn    (phy_rstn),
        .sgmii_txp   (sgmii_txp),
        .sgmii_txn   (sgmii_txn),
        .sgmii_rxp   (sgmii_rxp),
        .sgmii_rxn   (sgmii_rxn),
        // Management interface
        .gmii_mdc    (gmii_mdc),
        .gmii_mdio_out(gmii_mdio_out),
        .gmii_mdio_in(gmii_mdio_in),
        // connect EEPROM
        .i2c_sda     (i2c_sda),
        .i2c_scl     (i2c_scl),
        // DAQ commands
        .data_packet (data_packet),
        .data_number (data_number),
        .channel_ctrl(channel_ctrl),
        .trigger_cmd (trigger_cmd),
        // GPIO
        .dip         (dip),
        .led         (led)
    );

    lcd_wrap lcd_inst (
        .clk_50mhz(clk_50mhz),
        .rst(reset),
        .lcd_ctrl_3bits(lcd[2:0]),
        .lcd_data_4bits(lcd[6:3])
    );

    deepfifo_wrap deepfifo (
        .clk        (ref_clk_200mhz),
        .sys_rst    (~trigger),

        .data_clk   (adc_data_clk),
        .data_in    (adc_data_out),
        .data_pre_packet(data_pre_packet),

        .axi_clk    (ref_clk_200mhz),
        .axi_aresetn(aresetn_0),

        .axi_awaddr (S_AXI_0_awaddr),
        .axi_awlen  (S_AXI_0_awlen),
        .axi_awsize (S_AXI_0_awsize),
        .axi_awburst(S_AXI_0_awburst),
        .axi_awvalid(S_AXI_0_awvalid),
        .axi_awready(S_AXI_0_awready),
        .axi_wdata  (S_AXI_0_wdata),
        .axi_wstrb  (S_AXI_0_wstrb),
        .axi_wlast  (S_AXI_0_wlast),
        .axi_wvalid (S_AXI_0_wvalid),
        .axi_wready (S_AXI_0_wready),

        .axi_bvalid (S_AXI_0_bvalid),
        .axi_bready (S_AXI_0_bready),

        .axi_araddr (S_AXI_0_araddr),
        .axi_arlen  (S_AXI_0_arlen),
        .axi_arsize (S_AXI_0_arsize),
        .axi_arburst(S_AXI_0_arburst),
        .axi_arvalid(S_AXI_0_arvalid),
        .axi_arready(S_AXI_0_arready),
        .axi_rdata  (S_AXI_0_rdata),
        .axi_rlast  (S_AXI_0_rlast),
        .axi_rvalid (S_AXI_0_rvalid),
        .axi_rready (S_AXI_0_rready)
    );

    sdram sdram_i (
        .S_AXI_0_araddr(S_AXI_0_araddr),
        .S_AXI_0_arburst(S_AXI_0_arburst),
        .S_AXI_0_arcache(S_AXI_0_arcache),
        .S_AXI_0_arid(S_AXI_0_arid),
        .S_AXI_0_arlen(S_AXI_0_arlen),
        .S_AXI_0_arlock(S_AXI_0_arlock),
        .S_AXI_0_arprot(S_AXI_0_arprot),
        .S_AXI_0_arqos(S_AXI_0_arqos),
        .S_AXI_0_arready(S_AXI_0_arready),
        .S_AXI_0_arsize(S_AXI_0_arsize),
        .S_AXI_0_arvalid(S_AXI_0_arvalid),
        .S_AXI_0_awaddr(S_AXI_0_awaddr),
        .S_AXI_0_awburst(S_AXI_0_awburst),
        .S_AXI_0_awcache(S_AXI_0_awcache),
        .S_AXI_0_awid(S_AXI_0_awid),
        .S_AXI_0_awlen(S_AXI_0_awlen),
        .S_AXI_0_awlock(S_AXI_0_awlock),
        .S_AXI_0_awprot(S_AXI_0_awprot),
        .S_AXI_0_awqos(S_AXI_0_awqos),
        .S_AXI_0_awready(S_AXI_0_awready),
        .S_AXI_0_awsize(S_AXI_0_awsize),
        .S_AXI_0_awvalid(S_AXI_0_awvalid),
        .S_AXI_0_bid(S_AXI_0_bid),
        .S_AXI_0_bready(S_AXI_0_bready),
        .S_AXI_0_bresp(S_AXI_0_bresp),
        .S_AXI_0_bvalid(S_AXI_0_bvalid),
        .S_AXI_0_rdata(S_AXI_0_rdata),
        .S_AXI_0_rid(S_AXI_0_rid),
        .S_AXI_0_rlast(S_AXI_0_rlast),
        .S_AXI_0_rready(S_AXI_0_rready),
        .S_AXI_0_rresp(S_AXI_0_rresp),
        .S_AXI_0_rvalid(S_AXI_0_rvalid),
        .S_AXI_0_wdata(S_AXI_0_wdata),
        .S_AXI_0_wlast(S_AXI_0_wlast),
        .S_AXI_0_wready(S_AXI_0_wready),
        .S_AXI_0_wstrb(S_AXI_0_wstrb),
        .S_AXI_0_wvalid(S_AXI_0_wvalid),
        .aresetn_0(aresetn_0),
        .ddr3_sdram_addr(ddr3_sdram_addr),
        .ddr3_sdram_ba(ddr3_sdram_ba),
        .ddr3_sdram_cas_n(ddr3_sdram_cas_n),
        .ddr3_sdram_ck_n(ddr3_sdram_ck_n),
        .ddr3_sdram_ck_p(ddr3_sdram_ck_p),
        .ddr3_sdram_cke(ddr3_sdram_cke),
        .ddr3_sdram_cs_n(ddr3_sdram_cs_n),
        .ddr3_sdram_dm(ddr3_sdram_dm),
        .ddr3_sdram_dq(ddr3_sdram_dq),
        .ddr3_sdram_dqs_n(ddr3_sdram_dqs_n),
        .ddr3_sdram_dqs_p(ddr3_sdram_dqs_p),
        .ddr3_sdram_odt(ddr3_sdram_odt),
        .ddr3_sdram_ras_n(ddr3_sdram_ras_n),
        .ddr3_sdram_reset_n(ddr3_sdram_reset_n),
        .ddr3_sdram_we_n(ddr3_sdram_we_n),
        .reset(reset),
        .init_calib_complete_0(sdram_calib_complete),
        .mmcm_locked_0(sdram_mmcm_locked),
        .sys_diff_clock_clk_n(sys_diff_clock_clk_n),
        .sys_diff_clock_clk_p(sys_diff_clock_clk_p),
        .ui_addn_clk_0_0(ref_clk_100mhz),
        .ui_addn_clk_1_0(ref_clk_50mhz),
        .ui_clk_0(ref_clk_200mhz)
    );

endmodule