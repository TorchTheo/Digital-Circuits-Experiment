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