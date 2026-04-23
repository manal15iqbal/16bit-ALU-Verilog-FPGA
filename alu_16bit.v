module alu_16bit (
    input  signed [15:0] a,
    input  signed [15:0] b,
    input  [3:0]         opcode,
    output reg signed [31:0] result,
    output reg           zero
);

always @(*) begin
    case (opcode)

        // Arithmetic
        4'b0000: result = a + b;           // Addition
        4'b0001: result = a - b;           // Subtraction
        4'b0010: result = a * b;           // Multiplication

        // Logical
        4'b0011: result = a & b;           // AND
        4'b0100: result = a | b;           // OR
        4'b0101: result = ~(a & b);        // NAND
        4'b0110: result = ~(a | b);        // NOR
        4'b0111: result = a ^ b;           // XOR
        4'b1000: result = ~(a ^ b);        // XNOR

        // Shifts (shift amount = b[3:0])
        4'b1001: result = a << b[3:0];     // Logical shift left
        4'b1010: result = a >> b[3:0];     // Logical shift right
        4'b1011: result = a >>> b[3:0];    // Arithmetic shift right
        4'b1100: result = a <<< b[3:0];    // Arithmetic shift left

        // Unary
        4'b1101: result = a + 1;           // Increment
        4'b1110: result = a - 1;           // Decrement

        // Comparison
        4'b1111: begin
            if (a > b)
                result = 32'sd1;    //+1
            else if (a < b)
                result = -32'sd1;   //-1
            else
                result = 32'sd0;    //0
        end

        default: result = 32'sd0;
    endcase

    zero = (result == 0);
end

endmodule
