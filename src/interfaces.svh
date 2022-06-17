interface rbcp_int;
    logic        rbcp_we;
    logic        rbcp_re;
    logic [ 7:0] rbcp_wd;
    logic [31:0] rbcp_addr;
    logic [ 7:0] rbcp_rd;
    logic		 rbcp_ack;
endinterface

interface lcd_int;
    logic [2:0] lcd_control;
    logic [3:0] lcd_tx;
endinterface