module mux4x1 (	  
  input wire [1:0] selectionLine, // selection line -> 2 bit
      input wire [31:0] a,
      input wire [31:0] b,
      input wire [31:0] c,
  	  input wire [31:0] d,
  output reg [31:0] result
    );
    
  always @*
        begin
            case(selectionLine)
            2'b00 : result = a;
            2'b01 : result = b;
            2'b10 : result = c; 
            2'b11 : result = d;  
            endcase
        end
    endmodule