module cpu( clk , inst_Din); 
  
  	input clk ;
    input [31:0] inst_Din ;
  
	parameter IF_STAGE = 3'b000;
	parameter ID_STAGE = 3'b001;
	parameter EX_STAGE = 3'b010;
	parameter MEM_STAGE = 3'b011;
	parameter WB_STAGE = 3'b100;

  
   //PC
  reg [31:0] pc_next_out , pc_next_in ;
  reg [31:0] pc_J_out , pc_J_in; 	
  reg [31:0] pc_BTA_out , pc_BTA_in;
  reg [31:0] pc_stack_in , pc_stack_out ; 
  reg [1:0] PCsrc; 
  reg [31:0]pc_in , pc_out; 
  
 
  //Instruction memory
  reg [31:0] inst_mem_out;   
  
  
  //IR
  reg [5:0] op_code; 
  reg [3:0] inst_rs1 , inst_rs2 , inst_rd;	 
  reg [15:0] imm_16;  
  reg [25:0] J_offset;
  reg [1:0] mode;
 
  
  //extender
  reg [31:0] ext_reg_in , ext_reg_out ; 
  reg EX_OP;
  
  
  //Mux of register file
  reg [3:0] mux_src_rf_out;
  reg RS2src;
  
  
  //register file
  reg [31:0] BusA_in, BusA_out;
  reg [31:0] BusB_in, BusB_out;
  reg [31:0] BusW,BusW1;
  reg RegRw,Rs1Rw;	   
  
  
  //Mux of ALU 
  reg ALUSrc;
  reg [31:0] mux_src_ALU_out;
  
  
  //ALU
  reg [31:0] ALU_res_in, ALU_res_out;	 
  reg [3:0] ALU_flags_in, ALU_flags_out; // 0:carry  1:zero  2:negative  3:overflow	
  reg [1:0] ALUop;
  
  
  //Mux of Data Memory
  reg DataInputSrc;
  reg [32-1:0] mux_DataInputSrc_out;
  
  
  //Data Memory
  reg [31:0] D_mem_reg_in, D_mem_reg_out;  
  reg MemR, MemW,DataMemEn;	
  
  
  //Mux of WBdata
  reg WBdata;	 
  
  
  reg [2:0] state = 3'b000, next_state = 3'b000;	   

  int i = 0; 
  always @(negedge clk) begin
   if (i < 1) begin
      i++;
      state <= 3'b000; // Set the initial state
   end else begin
      state <= next_state;
      // $display("State = %0d, next_state = %0d, op_code = %b", state, next_state, op_code);
   end
 end	
  
 always @(negedge clk) begin
      case (state)
        3'b000: begin
            // Define FETCH behavior here...
            next_state = 3'b001;
			$display("State = %b , next_state = %b" , state , next_state);
        end
        
        3'b001: begin
          		if(op_code==6'b001100)begin // JMP
					next_state = 3'b000;
				end
				else begin 
					next_state = 3'b010; //other instructions
				end	
         
        end
        3'b010: begin
          if (op_code==6'b0010??) begin	//BGT + BLT + BEQ + BNE
			  next_state = 3'b000;
		  end
          else if (op_code==6'b00000? || op_code==6'b000010 || op_code==6'b000011 || op_code==6'b000100) begin	 //R_type + ANDI + ADDI
			  next_state = 3'b100;
		  end 
		  else 	//LW + LW.POI + SW + CALL + RET + PUSH + POP
			  next_state =3'b011;
		  end 
		  
        3'b100: begin	//R-type + ADDI + ANDI + LW + LW.POI +POP
            next_state = 3'b000;
        end	
		
        3'b011 : begin
			if(op_code==6'b000101 || op_code==6'b000110 || op_code==6'b010000 )begin //LW + LW.POI + POP
			  next_state = 3'b100;
			end
		else //CALL + RET + SW +PUSH 
			begin
			  next_state = 3'b000;
		    end
		end	
        default: begin
            next_state = 3'b000;
        end
    endcase
        
  end  

  
 controlUnit CU (
    .clk(clk),
    .next_state(next_state),
    .state(state),
    .PCsrc(PCsrc),
    .OP(op_code),
    .ExtOp(EX_OP),
    .Rs2Src(RS2src),
    .RegRw(RegRw),
    .Rs1Rw(Rs1Rw),
    .ALUsrc(ALUSrc),
    .DataInputSrc(DataInputSrc),
    .ALUop(ALUop),
    .MemR(MemR),
    .MemW(MemW),
    .Zeroflag(ALU_flags_out[1]),
    .Negflag(ALU_flags_out[2]),
    .WBdata(WBdata),
    .DataMemEn(DataMemEn)
  );
  

  
   //dff
  dFlipFlop #(32) next_pc (.data_input(pc_next_in) , .clock(clk) , .data_output(pc_next_out));
  always @(posedge clk) begin	
	  $display("----------------------------------------------------------------------------------------------------------"); 
	  $display("D Flip Flop for PC+1: pc_next_out = %b" , pc_next_out);
  end
  
  dFlipFlop #(32)next_pc_JTA (.data_input(pc_J_in) , .clock(clk) , .data_output(pc_J_out) ); 
  always @(posedge clk) begin 
	  $display("----------------------------------------------------------------------------------------------------------"); 
	  $display("D Flip Flop for Jump Target Address: pc_J_out = %b" , pc_J_out);
  end
  						 
  dFlipFlop #(32)next_pc_BTA (.data_input(pc_BTA_in) , .clock(clk) , .data_output(pc_BTA_out));	
  always @(posedge clk) begin	
	  $display("----------------------------------------------------------------------------------------------------------"); 
	  $display("D Flip Flop for Branch Target Address: pc_BTA_out = %b" , pc_BTA_out);
  end
    
  dFlipFlop #(32)next_pc_stack (.data_input(pc_stack_in) , .clock(clk) , .data_output(pc_stack_out));
  always @(posedge clk) begin
	  $display("----------------------------------------------------------------------------------------------------------"); 
	  $display("D Flip Flop for Stack: pc_stack_out = %b" , pc_stack_out);
  end
  
  //mux_pc
  mux4x1 mux_pc (.selectionLine(PCsrc),.a(pc_next_out),.b(pc_J_out),.c(pc_BTA_out),.d(pc_stack_out),.result(pc_in));	
  always @(posedge clk) begin
	  $display("----------------------------------------------------------------------------------------------------------"); 
	  $display("Mux of PC: PCsrc = %b, pc_in=%b" , PCsrc, pc_in);
  end
  
  //pc
  PC pc_u (.clk(clk),.state(state),.PC_input(pc_in),.PC_output(pc_out));  
  always @(posedge clk) begin	
	  $display("----------------------------------------------------------------------------------------------------------"); 
	  $display("PC module: state = %b, pc_in=%b, pc_out=%b" , state, pc_in, pc_out);
  end
  
  adder_32bit adder_next_pc (.input1(pc_out),.input2(4), .adder_output(pc_next_in)); 
  always @(posedge clk) begin
      $display("----------------------------------------------------------------------------------------------------------"); 
	  $display("To find PC+1: pc_out = %b, pc_next_in=%b" , pc_out, pc_next_in);
  end
  
  adder_32bit Adder (.input1(pc_out),.input2(ext_reg_out), .adder_output(pc_BTA_in));
  always @(posedge clk) begin
	  $display("----------------------------------------------------------------------------------------------------------"); 
	  $display("To find BTA: pc_out = %b, ext_reg_out=%b, pc_BTA_in=%b" , pc_out, ext_reg_out, pc_BTA_in);
  end  
  
  concatenation uut (.PC(pc_out), .Immediate26(imm_16), .ConcatenatedResult(pc_J_in));
  always @(posedge clk) begin
	  $display("----------------------------------------------------------------------------------------------------------"); 
	  $display("To find JTA: pc_out = %b, imm_16=%b, pc_J_in=%b" , pc_out, imm_16, pc_J_in);
  end  
  
  InstructionMemory  IM(.address(pc_out),.instruction(inst_mem_out));	
  always @(posedge clk) begin 
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("pc_out = %b, inst_mem_out=%b" , pc_out, inst_mem_out);
  end  
  
  
  IR ir (.clk(clk),.inst(inst_mem_out), .op_code(op_code), .inst_rs1(inst_rs1),  .inst_rs2(inst_rs2), .inst_rd(inst_rd),.imm_16(imm_16),.jump_offset(J_offset), .Mode(mode)); 
  always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("inst_mem_out=%b, op_code=%b, inst_rs1=%b, inst_rs2=%b, inst_rd=%b, imm_16=%b, J_offset=%b, mode=%b", inst_mem_out, op_code, inst_rs1, inst_rs2, inst_rd, imm_16, J_offset, mode);
  end

  sign_extender extender (.Imm_16(imm_16),  .ExtOp(EX_OP),.ExtOut(ext_reg_in));	
  always @(posedge clk) begin 
    $display("----------------------------------------------------------------------------------------------------------");  
    $display("imm_16 = %b, EX_OP=%b, ext_reg_in=%b" , imm_16, EX_OP, ext_reg_in);
  end
   
  dFlipFlop #(32)reg_extender(.data_input(ext_reg_in) , .clock(clk) , .data_output(ext_reg_out));
  always @(posedge clk) begin	
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("ext_reg_in= %b, ext_reg_out=%b" ,ext_reg_in,ext_reg_out);
  end
  
  mux2x1 Mux_RF (.selectionLine(RS2src),.a(inst_rs2),.b(inst_rd),.result(mux_src_rf_out));	
  always @(posedge clk) begin	
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("RS2src= %b, inst_rs2=%b, inst_rd=%b,mux_src_rf_out=%b" ,RS2src,inst_rs2,inst_rd,mux_src_rf_out);
  end
  
  RegFile RF (.RA(inst_rs1),.RB(mux_src_rf_out),.RW(inst_rd),.Bus_A(BusA_in),.Bus_B(BusB_in),.Bus_W(BusW),.Bus_W1(BusW1),.clk(clk),.RegRw(RegRw), .Rs1Rw(Rs1Rw));
  always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("inst_rs1= %b, mux_src_rf_out=%b, inst_rd=%b,BusA_in=%b BusB_in= %b, BusW=%b, BusW1=%b,RegRw=%b,Rs1Rw=%b" ,inst_rs1,mux_src_rf_out,inst_rd,BusA_in,BusB_in,BusW,BusW1,RegRw,Rs1Rw);
  end

  dFlipFlop #(32)reg_BusA(.data_input(BusA_in) , .clock(clk) , .data_output(BusA_out));
  always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("BusA_in= %b, BusA_out=%b" ,BusA_in,BusA_out);
  end
  
  dFlipFlop #(32)reg_BusB(.data_input(BusB_in) , .clock(clk) , .data_output(BusB_out));
  always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("BusB_in= %b, BusB_out=%b" ,BusB_in,BusB_out);
  end
  
  mux2x1 Mux_WBdata (.selectionLine(WBdata),.a(ALU_res_out),.b(D_mem_reg_out),.result(BusW));
   always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("WBdata= %b, ALU_res_out=%b ,D_mem_reg_out= %b, BusW=%b" ,WBdata,ALU_res_out,D_mem_reg_out,BusW);
  end
  
  mux2x1 Mux_ALU (.selectionLine(ALUSrc),.a(BusB_out),.b(ext_reg_out),.result(mux_src_ALU_out));
    always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("ALUSrc= %b, BusB_out=%b ,ext_reg_out= %b, mux_src_ALU_out=%b" ,ALUSrc,BusB_out,ext_reg_out,mux_src_ALU_out);
  end
  
  mux2x1 Mux_DataInputSrc (.selectionLine(DataInputSrc),.a(BusB_out),.b(pc_next_in),.result(mux_DataInputSrc_out));
   always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("DataInputSrc= %b, BusB_out=%b ,pc_next_in= %b, mux_DataInputSrc_out=%b" ,DataInputSrc,BusB_out,pc_next_in,mux_DataInputSrc_out);
  end
  
  ALU alu ( .A(BusA_out),.B(mux_src_ALU_out),.ALUop(ALUop),.result(ALU_res_in), .carry(ALU_flags_in[0]),.zero(ALU_flags_in[1]),.negative(ALU_flags_in[2]),.overflow(ALU_flags_in[3]));	
   always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("BusA_out= %b, mux_src_ALU_out=%b ,ALUop= %b, ALU_res_in=%b ,ALU_flags_in[0]= %b, ALU_flags_in[1]=%b ,ALU_flags_in[2]= %b, ALU_flags_in[3]=%b" ,BusA_out,mux_src_ALU_out,ALUop,ALU_res_in,ALU_flags_in[0],ALU_flags_in[1],ALU_flags_in[2],ALU_flags_in[3]);
  end

  data_memory_with_stack Data_Mem (.clk(clk),.mem_write(MemW),.mem_read(MemR),.dataMemEnable(DataMemEn),.address(ALU_res_in),.data_in(mux_DataInputSrc_out),.data_out(D_mem_reg_in));
    always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("MemW= %b, MemR=%b ,DataMemEn= %b, ALU_res_in=%b ,mux_DataInputSrc_out= %b, D_mem_reg_in=%b" ,MemW,MemR,DataMemEn,ALU_res_in,mux_DataInputSrc_out,D_mem_reg_in);
  end
   
  dFlipFlop #(4)reg_AluFlags (.data_input(ALU_flags_in), .clock(clk) , .data_output(ALU_flags_out) ); 	 
    always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("ALU_flags_in= %b, ALU_flags_out=%b" ,ALU_flags_in,ALU_flags_out);
  end	
  
  dFlipFlop #(32)reg_AluResult(.data_input(ALU_res_in), .clock(clk), .data_output(ALU_res_out) );
    always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("ALU_res_in= %b, ALU_res_out=%b" ,ALU_res_in,ALU_res_out);
  end 
  
  dFlipFlop #(32)reg_DataMem(.data_input(D_mem_reg_in), .clock(clk) , .data_output(D_mem_reg_out)) ;   
    always @(posedge clk) begin
	$display("----------------------------------------------------------------------------------------------------------");  
    $display("D_mem_reg_in= %b, D_mem_reg_out=%b" ,D_mem_reg_in,D_mem_reg_out);
  end
  
  
endmodule