module show_ascii(
	input [7:0]out,
	input captital,
	output reg [6:0]HEX2,
	output reg [6:0]HEX3
);
	reg [7:0]ascii;
	
	always @ (out or captital)
		begin
		if(out==8'b0)      //松开按键后数码管熄灭，而此时输出变量值为0
			begin
			HEX2=7'b1111111;
			HEX3=7'b1111111;
			end
		else
			begin
			if(captital&&out>=8'd97&&out<=8'd122)    //大写显示
				ascii=out-8'd32;
			else
				ascii=out;
			end
		if(out!=8'b0)       //防止数码管显示再次被改变
			begin
			case(ascii[3:0])
				8'd0:HEX2=7'b1000000;
				8'd1:HEX2=7'b1111001;
				8'd2:HEX2=7'b0100100;
				8'd3:HEX2=7'b0110000;
				8'd4:HEX2=7'b0011001;
				8'd5:HEX2=7'b0010010;
				8'd6:HEX2=7'b0000010;
				8'd7:HEX2=7'b1111000;
				8'd8:HEX2=7'b0000000;
				8'd9:HEX2=7'b0010000;
				8'd10:HEX2=7'b0001000;
				8'd11:HEX2=7'b0000011;
				8'd12:HEX2=7'b1000110;
				8'd13:HEX2=7'b0100001;
				8'd14:HEX2=7'b0000110;
				8'd15:HEX2=7'b0001110;
				default:HEX2=7'b1111111;
			endcase
			case(ascii[7:4])
				8'd0:HEX3=7'b1000000;
				8'd1:HEX3=7'b1111001;
				8'd2:HEX3=7'b0100100;
				8'd3:HEX3=7'b0110000;
				8'd4:HEX3=7'b0011001;
				8'd5:HEX3=7'b0010010;
				8'd6:HEX3=7'b0000010;
				8'd7:HEX3=7'b1111000;
				8'd8:HEX3=7'b0000000;
				8'd9:HEX3=7'b0010000;
				8'd10:HEX3=7'b0001000;
				8'd11:HEX3=7'b0000011;
				8'd12:HEX3=7'b1000110;
				8'd13:HEX3=7'b0100001;
				8'd14:HEX3=7'b0000110;
				8'd15:HEX3=7'b0001110;
				default:HEX3=7'b1111111;
			endcase
			end
		end
endmodule