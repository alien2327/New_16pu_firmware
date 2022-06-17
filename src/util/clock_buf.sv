module clock_buf (
    input  logic I,
    output logic O
);
    logic clk_ibuf;
    IBUF clk_ibuf_inst (
        .I (I),
        .O (clk_ibuf)
    );
    BUFG clk_bufg_inst (
        .I (clk_ibuf),
        .O (O)
    );
endmodule // clock_buf