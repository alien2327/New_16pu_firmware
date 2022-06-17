module lcd_wrap(
    input logic clk_50mhz,
    input logic rst,
    output logic [2:0] lcd_ctrl_3bits,
    output logic [3:0] lcd_data_4bits
);
    logic [127:0] line_1_buffer;
    logic [127:0] line_2_buffer;

    lcd16x2_ctrl lcd_inst (
        .clk          (clk_50mhz),
        .rst          (rst),
        .lcd_e        (lcd_ctrl_3bits[0]),
        .lcd_rs       (lcd_ctrl_3bits[1]),
        .lcd_rw       (lcd_ctrl_3bits[2]),
        .lcd_db       (lcd_data_4bits),
        .line1_buffer (line_1_buffer),
        .line2_buffer (line_2_buffer)
    );

    always_latch begin : lcd_display
        line1[127:120] <= 8'h20; 
        line1[119:112] <= 8'h20;
        line1[111:104] <= 8'h48;  // H
        line1[103: 96] <= 8'h65;  // e
        line1[ 95: 88] <= 8'h6c;  // l
        line1[ 87: 80] <= 8'h6c;  // l
        line1[ 79: 72] <= 8'h6f;  // o
        line1[ 71: 64] <= 8'h20;
        line1[ 63: 56] <= 8'h57;  // W
        line1[ 55: 48] <= 8'h6f;  // o
        line1[ 47: 40] <= 8'h72;  // r
        line1[ 39: 32] <= 8'h6c;  // l
        line1[ 31: 24] <= 8'h64;  // d
        line1[ 23: 16] <= 8'h21;  // !
        line1[ 15:  8] <= 8'h20;
        line1[  7:  0] <= 8'h20;

        line2[127:120] <= 8'h30;
        line2[119:112] <= 8'h31;
        line2[111:104] <= 8'h32;
        line2[103: 96] <= 8'h33;
        line2[ 95: 88] <= 8'h34;
        line2[ 87: 80] <= 8'h35;
        line2[ 79: 72] <= 8'h36;
        line2[ 71: 64] <= 8'h37;
        line2[ 63: 56] <= 8'h38;
        line2[ 55: 48] <= 8'h39;
        line2[ 47: 40] <= 8'h3a;
        line2[ 39: 32] <= 8'h3b;
        line2[ 31: 24] <= 8'h3c;
        line2[ 23: 16] <= 8'h3d;
        line2[ 15:  8] <= 8'h3e;
        line2[  7:  0] <= 8'h3f;
    end

endmodule