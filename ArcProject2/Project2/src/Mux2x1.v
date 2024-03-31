module mux2x1 (	  
  input wire selectionLine, // selection line -> 1 bit
  input wire [31:0] a,
  input wire [31:0] b,
  output reg [31:0] result
);

  always @* begin
    if (selectionLine == 1'b0)
      result <= a;
    else
      result <= b;
  end

endmodule