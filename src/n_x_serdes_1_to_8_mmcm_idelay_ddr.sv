`timescale 1ps/1ps

module n_x_serdes_1_to_8_mmcm_idelay_ddr # (
    parameter integer 	N            = 4,				        // Set the number of channels
    parameter integer 	D            = 8,   			        // Parameter to set the number of data lines per channel
    parameter integer 	MMCM_MODE    = 1,   		            // Parameter to set multiplier for MMCM to get VCO in correct operating range. 1 multiplies input clock by 7, 2 multiplies clock by 14, etc
    parameter real 	    CLKIN_PERIOD = 13.228,		            // Clock period (ns) of input clock on clkin_p
    parameter 		    HIGH_PERFORMANCE_MODE = "TRUE",         // Parameter to set HIGH_PERFORMANCE_MODE of input delays to reduce jitter
    parameter         	DIFF_TERM    = "TRUE", 		            // Parameter to enable internal differential termination
    parameter         	SAMPL_CLOCK  = "BUF_G",   	            // Parameter to set sampling clock buffer type, BUFIO, BUF_H, BUF_G
    parameter         	PIXEL_CLOCK  = "BUF_G",       	        // Parameter to set pixel clock buffer type, BUF_R, BUF_H, BUF_G
    parameter         	USE_PLL      = "FALSE",                 // Parameter to enable PLL use rather than MMCM use, overides SAMPL_CLOCK and INTER_CLOCK to be both BUFH
    parameter         	DATA_FORMAT  = "TWO_LANE"               // Parameter Used to determine method for mapping input parallel word to output serial words
) (
    input  logic [N-1:0]            clkin_p,                    // Input from LVDS clock receiver pin
    input  logic [N-1:0]            clkin_n,                    // Input from LVDS clock receiver pin
    input  logic [N*D-1:0]          datain_p,                   // Input from LVDS clock data pins
    input  logic [N*D-1:0]          datain_n,                   // Input from LVDS clock data pins
    input  logic                    enable_phase_detector,      // Enables the phase detector logic when high
    input  logic                    enable_monitor,             // Enables the monitor logic when high, note time-shared with phase detector function
    output logic                    rxclk,                      // Global/BUFIO rx clock network
    input  logic                    idelay_rdy,                 // Input delays are ready
    input  logic                    reset,                      // Reset line
    output logic                    rxclk_div,                  // Global/Regional clock output
    output logic                    rx_mmcm_lckdps,             // MMCM locked and phase shifting finished, synchronous to rxclk_64
    output logic                    rx_mmcm_lckd,               // MMCM locked, synchronous to rxclk_64
    output logic [N-1:0]            rx_mmcm_lckdpsbs,           // MMCM locked and phase shifting finished and bitslipping finished, synchronous to rxclk_div
    output logic [N*8-1:0]          clk_data,                   // Clock data
    output logic [N*D*8-1:0]        rx_data,                    // Received data
    output logic [6:0]              status,                     // Clock status
    output logic [(10*D+6)*N-1:0]   debug,                      // Debug information
    input  logic [15:0]             bit_rate_value,             // Bit rate in Mbps
    output logic [4:0]              bit_time_value,             // Calculated bit time value for slave devices
    output logic [32*D*N-1:0]       eye_info,                   // Eye information
    output logic [32*D*N-1:0]       m_delay_1hot                // Master delay control value as a one-hot vector
);

    logic rxclk_d4;
    logic pd;
    
    serdes_1_to_8_mmcm_idelay_ddr #(
        .SAMPL_CLOCK		      ( SAMPL_CLOCK           ),
        .PIXEL_CLOCK		      ( PIXEL_CLOCK           ),
        .USE_PLL		          ( USE_PLL               ),
        .HIGH_PERFORMANCE_MODE	  ( HIGH_PERFORMANCE_MODE ),
        .D			              ( D                     ),	 // Number of data lines
        .CLKIN_PERIOD		      ( CLKIN_PERIOD          ),	 // Set input clock period
        .MMCM_MODE		          ( MMCM_MODE             ),	 // Set mmcm vco, either 1 or 2
        .DIFF_TERM		          ( DIFF_TERM             ),
        .DATA_FORMAT		      ( DATA_FORMAT           )
    ) rx0 (
        .clkin_p   		          ( clkin_p[0]            ),
        .clkin_n   		          ( clkin_n[0]            ),
        .datain_p     		      ( datain_p[D-1:0]       ),
        .datain_n     		      ( datain_n[D-1:0]       ),
        .enable_phase_detector	  ( enable_phase_detector ),
        .enable_monitor		      ( enable_monitor        ),
        .rxclk    		          ( rxclk                 ),
        .idelay_rdy		          ( idelay_rdy            ),
        .rxclk_div		          ( rxclk_div             ),
        .reset     		          ( reset                 ),
        .rx_mmcm_lckd		      ( rx_mmcm_lckd          ),
        .rx_mmcm_lckdps		      ( rx_mmcm_lckdps        ),
        .rx_mmcm_lckdpsbs	      ( rx_mmcm_lckdpsbs[0]   ),
        .clk_data  		          ( clk_data[7:0]         ),
        .rx_data		          ( rx_data[8*D-1:0]      ),
        .bit_rate_value		      ( bit_rate_value        ),
        .bit_time_value		      ( bit_time_value        ),
        .status			          ( status                ),
        .eye_info		          ( eye_info[32*D-1:0]    ),
        .rst_iserdes		      ( rst_iserdes           ),
        .m_delay_1hot		      ( m_delay_1hot[32*D-1:0]),
        .debug			          ( debug[10*D+5:0]       )
    );

    generate
        if (N > 1) begin
            for (genvar i = 1 ; i <= (N-1) ; i = i+1) begin : loop0
                serdes_1_to_8_slave_idelay_ddr #(
                    .D			            ( D                     ),
                    .HIGH_PERFORMANCE_MODE	( HIGH_PERFORMANCE_MODE ),
                    .DIFF_TERM		        ( DIFF_TERM             ),
                    .DATA_FORMAT		    ( DATA_FORMAT           )
                ) rxn (
                    .clkin_p   		        ( clkin_p[i]            ),
                    .clkin_n   		        ( clkin_n[i]            ),
                    .datain_p     		    ( datain_p[D*(i+1)-1:D*i]),
                    .datain_n     		    ( datain_n[D*(i+1)-1:D*i]),
                    .enable_phase_detector	( enable_phase_detector ),
                    .enable_monitor		    ( enable_monitor        ),
                    .rxclk    		        ( rxclk                 ),
                    .idelay_rdy		        ( idelay_rdy            ),
                    .rxclk_div		        ( rxclk_div             ),
                    .reset     		        ( ~rx_mmcm_lckdps       ),
                    .bitslip_finished	    ( rx_mmcm_lckdpsbs[i]   ),
                    .clk_data  		        ( clk_data[8*i+7:8*i]   ),
                    .rx_data		        ( rx_data[(D*(i+1)*8)-1:D*i*8]),
                    .bit_time_value		    ( bit_time_value        ),
                    .eye_info		        ( eye_info[32*D*(i+1)-1:32*D*i]),
                    .m_delay_1hot		    ( m_delay_1hot[(32*D)*(i+1)-1:(32*D)*i]),
                    .rst_iserdes		    ( rst_iserdes           ),
                    .debug			        ( debug[(10*D+6)*(i+1)-1:(10*D+6)*i])
                );
            end
        end
    endgenerate

endmodule