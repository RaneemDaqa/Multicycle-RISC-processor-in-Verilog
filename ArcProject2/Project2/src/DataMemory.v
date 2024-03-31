module data_memory_with_stack (
    input wire clk,
    input wire mem_write,
    input wire mem_read,
    input wire dataMemEnable,       // Push to stack
    input wire [31:0] address,      // Address for memory operations
    input wire [31:0] data_in,      // Data to write to memory or push to stack
    output reg [31:0] data_out      // Data read from memory or stack
);

    parameter DATA_MEM_SIZE = 256;
    parameter STACK_START = 200;     // Define start address of stack in memory
    parameter STACK_SIZE = 56;       // Define size of the stack

    reg [31:0] memory [0:DATA_MEM_SIZE-1];
    reg [31:0] sp = STACK_START; 
	
	
	initial	begin
    // save 0x0002 at address = 0
      memory[0] = 'h02;
	
	// save 0x0001 at address = 4
      memory[4] = 'h01; 
	
	// save 0x0000 at address = 8
      memory[8] = 'h00; 
	end


    always @(posedge clk) begin
        // Handle data memory operations 
        if (mem_write == 1 && mem_read == 0 && sp < STACK_START + STACK_SIZE && dataMemEnable == 0) begin
            // Push case: The stack has available location (not full), and we want to push into the stack
            memory[sp] <= data_in;
            sp = sp + 4;
        end

        else if (mem_write == 0 && mem_read == 1 && sp > STACK_START && dataMemEnable == 0) begin
            // Pop case: The stack is not empty, and we want to pop from the stack
            sp = sp - 4;
            data_out <= memory[sp];
        end

        else if (mem_write == 1 && mem_read == 0 && dataMemEnable == 1) begin
            // Store into the static memory
            memory[address[31:2]] <= data_in;    // Shift left by 2 (division by 4) for word-addressable memory
        end

        else if (mem_write == 0 && mem_read == 1 && dataMemEnable == 1) begin
            // Load from the static memory
            data_out <= memory[address[31:2]];   // Shift left by 2 (division by 4) for word-addressable memory
        end
    end

endmodule

