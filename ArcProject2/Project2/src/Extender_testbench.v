`timescale 1ns / 1ps

module sign_extender_testbench;

reg [15:0] Imm_16;
reg ExtOp;
wire [31:0] ExtOut;

// Instantiate the Unit Under Test (UUT)
sign_extender uut (
    .Imm_16(Imm_16), 
    .ExtOp(ExtOp), 
    .ExtOut(ExtOut)
);

initial begin
    // Initialize Inputs
    Imm_16 = 0;
    ExtOp = 0;

    // Wait 100 ns for global reset to finish
    #100;

    // Add stimulus here
    repeat (10) begin
        Imm_16 = $random;
        ExtOp = $random % 2; // Randomly generate 0 or 1
        #10; // Wait 10 ns between changes
        $display("Time: %t, Imm_16: %h, ExtOp: %b, ExtOut: %h", $time, Imm_16, ExtOp, ExtOut);
    end

    $finish;
end

endmodule