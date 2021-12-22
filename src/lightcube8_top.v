module lightcube8_top (
    input wire clk,     //100MHz
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
    wire [3: 0] display_speed;              //控制默认动画速度，串口动画FPS由上位机发送frame_cube的速度决定。越大越慢。
    assign display_speed = switch[15:12];

    wire [8*64-1: 0] frame_cube_flat, frame_cube_uart_flat, frame_cube_default_flat;
    wire frame_valid, frame_valid_uart, frame_valid_default;

    //从串口接收动画
    uart_reciver uart_reciver(
        .clk(clk),
        .rst(rst),
        .rx(rx),

        .tx(tx),
        .frame_cube_flat(frame_cube_uart_flat),
        .frame_valid(frame_valid_uart)
    );

    //生成默认动画
    //display speed控制帧生成时间，从而控制帧数
    frame_gen frame_gen(
        .clk(clk),
        .rst(rst),
        .display_speed(display_speed),
        .display_mode(display_mode),        //when no use, close to save power

        .frame_cube_flat(frame_cube_default_flat),
        .frame_valid(frame_valid_default)
    );

    //根据模式选择动画，将一帧存储到reg中，用于Display显示
    //当frame_valid时，便更新frame，因此FPS由frame_valid决定
    frame_buffer frame_buffer(
        .clk(clk),
        .rst(rst),
        .display_mode(display_mode),        //display mode

        .frame_cube_uart_flat(frame_cube_uart_flat),
        .frame_valid_uart(frame_valid_uart),
        .frame_cube_default_flat(frame_cube_default_flat),
        .frame_valid_default(frame_valid_default),

        .frame_cube_flat(frame_cube_flat)
    );
    
    //根据frame，生成扫描信号
    Display Display(
        .clk(clk),
        .rst(rst),
        .frame_cube_flat(frame_cube_flat),

        .high_csn(high_csn),
        .row(row),
        .row_cs(row_cs)
    );

endmodule