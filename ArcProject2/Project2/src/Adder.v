module adder_32bit (
    input  [31:0] input1,  // Input from the extender
    input  [31:0] input2,       // Input from the PC
    output [31:0] adder_output  // Output to the mux
);

    // Assuming a ripple-carry adder for this example
    wire [31:0] sum;
    assign sum = input1 + input2;

    assign adder_output = sum;  // Pass the sum as the branch target address

endmodule