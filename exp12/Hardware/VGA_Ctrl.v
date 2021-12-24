module VGA_Ctrl (
	input pclk, //25MHz 时钟
	input reset, // 置位
	input [23:0] vga_data, // 上层模块提供的VGA 颜色数据
	output [9:0] h_addr, // 提供给上层模块的当前扫描像素点坐标
	output [9:0] v_addr,
	output hsync, // 行同步和列同步信号
	output vsync,
	output valid, // 消隐信号
	output [7:0] vga_r, // 红绿蓝颜色信号
	output [7:0] vga_g,
	output [7:0] vga_b

	, output reg [7:0] ascii_ind_x // 提供给上层模块的当前扫描字符坐标
	, output reg [7:0] ascii_ind_y
	, output reg [3:0] pixel_ind_x // 提供给上层模块的当前字模像素坐标
	, output reg [3:0] pixel_ind_y
);

	//640x480 分辨率下的VGA 参数设置
	parameter h_frontporch = 96;
	parameter h_active = 144;
	parameter h_backporch = 784;
	parameter h_total = 800;
	parameter v_frontporch = 2;
	parameter v_active = 35;
	parameter v_backporch = 515;
	parameter v_total = 525;

	// ascii matrix 70 * 30
	parameter ascii_ind_x_total = 70;
	parameter ascii_ind_y_total = 30;
	// ascii font 9 * 16
	parameter ascii_font_x_total = 9;
	parameter ascii_font_y_total = 16;

	// 像素计数值
	reg [9:0] x_cnt;
	reg [9:0] y_cnt;
	wire h_valid;
	wire v_valid;

	always @(posedge reset or posedge pclk) // 行像素计数
		if (reset == 1'b1) begin
			x_cnt <= 1;
		end
		else begin
			if (x_cnt == h_total) begin
				x_cnt <= 1;
			end
			else begin
				x_cnt <= x_cnt + 10'd1;
			end
		end

	always @(posedge pclk) // 列像素计数
		if (reset == 1'b1) begin
			y_cnt <= 1;
		end
		else begin
			if (y_cnt == v_total & x_cnt == h_total) begin
				y_cnt <= 1;
			end
			else if (x_cnt == h_total) begin
				y_cnt <= y_cnt + 10'd1;
			end
		end
		
	wire cnt_valid;
	assign cnt_valid = (x_cnt > h_active + 5) & (x_cnt <= h_backporch - 5) & (y_cnt > v_active) & (y_cnt <= v_backporch);
	
	always @(posedge pclk) begin
		if(reset == 1'b1) begin
			ascii_ind_x <= 0;
		end
		else if(cnt_valid) begin
			if(pixel_ind_x + 1 == ascii_font_x_total) begin
				if(ascii_ind_x + 1 == ascii_ind_x_total) begin
					ascii_ind_x <= 0;
				end
				else begin
					ascii_ind_x <= ascii_ind_x + 1;
				end
			end
		end
	end

	always @(posedge pclk) begin
		if(reset == 1'b1) begin
			ascii_ind_y <= 0;
		end
		else if(cnt_valid) begin
			if((pixel_ind_y + 1 == ascii_font_y_total) && (ascii_ind_x + 1 == ascii_ind_x_total) && (pixel_ind_x + 1 == ascii_font_x_total)) begin
				if((ascii_ind_y + 1 == ascii_ind_y_total)) begin
					ascii_ind_y <= 0;
				end
				else begin
					ascii_ind_y <= ascii_ind_y + 1;
				end
			end
		end
	end

	always @(posedge pclk) begin
		if(reset == 1'b1) begin
			pixel_ind_x <= 0;
		end
		else if(cnt_valid) begin
			if(pixel_ind_x + 1 == ascii_font_x_total) begin
				pixel_ind_x <= 0;
			end
			else begin
				pixel_ind_x <= pixel_ind_x + 1;
			end
		end
	end

	always @(posedge pclk) begin
		if(reset == 1'b1) begin
			pixel_ind_y <= 0;
		end
		else if(cnt_valid) begin
			if((ascii_ind_x + 1 == ascii_ind_x_total) && (pixel_ind_x + 1 == ascii_font_x_total)) begin
				if(pixel_ind_y + 1 == ascii_font_y_total) begin
					pixel_ind_y <= 0;
				end
				else begin
					pixel_ind_y <= pixel_ind_y + 1;
				end
			end
		end
	end

	// 生成同步信号
	assign hsync = (x_cnt > h_frontporch);
	assign vsync = (y_cnt > v_frontporch);

	// 生成消隐信号
	assign h_valid = (x_cnt > h_active) & (x_cnt <= h_backporch);
	assign v_valid = (y_cnt > v_active) & (y_cnt <= v_backporch);
	assign valid = h_valid & v_valid;

	// 计算当前有效像素坐标
	assign h_addr = h_valid ? (x_cnt - 10'd145) : {10{1'b0}};
	assign v_addr = v_valid ? (y_cnt - 10'd36) : {10{1'b0}};

	// 设置输出的颜色值
	assign vga_r = vga_data[23:16];
	assign vga_g = vga_data[15:8];
	assign vga_b = vga_data[7:0];

endmodule //VGA_Ctrl