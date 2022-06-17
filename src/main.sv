module daq_main #(
    parameter dummy = 0
) (
    // System I/F
    input logic sys_clk_p,
    input logic sys_clk_n,
    input logic sys_rst,

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
    output logic gmii_mdio_out,
    input  logic gmii_mdio_in,

    // connect EEPROM
    input  logic i2c_sda,
    output logic i2c_scl,

    // Onboard general purpose input/output (GPIO)
    input  logic [4:0] sw,
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

    logic ref_clk_300mhz;
    logic ref_clk_200mhz;
    logic ref_clk_100mhz;
    logic ref_clk_50mhz;
    logic ref_clk_locked;

    logic [DATA_CHANNEL-1:0][DATA_WIDTH-1:0] adc_data_out;
    logic [DATA_CHANNEL-1:0] adc_data_clk;
    logic [DATA_CHANNEL-1:0] adc_system_clk;

    logic [ 7:0] data_packet;
    logic [31:0] data_number;
    logic [ 7:0] channel_ctrl;
    logic        trigger_cmd;

    initial begin
        data_packet = 8'b0;
    end

    clk_wiz_0 clk_inst_0 (
        // Clock out ports
        .clk_300mhz (ref_clk_300mhz),
        .clk_200mhz (ref_clk_200mhz),
        .clk_100mhz (ref_clk_100mhz),
        .clk_50mhz  (ref_clk_50mhz),
        // Status and control signals
        .reset      (sys_rst),
        .locked     (ref_clk_locked),
        // Clock in ports
        .clk_in1_p  (sys_clk_p),
        .clk_in1_n  (sys_clk_n)
    );

    adc_capture_wrap adc_inst (
        // Reference input
        .ref_clk        (ref_clk_200mhz),
        .ref_rst        (sys_rst),
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
        .adc_system_clk (adc_system_clk),
    );

    sitcp_wrap #(
        .IP_ADDRESS  (IP_ADDRESS),
        .TCP_PORT    (TCP_PORT),
        .RBCP_PORT   (RBCP_PORT),
        .PHY_ADDRESS (PHY_ADDRESS)
    ) (
        // System ports
        .clk_200mhz  (ref_clk_200mhz),
        .sys_rst     (sys_rst),
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

endmodule