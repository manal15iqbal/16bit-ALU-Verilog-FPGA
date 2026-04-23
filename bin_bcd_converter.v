module bin_bcd_converter (
    input  signed [31:0] bin,
    output reg           sign,
    output reg  [3:0]    bcd0,  // ones
    output reg  [3:0]    bcd1,  
    output reg  [3:0]    bcd2,  
    output reg  [3:0]    bcd3,  
    output reg  [3:0]    bcd4,  
    output reg  [3:0]    bcd5,  
    output reg  [3:0]    bcd6,  
    output reg  [3:0]    bcd7,  
    output reg  [3:0]    bcd8,  
    output reg  [3:0]    bcd9   // billions
);

integer i;
reg [31:0] abs_bin;
reg [71:0] shift_reg; // 32-bit binary + 10 BCD digits (40 bits)

always @(*) begin
    
    sign = bin[31];

    
    if (bin[31])
        abs_bin = (~bin) + 1'b1;
    else
        abs_bin = bin;

    // double dabble algorithm used to convert binary to bcd
    shift_reg = 72'd0;
    shift_reg[31:0] = abs_bin;

    for (i = 0; i < 32; i = i + 1) begin
        if (shift_reg[35:32] >= 5) shift_reg[35:32] =shift_reg[35:32]+ 3;
        if (shift_reg[39:36] >= 5) shift_reg[39:36] =shift_reg[39:36]+ 3;
        if (shift_reg[43:40] >= 5) shift_reg[43:40] =shift_reg[43:40]+ 3;
        if (shift_reg[47:44] >= 5) shift_reg[47:44] =shift_reg[47:44]+ 3;
        if (shift_reg[51:48] >= 5) shift_reg[51:48] =shift_reg[51:48]+ 3;
        if (shift_reg[55:52] >= 5) shift_reg[55:52] =shift_reg[55:52]+ 3;
        if (shift_reg[59:56] >= 5) shift_reg[59:56] =shift_reg[59:56]+ 3;
        if (shift_reg[63:60] >= 5) shift_reg[63:60] =shift_reg[63:60]+ 3;
        if (shift_reg[67:64] >= 5) shift_reg[67:64] =shift_reg[67:64]+ 3;
        if (shift_reg[71:68] >= 5) shift_reg[71:68] =shift_reg[71:68]+ 3;

        shift_reg = shift_reg << 1;
    end

    bcd0 = shift_reg[35:32];
    bcd1 = shift_reg[39:36];
    bcd2 = shift_reg[43:40];
    bcd3 = shift_reg[47:44];
    bcd4 = shift_reg[51:48];
    bcd5 = shift_reg[55:52];
    bcd6 = shift_reg[59:56];
    bcd7 = shift_reg[63:60];
    bcd8 = shift_reg[67:64];
    bcd9 = shift_reg[71:68];
end

endmodule
