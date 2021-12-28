module seg7 (
    input wire clk,
    input wire rst,
    input wire [31: 0] num_data,
    
    output reg [7 :0] num_csn,
    output reg [6 :0] num_a_g
);

    reg [19:0] count;
    always @(posedge clk)
    begin
        if(rst)
        begin
            count <= 20'd0;
        end
        else
        begin
            count <= count + 1'b1;
        end
    end
    //scan data
    reg [3:0] scan_data;
    always @ ( posedge clk )  
    begin
        if ( rst )
        begin
            scan_data <= 4'd0;  
            num_csn   <= 8'b1111_1111;
        end
        else
        begin
            case(count[19:17])
                3'b000 : scan_data <= num_data[31:28];
                3'b001 : scan_data <= num_data[27:24];
                3'b010 : scan_data <= num_data[23:20];
                3'b011 : scan_data <= num_data[19:16];
                3'b100 : scan_data <= num_data[15:12];
                3'b101 : scan_data <= num_data[11: 8];
                3'b110 : scan_data <= num_data[7 : 4];
                3'b111 : scan_data <= num_data[3 : 0];
            endcase

            case(count[19:17])
                3'b000 : num_csn <= 8'b0111_1111;
                3'b001 : num_csn <= 8'b1011_1111;
                3'b010 : num_csn <= 8'b1101_1111;
                3'b011 : num_csn <= 8'b1110_1111;
                3'b100 : num_csn <= 8'b1111_0111;
                3'b101 : num_csn <= 8'b1111_1011;
                3'b110 : num_csn <= 8'b1111_1101;
                3'b111 : num_csn <= 8'b1111_1110;
            endcase
        end
    end

    always @(posedge clk)
    begin
        if ( rst )
        begin
            num_a_g <= 7'b0000000;
        end
        else
        begin
            case ( scan_data )
                4'd0 : num_a_g <= 7'b0000001;   //0
                4'd1 : num_a_g <= 7'b1001111;   //1
                4'd2 : num_a_g <= 7'b0010010;  //2
                4'd3 : num_a_g <= 7'b0000110;  //3
                4'd4 : num_a_g <= 7'b1001100;  //4
                4'd5 : num_a_g <= 7'b0100100;  //5
                4'd6 : num_a_g <= 7'b0100000;  //6
                4'd7 : num_a_g <= 7'b0001111;  //7
                4'd8 : num_a_g <= 7'b0000000; //8
                4'd9 : num_a_g <= 7'b0000100;  //9
                4'd10: num_a_g <= 7'b0001000;  //a
                4'd11: num_a_g <= 7'b1100000;  //b
                4'd12: num_a_g <= 7'b0110001;  //c
                4'd13: num_a_g <= 7'b1000010;  //d
                4'd14: num_a_g <= 7'b0110000;  //e
                4'd15: num_a_g <= 7'b0111000;  //f
                // 4'd0 : num_a_g <= 7'b1111110;   //0
                // 4'd1 : num_a_g <= 7'b0110000;   //1
                // 4'd2 : num_a_g <= 7'b1101101;   //2
                // 4'd3 : num_a_g <= 7'b1111001;   //3
                // 4'd4 : num_a_g <= 7'b0110011;   //4
                // 4'd5 : num_a_g <= 7'b1011011;   //5
                // 4'd6 : num_a_g <= 7'b1011111;   //6
                // 4'd7 : num_a_g <= 7'b1110000;   //7
                // 4'd8 : num_a_g <= 7'b1111111;   //8
                // 4'd9 : num_a_g <= 7'b1111011;   //9
                // 4'd10: num_a_g <= 7'b1110111;   //a
                // 4'd11: num_a_g <= 7'b0011111;   //b
                // 4'd12: num_a_g <= 7'b1001110;   //c
                // 4'd13: num_a_g <= 7'b0111101;   //d
                // 4'd14: num_a_g <= 7'b1001111;   //e
                // 4'd15: num_a_g <= 7'b1000111;   //f
            endcase
        end
    end
endmodule