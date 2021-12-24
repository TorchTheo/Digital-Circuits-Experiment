module Clock (
    input               sys_clk,
    output  reg[31:0]   milliseconds
);

reg [16:0]  clk_count;
reg         clk;

initial begin
	clk_count = 16'b0;
	milliseconds = 32'b0;
	clk = 0;
end

always @ (posedge sys_clk) begin

    if(clk_count == 25000) begin
        clk <= ~clk;
        clk_count <= 0;
    end
    else
        clk_count <= clk_count + 1;
end

always @ (posedge clk)
    milliseconds <= milliseconds + 1;

endmodule //Clock