module ImmGenerator (
    input  [31:0] instr,
    input  [2:0]  extOp,
    output [31:0] imm
);

wire [31:0] immI;
wire [31:0] immU;
wire [31:0] immS;
wire [31:0] immB;
wire [31:0] immJ;

assign immI = {{20{instr[31]}}, instr[31:20]};
assign immU = {instr[31:12], 12'b0};
assign immS = {{20{instr[31]}}, instr[31:25], instr[11:7]};
assign immB = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
assign immJ = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};


assign imm = extOp == 0 ? immI : (extOp == 1 ? immU : (extOp == 2 ? immS : (extOp == 3 ? immB : (extOp == 4 ? immJ : 0))));

endmodule
