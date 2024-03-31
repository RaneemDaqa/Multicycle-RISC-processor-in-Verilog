module ControlUnit_testbench();

  reg clk;
  reg [5:0] OP;
  reg [2:0] next_state;
  reg [2:0] state;
  reg Zeroflag, Negflag;
  wire ExtOp, Rs2Src, RegRw, Rs1Rw, ALUsrc, DataInputSrc, MemR, MemW, WBdata, DataMemEn;
  wire [1:0] PCsrc;
  wire [1:0] ALUop;

  controlUnit uut (
    .clk(clk),
    .next_state(next_state),
    .state(state),
    .PCsrc(PCsrc),
    .OP(OP),   
    .ExtOp(ExtOp),
    .Rs2Src(Rs2Src),
    .RegRw(RegRw),
    .Rs1Rw(Rs1Rw),
    .ALUsrc(ALUsrc),
    .DataInputSrc(DataInputSrc),
    .ALUop(ALUop),
    .MemR(MemR),
    .MemW(MemW),
    .Zeroflag(Zeroflag),
    .Negflag(Negflag),
    .WBdata(WBdata),
    .DataMemEn(DataMemEn)
  );

  initial begin
    // Initialize inputs
    clk = 0;
    OP = 6'b000000;
    next_state = 3'b000;
    state = 3'b000;
    Zeroflag = 0;
    Negflag = 0;

    // Apply stimulus
	#10 OP = 6'b000000; // Triggering AND case
	#10 OP = 6'b000001; // Triggering ADD case
	#10 OP = 6'b000010; // Triggering SUB case
    #10 OP = 6'b000011; // Triggering ANDI case	
	#10 OP = 6'b000100; // Triggering ADDI case	
	#10 OP = 6'b000101; // Triggering LW case 
	#10 OP = 6'b000110; // Triggering LW.POI case
	#10 OP = 6'b000111; // Triggering SW case
    #10 OP = 6'b001000; // Triggering Branch case: BGT
    #10 OP = 6'b001001; // Triggering Branch case: BLT	
    #10 OP = 6'b001010; // Triggering Branch case: BEQ
    #10 OP = 6'b001011; // Triggering Branch case: BNE 
	#10 OP = 6'b001100; // Triggering JMP case 
	#10 OP = 6'b001101; // Triggering CALL case
	#10 OP = 6'b001110; // Triggering RET case 
	#10 OP = 6'b001111; // Triggering PUSH case
	#10 OP = 6'b010000; // Triggering POP case

    #170 $finish;
  end

  always #5 clk = ~clk; // Clock generation

  // Print statements
  initial begin
    $monitor("Time=%0t ->	state=%b, next_state=%b, OP=%b PCsrc=%b ALUop=%b ExtOp=%b Rs2Src=%b RegRw=%b Rs1Rw=%b ALUsrc=%b DataInputSrc=%b MemR=%b MemW=%b WBdata=%b DataMemEn=%b",
      $time, state, next_state, OP, PCsrc, ALUop, ExtOp, Rs2Src, RegRw, Rs1Rw, ALUsrc, DataInputSrc, MemR, MemW, WBdata, DataMemEn);
  end

endmodule
