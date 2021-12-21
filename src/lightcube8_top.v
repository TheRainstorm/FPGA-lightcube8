module lightcube8_top (
    input wire clk,
    input wire rst,

    //switch
    input wire [15:0] switch,

    //uart
    input wire rx,
    output wire tx, //no use

    //display
    output wire [7:0] high_csn,             //层选信号, 共阴极, 故低电平为选中
    output wire [7:0] row,                  //对应一行上8个LED灯的亮灭
    output wire [7:0] row_cs                //行选信号, 高电平为选中
);
    //display mode
    wire display_mode;                      //0: 播放默认动画, 1: 通过串口接收动画
    assign display_mode = switch[0];

    //display speed
    wire [3: 0] display_speed;              //控制display模块扫描光立方速度，越大越慢(需要能够动态调整FPS，还未实现)
    assign display_speed = switch[15:12];

    wire FPS_clk;
    wire display_clk;
    pll pll0(
        .clk(clk),
        .rst(rst),

        .FPS_clk(FPS_clk),
        .display_clk(display_clk)
    );

    wire [7:0] frame_cube [63:0];
    wire [7:0] frame_cube_uart [63:0];
    wire [7:0] frame_cube_default [63:0];

    uart_reciver uart_reciver(
        .clk(clk),
        .rst(rst),
        .rx(rx),

        .tx(tx),
        .frame_cube(frame_cube_uart)
    );

    frame_gen frame_gen(
        .clk(FPS_clk),
        .rst(rst),
        .display_mode(display_mode),        //when close to save power

        .frame_cube(frame_cube_default)
    );

    frame_buffer frame_buffer(
        .clk(FPS_clk),
        .rst(rst),
        .display_mode(display_mode),        //display mode
        .frame_cube_default(frame_cube_default),
        .frame_cube_uart(frame_cube_uart),

        .frame_cube(frame_cube)
    );

    Display Display(
        .clk(display_clk),
        .rst(rst),
        .display_speed(display_speed),
        .frame_cube(frame_cube),

        .high_csn(high_csn),
        .row(row),
        .row_cs(row_cs)
    );

endmodule