module dFlipFlop #(parameter WIDTH = 32)(
    input [WIDTH-1:0] data_input,
    input clock,
    output reg [WIDTH-1:0] data_output
);

    always @ (*) begin
        data_output <= data_input;
    end

endmodule