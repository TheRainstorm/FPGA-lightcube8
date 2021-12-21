module frame_gen (
    input wire clk,
    input wire rst,
    input wire display_mode,

    output wire [7:0] frame_cube [63:0]
);
    reg [5: 0] cnt;
    always @(posedge clk) begin
        cnt <= rst | display_mode? 0 : cnt + 1;
    end

    wire [63: 0] mask;
    decode6x64(cnt, mask);

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1)
        begin
            assign frame_cube[i] = 8'hff & mask[i];
        end
    endgenerate

endmodule

