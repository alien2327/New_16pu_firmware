interface rbcp_if;
    logic        we;
    logic        re;
    logic [ 7:0] wd;
    logic [31:0] addr;
    logic [ 7:0] rd;
    logic		 ack;
endinterface // rbcp_if

interface gmii_if;
    logic       clk;
    logic       tx_en;  // out: transmit enable
    logic [7:0] txd;    // out: transmit data
    logic       tx_er;  // out: transmit error 
    logic       rx_dv;  // in : receive data valid
    logic [7:0] rxd;    // in : receive data
    logic       rx_er;  // in : receive error
endinterface // gmii_if

interface tcp_if;
    logic [7:0] rx_data;
    logic [7:0] tx_data;
    logic       rx_wr;
    logic       tx_full;
    logic       close_req;  // out: connection close request
    logic       open_ack;
endinterface // tcp_if

interface iic_if;
    logic       req;
    logic       ack;
    logic [7:0] rdt;
    logic       rvl;
endinterface // iic_if

module sitcp_wrap #(
    parameter IP_ADDRESS  = 32'd0,
    parameter TCP_PORT    = 16'd0,
    parameter RBCP_PORT   = 16'd0,
    parameter PHY_ADDRESS = 5'd0
) (
    // System ports
    input  logic clk_200mhz,
    input  logic sys_rst,
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
    inout  logic gmii_mdio_in,
    // connect EEPROM
    inout  logic i2c_sda,
    output logic i2c_scl,
    // DAQ commands
    input  logic [ 7:0] data_packet,
    output logic [31:0] data_number,
    output logic [ 7:0] channel_ctrl,
    output logic        trigger_cmd,
    // GPIO
    input  logic [7:0] dip,
    output logic [7:0] led
);
    logic        clk_200mhz_buf;
    logic        sitcp_rst;
    logic [15:0] status_vector;
    logic [11:0] fifo_data_count;
    logic        fifo_rd_valid;

    logic        duplex_mode;
    logic [ 1:0] led_link_speed;
    logic        link_status;
    logic        sgmii_clk_en;
    logic [ 1:0] sgmii_link;
    logic        sel_sgmii;
    logic [15:0] sfg_reg;
    logic        userclk;
    logic        userclk2;

    logic        gmii_mdio_oe;

    logic        eeprom_CS;
    logic        eeprom_SK;
    logic        eeprom_DI;
    logic        eeprom_DO;

    rbcp_if      rbcp();
    gmii_if      gmii();
    tcp_if       tcp();
    iic_if       iic();

    clock_buf ref_clk_buf (
        .I (clk_200mhz),
        .O (clk_200mhz_buf)
    );

    assign link_status         = status_vector[15];
    assign duplex_mode         = status_vector[12];
    assign led_link_speed[1:0] = status_vector[11:10];

	assign led[7]		=	~sys_rst;
	assign led[6:3]	    =	{led_link_speed[1:0], link_status, duplex_mode};
	assign led[2]		=	sitcp_rst;

    AT93C46_IIC #(
        .PCA9548_AD			(7'b1110_100),				// PCA9548 Dvice Address
        .PCA9548_SL			(8'b0001_1000),				// PCA9548 Select code (Ch3,Ch4 enable)
        .IIC_MEM_AD			(7'b1010_100),				// IIC Memory Dvice Address
        .FREQUENCY			(8'd200),					// CLK_IN Frequency  > 10MHz
        .DRIVE				(4),						// Output Buffer Strength
        .IOSTANDARD			("LVCMOS18"),				// I/O Standard
        .SLEW				("SLOW")					// Outputbufer Slew rate
    ) AT93C46_IIC (
        .CLK_IN				(clk_200mhz_buf),			// System Clock
        .RESET_IN			(~sys_rst),				    // Reset
        .IIC_INIT_OUT		(sitcp_rst),				// IIC , AT93C46 Initialize (0=Initialize End)
        .EEPROM_CS_IN		(eeprom_CS),				// AT93C46 Chip select
        .EEPROM_SK_IN		(eeprom_SK),				// AT93C46 Serial data clock
        .EEPROM_DI_IN		(eeprom_DI),				// AT93C46 Serial write data (Master to Memory)
        .EEPROM_DO_OUT		(eeprom_DO),				// AT93C46 Serial read data(Slave to Master)
        .INIT_ERR_OUT		(),							// PCA9548 Initialize Error
        .IIC_REQ_IN			(iic.req),					// IIC Request
        .IIC_NUM_IN			(8'd0),						// IIC Number of Access[7:0]	0x00:1Byte , 0xff:256Byte
        .IIC_DAD_IN			(7'b101_0000),				// IIC Device Address[6:0]
        .IIC_ADR_IN			(8'b0000_0110),				// IIC Word Address[7:0]
        .IIC_RNW_IN			(1'b1),						// IIC Read(1) / Write(0)
        .IIC_WDT_IN			(8'd0),						// IIC Write Data[7:0]
        .IIC_RAK_OUT		(iic.ack),					// IIC Request Acknowledge
        .IIC_WDA_OUT		(),							// IIC Wite Data Acknowledge(Next Data Request)
        .IIC_WAE_OUT		(),							// IIC Wite Last Data Acknowledge(same as IIC_WDA timing)
        .IIC_BSY_OUT		(),							// IIC Busy
        .IIC_RDT_OUT		(iic.rdt[7:0]),				// IIC Read Data[7:0]
        .IIC_RVL_OUT		(iic.rvl),					// IIC Read Data Valid
        .IIC_EOR_OUT		(),							// IIC End of Read Data(same as IIC_RVL timing)
        .IIC_ERR_OUT		(),							// IIC Error Detect
        // Device Interface
        .IIC_SCL_OUT		(i2c_scl),					// IIC Clock
        .IIC_SDA_IO			(i2c_sda)					// IIC Data
    );

    assign gmii_mdio_in		= gmii_mdio_oe ? gmii_mdio_out : 1'bz;

	WRAP_SiTCP_GMII_XC7V_32K	#(
        .TIM_PERIOD         (8'd200             )
    ) SiTCP (
		.CLK				(clk_200mhz_buf 	),	// in	: System Clock >129MHz is recommended
		.RST				(sitcp_rst  		),	// in	: System reset
	// Configuration parameters
		.FORCE_DEFAULTn		(dip[0]	 		 	),	// in	: Load default parameters
		.EXT_IP_ADDR		(IP_ADDRESS         ),	// in	: IP address[31:0]
		.EXT_TCP_PORT		(TCP_PORT       	),	// in	: TCP port #[15:0]
		.EXT_RBCP_PORT		(RBCP_PORT      	),	// in	: RBCP port #[15:0]
		.PHY_ADDR			(PHY_ADDRESS    	),	// in	: PHY-device MIF address[4:0]
	// EEPROM
		.EEPROM_CS			(eeprom_CS			),	// out	: Chip select
		.EEPROM_SK			(eeprom_SK			),	// out	: Serial data clock
		.EEPROM_DI			(eeprom_DI			),	// out	: Serial write data
		.EEPROM_DO			(eeprom_DO			),	// in	: Serial read data
		// user data, intialial values are stored in the EEPROM, 0xFFFF_FC3C-3F
		.USR_REG_X3C		(					),	// out	: Stored at 0xFFFF_FF3C
		.USR_REG_X3D		(					),	// out	: Stored at 0xFFFF_FF3D
		.USR_REG_X3E		(					),	// out	: Stored at 0xFFFF_FF3E
		.USR_REG_X3F		(					),	// out	: Stored at 0xFFFF_FF3F
	// MII interface
		.GMII_RSTn			(phy_rstn			),	// out	: PHY reset Active low
		.GMII_1000M			(1'b1				),	// in	: GMII mode (0:MII, 1:GMII)
		// TX
		.GMII_TX_CLK		(gmii.clk			),	// in	: Tx clock
		.GMII_TX_EN			(gmii.tx_en			),	// out	: Tx enable
		.GMII_TXD			(gmii.txd[7:0]		),	// out	: Tx data[7:0]
		.GMII_TX_ER			(gmii.tx_er			),	// out	: TX error
		// RX
		.GMII_RX_CLK		(gmii.clk			),	// in	: Rx clock
		.GMII_RX_DV			(gmii.rx_dv			),	// in	: Rx data valid
		.GMII_RXD			(gmii.rxd[7:0]		),	// in	: Rx data[7:0]
		.GMII_RX_ER			(gmii.rx_er			),	// in	: Rx error
		.GMII_CRS			(1'b0				),	// in	: Carrier sense
		.GMII_COL			(1'b0				),	// in	: Collision detected
		// Management IF
		.GMII_MDC			(gmii_mdc			),	// out	: Clock for MDIO
		.GMII_MDIO_IN		(gmii_mdio_in		),	// in	: Data
		.GMII_MDIO_OUT		(gmii_mdio_out		),	// out	: Data
		.GMII_MDIO_OE		(gmii_mdio_oe		),	// out	: MDIO output enable
	// User I/F
		.SiTCP_RST			(       			),	// out	: Reset for SiTCP and related circuits
		// TCP connection control
		.TCP_OPEN_REQ		(1'b0				),	// in	: Reserved input, shoud be 0
		.TCP_OPEN_ACK		(tcp.open_ack		),	// out	: Acknowledge for open (=Socket busy)
		.TCP_ERROR			(					),	// out	: TCP error, its active period is equal to MSL
		.TCP_CLOSE_REQ		(tcp.close_req		),	// out	: Connection close request
		.TCP_CLOSE_ACK		(tcp.close_req		),	// in	: Acknowledge for closing
		// FIFO I/F
		.TCP_RX_WC			({4'b1111,fifo_data_count[11:0]}),	// in	: Rx FIFO write count[15:0] (Unused bits should be set 1)
		.TCP_RX_WR			(tcp.rx_wr			),	// out	: Write enable
		.TCP_RX_DATA		(tcp.rx_data[7:0]	),	// out	: Write data[7:0]
		.TCP_TX_FULL		(tcp.tx_full		),	// out	: Almost full flag
		.TCP_TX_WR			(fifo_rd_valid		),	// in	: Write enable
		.TCP_TX_DATA		(tcp.tx_data[7:0]	),	// in	: Write data[7:0]
		// RBCP
		.RBCP_ACT			(					),	// out	: RBCP active
		.RBCP_ADDR			(rbcp.addr[31:0]	),	// out	: Address[31:0]
		.RBCP_WD			(rbcp.wd[7:0]		),	// out	: Data[7:0]
		.RBCP_WE			(rbcp.we			),	// out	: Write enable
		.RBCP_RE			(rbcp.re			),	// out	: Read enable
		.RBCP_ACK			(rbcp.ack			),	// in	: Access acknowledge
		.RBCP_RD			(rbcp.rd[7:0]		)	// in	: Read data[7:0]
	);	

	WRAP_gig_ethernet_pcs_pma_0 gig_ethernet_pcs_pma_0 (
		.SYS_CLK			(clk_200mhz_buf		),
		.RESET_IN			(~sys_rst			),
		
		.SGMII_CLK_P		(sgmii_clk_p		),
		.SGMII_CLK_N		(sgmii_clk_n		),
		.SGMII_TXP			(sgmii_txp			),	// out	: Tx signal line
		.SGMII_TXN			(sgmii_txn			),	// out	: 
		.SGMII_RXP			(sgmii_rxp			),	// in	: Rx signal line
		.SGMII_RXN			(sgmii_rxn			),	// in	: 

		.GMII_CLK			(gmii.clk			),	// out : GMII Shared clock
		.GMII_TX_EN			(gmii.tx_en			),	// in : Tx enable
		.GMII_TXD			(gmii.txd[7:0]		),	// in : Tx data[7:0]
		.GMII_TX_ER			(gmii.tx_er			),	// in : TX error
		.GMII_RX_DV			(gmii.rx_dv			),	// out : Rx data valid
		.GMII_RXD			(gmii.rxd[7:0]		),	// out : Rx data[7:0]
		.GMII_RX_ER			(gmii.rx_er			),	// out : Rx error
	
		.STATUS_VECTOR		(status_vector[15:0])
	);

	fifo_generator_v11_0 fifo_generator_v11_0(
		.clk				(clk_200mhz_buf		),	//in	:
		.rst				(~tcp.open_ack		),	//in	:
		.din				(data_packet    	),	//in	:
		.wr_en				(tcp.rx_wr			),	//in	:
		.full				(					),	//out	:
		.dout				(tcp.tx_data[7:0]	),	//out	:
		.valid				(fifo_rd_valid		),	//out	:active h
		.rd_en				(~tcp.tx_full		),	//in	:
		.empty				(					),	//out	:
		.data_count			(fifo_data_count[11:0])	//out	:
	);

    rbcp_inst rbcp_inst (
        .clk          (clk_200mhz_buf),
        .data_number  (data_number   ),
        .channel_ctrl (channel_ctrl  ),
        .trigger_cmd  (trigger_cmd   ),
        .we           (rbcp.we       ),
        .re           (rbcp.re       ),
        .wd           (rbcp.wd       ),
        .addr         (rbcp.addr     ),
        .rd           (rbcp.rd       ),
        .ack          (rbcp.ack      )
    );

endmodule // sitcp_wrap