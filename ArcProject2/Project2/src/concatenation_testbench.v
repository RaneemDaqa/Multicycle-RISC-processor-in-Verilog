module concatenation_testbench;

  // Parameters
  parameter DELAY = 1;

  // Signals
  reg [31:0] PC;
  reg [25:0] Immediate26;
  wire [31:0] ConcatenatedResult;

  // Instantiate the module
  concatenation uut (
    .PC(PC),
    .Immediate26(Immediate26),
    .ConcatenatedResult(ConcatenatedResult)
  );

  // Initial block for testbench stimulus
  initial begin
    // Test case 1
    PC = 32'hAABBCCDD;
    Immediate26 = 26'h123456;

    // Display input values
    $display("Test Case 1:");
    $display("PC = 0x%h", PC);
    $display("Immediate26 = 0x%h", Immediate26);

    // Wait for some time
    #DELAY;

    // Display output value
    $display("ConcatenatedResult = 0x%h", ConcatenatedResult);

    // Test case 2
    PC = 32'h11223344;
    Immediate26 = 26'hABCDEF;

    // Display input values
    $display("Test Case 2:");
    $display("PC = 0x%h", PC);
    $display("Immediate26 = 0x%h", Immediate26);

    // Wait for some time
    #DELAY;

    // Display output value
    $display("ConcatenatedResult = 0x%h", ConcatenatedResult);

    // Add more test cases as needed

    // Stop simulation
    $stop;
  end

endmodule