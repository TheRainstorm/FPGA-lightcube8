module test_pmod_top (
    //switch
    input wire [15:0] switch,

    //led
    output wire [15:0] led,

    //pmod
    output wire [7:0] Ja,
    output wire [7:0] Jb,
    output wire [7:0] Jc,
    output wire [7:0] Jd
);

    assign led = switch;

    assign Ja = 8'h80;
    assign Jb = switch[15:8];
    assign Jc = 8'b0;
    assign Jd = switch[7 :0];
    
endmodule