`include "exp11/ALU.v"
`include "exp11/BranchCond.v"
`include "exp11/ContrGen.v"
`include "exp11/DataMem.v"
`include "exp11/InstrMem.v"
`include "exp11/ImmGenerator.v"
`include "exp11/MUX2.v"
`include "exp11/MUX4.v"
`include "exp11/PC.v"
`include "exp11/RegFile.v"
`include "exp11/InstrDecode.v"

module cpu (
    input clk,
    input reset
);

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
wire    [31:0]  _dmem_result;

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


PC _cpu_pc(clk, reset, next_pc, pc);
InstrMem _cpu_instr_mem(clk, next_pc, instr);
InstrDecode _cpu_instr_decode(instr, op, ra, rb, rd, func3, func7);
RegFile myregfile(clk, ra, rb, rd, busW, RegWr, rs1, rs2);
ImmGenerator _cpu_imm_generator(instr, ExtOp, imm);
ContrGen _cpu_control_generator(op, func3, func7, ExtOp, RegWr, ALUAsrc, ALUBsrc, ALUctr, Branch, MemtoReg, MemWr, MemOp);
ALU _cpu_alu(_cpu_alu_var_1, _cpu_alu_var_2, ALUctr, less, zero, _alu_result);
BranchCond _cpu_branch_condition(Branch, zero, less, PCAsrc, PCBsrc);
DataMem _cpu_data_memory(_alu_result, _dmem_result, rs2, clk, ~clk, MemOp, MemWr);

MUX2 _cpu_pc_generator_mux_1(32'b100, imm, PCAsrc, _cpu_pc_generator_mux_var_1);
MUX2 _cpu_pc_generator_mux_2(pc, rs1, PCBsrc, _cpu_pc_generator_mux_var_2);

MUX2 _cpu_alu_mux_1(rs1, pc, ALUAsrc, _cpu_alu_var_1);
MUX4 _cpu_alu_mux_2(rs2, imm, 32'b100, 32'b0, ALUBsrc, _cpu_alu_var_2);

MUX2 _cpu_dmem_mux(_alu_result, _dmem_result, MemtoReg, busW);

assign next_pc = !reset ? (_cpu_pc_generator_mux_var_1 + _cpu_pc_generator_mux_var_2) : 32'b0;

endmodule 