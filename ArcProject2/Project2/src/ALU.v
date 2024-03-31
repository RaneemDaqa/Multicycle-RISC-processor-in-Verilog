/* ALU Arithmetic and Logic Operations
----------------------------------------------------------------------
|ALUop|   ALU Operation
----------------------------------------------------------------------
| 00  |   result = A and B;
----------------------------------------------------------------------
| 01  |   result = A + B;
----------------------------------------------------------------------
| 10  |   result = A - B;
----------------------------------------------------------------------*/
module ALU (
  input [31:0] A,			// ALU 32-bit Input A
  input [31:0] B,			// ALU 32-bit Input B
  input [1:0] ALUop,		// 2-bit ALU Selection
  output reg [31:0] result, // ALU 32-bit Output
  output reg carry, 		// Carry Out Flag
  output reg zero,	 		// Zero Flag
  output reg negative,		// Negative Flag
  output reg overflow		// Overflow Flag
);

always @(A or B or ALUop) begin
   case (ALUop)
      2'b00: begin // AND
         result = A & B;
      end

      2'b01: begin // ADD
         result = A + B;
         carry = A[31] & B[31] | A[31] & ~result[31] | ~result[31] & B[31]; // Carry out
         overflow = A[31] & B[31] & ~result[31] | ~A[31] & ~B[31] & result[31]; // Overflow for addition
      end

      2'b10: begin // SUB
         result = A - B;
         carry = B > A; // Borrow in subtraction is the carry here
         overflow = ~A[31] & B[31] & result[31] | A[31] & ~B[31] & ~result[31]; // Overflow for subtraction
      end

      default: begin
         result = 32'b0;
         carry = 1'b0;
         zero = 1'b0;
         negative = 1'b0;
         overflow = 1'b0;
      end
   endcase 
   zero = (result == 32'b0); // checks if the result is equal to zero
   negative = result[31]; // MSB as sign bit 
end
endmodule