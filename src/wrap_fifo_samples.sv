module wrap_fifo_samples
(
     input  logic [3:0] 	FR_p,
     input  logic [3:0] 	FR_n,
     input  logic [31:0] 	DATA_p,
     input  logic [31:0] 	DATA_n,
     input  logic 		    idelay_rdy,
     input  logic 		    reset
);

    logic         DataClock;
    logic [255:0] WaveSample;
    
    wrap_serdes wrap_serdes
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
        .reset      ( SystemReset   ),
        .clock      ( DataClock     ),
        
        // Deserialized sample data
        .sample     ( WaveSample    )
    );

endmodule