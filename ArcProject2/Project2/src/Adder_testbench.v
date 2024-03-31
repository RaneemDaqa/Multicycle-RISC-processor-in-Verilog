`timescale 1ns / 1ps

module adder_32bit_tb;

    // Test Inputs
    reg [31:0] input1;
    reg [31:0] input2;

    // Output
    wire [31:0] adder_output;

    // Instantiate the Unit Under Test (UUT)
    adder_32bit uut (
        .input1(input1), 
        .input2(input2), 
        .adder_output(adder_output)
    );

    integer i;

    initial begin
        // Initialize Inputs
        input1 = 0;
        input2 = 0;

        // Wait for 100 ns for global reset to finish
        #100;

        // Add stimulus here
        for (i = 0; i < 4; i = i + 1) begin
            input1 = $random;
            input2 = $random;
            #10; // Wait 10 ns between input changes

            // Display the inputs and output
            $display("Time: %d, Input1: %d, Input2: %d, Output: %d", 
                     $time, input1, input2, adder_output);
        end

        // Optional: Finish the simulation
        #10 $finish;
    end
      
endmodule