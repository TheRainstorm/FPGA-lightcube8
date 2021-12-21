module frame_buffer (
    input wire clk,
    input wire rst,

    input wire display_mode,
    input wire [7:0] frame_cube_default [63:0],
    input wire [7:0] frame_cube_uart [63:0],
    output reg [7:0] frame_cube [63:0]
);
    always @(posedge clk) begin
        if(display_mode) begin
            frame_cube <= frame_cube_uart;
        end else begin
            frame_cube <= frame_cube_default;
        end
    end
endmodule