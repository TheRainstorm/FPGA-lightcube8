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

    assign Ja = switch[15:8];
    assign Jb = 16'hffff;
    assign Jc = 16'b0;
    assign Jd = switch[7 :0];
    
endmodule