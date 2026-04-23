module td_mux #(
    parameter CLK_FREQ   = 50_000_000,  // FPGA clock (Hz)
    parameter REFRESH_HZ = 200,          // total refresh rate
    parameter HOLD_SEC   =  3            // seconds per page
)(
    input  wire        clk,
    input  wire        rst,

    input  wire        sign,
    input  wire [3:0]  bcd0,
    input  wire [3:0]  bcd1,
    input  wire [3:0]  bcd2,
    input  wire [3:0]  bcd3,
    input  wire [3:0]  bcd4,
    input  wire [3:0]  bcd5,
    input  wire [3:0]  bcd6,
    input  wire [3:0]  bcd7,
    input  wire [3:0]  bcd8,
    input  wire [3:0]  bcd9,

    output reg  [3:0]  bcd_out,
    output wire        sign_led,
    output reg  [4:0]  en            
);

    assign sign_led = sign;

    // Page timer (3 seconds)
    localparam integer PAGE_CNT_MAX = CLK_FREQ * HOLD_SEC;
    reg [$clog2(PAGE_CNT_MAX)-1:0] page_cnt;
    reg page_sel;  // Page 0 = bcd[4:0], Page 1 = bcd[9:5]

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            page_cnt <= 0;
            page_sel <= 1'b1;  
        end else begin
            if (page_cnt == PAGE_CNT_MAX - 1) begin
                page_cnt <= 0;
                page_sel <= ~page_sel;
            end else begin
                page_cnt <= page_cnt + 1;
            end
        end
    end

    // Digit refresh clock
    localparam integer DIVIDER = CLK_FREQ / (REFRESH_HZ * 5);
    reg [$clog2(DIVIDER)-1:0] div_cnt;
    reg [2:0] digit_sel;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            div_cnt   <= 0;
            digit_sel <= 0;
        end else begin
            if (div_cnt == DIVIDER - 1) begin
                div_cnt   <= 0;
                digit_sel <= digit_sel + 1;
            end else begin
                div_cnt <= div_cnt + 1;
            end
        end
    end

    // Digit multiplexing and page select
    always @(*) begin
        en       = 5'b00000;
        bcd_out = 4'd0;

        case (digit_sel)
            3'd0: begin
                en = 5'b00001;
                bcd_out = page_sel ? bcd5 : bcd0;
            end
            3'd1: begin
                en = 5'b00010;
                bcd_out = page_sel ? bcd6 : bcd1;
            end
            3'd2: begin
                en = 5'b00100;
                bcd_out = page_sel ? bcd7 : bcd2;
            end
            3'd3: begin
                en = 5'b01000;
                bcd_out = page_sel ? bcd8 : bcd3;
            end
            3'd4: begin
                en = 5'b10000;
                bcd_out = page_sel ? bcd9 : bcd4;
            end
            default: ;
        endcase
    end

endmodule
