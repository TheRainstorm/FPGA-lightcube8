module lightcube8_test_display (
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
    wire rst;
    assign rst = ~resetn;

    wire [7:0] high_cs  ;  
    wire [7:0] row      ;
    wire [7:0] row_cs   ;

    assign Jb = row;    //数据线
    assign Jd = row_cs; //使能线
    assign Ja = high_cs;    //层选


    assign led = switch;

    //seg7
    assign num_csn = 8'b1111_1111;
    assign num_a_g = 7'b1111111;

    wire [1:0] sel;
    assign sel = switch[15:14];

    wire [8*64-1: 0] frame_cube_flat;

    assign frame_cube_flat = (sel==2'b01) ? 256'hff_fe_fc_f8_f0_e0_c0_80_00_ff_fe_fc_f8_f0_e0_c0_80_00_ff_fe_fc_f8_f0_e0_c0_80_00_ff_fe_fc_f8_f0_e0_c0_80_00_ff_fe_fc_f8_f0_e0_c0_80_00_ff_fe_fc_f8_f0_e0_c0_80_00_ff_fe_fc_f8_f0_e0_c0_80_00_ff : 
                                            256'hff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff_ff;
    
    wire [7:0] high_csn;
    assign high_cs = ~high_csn;
    Display Display(
        .clk(clk),
        .rst(rst),
        .frame_cube_flat(frame_cube_flat),

        .high_csn(high_csn),
        .row(row),
        .row_cs(row_cs)
    );

endmodule