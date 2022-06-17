module deepfifo_wrap #(
    parameter integer D = 16,
    parameter integer S = 8,
    parameter integer FIFO_WIDTH = 16
) (
    input  logic clk,
    input  logic sys_rst,

    input  logic [S-1:0]            data_clk,
    input  logic [S-1:0][D-1:0]     data_in,
    output logic [S*FIFO_WIDTH-1:0] data_pre_packet,

    input  logic            axi_clk,
    output logic            axi_aresetn,

    output logic  [ 31:0] 	axi_awaddr,
    output logic  [  7:0] 	axi_awlen,
    output logic  [  2:0] 	axi_awsize,
    output logic  [  1:0] 	axi_awburst,
    output logic  	        axi_awvalid,
    input  logic  	        axi_awready,
    output logic  [511:0]   axi_wdata,
    output logic  [ 63:0] 	axi_wstrb,
    output logic  	        axi_wlast,
    output logic  	        axi_wvalid,
    input  logic  	        axi_wready,

    input  logic  	        axi_bvalid,
    output logic  	        axi_bready,

    output logic  [ 31:0] 	axi_araddr,
    output logic  [  7:0] 	axi_arlen,
    output logic  [  2:0] 	axi_arsize,
    output logic  [  1:0] 	axi_arburst,
    output logic  	        axi_arvalid,
    input  logic  	        axi_arready,
    input  logic  [511:0]   axi_rdata,
    input  logic  	        axi_rlast,
    input  logic  	        axi_rvalid,
    output logic  	        axi_rready
);
    logic         fifo_pre_rd_en;
    logic         fifo_pre_empty;
    logic [511:0] fifo_pre_dout;
    logic [  7:0] fifo_pre_rd_count;

    logic         fifo_post_wr_en;
    logic         fifo_post_full;
    logic [511:0] fifo_post_din;
    logic [  7:0] fifo_post_wr_count;

    logic data_clk_all;
    assign data_clk_all = &data_clk;

    fifo_deepfifo_pre fifo_pre_inst (
        .rst(sys_rst),
        .wr_clk(data_clk_all),
        .rd_clk(axi_clk),
        .din(data_in),
        .wr_en(1'b1),
        .rd_en(fifo_pre_rd_en),
        .dout(fifo_pre_dout),
        .full(),
        .rd_data_count(fifo_pre_rd_count),
        .empty(fifo_pre_empty)
    );

    deepfifo #(
        .log2_ram_size_addr(30),
        .log2_word_width(9),
        .log2_fifo_words(9),
        .fifo_threshold(256)
    ) deepfifo_inst (
        .clk				    (axi_clk),
        .reset				    (sys_rst), // Active high

        .fifo_pre_rd_en			(fifo_pre_rd_en),
        .fifo_pre_empty			(fifo_pre_empty),
        .fifo_pre_dout			(fifo_pre_dout),
        .fifo_pre_rd_count		(fifo_pre_rd_count),

        .fifo_post_wr_en        (fifo_post_wr_en),
        .fifo_post_din			(fifo_post_din),
        .fifo_post_full			(fifo_post_full),
        .fifo_post_wr_count		(fifo_post_wr_count),

        .axi_aresetn			(axi_aresetn),

        .axi_awaddr			    (axi_awaddr),
        .axi_awlen			    (axi_awlen),
        .axi_awvalid			(axi_awvalid),
        .axi_awready			(axi_awready),
        .axi_awsize			    (axi_awsize),
        .axi_awburst			(axi_awburst),

        .axi_wdata			    (axi_wdata),
        .axi_wstrb			    (axi_wstrb),
        .axi_wlast			    (axi_wlast),
        .axi_wvalid			    (axi_wvalid),

        .axi_bvalid			    (axi_bvalid),
        .axi_bready			    (axi_bready),

        .axi_araddr			    (axi_araddr),
        .axi_arlen			    (axi_arlen),
        .axi_arvalid			(axi_arvalid),
        .axi_arready			(axi_arready),
        .axi_arsize			    (axi_arsize),
        .axi_arburst			(axi_arburst),

        .axi_wready			    (axi_wready),
        .axi_rdata			    (axi_rdata),
        .axi_rready			    (axi_rready),
        .axi_rlast			    (axi_rlast),
        .axi_rvalid			    (axi_rvalid)
    );

    fifo_deepfifo_post fifo_post_inst (
        .rst(sys_rst),
        .wr_clk(axi_clk),
        .rd_clk(clk),
        .din(fifo_post_din),
        .wr_en(fifo_post_wr_en),
        .rd_en(1'b1),
        .dout(data_pre_packet),
        .full(fifo_post_full),
        .wr_data_count(fifo_post_wr_count),
        .empty()
    );


endmodule