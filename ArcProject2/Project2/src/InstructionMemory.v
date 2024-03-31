module InstructionMemory(
    input [31:0] address, // Input address from the processor (word-addressed)
    output reg [31:0] instruction // Output instruction at the given address
);

	// Define the word size
  	parameter WORD_SIZE = 32;

  	// Define the size of the instruction memory in words
  	parameter MEMORY_SIZE = 1024;

  	// Declare the instruction memory as an array of words
  	reg [WORD_SIZE-1:0] memory [0:MEMORY_SIZE-1];

    // Initialize the memory with the instructions
    initial begin 	
        for (int i = 0; i < 1024; i ++) begin
            memory[i] = 32'h00000000;
        end
		
        memory[0] = 32'b000011_0000_0000_0000000000000000_00; // ANDI $t0, $t0, 0 
		
        memory[4] = 32'b000101_0001_0000_0000000000000000_00; // LW $t1, 0($t0)
		
        memory[8] = 32'b000101_0010_0000_0000000000000100_00; // LW $t2, 4($t0)
		
        memory[12] = 32'b000011_0011_0011_0000000000000000_00; // ANDI $t3, $t3, 0
		
        memory[16] = 32'b001010_0001_0000_0000000000001100_00; // BEQ $t1, $t0, Label_1  
		
        memory[20] = 32'b001111_0001_0000000000000000000000; // PUSH $t1	
		
        memory[24] = 32'b001011_0011_0010_0000000000001000_00; // BNE $t3, $t2, Label_2
		
        memory[28] = 32'b000010_0001_0001_0010_00000000000000; // Label_1: SUB $t1, $t1, $t2
		
        memory[32] = 32'b010000_0001_1111111111111001111111; // Label_2: POP $t4 
		
        memory[36] = 32'b001001_0010_0001_0000000000001100_00; // BLT $t2, $t1, Label_3 
		
        memory[40] = 32'b000111_0100_0000_0000000000001000_00; // SW $t4, 8($t0)
		
		memory[44] = 32'b001100_00000000000000000000101100; // End: JMP End
	
		memory[48] = 32'b000000_0011_0001_0010_00000000000000; // Label_3: AND $t3, $t1, $t2
    end		  
	
    // Fetch instruction based on address
    always @(address) begin
		// Check if the address is word-aligned
    	if (address % (WORD_SIZE/8) == 0) begin
      		// Read the instruction from memory
      		instruction <= memory[address]; // Word-aligned address
    	end else begin
			instruction <= 32'h00000000;
    	end	 
    end
endmodule