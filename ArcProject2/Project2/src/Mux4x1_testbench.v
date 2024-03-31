`timescale 1ns/1ns

module mux4x1_testbench;

  // Inputs
  reg [1:0] selectionLine;
  reg [31:0] a, b, c, d;

  // Outputs
  wire [31:0] result;

  // Instantiate the mux4x1 module
  mux4x1 uut (
    .selectionLine(selectionLine),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .result(result)
  );

  // Initial block for test stimulus
  initial begin
    // Test Case 1
    selectionLine = 2'b00;
    a = 32'h12345678;
    b = 32'h87654321;
    c = 32'hABCDEFAB;
    d = 32'hFEDCBAFE;

    #10; // Wait for 10 time units

    // Check the result
    if (result !== a) $display("Test Case 1 Failed! Expected: %h, Got: %h", a, result);
    else $display("Test Case 1 Passed!");

    // Test Case 2
    selectionLine = 2'b01;
    a = 32'h12345678;
    b = 32'h87654321;
    c = 32'hABCDEFAB;
    d = 32'hFEDCBAFE;

    #10; // Wait for 10 time units

    // Check the result
    if (result !== b) $display("Test Case 2 Failed! Expected: %h, Got: %h", b, result);
    else $display("Test Case 2 Passed!");

    // Test Case 3
    selectionLine = 2'b10;
    a = 32'h12345678;
    b = 32'h87654321;
    c = 32'hABCDEFAB;
    d = 32'hFEDCBAFE;

    #10; // Wait for 10 time units

    // Check the result
    if (result !== b) $display("Test Case 3 Failed! Expected: %h, Got: %h", b, result);
    else $display("Test Case 3 Passed!");
		
	// Test Case 4
    selectionLine = 2'b11;
    a = 32'h12345678;
    b = 32'h87654321;
    c = 32'hABCDEFAB;
    d = 32'hFEDCBAFE;

    #10; // Wait for 10 time units

    // Check the result
    if (result !== b) $display("Test Case 4 Failed! Expected: %h, Got: %h", b, result);
    else $display("Test Case 4 Passed!");

    // Finish simulation
    $finish;
  end

endmodule
