module vga_(
input clk,
input vga_clk,
input VGA_BLANK_N,
input [9:0]h_addr,
input [9:0]v_addr,

input [7:0]ascin,
input [31:0]waddr,
input wclk,
input wren,
input [12:0] offset,

output reg [23:0] vga_data
);

integer x; // row
integer y; // col
integer x_; // pixel row
integer y_; // pixel col

wire [31:0]index;
wire [31:0]asc;

wire ovfl;
wire [7:0] data;
wire ready;
wire [31:0]raddr;
wire [31:0]wraddr;

//assign offset = (waddr[19:0]>2130) ? ((waddr -2059)/71) : 0;
assign raddr = (y << 6) + (y << 2) + (y << 1) + y + x + offset;
assign index = (asc << 4) + y_;
assign wraddr = waddr + offset;


data_matrix mydm(
	index,
	vga_clk,
	matrix_line);
	
vga_mem_ myvr(
	ascin[7:0],
	raddr[12:0],
	clk,
	waddr[12:0],
	wclk,
	wren,
	asc);
	
/*VGA_Mem myvr(
	clk,
	ascin,
	raddr[12:0],
	waddr[12:0],
	wren,
	asc);*/
	
wire [11:0] matrix_line;

reg [9:0] counth; // 像素行
reg [9:0] countv; // 像素列
reg [6:0] line_col; // 字符行
reg [10:0] line_row; // 字符列
reg [7:0] ascii;
reg [6:0] line [29:0];

initial 
begin
	vga_data = 0;
	x = 0;
	y = 0;
	x_ = 0;
	y_ = 0;
	counth = 0;
	countv = 0;
	line_col = 0;
	line_row = 0;
	ascii = 0;
end

	
always @ (posedge vga_clk)
begin
	if(h_addr >= 0 && h_addr < 640)
	begin
		y =  v_addr[8:4];
		y_ =  v_addr[3:0];
	end
	else
		vga_data = 24'h000000;
		
	if(matrix_line[x_])
		vga_data = 24'hffffff;
	else
		vga_data = 24'h000000;
		
	if(VGA_BLANK_N)
	begin
		if(x_ == 8)
		begin
			x = x + 1;
			x_ = 0;
		end
		else
			x_ = x_ + 1;
		if(x == 71)
			x = 0;
		else
			x = x;
	end
	else 
	begin
		x = 0;
		x_ = 0;
	end
end

endmodule

