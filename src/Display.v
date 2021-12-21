module Display (
    input wire clk,
    input wire rst,
    input wire [3:0] display_speed,
    input wire [7:0] frame_cube [63:0],     //一层8行，8层64行，每行包含8个LED灯

    output wire [7:0] high_csn,             //层选信号, 共阴极, 故低电平为选中
    output wire [7:0] row,                  //对应一行上8个LED灯的亮灭
    output wire [7:0] row_cs                //行选信号, 高电平为选中
);
    reg [3:0] cnt_speed;
    always @(posedge clk) begin
        if(rst || cnt_speed == display_speed) begin
            cnt_speed <= 0;
        end
        else begin
            cnt_speed <= cnt_speed + 1;
        end
    end

    reg [5:0] cnt;
    always @(posedge clk) begin
        if(rst) begin
            cnt <= 0;
        end 
        else if(cnt_speed == 0)begin
            cnt <= cnt + 1;
        end
    end

    wire [5:0] scan_row;
    assign scan_row = cnt;

    decoder3x8 decoder1(
        .x(scan_row[5:3]),
        .y(~high_csn),
    );

    decoder3x8 decoder2(
        .x(scan_row[2:0]),
        .y(row_cs),
    );

    assign row = frame_cube[scan_row];
endmodule