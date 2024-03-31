module concatenation(
  // Module ports and parameters
  input [31:0] PC,
  input [25:0] Immediate26,
  output [31:0] ConcatenatedResult
);
  
  assign ConcatenatedResult = {PC[31:26], Immediate26};

endmodule 