`timescale 1ns/1ns

module IR_testbench;

  // Inputs
  reg clk;
  reg [31:0] inst;

  // Outputs
  wire [5:0] op_code;
  wire [3:0] inst_rs1, inst_rs2, inst_rd;
  wire [15:0] imm_16;
  wire [25:0] jump_offset;
  wire [1:0] mode;

  // Instantiate the module under test
  IR uut (
    .clk(clk),
    .inst(inst),
    .op_code(op_code),
    .inst_rs1(inst_rs1),
    .inst_rs2(inst_rs2),
    .inst_rd(inst_rd),
    .imm_16(imm_16),
    .jump_offset(jump_offset),
    .Mode(mode)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test cases
  initial begin
    // Test Case 1: R-type instruction -> SUB
    inst = 32'b00001001101000000100000000110011;
    #10;
    $display("Test Case 1 - R-type:");
    $display("op_code = %b, inst_rs1 = %b, inst_rs2 = %b, inst_rd = %b", op_code, inst_rs1, inst_rs2, inst_rd);

    // Test Case 2: I-type instruction -> ANDI
    inst = 32'b00001100001100010000000000110011;
    #10;
    $display("Test Case 2 - I-type:");
    $display("op_code = %b, inst_rs1 = %b, imm_16 = %b, mode = %b", op_code, inst_rs1, imm_16, mode);

    // Test Case 3: J-type instruction -> JMP
    inst = 32'b00110000000011010000000110110011;
    #10;
    $display("Test Case 3 - J-type:");
    $display("op_code = %b, jump_offset = %b", op_code, jump_offset);

    // Test Case 4: S-type instruction
    inst = 32'b00111100100000000000000000111111;
    #10;
    $display("Test Case 4 - S-type:");
    $display("op_code = %b, inst_rd = %b", op_code, inst_rd);

    // End simulation
    $finish;
  end

endmodule
