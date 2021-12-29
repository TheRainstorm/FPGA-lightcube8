`include "defines.h"

module lightcube8_top #(FRAME_GEN_CLK_DIV = 23, SCAN_CLK_DIV = 14)
(
    input wire clk,     //100MHz
    input wire resetn,  //active low

    //switch
    input wire [15:0] switch,

    //led
    output wire [15:0] led,

    //seg7
    output wire [7 :0] num_csn,
    output wire [6 :0] num_a_g,

    //uart
    input wire rx,
    output wire tx, //no use

    //display
    output wire [7:0] high_csn,             //层选信号，共阴极，0为选中
    output wire [7:0] row,                  //对应一行上8个LED灯的亮灭
    output wire [7:0] row_cs                //行选信号, 高电平为选中
);
    wire rst;
    assign rst = ~resetn;

    //led
    assign led = switch;

    //display mode
    wire [1: 0] display_mode;                      //00: 显示静态帧, 10: 播放默认动画, 11: 通过串口接收动画
    assign display_mode = switch[15:14];
    wire [3: 0] display_sel;
    assign display_sel = switch[3: 0];              //显示静态帧时用于选择

    wire [8*64-1: 0] frame_cube_flat, frame_cube_uart_flat, frame_cube_default_flat;
    wire frame_valid, frame_valid_uart, frame_valid_default;

    //从串口接收动画
    wire sel_uart;
    assign sel_uart = display_mode==`UART_MODE;
    uart_reciver uart_reciver(
        .clk(clk),
        .rst(rst),
        .en(sel_uart),
        .rx(rx),

        .tx(tx),
        .frame_cube_flat(frame_cube_uart_flat),
        .frame_valid(frame_valid_uart)
    );

    //生成默认动画
    wire sel_gen;
    assign sel_gen = display_mode==`GEN_MODE;
    wire [3:0] display_speed;
    assign display_speed = switch[3: 0];
    frame_gen #(FRAME_GEN_CLK_DIV) frame_gen(
        .clk(clk),
        .rst(rst),
        .en(sel_gen),
        .display_speed(display_speed),       //控制默认动画速度，越大越慢。

        .frame_cube_flat(frame_cube_default_flat),
        .frame_valid(frame_valid_default)
    );

    //根据模式选择动画，将一帧存储到reg中，用于Display显示
    //当frame_valid时，便更新frame，因此FPS由frame_valid决定
    //当为FRAME_MODE时，frame_buffer直接输出指定frame
    wire [31: 0] frame_cnt;
    frame_buffer frame_buffer(
        .clk(clk),
        .rst(rst),
        .display_mode(display_mode),        //display mode
        .display_sel(display_sel),

        .frame_cube_uart_flat(frame_cube_uart_flat),
        .frame_valid_uart(frame_valid_uart),
        .frame_cube_default_flat(frame_cube_default_flat),
        .frame_valid_default(frame_valid_default),

        .frame_cnt(frame_cnt),
        .frame_cube_flat(frame_cube_flat)
    );
    
    //根据frame，生成扫描信号
    Display #(SCAN_CLK_DIV) Display(
        .clk(clk),
        .rst(rst),
        .frame_cube_flat(frame_cube_flat),

        .high_csn(high_csn),
        .row(row),
        .row_cs(row_cs)
    );

    seg7 seg7(
        .clk(clk),
        .rst(rst),
        .num_data(frame_cnt),

        .num_csn(num_csn),
        .num_a_g(num_a_g)
    );

endmodule