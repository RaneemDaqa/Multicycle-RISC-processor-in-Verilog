module sign_extender (Imm_16, ExtOp, ExtOut);
	input wire [15:0] Imm_16;
    input wire ExtOp;
    output reg [31:0] ExtOut ;
	always @(*) begin
    if (ExtOp) begin
        // Sign-extend Imm_16
        ExtOut = {{16{Imm_16[15]}}, Imm_16};
    end else begin
        // Zero-extend Imm_16
        ExtOut = {16'b0, Imm_16};
    end
end
endmodule