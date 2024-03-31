module IR(clk, inst, op_code, inst_rs1, inst_rs2, inst_rd, imm_16, jump_offset, Mode); 
    input clk ; 
    input [31:0] inst; 
	output reg [5:0] op_code; 
	output reg [3:0] inst_rs1 , inst_rs2 , inst_rd;
	output reg [15:0] imm_16; 
	output reg [25:0] jump_offset;
	output reg [1:0] Mode; 	 
	
  always @(posedge clk)
	begin 				 	
		op_code = inst[31:26];	
		
		// R-type: AND, ADD, and SUB
		if (op_code == 6'b000000 || op_code == 6'b000001 || op_code == 6'b000010)begin 
			inst_rd = inst[25:22]; 
			inst_rs1 = inst[21:18]; 
			inst_rs2 = inst[17:14]; 
		end 
		// I-type
		else if (op_code == 6'b000011 || op_code == 6'b000100 || op_code == 6'b000101 || op_code == 6'b000110
		|| op_code == 6'b000111 || op_code == 6'b001000 || op_code == 6'b001001 || op_code == 6'b001010 || op_code == 6'b001011 )begin 
			inst_rd = inst[25:22]; 
			inst_rs1 = inst[21:18]; 
			imm_16 = inst[17:2];	
			Mode = inst[1:0];	

		end 
		// J-type: JMP & CALL
		else if (op_code == 6'b001100 || op_code == 6'b001101)begin  
			jump_offset = inst[25:0];

		end 	
		// S-type: PUSH & POP
		else if (op_code == 6'b001111 || op_code == 6'b010000)begin 
			inst_rd = inst[25:22]; 	

		end 
	    else begin 
		   	// J-type: RET "26-bit unused" 
		end
	end	
endmodule