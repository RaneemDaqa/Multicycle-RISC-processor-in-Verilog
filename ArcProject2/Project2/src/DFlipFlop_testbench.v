`timescale 1ns / 1ps

module dFlipFlop_testbench;

    // Parameters
    parameter WIDTH = 32;

    // Inputs
    reg [WIDTH-1:0] data_input;
    reg clock;

    // Outputs
    wire [WIDTH-1:0] data_output;

    // Instantiate the Unit Under Test (UUT)
    dFlipFlop #(.WIDTH(WIDTH)) uut (
        .data_input(data_input), 
        .clock(clock), 
        .data_output(data_output)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #10 clock = ~clock; // Clock with period of 20ns
    end

    // Test case generation
    initial begin
        // Initialize Inputs
        data_input = 0;

        // Wait for global reset
        #100;

        // Apply random inputs
        forever begin
            #20 data_input = $random; // Change input every 20ns
        end
    end

    // Monitor changes and display them
    initial begin
        $monitor("Time = %t, Input = %b, Output = %b", $time, data_input, data_output);
    end

    // End simulation after a certain time
    initial begin
        #1000 $finish; // Stop simulation after 1000ns
    end

endmodule