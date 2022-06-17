module rbcp_inst (
    input  logic clk,

    output logic [31:0] data_number,
    output logic [ 7:0] channel_ctrl,
    output logic        trigger_cmd,

    input  logic        we,
    input  logic        re,
    input  logic [ 7:0] wd,
    input  logic [31:0] addr,
    output logic [ 7:0] rd,
    output logic    	ack
);
    localparam DATANUMBER_0 = 0;
    localparam DATANUMBER_1 = 1;
    localparam DATANUMBER_2 = 2;
    localparam DATANUMBER_3 = 3;
    localparam CHANNELCTRL  = 4;
    localparam TRIGGERCMD   = 5;

    logic [7:0] trigger_cmd_padding;
    assign trigger_cmd_padding = {7'b0, trigger_cmd};

    always_ff @( clk ) begin: rbcp_cmd
        if (re) begin
            case (addr)
                DATANUMBER_0: rd <= data_number[31:24];
                DATANUMBER_1: rd <= data_number[23:16];
                DATANUMBER_2: rd <= data_number[15: 8];
                DATANUMBER_3: rd <= data_number[ 7: 0];
                CHANNELCTRL:  rd <= channel_ctrl;
                TRIGGERCMD:   rd <= trigger_cmd_padding;
                default:      rd <= rd;
            endcase
        end else if (we) begin
            case (addr)
                DATANUMBER_0: data_number[31:24]  <= wd;
                DATANUMBER_1: data_number[23:16]  <= wd;
                DATANUMBER_2: data_number[15: 8]  <= wd;
                DATANUMBER_3: data_number[ 7: 0]  <= wd;
                CHANNELCTRL:  channel_ctrl        <= wd;
                TRIGGERCMD:   trigger_cmd         <= wd[0];
            endcase 
        end
    end

endmodule // rbcp_inst