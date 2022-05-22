`timescale 1ps/1ps

module serdes_1_to_8_slave_idelay_ddr (clkin_p, clkin_n, datain_p, datain_n, enable_phase_detector, enable_monitor, idelay_rdy, rxclk, reset, rxclk_div, 
                                       bitslip_finished, clk_data, rx_data, debug, bit_time_value, m_delay_1hot, rst_iserdes, eye_info) ;

   parameter integer 	D = 8 ;   			// Parameter to set the number of data lines
   parameter 		HIGH_PERFORMANCE_MODE = "TRUE";// Parameter to set HIGH_PERFORMANCE_MODE of input delays to reduce jitter
   parameter         	DIFF_TERM = "TRUE" ; 		// Parameter to enable internal differential termination
   parameter         	DATA_FORMAT = "PER_CLOCK" ;     // Parameter Used to determine method for mapping input parallel word to output serial words
   
   input 		clkin_p ;			// Input from LVDS clock receiver pin
   input 		clkin_n ;			// Input from LVDS clock receiver pin
   input [D-1:0] 	datain_p ;			// Input from LVDS clock data pins
   input [D-1:0] 	datain_n ;			// Input from LVDS clock data pins
   input 		enable_phase_detector ;		// Enables the phase detector logic when high
   input 		enable_monitor ;		// Enables the monitor logic when high, note time-shared with phase detector function
   input 		idelay_rdy ;			// input delays are ready
   input 		reset ;				// Reset line
   input 		rxclk ;				// Global/BUFIO rx clock network
   input 		rxclk_div ;			// Global/Regional clock input
   output 		bitslip_finished ;	 	// bitslipping finished
   output [7:0] 	clk_data ;	 		// Clock Data
   output [D*8-1:0] 	rx_data ;	 		// Received Data
   output [10*D+5:0] 	debug ;	 			// debug info
   input [4:0] 		bit_time_value ;		// Calculated bit time value from 'master'
   input 		rst_iserdes ;			// reset serdes input
   output [32*D-1:0] 	eye_info ;			// Eye info
   output [32*D-1:0] 	m_delay_1hot ;			// Master delay control value as a one-hot vector

   wire [D*5-1:0] 	m_delay_val_in ;
   wire [D*5-1:0] 	s_delay_val_in ;
   wire			rx_clk_in ;			
   reg [1:0] 		bsstate ;                 	
   reg 			bslip ;                 	
   reg 			bslipreq ;                 	
   reg 			bslipr ;                 	
   reg [3:0] 		bcount ;                 	
   wire [7:0] 		clk_iserdes_data ;      	
   reg [7:0] 		clk_iserdes_data_d ;    	
   reg 			enable ;                	
   reg 			flag ;                 	
   reg [2:0] 		state2 ;			
   reg [3:0] 		state2_count ;			
   reg [5:0] 		scount ;			
   reg 			locked_out ;	
   reg 			locked_out_rt ;	
   reg			chfound ;	
   reg			chfoundc ;
   reg [4:0] 		c_delay_in ;
   reg [4:0] 		old_c_delay_in ;
   reg			local_reset ;
   wire [D-1:0] 	rx_data_in_p ;			
   wire [D-1:0] 	rx_data_in_n ;			
   wire [D-1:0] 	rx_data_in_m ;			
   wire [D-1:0] 	rx_data_in_s ;		
   wire [D-1:0] 	rx_data_in_md ;			
   wire [D-1:0] 	rx_data_in_sd ;	
   wire [(8*D)-1:0] 	mdataout ;						
   wire [(8*D)-1:0] 	mdataoutd ;			
   wire [(8*D)-1:0] 	sdataout ;						
   reg			bslip_ackr ;		
   reg			bslip_ack ;		
   reg [1:0] 		bstate ;
   reg			data_different ;		
   reg			bs_finished ;
   reg			not_bs_finished ;
   wire [4:0] 		bt_val ;
   reg [D*4-1:0] 	s_state ;                 			
   reg			retry ;
   reg			no_clock ;
   reg [1:0] 		c_loop_cnt ;  

   parameter [D-1:0] 	RX_SWAP_MASK = 16'h0000 ;	// pinswap mask for input data bits (0 = no swap (default), 1 = swap). Allows inputs to be connected the wrong way round to ease PCB routing.

   assign clk_data = clk_iserdes_data ;
   assign debug = {s_delay_val_in, m_delay_val_in, bslip, c_delay_in} ;
   assign bitslip_finished = bs_finished & ~reset ;
   assign bt_val = bit_time_value ;

   always @ (posedge rxclk_div or posedge reset) begin	// generate local sync (rxclk_div) reset
      if (reset == 1'b1 || retry == 1'b1) begin
	 local_reset <= 1'b1 ;
      end
      else begin
	 if (idelay_rdy == 1'b0) begin
	    local_reset <= 1'b1 ;
	 end
	 else begin
	    local_reset <= 1'b0 ;
	 end
      end
   end

   // Bitslip state machine

   always @ (posedge rxclk_div)
     begin
	if (locked_out == 1'b0) begin
	   bslip <= 1'b0 ;
	   bsstate <= 1 ;
	   enable <= 1'b0 ;
	   bcount <= 4'h0 ;
	   bs_finished <= 1'b0 ;
	   not_bs_finished <= 1'b1 ;
	   retry <= 1'b0 ;
	end
	else begin
	   enable <= 1'b1 ;
   	   if (enable == 1'b1) begin
   	      if (clk_iserdes_data != 8'b11110000) begin flag <= 1'b1 ; end else begin flag <= 1'b0 ; end
     	      if (bsstate == 0) begin
   		 if (flag == 1'b1) begin
     		    bslip <= 1'b1 ;						// bitslip needed
     		    bsstate <= 1 ;
     		 end
     		 else begin
     		    bs_finished <= 1'b1 ;					// bitslip done
     		    not_bs_finished <= 1'b0 ;				// bitslip done
     		 end
	      end
   	      else if (bsstate == 1) begin				
     		 bslip <= 1'b0 ; 
     		 bcount <= bcount + 4'h1 ;
   		 if (bcount == 4'hF) begin
     		    bsstate <= 0 ;
     		 end
   	      end
   	   end
	end
     end

   // Clock input 

   IBUFGDS #(
	     .DIFF_TERM 		(DIFF_TERM)) 
   iob_clk_in (
	       .I    			(clkin_p),
	       .IB       		(clkin_n),
	       .O         		(rx_clk_in));

   genvar i ;
   genvar j ;

   IDELAYE2 #(
	      .HIGH_PERFORMANCE_MODE	(HIGH_PERFORMANCE_MODE),
      	      .IDELAY_VALUE		(1),
      	      .DELAY_SRC		("IDATAIN"),
      	      .IDELAY_TYPE		("VAR_LOAD"))
   idelay_cm(               	
				.DATAOUT		(rx_clk_in_d),
				.C			(rxclk_div),
				.CE			(1'b0),
				.INC			(1'b0),
				.DATAIN			(1'b0),
				.IDATAIN		(rx_clk_in),
				.LD			(1'b1),
				.LDPIPEEN		(1'b0),
				.REGRST			(1'b0),
				.CINVCTRL		(1'b0),
				.CNTVALUEIN		(c_delay_in),
				.CNTVALUEOUT		());
   
   ISERDESE2 #(
	       .DATA_WIDTH     	(8), 				
	       .DATA_RATE      	("DDR"), 			
	       .SERDES_MODE    	("MASTER"), 			
	       .IOBDELAY	    	("IFD"), 			
	       .INTERFACE_TYPE 	("NETWORKING")) 		
   iserdes_cm (
	       .D       		(1'b0),
	       .DDLY     		(rx_clk_in_d),
	       .CE1     		(1'b1),
	       .CE2     		(1'b1),
	       .CLK    		(rxclk),
	       .CLKB    		(~rxclk),
	       .RST     		(local_reset),
	       .CLKDIV  		(rxclk_div),
	       .CLKDIVP  		(1'b0),
	       .OCLK    		(1'b0),
	       .OCLKB    		(1'b0),
	       .DYNCLKSEL    		(1'b0),
	       .DYNCLKDIVSEL  		(1'b0),
	       .SHIFTIN1 		(1'b0),
	       .SHIFTIN2 		(1'b0),
	       .BITSLIP 		(bslip),
	       .O	 		(),
	       .Q8 			(clk_iserdes_data[7]),
	       .Q7 			(clk_iserdes_data[6]),
	       .Q6 			(clk_iserdes_data[5]),
	       .Q5 			(clk_iserdes_data[4]),
	       .Q4 			(clk_iserdes_data[3]),
	       .Q3 			(clk_iserdes_data[2]),
	       .Q2 			(clk_iserdes_data[1]),
	       .Q1 			(clk_iserdes_data[0]),
	       .OFB 			(),
	       .SHIFTOUT1 		(),
	       .SHIFTOUT2 		());	

   always @ (posedge rxclk_div) begin				// 
      clk_iserdes_data_d <= clk_iserdes_data ;
      if ((clk_iserdes_data != clk_iserdes_data_d) && (clk_iserdes_data != 8'h00) && (clk_iserdes_data != 8'hFF)) begin
	 data_different <= 1'b1 ;
      end
      else begin
	 data_different <= 1'b0 ;
      end
      if ((clk_iserdes_data == 8'h00) || (clk_iserdes_data == 8'hFF)) begin
	 no_clock <= 1'b1 ;
      end
      else begin
	 no_clock <= 1'b0 ;
      end
   end
   
   always @ (posedge rxclk_div) begin					// clock delay shift state machine
      if (local_reset == 1'b1) begin
	 scount <= 6'h00 ;
	 state2 <= 0 ;
	 state2_count <= 4'h0 ;
	 locked_out <= 1'b0 ;
	 chfoundc <= 1'b1 ;
	 chfound <= 1'b0 ;
	 c_delay_in <= bt_val ;						// Start the delay line at the current bit period
	 c_loop_cnt <= 2'b00 ;	
      end
      else begin
	 if (scount[5] == 1'b0) begin
	    if (no_clock == 1'b0) begin
	       scount <= scount + 6'h01 ;
	    end
	    else begin
	       scount <= 6'h00 ;
	    end
	 end
	 state2_count <= state2_count + 4'h1 ;
	 if (chfoundc == 1'b1) begin
	    chfound <= 1'b0 ;
	 end
	 else if (chfound == 1'b0 && data_different == 1'b1) begin
	    chfound <= 1'b1 ;
	 end
	 if ((state2_count == 4'hF && scount[5] == 1'b1)) begin
	    case(state2) 					
	      0	: begin							// decrement delay and look for a change
		 if (chfound == 1'b1 || (c_loop_cnt == 2'b11 && c_delay_in == 5'h00)) begin  // quit loop if we've been around a few times
		    chfoundc <= 1'b1 ;				// change found
		    state2 <= 1 ;
		    c_delay_in <= old_c_delay_in ;
		 end
		 else begin
		    chfoundc <= 1'b0 ;
		    old_c_delay_in <= c_delay_in ;
		    if (c_delay_in != 5'h00) begin			// check for underflow
		       c_delay_in <= c_delay_in - 5'h01 ;
		    end
		    else begin
		       c_delay_in <= bt_val ;
		       c_loop_cnt <= c_loop_cnt + 2'b01 ;
		    end
		 end
	      end
	      1	: begin							// add half a bit period using input information
		 state2 <= 2 ;
		 if (c_delay_in < {1'b0, bt_val[4:1]}) begin		// choose the lowest delay value to minimise jitter
		    c_delay_in <= c_delay_in + {1'b0, bt_val[4:1]} ;
		 end
		 else begin
		    c_delay_in <= c_delay_in - {1'b0, bt_val[4:1]} ;
		 end
	      end
	      default	: begin							// issue locked out signal
		 locked_out <= 1'b1 ;
	      end
	    endcase
	 end
      end
   end
   
   generate
      for (i = 0 ; i <= D-1 ; i = i+1)
	begin : loop3

	   delay_controller_wrap # (
				    .S 			(8))
	   dc_inst (                       
					   .m_datain		(mdataout[8*i+7:8*i]),
					   .s_datain		(sdataout[8*i+7:8*i]),
					   .enable_phase_detector	(enable_phase_detector),
					   .enable_monitor		(enable_monitor),
					   .reset			(not_bs_finished),
					   .clk			(rxclk_div),
					   .c_delay_in		(c_delay_in),
					   .m_delay_out		(m_delay_val_in[5*i+4:5*i]),
					   .s_delay_out		(s_delay_val_in[5*i+4:5*i]),
					   .data_out		(mdataoutd[8*i+7:8*i]),
					   .bt_val			(bt_val),
					   .del_mech		(1'b0),
					   .m_delay_1hot		(m_delay_1hot[32*i+31:32*i]),
					   .results		(eye_info[32*i+31:32*i])) ;

	   // Data bit Receivers 

	   IBUFDS_DIFF_OUT #(
			     .DIFF_TERM 		(DIFF_TERM)) 
	   data_in (
		    .I    			(datain_p[i]),
		    .IB       		(datain_n[i]),
		    .O         		(rx_data_in_p[i]),
		    .OB         		(rx_data_in_n[i]));

	   assign rx_data_in_m[i] = rx_data_in_p[i]  ^ RX_SWAP_MASK[i] ;
	   assign rx_data_in_s[i] = ~rx_data_in_n[i] ^ RX_SWAP_MASK[i] ;

	   IDELAYE2 #(
		      .HIGH_PERFORMANCE_MODE	(HIGH_PERFORMANCE_MODE),
      		      .IDELAY_VALUE		(0),
      		      .DELAY_SRC		("IDATAIN"),
      		      .IDELAY_TYPE		("VAR_LOAD"))
	   idelay_m(               	
					.DATAOUT		(rx_data_in_md[i]),
					.C			(rxclk_div),
					.CE			(1'b0),
					.INC			(1'b0),
					.DATAIN			(1'b0),
					.IDATAIN		(rx_data_in_m[i]),
					.LD			(1'b1),
					.LDPIPEEN		(1'b0),
					.REGRST			(1'b0),
					.CINVCTRL		(1'b0),
					.CNTVALUEIN		(m_delay_val_in[5*i+4:5*i]),
					.CNTVALUEOUT		());
	   
	   ISERDESE2 #(
		       .DATA_WIDTH     	(8), 			
		       .DATA_RATE      	("DDR"), 		
		       .SERDES_MODE    	("MASTER"), 		
		       .IOBDELAY	    	("IFD"), 		
		       .INTERFACE_TYPE 	("NETWORKING")) 	
	   iserdes_m (
		      .D       		(1'b0),
		      .DDLY     		(rx_data_in_md[i]),
		      .CE1     		(1'b1),
		      .CE2     		(1'b1),
		      .CLK	   		(rxclk),
		      .CLKB    		(~rxclk),
		      .RST     		(rst_iserdes),
		      .CLKDIV  		(rxclk_div),
		      .CLKDIVP  		(1'b0),
		      .OCLK    		(1'b0),
		      .OCLKB    		(1'b0),
		      .DYNCLKSEL    		(1'b0),
		      .DYNCLKDIVSEL  		(1'b0),
		      .SHIFTIN1 		(1'b0),
		      .SHIFTIN2 		(1'b0),
		      .BITSLIP 		(bslip),
		      .O	 		(),
		      .Q8  			(mdataout[8*i+7]),
		      .Q7  			(mdataout[8*i+6]),
		      .Q6  			(mdataout[8*i+5]),
		      .Q5  			(mdataout[8*i+4]),
		      .Q4  			(mdataout[8*i+3]),
		      .Q3  			(mdataout[8*i+2]),
		      .Q2  			(mdataout[8*i+1]),
		      .Q1  			(mdataout[8*i+0]),
		      .OFB 			(),
		      .SHIFTOUT1		(),
		      .SHIFTOUT2 		());

	   IDELAYE2 #(
		      .HIGH_PERFORMANCE_MODE	(HIGH_PERFORMANCE_MODE),
      		      .IDELAY_VALUE		(0),
      		      .DELAY_SRC		("IDATAIN"),
      		      .IDELAY_TYPE		("VAR_LOAD"))
	   idelay_s(               	
					.DATAOUT		(rx_data_in_sd[i]),
					.C			(rxclk_div),
					.CE			(1'b0),
					.INC			(1'b0),
					.DATAIN			(1'b0),
					.IDATAIN		(rx_data_in_s[i]),
					.LD			(1'b1),
					.LDPIPEEN		(1'b0),
					.REGRST			(1'b0),
					.CINVCTRL		(1'b0),
					.CNTVALUEIN		(s_delay_val_in[5*i+4:5*i]),
					.CNTVALUEOUT		());
	   
	   ISERDESE2 #(
		       .DATA_WIDTH     	(8), 			
		       .DATA_RATE      	("DDR"), 		
		       //	.SERDES_MODE    	("SLAVE"), 		
		       .IOBDELAY	    	("IFD"), 		
		       .INTERFACE_TYPE 	("NETWORKING")) 	
	   iserdes_s (
		      .D       		(1'b0),
		      .DDLY     		(rx_data_in_sd[i]),
		      .CE1     		(1'b1),
		      .CE2     		(1'b1),
		      .CLK	   		(rxclk),
		      .CLKB    		(~rxclk),
		      .RST     		(rst_iserdes),
		      .CLKDIV  		(rxclk_div),
		      .CLKDIVP  		(1'b0),
		      .OCLK    		(1'b0),
		      .OCLKB    		(1'b0),
		      .DYNCLKSEL    		(1'b0),
		      .DYNCLKDIVSEL  		(1'b0),
		      .SHIFTIN1 		(1'b0),
		      .SHIFTIN2 		(1'b0),
		      .BITSLIP 		(bslip),
		      .O	 		(),
		      .Q8  			(sdataout[8*i+7]),
		      .Q7  			(sdataout[8*i+6]),
		      .Q6  			(sdataout[8*i+5]),
		      .Q5  			(sdataout[8*i+4]),
		      .Q4  			(sdataout[8*i+3]),
		      .Q3  			(sdataout[8*i+2]),
		      .Q2  			(sdataout[8*i+1]),
		      .Q1  			(sdataout[8*i+0]),
		      .OFB 			(),
		      .SHIFTOUT1		(),
		      .SHIFTOUT2 		());

	   for (j = 0 ; j <= 7 ; j = j+1) begin : loop1			// Assign data bits to correct serdes according to required format
	      if (DATA_FORMAT == "PER_CLOCK") begin
		 assign rx_data[D*j+i] = mdataoutd[8*i+j] ;
	      end
	      else   if(DATA_FORMAT == "TWO_LANE") begin
		 assign rx_data[8*i+2*j-9*(i%2)+1] = mdataoutd[8*i+j] ;
	      end
	      
	      else begin
		 assign rx_data[8*i+j] = mdataoutd[8*i+j] ;
	      end
	   end
	end
   endgenerate
endmodule
