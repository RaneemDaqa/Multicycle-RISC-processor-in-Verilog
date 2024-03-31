module mux2x1_testbench;

  // Signals
  reg selectionLine;
  reg [31:0] a, b;
  wire [31:0] result;

  // Instantiate the mux2x1 module
  mux2x1 uut (
    .selectionLine(selectionLine),
    .a(a),
    .b(b),
    .result(result)
  );

  // Initial block: Initialize testbench signals
  initial begin
    // Test case 1: selectionLine is 0
    selectionLine = 0;
    a = 32'h12345678;
    b = 32'h87654321;
    #10; // Wait for a while
    if (result !== a) 
		$display("Test case 1 failed");

    // Test case 2: selectionLine is 1
    selectionLine = 1;
    a = 32'h12345678;
    b = 32'h87654321;
    #10; // Wait for a while
    if (result !== b) 
		$display("Test case 2 failed");

    // Finish simulation
    $stop;
  end

endmodule
