module rbcp_inst (
    input logic clk,

    inout logic [31:0] data_number,
    inout logic [ 7:0] channel_ctrl,
    inout logic        trigger_cmd,

    inout rbcp_if rbcp_in
);
    localparam DATANUMBER_0 = 0;
    localparam DATANUMBER_1 = 1;
    localparam DATANUMBER_2 = 2;
    localparam DATANUMBER_3 = 3;
    localparam CHANNELCTRL  = 4;
    localparam TRIGGERCMD   = 5;

    logic [7:0] trigger_cmd_padding;
    assign trigger_cmd_padding = {7'b0, trigger_cmd};
    assign trigger_cmd = trigger_cmd_padding[0];

    always_ff @( clk ) begin: rbcp_cmd
        if (rbcp_in.re) begin
            case (rbcp_in.addr)
                DATANUMBER_0: rbcp_in.rd <= data_number[31:24];
                DATANUMBER_1: rbcp_in.rd <= data_number[23:16];
                DATANUMBER_2: rbcp_in.rd <= data_number[15: 8];
                DATANUMBER_3: rbcp_in.rd <= data_number[ 7: 0];
                CHANNELCTRL:  rbcp_in.rd <= channel_ctrl;
                TRIGGERCMD:   rbcp_in.rd <= trigger_cmd_padding;
                default:      rbcp_in.rd <= rbcp_in.rd;
            endcase
        end else if (rbcp_in.we) begin
            case (rbcp_in.addr)
                DATANUMBER_0: data_number[31:24]  = rbcp_in.wd;
                DATANUMBER_1: data_number[23:16]  = rbcp_in.wd;
                DATANUMBER_2: data_number[15: 8]  = rbcp_in.wd;
                DATANUMBER_3: data_number[ 7: 0]  = rbcp_in.wd;
                CHANNELCTRL:  channel_ctrl        = rbcp_in.wd;
                TRIGGERCMD:   trigger_cmd_padding = rbcp_in.wd;
            endcase 
        end
    end

endmodule // rbcp_inst