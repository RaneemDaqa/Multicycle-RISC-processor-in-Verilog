`timescale 1ns / 1ps

module PC_testbench;

  reg clk;
  reg [31:0] PC_input;
  reg [2:0] state;
  wire [31:0] PC_output;

  // Instantiate the Unit Under Test (UUT)
  PC uut (
    .clk(clk), 
    .state(state), 
    .PC_input(PC_input), 
    .PC_output(PC_output)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #10 clk = ~clk;  // Toggle clock every 10 ns
  end
    initial begin

  #20; 
 state = $random % 8; // Set state to 0
 PC_input = $random; // Generate a random 32-bit number

 #20; 
 state = $random % 8; // Set state to 0
 PC_input = $random; // Generate a random 32-bit number

 #20; 
 state = 0; // Set state to 0
 PC_input = $random; // Generate a random 32-bit number

  #20; 
  state = 0; // Set state to 0
  PC_input = $random; // Generate a random 32-bit number
$finish;
		end
  // Monitor changes
  initial begin
    $monitor("Time = %d, clk = %b, state = %b, PC_input = %d, PC_output = %d", 
             $time, clk, state, PC_input, PC_output);
  end

endmodule