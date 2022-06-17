module adc_capture_wrap #(
    parameter integer D = 16,
    parameter integer S = 8
) (
    input  logic                ref_clk,
    input  logic                ref_rst,
    output logic [S-1:0][D-1:0] adc_data_out,
    output logic [S-1:0]        adc_data_clk,
    output logic [S-1:0]        adc_system_clk,

    input  logic [1:0]      data_clk_in_p, 
    input  logic [1:0]      data_clk_in_n, 
    input  logic [1:0]      frame_in_p, 
    input  logic [1:0]      frame_in_n, 
    input  logic [7:0][1:0] data_in_p, 
    input  logic [7:0][1:0] data_in_n 
);
    logic [S-1:0][D-1:0] rxd;

    logic [S-1:0] data_clk_p_buf;
    logic [S-1:0] data_clk_n_buf;
    logic [S-1:0] data_clk_out;
    logic [S-1:0] adc_clk_out;

    logic           ref_clk_buf;
    logic [S-1:0]   rx_locked;
    logic           delay_ready;
    logic [S-1:0]   bitslip;
    logic [S-1:0][3:0] bcount;

    // Buf assignment for clock ports
    clock_buf ref_clk_buf (
        .I (ref_clk),
        .O (ref_clk_buf)
    );
    generate
        for (genvar i = 0; i < S; i = i + 1) begin: data_clk_buf
            clock_buf data_clk_p_buf (
                .I (data_clk_in_p[i/4]),
                .O (data_clk_p_buf[i])
            );
            clock_buf data_clk_n_buf (
                .I (data_clk_in_n[i/4]),
                .O (data_clk_n_buf[i])
            );
        end
    endgenerate

    // Instantiate input delay control block
    IDELAYCTRL icontrol (              				
        .REFCLK (ref_clk_buf),
        .RST    (ref_rst),
        .RDY    (delay_ready)
    );

    // Deserialize serial-data from adc (two lane mode)
    // 200 or 300 Mhz Reference Clock Input, 300 MHz receomended for bit rates > 1 Gbps
    generate
        for (genvar i = 0; i < S; i = i + 1) begin: adc_data_serdes
            serdes_1_to_468_idelay_ddr #(
                .S			            (S),        // Set the serdes factor (4, 6 or 8)
                .D			            (D),        // Number of data lines
                .REF_FREQ		        (200.0),    // Set idelay control reference frequency, 300 MHz shown
                .CLKIN_PERIOD		    (1.149),    // Set input clock period, 880 MHz shown 
                                                    // (Sampling clock ~110MHz (1.7 MHz * 64 multipiler) with tx 8bits per lane)
                .HIGH_PERFORMANCE_MODE 	("TRUE"),
                .DATA_FORMAT 		    ("PER_CLOCK")
            ) rx_serdes_inst (
                .clkin_p   		        (data_clk_p_buf[i]),
                .clkin_n   		        (data_clk_n_buf[i]),
                .datain_p     		    (data_in_p[i]),
                .datain_n     		    (data_in_n[i]),
                .enable_phase_detector	(1'b1),			// enable phase detector (active alignment) operation
                .enable_monitor		    (1'b0),			// enables data eye monitoring
                .dcd_correct		    (1'b0),			// enables clock duty cycle correction
                .rxclk    		        (data_clk_out[i]),
                .idelay_rdy		        (delay_ready),
                .system_clk		        (adc_clk_out[i]),
                .reset     		        (ref_rst),
                .rx_lckd		        (rx_locked[i]),
                .bitslip  		        (bitslip[i]),
                .rx_data		        (rxd[i]),
                .bit_rate_value		    (16'h0880),		// required bit rate value in BCD (880 Mbps shown)
                .bit_time_value		    (),				// bit time value
                .eye_info		        (),				// data eye monitor per line
                .m_delay_1hot		    (),				// sample point monitor per line
                .debug			        ()
            );
        end
    endgenerate
    assign adc_data_clk = data_clk_out;
    assign adc_system_clk = adc_clk_out;
    assign adc_data_out = rxd;
endmodule // adc_capture_wrap