module logiLayer(
input clk,
input ps2_clk,
input ps2_data,
input vga_clk,
input VGA_BLANK_N,
input [9:0]h_addr,
input [9:0]v_addr,

output reg [23:0] vga_data,
output reg LEDR
);

integer x; // row
integer y; // col
integer x_; // pixel row
integer y_; // pixel col
integer index;
integer asc;

wire ovfl;
wire [7:0] data;
wire ready;


(* ram_init_file = "vga_font.mif" *) reg [11:0] data_matrix [4095:0];
reg [7:0] v_ram [2100:0]; // 显存，存放某位置字符的ascii
reg [11:0] matrix_line;
(* ram_init_file = "scancode.mif" *) reg [7:0] ram [255:0]; // scancode -> ascii
(* ram_init_file = "scancode_cap.mif" *) reg [7:0] ram_cap [255:0]; // scancode -> ascii shift模式下
reg [7:0] effdata;
reg nextdata_n;
reg state;
reg capslock;
reg shift;
reg [9:0] counth; // 像素行
reg [9:0] countv; // 像素列
reg [6:0] line_col; // 字符行
reg [10:0] line_row; // 字符列
reg [7:0] ascii;
reg [6:0] line [29:0];

ps2_keyboard keyboard(clk, 1, ps2_clk, ps2_data, data, ready, nextdata_n, ovfl);

initial 
begin
	vga_data = 0;
	x = 0;
	y = 0;
	x_ = 0;
	y_ = 0;
	index = 0;
	asc = 0;
	counth = 0;
	countv = 0;
	line_col = 0;
	line_row = 0;
	ascii = 0;
	matrix_line = 0;
	effdata = 0;
	capslock = 0;
	shift = 0;
	state = 0;
end

// handle the keyboard logic

always @ (*)
	LEDR = capslock ^ shift;

always @ (posedge clk)
begin
	if(ready==1)
	begin
		if(data == 8'h58)
		begin
			if(state == 0 && capslock == 0)
			begin
				capslock = 1;
			end
			else if(state == 1 && capslock == 0)
			begin
				capslock = 0;
			end
			else if(state == 1 && capslock == 1)
			begin
				capslock = 1;
			end
			else if(state == 0 && capslock == 1)
			begin
				capslock = 0;
			end
		end
		if(data == 8'h12 || data == 8'h59)
		begin
			if(state == 0 && shift == 0)
			begin
				shift = 1;
			end
			else if(state == 1 && shift == 0)
			begin
				shift = 1;
			end
			else if(state == 1 && shift == 1)
			begin
				shift = 0;
			end
			else if(state == 0 && shift == 1)
			begin
				shift = 0;
			end
		end
		if((data != 8'hf0)&&(state == 0))
		begin
			if(data == 8'h58||data==8'h12||data==8'h59||data==8'h66||data==8'h5a)
			begin
				if(data == 8'h66)
				begin
					v_ram[(line_row << 6) + (line_row << 2) + (line_row << 1) + line_col] = 0;
					if(line_col > 0) begin
						line_col = line_col - 1;
						counth = counth - 9;
					end
					else
					begin
						if(line_row > 0) begin
							line_row =  line_row - 1;
							line_col = line[line_row];
							countv = countv - 16;
							counth = (line[line_row] << 3) + line_row;
						end
						else begin
							line_row = 0;
							line_col = 0;
							counth = 0;
							countv = 0;
						end
					end
				end
				else if(data == 8'h5a)
				begin
					line[line_row] = line_col;
					line_row = line_row + 1;
					countv = countv + 16;	
					line_col = 0;
					counth = 0;
				end
			end
			else
			begin
			effdata = data;
			if(line_col < 69)
			begin 
				line_col = line_col + 1;
				counth = counth + 9;
			end
			else
			begin
				line[line_row] = line_col;
				counth = 0;
				line_col = 0;
				line_row = line_row + 1;
				countv = countv + 16;
			end
			if(capslock^shift == 0)
			begin
				ascii = ram[data];
			end
			else
			begin
				ascii = ram_cap[data];
			end
			v_ram[(line_row << 6) + (line_row << 2) + (line_row << 1) + line_col] = ascii;
			end
		end
		else if((data == 8'hf0)&&(state == 0))
		begin
			//this data is f0
			//so this data is eff
			//and let the count ++
			//and let the state become 1 to show this f0
			effdata = data;
			state = 1;
		end
		else if((data != 8'hf0)&&(state == 1))
		begin
			//this data is not f0 and predata is f0
			//so this data is not eff
			//and let the state become 0 to show this is not f0
			state = 0;
			effdata = 8'hf0;
		end
	//done
		nextdata_n=0;
		end
	end
	

always @ (posedge vga_clk)
begin
	if(h_addr >= 0 && h_addr < 640)
	begin
		y =  v_addr[8:4];
		y_ =  v_addr[3:0];
		asc = v_ram[(y << 6) + (y << 2) + (y << 1) + x];
		index = (asc << 4) + y_;
		matrix_line = data_matrix[index];
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

