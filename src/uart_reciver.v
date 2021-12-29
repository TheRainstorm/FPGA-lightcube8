module uart_reciver (
    input wire clk,
    input wire rst,
    input wire en,
    input wire rx,

    output wire tx, //no use
    output wire [8*64-1: 0] frame_cube_flat,
    output reg frame_valid
);
    assign tx = 1'b1; //no use

    wire [7: 0] byte;
    wire byte_valid;
    uart_rx uart_rx(
        .clk_100M(clk),
        .rst(rst),
        .en(en),
        .rx(rx),

        .byte_valid(byte_valid),
        .byte(byte)
    );

    reg [5: 0] byte_cnt;
    always @(posedge clk) begin
        // byte_cnt <= rst | frame_valid  ? 0 :
        byte_cnt <= rst                ? 0 :    //overflow to 0
                    byte_valid         ? byte_cnt + 1 : byte_cnt;
    end

    //byte_valid时，将byte存下来
    reg [7:0] frame_cube [63:0];
    always @(posedge clk) begin
        if(byte_valid) begin
            frame_cube[byte_cnt] <= byte;
        end
    end

    //在将byte存下来的同时，将frame_valid置为1，维持一个周期
    always @(posedge clk) begin
        frame_valid <= rst ? 0 :
                       ~frame_valid & byte_valid & (byte_cnt==63) ? 1 : 0;
    end

    genvar i;
    generate
        for(i = 0; i < 64; i = i + 1)
        begin : gen_frame
            assign frame_cube_flat[(i<<3) + 7 -: 8] = frame_cube[i];
        end
    endgenerate
    
endmodule