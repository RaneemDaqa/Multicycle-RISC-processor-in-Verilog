module RegFile(RA, RB, RW, Bus_A, Bus_B, Bus_W, Bus_W1, clk, RegRw, Rs1Rw);
    input clk, RegRw, Rs1Rw;
    input [3:0] RA, RB, RW;
    input [31:0] Bus_W, Bus_W1;
    output reg [31:0] Bus_A, Bus_B;

    integer i = 0;
    reg [31:0] register_file [15:0]; // 16 32-bit general-purpose registers: from R0 to R15. 

    initial begin
        for (i = 0; i < 16; i = i + 1)
            register_file[i] = 0;
    end

    always @(posedge clk) begin	
		// Write
        if (RegRw == 1 && Rs1Rw == 0) begin
            register_file[RW] <= Bus_W;
        end else if (RegRw == 1 && Rs1Rw == 1) begin
            register_file[RW] <= Bus_W;
            register_file[RA] <= Bus_W1;
        end else begin
			// Read
        	Bus_A <= register_file[RA];
        	Bus_B <= register_file[RB];
		end	
    end
endmodule
