module lightcube8_top_wrap (
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

    //pmod
    output wire [7:0] Ja,
    output wire [7:0] Jb,
    output wire [7:0] Jd
);

    wire [7:0] high_csn ;  
    wire [7:0] row      ;
    wire [7:0] row_cs   ;
    lightcube8_top lightcube8_top(
        .clk(clk),
        .resetn(resetn),
        .switch(switch),
        .rx(rx),

        .tx(tx),
        .led(led),
        .num_csn(num_csn),
        .num_a_g(num_a_g),
        .high_csn(high_csn),
        .row(row),
        .row_cs(row_cs)
    );

    assign Jb = row;    //数据线
    assign Jd = row_cs; //使能线
    assign Ja = ~high_csn;    //层选        //所用芯片取了反

endmodule