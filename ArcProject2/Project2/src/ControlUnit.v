module controlUnit(clk, next_state, state, PCsrc, OP, ExtOp, Rs2Src, RegRw, Rs1Rw, ALUsrc, DataInputSrc, ALUop, MemR,
                  MemW, Zeroflag, Negflag, WBdata, DataMemEn);

  input clk;
  input Zeroflag, Negflag;	 
  input [5:0] OP;
  output reg ExtOp = 0, Rs2Src = 0, RegRw = 0, Rs1Rw = 0, ALUsrc = 0, DataInputSrc = 0, MemR = 0, MemW = 0, WBdata = 0, DataMemEn = 0;
  output reg [1:0] PCsrc = 2'b00;
  output reg [1:0] ALUop = 2'b00; 
  input [2:0] next_state;
  input [2:0] state;

  parameter IF_STAGE = 3'b000;
  parameter ID_STAGE = 3'b001;
  parameter EX_STAGE = 3'b010;
  parameter MEM_STAGE = 3'b011;
  parameter WB_STAGE = 3'b100;
  
  parameter AND = 0;
  parameter ADD = 1;
  parameter SUB = 2;
    
	// main control signals
  always@ (negedge clk) begin 
    casex({OP})
			6'b00000?: begin // R-type: AND + ADD 
				Rs2Src <= 0;  
				MemR <= 0;
				MemW <= 0;
                RegRw <= 1;
              	Rs1Rw <= 0;  
              
              if(next_state == WB_STAGE) begin
					WBdata <= 1;
				end	
              	else begin
                  WBdata <= 0;
                end
			end
			
			6'b000010: begin // SUB	
				Rs2Src <= 0;  
				MemR <= 0;
				MemW <= 0;
                RegRw <= 1;
              	Rs1Rw <= 0;
              
              if(next_state == WB_STAGE) begin
					WBdata <= 1;
				end	
              	else begin
                  WBdata <= 0;
                end
			end
			
      
			6'b000011: begin // I-type: ANDI 
                RegRw <= 1;
                ExtOp <= 0;
              	MemR <= 0;
				MemW <= 0;
                Rs1Rw <=0;
              if(next_state == WB_STAGE) begin
					WBdata <= 1;
				end	
              	else begin
                  WBdata <= 0;
                end
            end
              
             6'b000100: begin // I-type: ADDI 
                RegRw <= 1;
                ExtOp <= 1;
              	MemR <= 0;
				MemW <= 0;
                Rs1Rw <=0;
              if(next_state == WB_STAGE) begin
					WBdata <= 1;
				end	
              	else begin
                  WBdata <= 0;
                end
             end
			
			6'b000101: begin // I-type: LW
                RegRw <= 1;
                ExtOp <= 1;
              	MemR <= 1;
				MemW <= 0;
                Rs1Rw <=0;
				DataMemEn <= 1;	
        
              if(next_state == WB_STAGE) begin
					WBdata <= 1;
				end	
              	else begin
                  WBdata <= 0;
                end 
			end
      
      
      		6'b000110: begin // I-type: LW.POI
                RegRw <= 1;
                ExtOp <= 1;
              	MemR <= 1;
				MemW <= 0;
                Rs1Rw <=1; 
				DataMemEn <= 1;

              if(next_state == WB_STAGE) begin
					WBdata <= 1;
				end	
              	else begin
                  WBdata <= 0;
                end
			end
			
            
      		6'b000111: begin // I-type: STORE
                RegRw <= 0;
                ExtOp <= 1;
                DataInputSrc <= 0;
              	MemR <= 0;	
				DataMemEn <= 1;
              if(next_state == MEM_STAGE) begin
					MemW = 1;
				end
              	else begin
                  MemW <= 0;
                end
			end
      
      
           6'b0010??: begin //Branch
                Rs2Src <= 1 ;
                RegRw <= 0;
                MemR <= 0;
				MemW <= 0;
           end
			
      
      
			6'b001100:  begin // J-type: jump
                 RegRw <= 0;
                 MemR <= 0;
                 MemW <= 0;
           end	
			
      
			6'b001101:  begin // J-type: CALL
				RegRw <= 0;
                DataInputSrc <= 1;
                MemR <= 0; 
				DataMemEn <= 0;
              if(next_state == MEM_STAGE) begin
					MemW = 1;
				end
              	else begin
                  MemW <= 0;
                end
            end	 
      
            6'b001110:  begin // J-type: RET
                RegRw <= 0;
                MemR <= 1;
                MemW <= 0; 
				DataMemEn <= 0;
                if(next_state == WB_STAGE) begin
					WBdata <= 1;
				end	
              	else begin
                  WBdata <= 0;
                end
             end
			
          6'b001111:  begin // PUSH
            Rs2Src <= 1 ;
            RegRw <= 0;
            DataInputSrc <= 0;
            MemR <= 0;	  
			DataMemEn <= 0;
            if(next_state == MEM_STAGE) begin
					MemW = 1;
				end
              	else begin
                  MemW <= 0;
                end
          end
      
      
           6'b010000:  begin // POP
            RegRw <= 1;
            MemR <= 1;
            MemW <= 0;
			DataMemEn <= 0;
			Rs1Rw <=0;
            if(next_state == WB_STAGE) begin
					WBdata <= 1;
				end	
              	else begin
                  WBdata <= 0;
                end
          end
		endcase
	end	

  // PC control
  always @(negedge clk) begin // TODO: posedge
		if(next_state == IF_STAGE) begin
          if (OP == 6'b001100 || OP == 6'b001101 || OP == 6'b001110)begin 
            if (OP == 6'b001110)begin 
            	PCsrc <= 3; // RET
          	end
            else begin
              PCsrc <= 1; // Jump Target Address
            end
          end
		  else if ((OP == 6'b001010 && Zeroflag == 1) || (OP == 6'b001011 && Zeroflag == 0) || (OP == 6'b001000 && Negflag == 0) || (OP == 6'b001001 && Negflag == 1))begin // Branch
            	PCsrc <= 2; // Branch Target Address
          end
          else begin
            PCsrc <= 0; // Other instructions
          end
		end
    end 
  
  
  // ALU control signal
  always @(posedge clk, OP) begin
    casex({OP})
			6'b000000: begin // AND
				ALUsrc <= 0;
				ALUop <= AND;
			end	 
			
			6'b000001: begin // ADD
				ALUsrc <= 0;
				ALUop <= ADD;
			end
			
			8'b00000010: begin // SUB
				ALUsrc <= 0;
				ALUop <= SUB;
			end		
			
			6'b000011: begin // ANDI
				ALUsrc <= 1;
				ALUop <= AND;
			end
			
			6'b000100: begin // ADDI
				ALUsrc <= 1;
				ALUop <= ADD;
			end
			
      		6'b000101: begin // LW
				ALUsrc <= 1;
				ALUop <= ADD;
			end
      
			6'b00011?: begin // LW.POI + SW
				ALUsrc <= 1;
				ALUop <= ADD;
			end	 
			
			6'b0010??: begin // Branch
				ALUsrc <= 0;
				ALUop <= SUB;
			end	 
		endcase
	end
endmodule