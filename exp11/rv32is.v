module rv32is(
	input 	clock,
	input 	reset,
	output [31:0] imemaddr,
	input  [31:0] imemdataout,
	output 	imemclk,
	output [31:0] dmemaddr,
	input  [31:0] dmemdataout,
	output [31:0] dmemdatain,
	output 	dmemrdclk,
	output	dmemwrclk,
	output [2:0] dmemop,
	output	dmemwe,
	output [31:0] dbgdata);
//add your code here

wire    [31:0]  pc;
wire    [31:0]  next_pc;
wire    [31:0]  instr;
wire    [31:0]  busW;
wire    [31:0]  rs1;
wire    [31:0]  rs2;
wire    [31:0]  imm;
wire    [31:0]  _cpu_pc_generator_mux_var_1;
wire    [31:0]  _cpu_pc_generator_mux_var_2;
wire    [31:0]  _cpu_alu_var_1;
wire    [31:0]  _cpu_alu_var_2;
wire    [31:0]  _alu_result;

wire    [4:0]   ra;
wire    [4:0]   rb;
wire    [4:0]   rd;
wire    [6:0]   op;  
wire    [2:0]   func3;
wire    [6:0]   func7;
wire    [2:0]   ExtOp;
wire            RegWr;
wire            ALUAsrc;
wire    [1:0]   ALUBsrc;
wire    [3:0]   ALUctr;
wire    [2:0]   Branch;
wire            MemtoReg;
wire            MemWr;
wire    [2:0]   MemOp;
wire            less;
wire            zero;
wire            PCAsrc;
wire            PCBsrc;

assign instr = imemdataout;
assign dmemop = MemOp;
assign dmemaddr = _alu_result;
assign dmemdatain = rs2;
assign dmemrdclk = clock;
assign dmemwrclk = ~clock;
assign imemclk = ~clock;
assign dmemwe = MemWr;
assign dbgdata = pc;

PC _cpu_pc(clock, reset, next_pc, pc);
InstrDecode _cpu_instr_decode(instr, op, ra, rb, rd, func3, func7);
RegFile myregfile(~clock, ra, rb, rd, busW, RegWr, rs1, rs2);
ImmGenerator _cpu_imm_generator(instr, ExtOp, imm);
ContrGen _cpu_control_generator(op, func3, func7, ExtOp, RegWr, ALUAsrc, ALUBsrc, ALUctr, Branch, MemtoReg, MemWr, MemOp);
ALU _cpu_alu(_cpu_alu_var_1, _cpu_alu_var_2, ALUctr, less, zero, _alu_result);
BranchCond _cpu_branch_condition(Branch, zero, less, PCAsrc, PCBsrc);

