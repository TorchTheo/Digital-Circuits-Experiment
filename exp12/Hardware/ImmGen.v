module ImmGen (
	input 			[24:0] 	instr_31_7, 
	input 			[2:0] 	extop, 
	output 	wire 	[31:0] 	imm
);

wire [31:0] immI;
wire [31:0] immU;
wire [31:0] immS;
wire [31:0] immB;
wire [31:0] immJ;

assign immI = {{20{instr_31_7[24]}}, instr_31_7[24:13]};
assign immU = {instr_31_7[24:5], 12'b0};
assign immS = {{20{instr_31_7[24]}}, instr_31_7[24:18], instr_31_7[4:0]};
assign immB = {{20{instr_31_7[24]}}, instr_31_7[0], instr_31_7[23:18], instr_31_7[4:1], 1'b0};
assign immJ = {{12{instr_31_7[24]}}, instr_31_7[12:5], instr_31_7[13], instr_31_7[23:14], 1'b0};

assign imm = (extop == 3'b000)
				? immI
				: ((extop == 3'b001)
					? immU
					: ((extop == 3'b010)
						? immS
						: ((extop == 3'b011)
							? immB
							: immJ)));

endmodule //ImmGen