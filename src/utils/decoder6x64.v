module decoder6x64 (
    input wire [5 : 0] x,

    output wire [63 : 0] y
);
    wire [15: 0] y1;
    wire [31: 0] y2;
    decoder4x16 d1 (
        .x(x[3:0]),
        .y(y1)
    );

    assign y2 = x[4] ? {y1, 16'b0} : {16'b0, y1};
    assign y = x[5] ? {y2, 32'b0} : {32'b0, y2};
endmodule