MUX2 _cpu_pc_generator_mux_1(32'b100, imm, PCAsrc, _cpu_pc_generator_mux_var_1);
MUX2 _cpu_pc_generator_mux_2(pc, rs1, PCBsrc, _cpu_pc_generator_mux_var_2);

MUX2 _cpu_alu_mux_1(rs1, pc, ALUAsrc, _cpu_alu_var_1);
MUX4 _cpu_alu_mux_2(rs2, imm, 32'b100, 32'b0, ALUBsrc, _cpu_alu_var_2);

MUX2 _cpu_dmem_mux(_alu_result, dmemdataout, MemtoReg, busW);

assign next_pc = !reset ? (_cpu_pc_generator_mux_var_1 + _cpu_pc_generator_mux_var_2) : 32'b0;
assign imemaddr = next_pc;

endmodule








module ALU(
	input [31:0] dataa,
	input [31:0] datab,
	input [3:0]  ALUctr,
	output less,
	output zero,
	output reg [31:0] aluresult);

//add your code here
	reg l = 0;
	reg z = 0;
	reg [31:0] temp[1:0];
	always @ (*) begin
		temp[0] = 32'b0;
		temp[1] = 32'b11111111111111111111111111111111;
		if(ALUctr == 4'b0)
			aluresult = dataa + datab;
		else if(ALUctr == 4'b1000)
			aluresult = dataa - datab;
		else if(ALUctr[2:0] == 3'b001)
			aluresult = dataa << datab[4:0];
		else if(ALUctr == 4'b0010) begin
			z = dataa == datab ? 1 : 0;
			if(dataa[31] == datab[31])
				aluresult = dataa < datab;
			else 
				aluresult = dataa > datab;
			l = aluresult[0];
		end
		else if(ALUctr == 4'b1010) begin
			z = dataa == datab ? 1 : 0;
			aluresult = dataa < datab;
			l = aluresult[0];
		end
		else if(ALUctr[2:0] == 3'b011)
			aluresult = datab;
		else if(ALUctr[2:0] == 3'b100)
			aluresult = dataa ^ datab;
		else if(ALUctr == 4'b0101)
			aluresult = dataa >> datab[4:0];
		else if(ALUctr == 4'b1101)
			aluresult = (dataa >> datab[4:0]) + (temp[dataa[31]] << (32 - datab[4:0]));
		else if(ALUctr[2:0] == 3'b110)
			aluresult = dataa | datab;
		else if(ALUctr[2:0] == 3'b111)
			aluresult = dataa & datab;
		if(ALUctr != 4'b0010 && ALUctr != 4'b1010)
			z = aluresult == 0 ? 1 : 0;
	end
	assign zero = z;
	assign less = l;

endmodule //ALU

module BranchCond (
    input   [2:0]   branch,
    input           zero,
    input           less,
    output          PCAsrc,
    output          PCBsrc  
);

assign PCAsrc = (~branch[2] & branch[0]) | 
                (~branch[1] & branch[0] & ~zero) | 
                (~branch[2] & branch[1]) | 
                (branch[1] & ~branch[0] & less) | 
                (branch[2] & ~branch[1] & ~branch[0] & zero) | 
                (branch[1] & branch[0] & ~less);

assign PCBsrc = (~branch[2] & branch[1] & ~branch[0]);

endmodule

module ContrGen (
    input   [6:0]   op,
    input   [2:0]   func3,
    input   [6:0]   func7,
    output  [2:0]   ExtOp,
    output          RegWr,
    output          ALUAsrc,
    output  [1:0]   ALUBsrc,
    output  [3:0]   ALUctr,
    output  [2:0]   Branch,
    output          MemtoReg,
    output          MemWr,
    output  [2:0]   MemOp
);

assign ExtOp =  ((~op[6] & ~op[5] & op[4] & ~op[3] & ~op[2]) | 
                 (op[6] & op[5] & ~op[4] & ~op[3] & op[2] & ~func3[2] & ~func3[1] & ~func3[0]) | 
                 (~op[6] & ~op[5] & ~op[4] & ~op[3] & ~op[2])) ? 3'b000 :
                (((~op[6] & op[5] & op[4] & ~op[3] & op[2]) | 
                  (~op[6] & ~op[5] & op[4] & ~op[3] & op[2])) ? 3'b001 :
                ((~op[6] & op[5] & ~op[4] & ~op[3] & ~op[2]) ? 3'b010 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2]) ? 3'b011 :
                ((op[6] & op[5] & ~op[4] & op[3] & op[2]) ? 3'b100 : 3'bxxx))));

assign RegWr =  ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2]) | 
                (~op[6] & op[5] & ~op[4] & ~op[3] & ~op[2])) ? 0 : 1;

assign Branch = (op[6] & op[5] & ~op[4] & op[3] & op[2]) ? 3'b001 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & op[2]) ? 3'b010 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2] & ~func3[2] & ~func3[1] & ~func3[0]) ? 3'b100 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2] & ~func3[2] & ~func3[1] & func3[0]) ? 3'b101 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2] & func3[2] & ~func3[0]) ? 3'b110 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2] & func3[2] & func3[0]) ? 3'b111 : 3'b000)))));

assign MemtoReg = ~op[6] & ~op[5] & ~op[4] & ~op[3] & ~op[2];

assign MemWr = ~op[6] & op[5] & ~op[4] & ~op[3] & ~op[2];

assign MemOp = (~op[6] & ~op[4] & ~op[3] & ~op[2]) ? func3 : 3'bxxx;

assign ALUAsrc = (op[6] & op[5] & ~op[4] & op[2]) | (~op[6] & ~op[5] & op[4] & ~op[3] & op[2]);

assign ALUBsrc = ((~op[6] & op[5] & op[4] & ~op[3] & ~op[2]) | 
                 (op[6] & op[5] & ~op[4] & ~op[3] & ~op[2])) ? 2'b00 :
                 (((~op[6] & ~op[5] & op[4] & ~op[3]) |
                   (~op[6] & ~op[4] & ~op[3] & ~op[2]) | 
                   (~op[6] & op[5] & op[4] & ~op[3] & op[2])) ? 2'b01 :
                 ((op[6] & op[5] & ~op[4] & op[2]) ? 2'b10 : 2'bxx));

assign ALUctr[3] =  (~op[6] & ~op[5] & op[4] & ~op[3] & ~op[2] & ((~func3[2] & func3[1] & func3[0]) | (func3[2] & ~func3[1] & func3[0] & func7[5]))) |
                    (~op[6] & op[5] & op[4] & ~op[3] & ~op[2] & ((~func3[2] & func3[1] & func3[0]) | (func7[5] & ((~func3[2] & ~func3[1] & ~func3[0]) | (func3[2] & ~func3[1] & func3[0]))))) |
                    (op[6] & op[5] & ~op[4] & ~op[3] & ~op[2] & func3[2] & func3[1]);

assign ALUctr[2] =  ~op[6] & op[4] & ~op[3] & ~op[2] & func3[2];

assign ALUctr[1] =  (~op[6] & op[5] & op[4] & ~op[3] & op[2]) | 
                    (~op[6] & op[4] & ~op[3] & ~op[2] & func3[1]) |
                    (op[6] & op[5] & ~op[4] & ~op[3] & ~op[2]);

assign ALUctr[0] =  (~op[6] & op[5] & op[4] & ~op[3] & op[2]) | 
                    (~op[6] & ~op[5] & op[4] & ~op[3] & ~op[2] & 
                        ((func3[2] & func3[0]) | 
                        (~func3[2] & ~func3[1] & func3[0] & ~func7[5]))) |
                    (~op[6] & op[5] & op[4] & ~op[3] & ~op[2] & 
                        ((~func3[2] & ~func3[1] & func3[0] & ~func7[5]) | 
                        (func3[2] & func3[0])));

endmodule //ContrGen

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


module InstrDecode (
    input   [31:0]  instr,
    output  [6:0]   op,
    output  [4:0]   rs1,
    output  [4:0]   rs2,
    output  [4:0]   rd,
    output  [2:0]   func3,
    output  [6:0]   func7
);

assign op       = instr[6:0];
assign rs1      = instr[19:15];
assign rs2      = instr[24:20];
assign rd       = instr[11:7];
assign func3    = instr[14:12];
assign func7    = instr[31:25];


endmodule //InstrEncode

module MUX2 (
    input   [31:0]  a,
    input   [31:0]  b,
    input           control,
    output  [31:0]  out
);

assign out = (control == 0) ? a : b;

endmodule //MUX2

module MUX4 (
    input   [31:0]  in_1,
    input   [31:0]  in_2,
    input   [31:0]  in_3,
    input   [31:0]  in_4,
    input   [1:0]   control,
    output  [31:0]  out
);

assign out = (control == 0 ? in_1 : (control == 1 ? in_2 : (control == 2 ? in_3 : in_4)));

endmodule //MUX4

module PC (
    input clk,
    input reset,
    input [31:0] next_pc,
    output reg [31:0] pc
);

always @(negedge clk) begin
    if(reset)
        pc <= 32'b0;
    else
        pc <= next_pc;
end

endmodule //PC

module RegFile(clk, ra, rb, rw, busW, regWr, busA, busB);
input               clk;
input       [4:0]   ra;
input       [4:0]   rb;
input       [4:0]   rw;
input       [31:0]  busW;
input               regWr;
output      [31:0]  busA;
output      [31:0]  busB;

reg [31:0] regs[31:0];
integer i;

initial begin
    regs[0] = 32'b0;
end
assign busB = regs[rb];
assign busA = regs[ra];


always @(posedge clk) begin
    if(regWr)
        regs[rw] <= busW;
    regs[0] <= 32'b0;
end

endmodule