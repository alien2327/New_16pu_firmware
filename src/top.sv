package SiTCPPackage;
typedef struct packed {
    logic [31:0] ADDR;   // SiTCP Address
    logic [31:0] DNum;   // Data number
    logic [7:0]  WD;     // Write Data
    logic [7:0]  RD;     // Read Data
    logic [4:0]  ChCtrl; // Channel Control
    logic [7:0]  Stat;   // Status
    logic        ACK;    // Access acknowledge
    logic        TTrig;  // Test Trigger
} RBCP;
endpackage

module top
(
    // System clock input
    input  logic        SystemClockP,
    input  logic        SystemClockN,
    
    // Signal from two ADC (FMC)
    input  logic [3:0]  FrameClockP,
    input  logic [3:0]  FrameClockN,
    input  logic [31:0] DataInputP,
    input  logic [31:0] DataInputN,
    
    // Signal from beam control
    input  logic        BeamTrigger,
    input  logic        ClockMultiplied64,
    output logic        ClockMultiplied52,
    
    // Clock for Ethernet
    input  logic        SGMIIClockP,
    input  logic        SGMIIClockN,
    output logic        PHYReset,
    
    // Ethernet IO
    input  logic        SGMIIRecieverP,
    input  logic        SGMIIRecieverN,
    output logic        SGMIITransmitterP,
    output logic        SGMIITransmitterN,
    
    // Management IF
    inout  logic        GMIIMDIOInputOuput,
    output logic        GMIIMDC,
    
    // connect EEPROM using I2C
    inout  logic        I2CSDA,
    output logic        I2CSCL,
    
    // General Purpose IO
    input  logic [7:0]  DIP,
    input  logic [4:0]  Switch,
    output logic [7:0]  UserLED
);

    logic         UserClock200Mhz;
    logic         UserClock130Mhz;
    logic         UserClock100Mhz;
    logic         SystemReset;
    
    logic         SamplingClockReset;
    logic         SamplingClockLocked;
    
    logic         iDelayReady;
    SiTCPPackage::RBCP RBCPPacket;
    logic [7:0]   TCP_TX_DATA;
    logic 	      TCP_TX_FULL;
    logic 	      TCP_TX_WR;
    
    assign SamplingClockReset = Switch[3];
    assign SystemReset        = Switch[4];
    
    clk_wiz_0 clk_inst_0
    (
        // Clock out ports
        .clk_out_200mhz ( UserClock200Mhz ),
        .clk_out_130mhz ( UserClock130Mhz ),
        .clk_out_100mhz ( UserClock100Mhz ),
        
        // Status and control signals
        .reset          ( SystemReset     ),
        .locked         (                 ),
        
        // Clock in ports
        .clk_in1_p      ( SystemClockP    ),
        .clk_in1_n      ( SystemClockN    )
    );
    
    clk_wiz_1 clk_inst_1
    (
        // Clock out ports
        .clk_out_52m    ( ClockMultiplied52   ),
        
        // Status and control signals
        .reset          ( SamplingClockReset  ),
        .locked         ( SamplingClockLocked ),
        
        // Clock in ports
        .clk_in_64m     ( ClockMultiplied64   )
    );
    
    IDELAYCTRL icontrol (
        .REFCLK ( UserClock200Mhz ),
        .RST    ( SystemReset     ),
        .RDY    ( iDelayReady     )
    );
    
    wrap_fifo_samples wrap_fifo_samples
    (
        // 8-bit frame LVDS clock from ADC
        .FR_p       ( FrameClockP   ),
        .FR_n       ( FrameClockN   ),
        
        // Digitized LVDS data from ADC
        .DATA_p     ( DataInputP    ),
        .DATA_n     ( DataInputN    ),
        
        // Delay control
        .idelay_rdy ( iDelayReady   ),
        
        // Genetral control
        .reset      ( SystemReset   )
    );

    wrap_sitcp wrap_sitcp (
        .CLK_200M     ( UserClock200Mhz    ),
        .CLK_130M     ( UserClock130Mhz    ),
        .SGMII_CLK_P  ( SGMIIClockP        ),
        .SGMII_CLK_N  ( SGMIIClockN        ),
        .PHY_RSTn     ( PHYReset           ),
        .SGMII_TXP    ( SGMIITransmitterP  ), 
        .SGMII_TXN    ( SGMIITransmitterN  ),
        .SGMII_RXP    ( SGMIIRecieverP     ),
        .SGMII_RXN    ( SGMIIRecieverN     ),
        .GMII_MDC     ( GMIIMDC            ), 
        .GMII_MDIO_IN ( GMIIMDIOInputOuput ),
        .reset        ( SystemReset        ), 
        .TCP_OPEN_ACK (                    ),
        .TCP_TX_FULL  ( TCP_TX_FULL        ),
        .TCP_TX_WR    ( TCP_TX_WR          ),
        .TCP_TX_DATA  ( TCP_TX_DATA        ),
        .I2C_SDA      ( I2CSDA             ),
        .I2C_SCL      ( I2CSCL             ),
        .DIP          ( DIP                ),
        .Switch       ( Switch             ),
        .UserLED      ( UserLED            ),
		.RBCP_ADDR	  ( RBCPPacket.ADDR    ),	// out	: Address[31:0]
		.RBCP_WD	  ( RBCPPacket.WD      ),	// out	: Data[7:0]
		.RBCP_ACK	  ( RBCPPacket.ACK	   ),	// in	: Access acknowledge
		.RBCP_RD	  ( RBCPPacket.RD      )	// in	: Read data[7:0]
    );

endmodule