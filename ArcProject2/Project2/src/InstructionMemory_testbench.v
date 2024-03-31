
`timescale 1ns / 1ns

module InstructionMemory_testbench;

  // Inputs
  reg [31:0] address;

  // Outputs
  reg [31:0] instruction;

  // Clock generation
  reg clk;

  // Instantiate the module
  InstructionMemory IM (
    .address(address),
    .instruction(instruction)
  );

  // Clock generation process
  always begin
    #5 clk = ~clk;
  end

  // Initial block for testbench setup
  initial begin
    // Initialize inputs
    address = 0;
    clk = 0;

    // Display header
    $display("Time\tAddress\tInstruction");

    // Run simulation for multiple addresses
    // You can add more test cases as needed
    repeat (10) begin
      #5; // Wait for a few time units
      $display("%0t\t%h\t%h", $time, address, instruction);	  
	  address = address + 4; // Increment address by 4 for the next test
    end

    // End simulation
    $stop;
  end

endmodule