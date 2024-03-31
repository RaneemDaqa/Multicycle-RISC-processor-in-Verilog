module PC(clk, state, PC_input, PC_output);	 
	input wire clk;
	input wire [31:0] PC_input;
	input [2:0]state;
	output reg [31:0] PC_output;
 
    initial begin 
     PC_output = 0; 
   end 
 
    always @(posedge clk ) begin
      if (state == 3'b000) 
        // output equals input
        PC_output<= PC_input; 
    end
  endmodule