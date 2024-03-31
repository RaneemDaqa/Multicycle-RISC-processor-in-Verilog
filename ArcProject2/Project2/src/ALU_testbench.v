`timescale 1ns/1ps

module ALU_testbench;

  reg [31:0] A, B;
  reg [1:0] ALUop;
  wire [31:0] result;
  wire carry, zero, negative, overflow;

  ALU uut (
    .A(A),
    .B(B),
    .ALUop(ALUop),
    .result(result),
    .carry(carry),
    .zero(zero),
    .negative(negative),
    .overflow(overflow)
  );

  // Clock generation
  reg clk = 0;
  always #5 clk = ~clk;

  initial begin 
	  forever begin 
         #3 A <= $urandom_range(0,255); 
         #6 B <= $urandom_range(0,255); 
         #12 ALUop <= $urandom_range(0,2) ; 
		 
		 $display("Test Case:");
    	 $display("A = %h", A);
    	 $display("B = %h", B);
    	 $display("ALUop = %b", ALUop);
    	 $display("Result = %h", result);
    	 $display("Borrow = %b", carry);
   		 $display("Zero = %b", zero);
    	 $display("Negative = %b", negative);
    	 $display("Overflow = %b", overflow); 
		 $display("--------------------------");
      end 
   end 

  initial begin
    #1000;
    $finish ;
  end

endmodule
