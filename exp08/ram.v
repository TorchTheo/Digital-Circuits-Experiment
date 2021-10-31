module ram(
	input [18:0] addr,
	input clk,
	output [3:0] r,
	output [3:0] g,
	output [3:0] b
);
	
	(* ram_init_file = "scancode.mif" *) reg [11:0] ram [327679:0];
	reg [11:0] rgb;
	

	always @(posedge clk)
	begin
		rgb <= ram[addr];
	end
	
	assign r = rgb[11:8];
	assign g = rgb[7:4];
	assign b = rgb[3:0];
endmodule
