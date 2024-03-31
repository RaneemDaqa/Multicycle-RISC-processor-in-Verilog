`timescale 1ns / 1ps

module data_memory_with_stack_tb;

    reg clk;
    reg mem_write;
    reg mem_read;
    reg dataMemEnable;
    reg [31:0] address;
    reg [31:0] data_in;
    wire [31:0] data_out;

    // Instantiate the Unit Under Test (UUT)
    data_memory_with_stack uut (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .dataMemEnable(dataMemEnable),
        .address(address),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Toggle clock every 10 ns
    end

    // Test case generation
    initial begin
        // Initialize Inputs
        mem_write = 0;
        mem_read = 0;
        dataMemEnable = 0;
        address = 0;
        data_in = 0;

        // Wait for global reset
        #100;

        // Test 1: Write to memory
        mem_write = 1;
        mem_read = 0;
        dataMemEnable = 1; // Enable static memory
        address = $random % 256;
        data_in = $random;
        #20;
        $display("Time: %t,Write to Memory-Address:%d, Data In:%d",$time, address, data_in);

        // Test 2: Read from memory
        mem_write = 0;
        mem_read = 1;
        #20;
        $display("Time:%t,Read from Memory-Address:%d, Data Out:%d", $time, address, data_out);

        // Test 3: Push to stack
        mem_write = 1;
        mem_read = 0;
        dataMemEnable = 0; // Enable stack operation
        data_in = $random;
        #20;
        $display("Time:%t,Push to Stack-Data In:%d", $time, data_in);

        // Test 4: Pop from stack
        mem_write = 0;
        mem_read = 1;
        #20;
        $display("Time: %t,Pop from Stack-Data Out:%d", $time, data_out);

        // Add more tests as needed for edge cases (e.g., stack overflow, stack underflow)

        // Finish simulation
        #1000;
        $finish;
    end

endmodule