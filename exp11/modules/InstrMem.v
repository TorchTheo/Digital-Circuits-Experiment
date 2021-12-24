module InstrMem (
    input               rd_clk,
    input       [31:0]  rd_addr,
    output reg  [31:0]  instr 
);

reg [31:0] instr_regs[(1 << 30) - 1:0];

always @ (negedge rd_clk) begin
    instr = instr_regs[(rd_addr) >> 2];
end

endmodule //InstrMem