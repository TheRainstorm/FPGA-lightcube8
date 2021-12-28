module frame_buffer (
    input wire clk,
    input wire rst,
    input wire display_mode,

    input wire [8*64-1: 0] frame_cube_uart_flat,
    input wire frame_valid_uart,
    input wire [8*64-1: 0] frame_cube_default_flat,
    input wire frame_valid_default,

    output reg [31: 0] frame_cnt,
    output reg [8*64-1: 0] frame_cube_flat
);
    always @(posedge clk) begin
        if(rst) begin
            frame_cube_flat <= 0;
        end
        else if(display_mode) begin
            if(frame_valid_uart) begin
                frame_cube_flat <= frame_cube_uart_flat;
            end
        end else begin
            if(frame_valid_default) begin
                frame_cube_flat <= frame_cube_default_flat;
            end
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            frame_cnt <= 0;
        end
        else if(frame_valid_uart | frame_valid_default)begin
            frame_cnt <= frame_cnt + 1;
        end
    end

endmodule