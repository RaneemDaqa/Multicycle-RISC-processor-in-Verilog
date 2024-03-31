module cpu_testbench;

  reg clk;
  reg [31:0] inst_Din;
  
  // Instantiate the CPU module
  cpu dut (
    .clk(clk),
    .inst_Din(inst_Din)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test vector generation
  initial begin
    // Test case 1
    inst_Din = 32'b000000_1010_0101_1111_11110110010000; // Replace this with your instruction
    #450; // Wait for a clock cycle or two for the system to start processing
    $display("Test Case 1 Results:");
    $display("Current State: %b", dut.state);
    $display("Next State: %b", dut.next_state);
    $display("op_code: %b", dut.op_code);  
    $display("inst_rs1: %b", dut.inst_rs1);
    $display("inst_rs2: %b", dut.inst_rs2);
    $display("inst_rd: %b", dut.inst_rd);



    // Finish simulation after all test cases
    $stop;
  end

endmodule