module Display_4_16_decoder (
    input wire clk,
    input wire rst,
    input wire [7:0] frame_cube [63:0],     //64个灯柱，每个灯柱包含8个LED灯

    output wire [7:0] led_v,                //对应灯柱上8个LED灯的亮灭
    output wire [3:0] scan,                 //经过解码后为16位的独热码，对应16个灯柱
    output wire [3:0] en                    //切换到下一个解码器
);
    parameter LEN = 20;
    reg [LEN-1:0] cnt;
    always @(posedge clk) begin
        if(rst) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end

    wire [5:0] scan_pillar;     //0-63, 扫描每个灯柱
    assign scan_pillar = cnt[LEN-1 -: 6];

    assign scan = scan_pillar[3:0]; //0-f, 

    decoder2x4 decoder1(
        .x(scan_pillar[5:4]),
        .y(en)
    );

    assign led_v = frame_cube[scan_pillar];     //控制灯柱上8个灯，每个的亮暗
endmodule