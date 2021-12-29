`timescale 1ns/1ps

module tb_lightcube8_top;
    reg clk;
    reg rst;

    //clock generating
    real         CYCLE_100MHz = 10;
    always begin
        clk = 0 ; #(CYCLE_100MHz/2) ;
        clk = 1 ; #(CYCLE_100MHz/2) ;
    end

    wire resetn;
    assign resetn = ~rst;
    //reset generating
    initial begin
        rst      = 1'b0;
        #8 rst = 1'b1;
        #2000 rst = 1'b0;
    end

    real         BAUD_PERIOD = 8680;
    real         IDLE_PERIOD = 8680*10;
    real         FPS_PERIOD = 8680*20;
    reg rx;
    reg [15: 0] switch;

    // initial begin
    //     rx = 1'b1;
    //     switch = 16'b0;
        
    //     switch[0] = 1'b0;   //default mode
    // end

    integer i, j, k;
    reg [7: 0] data;
    initial begin
        rx = 1'b1;
        switch = 16'b0;

        switch[15:14] = 2'b00;   //default mode
        #3000
        switch[15:14] = 2'b11;   //uart mode

        for(i = 0; i<10; i = i + 1) begin   //10 frames
            for(j =0; j<64; j = j + 1) begin    //64 bytes
                data = i[7:0] ^ j[7:0];
                rx = 1'b0; #BAUD_PERIOD;
                rx = data[0]; #BAUD_PERIOD;
                rx = data[1]; #BAUD_PERIOD;
                rx = data[2]; #BAUD_PERIOD;
                rx = data[3]; #BAUD_PERIOD;
                rx = data[4]; #BAUD_PERIOD;
                rx = data[5]; #BAUD_PERIOD;
                rx = data[6]; #BAUD_PERIOD;
                rx = data[7]; #BAUD_PERIOD;
                rx = data[0]; #BAUD_PERIOD;
                rx = 1'b1; #BAUD_PERIOD;

                #IDLE_PERIOD;
            end
            
            #FPS_PERIOD;
        end
    end

    wire tx;
    wire [7:0] high_csn;
    wire [7:0] row     ;
    wire [7:0] row_cs  ;

    lightcube8_top #(.FRAME_GEN_CLK_DIV(14), .SCAN_CLK_DIV(14)) lightcube8_top(
        .clk(clk),
        .resetn(resetn),
        .switch(switch),
        .rx(rx),

        .tx(tx),
        .high_csn(high_csn),
        .row(row),
        .row_cs(row_cs)
    );
    
endmodule