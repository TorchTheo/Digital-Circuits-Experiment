module VGA_Mem (
	input clk,
	input rstn, // unused
	input wren,
	input [7:0] w_ascii_addr_x,
	input [7:0] w_ascii_addr_y,
	input [7:0] w_ascii,
	input [7:0] r_ascii_addr_x, // 字符坐标
	input [7:0] r_ascii_addr_y,
	input [3:0] r_ascii_pixel_x, // 像素坐标
	input [3:0] r_ascii_pixel_y,
	output [23:0] vga_data
);

	wire [8:0] font_line;
	wire [7:0] ascii;

	// 8 * 70(x) * 64(y)
	// reg [7:0] mem[4479:0]; // virtual video memory containing ascii codes, ram
	VGAMEM mem(
		.aclr(~rstn),
		.clock(clk),
		.data(w_ascii),
		.wraddress({ w_ascii_addr_x[6:0], w_ascii_addr_y[5:0] }),
		.wren(wren),
		.rdaddress({ r_ascii_addr_x[6:0], r_ascii_addr_y[5:0] }),
		.q(ascii)
	);

	// 9(x) * 256(ascii) * 16(y)
	// reg [8:0] fonts[4095:0]; // char's fonts, rom
	FONTROM fonts(
		.address({ ascii[7:0], r_ascii_pixel_y[3:0] }),
		.clock(clk),
		.q(font_line)
	);
	
	parameter font_color = 24'hFFFFFF;
	parameter back_color = 24'h000000;

	assign vga_data = (w_ascii_addr_x == r_ascii_addr_x && w_ascii_addr_y == r_ascii_addr_y && r_ascii_pixel_x == 4'h8) 
							? (cursor_blink ? font_color : back_color)
							: ((font_line[r_ascii_pixel_x[3:0]]) ? font_color : back_color);

	// always @(posedge clk) begin
	//	if(wren) begin
	//		mem[] = w_ascii;
	//	end
	// end
	
	wire cursor_blink;
	clkgen #(1) cursor_blink_gen(clk, ~rstn, 1'b1, cursor_blink);

endmodule //VGA_Mem