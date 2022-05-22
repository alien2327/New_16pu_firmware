module wrap_serdes
(
     input  logic [3:0] 	FR_p,
     input  logic [3:0] 	FR_n,
     input  logic [31:0] 	DATA_p,
     input  logic [31:0] 	DATA_n,
     input  logic 		    idelay_rdy,
     input  logic 		    reset,
     output logic   	    clock,
     output logic [255:0]   sample
);

    n_x_serdes_1_to_8_mmcm_idelay_ddr wrapped (
        .clkin_p                ( FR_p       ),
        .clkin_n                ( FR_n       ),
        .datain_p               ( DATA_p     ), 
        .datain_n               ( DATA_n     ), 
        .enable_phase_detector  ( 1'b1       ), 
        .enable_monitor         ( 1'b0       ), 
        .rxclk                  (            ), 
        .idelay_rdy             ( idelay_rdy ),
        .reset                  ( reset      ), 
        .rxclk_div              ( clock      ), 
        .rx_mmcm_lckdps         (            ), 
        .rx_mmcm_lckd           (            ), 
        .rx_mmcm_lckdpsbs       (            ),
        .clk_data               (            ), 
        .rx_data                ( sample     ), 
        .status                 (            ), 
        .debug                  (            ), 
        .bit_rate_value         ( 16'h0605   ), 
        .bit_time_value         (            ), 
        .eye_info               (            ), 
        .m_delay_1hot           (            )
    );

endmodule