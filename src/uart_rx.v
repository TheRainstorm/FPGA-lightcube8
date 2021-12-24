//串口参数：
//  波特率：115200
//  数据位：8
//  停止位：1

//串口波特率设置为115200，输入为100MHz的时钟，分频数为868
//过程
//1. 检测rx下降沿，开始计数

module uart_rx (
    input wire clk_100M,
    input wire rst,
    input wire rx,

    output wire byte_valid,
    output reg [7:0] byte
);
    wire clk;
    assign clk = clk_100M;

    /**
     * 检测rx下降沿
     */
    reg rx_delay;
    always @(posedge clk) begin
        rx_delay <= rst ? 1 : rx;
    end
    wire rx_neg_edge;
    assign rx_neg_edge = ~rx & rx_delay;    //rx下降沿

    reg rx_en;  //使能baud_gen，从检测到下降沿开始，到接收数据结束，期间保持1
    always @(posedge clk) begin
        if(rst) begin
            rx_en <= 0;
        end
        else begin
            case(rx_en)
                0: rx_en <= rx_neg_edge ? 1 : 0;
                1: rx_en <= byte_valid  ? 0 : 1;
            endcase
        end
    end

    /**
     *生成rx采样信号rx_valid
     */
    wire rx_valid;
    baud_gen baud_gen(
        .clk_100M(clk),
        .rst(rst),
        .rx_en(rx_en),

        .rx_valid(rx_valid)
    );

    reg [3: 0] rx_cnt;
    always @(posedge clk) begin
        rx_cnt <= rst | byte_valid  ? 0 :
                  rx_valid          ? rx_cnt + 1 : rx_cnt;
    end

    wire flag_data;
    assign flag_data = rx_cnt!=0 && rx_cnt!=9;

    always @(posedge clk) begin
        if(rst) begin
            byte <= 8'b0;
        end 
        else if(rx_valid & flag_data) begin
            byte <= {rx, byte[7:1]};
        end
    end

    assign byte_valid = rx_valid && (rx_cnt==9);
endmodule

/**
 * 在rx_en时，生成rx采样信号
 */
module baud_gen (
    input wire clk_100M,
    input wire rst,
    input wire rx_en,

    output wire rx_valid
);
    parameter BAUD_DIV = 868;

    reg [9: 0] counter;         //计数器对clk_100M分频
    reg flag_start_bit;         //标记开始位，过半个BAUD_DIV生成采样信号，之后每BAUD_DIV生成采样信号
    always @(posedge clk_100M) begin
        if(rx_en) begin
            if(sample1) begin
                counter <= 0;
                flag_start_bit <= 0;
            end
            else if(sample2) begin
                counter <= 0;
            end
            else begin
                counter <= counter + 1;
            end
        end
        else begin
            counter <= 0;
            flag_start_bit <= 1;
        end
    end
    wire sample1 = flag_start_bit && counter == (BAUD_DIV>>1);
    wire sample2 = counter == BAUD_DIV;

    assign rx_valid = sample1 | sample2;
endmodule