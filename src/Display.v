module Display (
    input wire clk,
    input wire rst,
    input wire [8*64-1: 0] frame_cube_flat,
    // input wire [7:0] frame_cube [63:0],     //一层8行，8层64行，每行包含8个LED灯

    output wire [7:0] high_csn,             //层选信号, 共阴极, 故低电平为选中
    output wire [7:0] row,                  //对应一行上8个LED灯的亮灭
    output wire [7:0] row_cs                //行选信号, 高电平为选中
);
    //flat to cube
    wire [7:0] frame_cube [63:0];
    genvar i;
    generate
        for(i = 0; i < 64; i = i + 1)
        begin : gen_frame
            assign frame_cube[i] = frame_cube_flat[(i<<3) + 7 -: 8];
        end
    endgenerate

    //对clk进行分频
    parameter LEN = 14;
    reg [LEN-1:0] cnt;
    always @(posedge clk) begin
        cnt <= rst ? 0 : cnt + 1;
    end

    wire [5:0] scan_row;
    assign scan_row = cnt[LEN-1 -: 6];

    wire [7:0] high_csn_tmp;
    assign high_csn = ~high_csn_tmp;
    decoder3x8 decoder1(
        .x(scan_row[5:3]),
        .y(high_csn_tmp)
    );

    decoder3x8 decoder2(
        .x(scan_row[2:0]),
        .y(row_cs)
    );

    assign row = frame_cube[scan_row];
endmodule