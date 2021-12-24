module exp07(

	input clk,
	input clk_ps2,
	input ps2_in,
	output led,
	output [6:0]HEX0,
	output [6:0]HEX1,
	output [6:0]HEX2,
	output [6:0]HEX3,
	output [6:0]HEX4,
	output [6:0]HEX5
);

	wire [7:0]in_data;
	wire [7:0]out;
	wire [7:0]times;
	wire [7:0]ASCII;
	wire ready;
	wire nextdata_n;
	wire if_conflict;
	wire if_capital;
	reg clrn=1;
	wire overflow;
	assign led=(if_conflict==1);

	
	ps2_keyboard ps2Keyboard(clk,clrn,clk_ps2,ps2_in,in_data,ready,nextdata_n,overflow);
	
	ana_insert anaInsert(clk,ready,in_data,out,times,nextdata_n,if_conflict,if_capital,HEX4,HEX5);
	
	show_keycode showKeycode(out,HEX0,HEX1);
	
	show_ascii showAscii(ASCII,if_capital,HEX2,HEX3);
	
	translate(out,clk,ASCII);
	
endmodule
