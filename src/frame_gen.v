module frame_gen (
    input wire clk,
    input wire rst,
    input wire display_mode,
    input wire [3: 0] display_speed,

    output wire [8*64-1: 0] frame_cube_flat,
    // output wire [7:0] frame_cube [63:0]
    output wire frame_valid
);
    //默认生成动画，循环遍历每个行（共64个），让每行全亮。

    reg [3: 0] speed_cnt;   //用于控制速度
    wire speed_ctrl;
    assign speed_ctrl = (speed_cnt == display_speed);
    always @(posedge clk) begin
        speed_cnt <= rst | speed_ctrl? 0 : speed_cnt + 1;
    end

    //对clk进行分频，最慢为每一帧1秒，display_speed为16档，故最快为每帧1/16秒
    parameter LEN = 23;     // 2*23/100M * 16 = 1.34s
    reg [LEN-1:0] cnt;
    always @(posedge clk) begin
        cnt <= rst | display_mode? 0 :
               speed_ctrl ? cnt + 1 : cnt;
    end

    assign frame_valid = ~display_mode & (cnt == 0);

    //scan_now指定的行全亮，构成一帧
    reg [5: 0] scan_row;
    always @(posedge clk) begin
        if(rst) begin
            scan_row <= 0;
        end else begin
            if(frame_valid) begin
                scan_row <= scan_row + 1;
            end
        end
    end

    wire [63: 0] mask;
    decoder6x64 decoder6x64(scan_row, mask);

    wire [7:0] frame_cube [63:0];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1)
        begin
            assign frame_cube[i] = 8'hff & {8{mask[i]}};
        end
    endgenerate

    generate
        for(i = 0; i < 64; i = i + 1)
        begin : gen_frame
            assign frame_cube_flat[(i<<3) + 7 -: 8] = frame_cube[i];
        end
    endgenerate
endmodule

