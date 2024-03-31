module RegFile_testbench;

  reg clk, RegRw, Rs1Rw;
  reg [3:0] RA, RB, RW;
  reg [31:0] Bus_W, Bus_W1;
  wire [31:0] Bus_A, Bus_B;

  // Instantiate the RegFile module
  RegFile uut (
    .RA(RA),
    .RB(RB),
    .RW(RW),
    .Bus_A(Bus_A),
    .Bus_B(Bus_B),
    .Bus_W(Bus_W),
    .Bus_W1(Bus_W1),
    .clk(clk),
    .RegRw(RegRw),
    .Rs1Rw(Rs1Rw)
  );

  initial begin
    // Initialize inputs
    clk = 0;
    RegRw = 0;
    Rs1Rw = 0;
    RA = 0;
    RB = 0;
    RW = 0;
    Bus_W = 32'h0000_0000;
    Bus_W1 = 32'h0000_0000;	 
	
	$display("-----------------------------");

    // Test Case 1: Write to register 3, Read from register 3
    #10 RegRw = 1; Rs1Rw = 0; RW = 3; Bus_W = 32'h1234_5678; // Write to register 3
    #10 RegRw = 0; RA = 3; // Read from register 3	 
	
	$display("-----------------------------");

    // Test Case 2: Write to registers 5 and 3, Read from registers 5 and 3
    #10 RegRw = 1; Rs1Rw = 1; RW = 5; Bus_W = 32'h8765_4321; Bus_W1 = 32'h1111_2222; // Write to registers 5 and 3
    #10 RegRw = 0; RA = 3; RB = 5; // Read from registers 3 and 5
	
	$display("-----------------------------");

    // Test Case 3: Write to register 0, Read from register 0
    #10 RegRw = 1; Rs1Rw = 0; RW = 0; Bus_W = 32'hAAAA_AAAA; // Write to register 0
    #10 RegRw = 0; RA = 0; // Read from register 0		 
	
	$display("-----------------------------");

    #100 $finish;
  end

  always #5 clk = ~clk; // Clock generation

  // Print statements
  initial begin
    $monitor("Time=%0t -> RegRw=%0d Rs1Rw=%0d RA=%0d RB=%0d RW=%0d Bus_W=%h Bus_W1=%h Bus_A=%h Bus_B=%h",
	$time, RegRw, Rs1Rw, RA, RB, RW, Bus_W, Bus_W1, Bus_A, Bus_B);  
  end

endmodule
