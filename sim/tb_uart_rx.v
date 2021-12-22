`timescale 1ns/1ps

module tb_uart_rx;
    reg clk;
    reg rst;

    //clock generating
    real         CYCLE_100MHz = 10;
    always begin
        clk = 0 ; #(CYCLE_100MHz/2) ;
        clk = 1 ; #(CYCLE_100MHz/2) ;
    end

    //reset generating
    initial begin
        rst      = 1'b0;
        #8 rst = 1'b1;
        #2000 rst = 1'b0;
    end

    //uart_rx
    real         BAUD_PERIOD = 8680;
    reg rx;
    initial begin
        rx = 1'b1;
        #3000
        rx = 1'b0; #BAUD_PERIOD;
        rx = 1'b1; #BAUD_PERIOD;
        rx = 1'b1; #BAUD_PERIOD;
        rx = 1'b1; #BAUD_PERIOD;
        rx = 1'b1; #BAUD_PERIOD;
        rx = 1'b1; #BAUD_PERIOD;
        rx = 1'b1; #BAUD_PERIOD;
        rx = 1'b0; #BAUD_PERIOD;
        rx = 1'b1; #BAUD_PERIOD;
        rx = 1'b1; #BAUD_PERIOD;

        rx = 1'b0; #BAUD_PERIOD;
        rx = 1'b0; #BAUD_PERIOD;
        rx = 1'b0; #BAUD_PERIOD;
        rx = 1'b0; #BAUD_PERIOD;
        rx = 1'b0; #BAUD_PERIOD;
        rx = 1'b1; #BAUD_PERIOD;
        rx = 1'b0; #BAUD_PERIOD;
        rx = 1'b0; #BAUD_PERIOD;
        rx = 1'b1; #BAUD_PERIOD;
        rx = 1'b1; #BAUD_PERIOD;
    end

    wire byte_valid;
    wire [7:0] byte;
    uart_rx uart_rx(
        .clk_100M(clk),
        .rst(rst),
        .rx(rx),

        .byte_valid(byte_valid),
        .byte(byte)
    );
    
endmodule