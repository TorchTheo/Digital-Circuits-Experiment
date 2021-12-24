//simple scancode converter
module scancode_ram(clk, addr, state, outdata);
input clk;
input [7:0] addr;
input [1:0] state;
output reg [7:0] outdata;

//(* ram_init_file = "./ascii_tab.mif" *) 
reg [7:0] ascii_normal[255:0];
reg [7:0] ascii_shift[255:0];
reg [7:0] ascii_cap[255:0];
reg [7:0] ascii_shift_cap[255:0];

initial begin
	$readmemh("C:/Users/hfche/Desktop/test_for_12/Users/STRING10/Documents/FPGA_Proj/EXP12/RV32Is/scancode.txt", ascii_normal, 0, 255);
	$readmemh("C:/Users/hfche/Desktop/test_for_12/Users/STRING10/Documents/FPGA_Proj/EXP12/RV32Is/shiftcode.txt", ascii_shift, 0, 255);
	$readmemh("C:/Users/hfche/Desktop/test_for_12/Users/STRING10/Documents/FPGA_Proj/EXP12/RV32Is/capcode.txt", ascii_cap, 0, 255);
	$readmemh("C:/Users/hfche/Desktop/test_for_12/Users/STRING10/Documents/FPGA_Proj/EXP12/RV32Is/capshiftcode.txt", ascii_shift_cap, 0, 255);
end

always @(posedge clk)
begin
      case(state)
		0: outdata = ascii_normal[addr];
		1:	outdata = ascii_shift[addr];
		2: outdata = ascii_cap[addr];
		3:	outdata = ascii_shift_cap[addr];
		default: outdata = 8'bz;
		endcase
end

endmodule