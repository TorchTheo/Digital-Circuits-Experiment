module ana_insert(
	input clk,
	input ready,
	input [7:0]in,
	output reg [7:0]out,
	output reg [7:0]key_count,
	output reg nextdata_n,
	output reg if_conflict,
	output reg if_capital,
	output reg [6:0]HEX4,
	output reg [6:0]HEX5
);
	reg [2:0]state=3'b001;
	reg [7:0]pre=0;
	initial key_count=0;
	
	always @ (posedge clk)
		if(clk)
			begin
			if(ready)
				begin
				case(state)
					3'b001:  //空状态
					begin
					if(in!=8'hf0) 
						begin
						if(in!=pre)
							begin
							if(key_count==8'd99) 
								key_count<=8'd00;
							else 
								key_count<=key_count+1;
							end
						out<=in;
						pre<=in;
						state<=3'b010;
						end
					else
						begin
						out<=0; 
						pre<=0;
						if_conflict<=0;
						if_capital<=0;
						state<=3'b100;
						end
					end
					3'b010:  //按键状态
						begin
						if(in!=8'hf0) 
							begin
							if(in!=pre)
								begin
								if(key_count==8'd99) 
									key_count<=8'd00;
								else 
									key_count<=key_count+1;
								end
//							if((pre==8'h12&&in!=8'h12)||(pre==8'h14&&in!=8'h14))
							if((pre==8'h12&&in==8'h14)||(pre==8'h14&&in==8'h12))
								if_conflict<=1;
							else
								if_conflict<=0;
							if((pre==8'h12&&in!=8'h12)||(pre==8'h58&&in!=8'h58))
								if_capital<=1;
							else
								if_capital<=0;
							out<=in;
							pre<=in;
							state<=3'b010;
							end
						else 
							begin 
							state<=3'b100; 
							out<=0;
							pre<=0;
							if_conflict<=0;
							if_capital<=0;
							end
						end
					3'b100:  //松完等待接收0xf0之后的信号
						begin
						if(in!=8'hf0) 
							state<=3'b001;
						else 
							begin 
							state<=3'b100; 
							out<=0; 
							pre<=0;
							if_conflict<=0;
							if_capital<=0;
							end
						end
					endcase
					nextdata_n<=1;
					end
				else
					nextdata_n<=0;
				end
	
	always @ (key_count)
		begin
		case(key_count%10)
			0:HEX4=7'b1000000;
			1:HEX4=7'b1111001;
			2:HEX4=7'b0100100;
			3:HEX4=7'b0110000;
			4:HEX4=7'b0011001;
			5:HEX4=7'b0010010;
			6:HEX4=7'b0000010;
			7:HEX4=7'b1111000;
			8:HEX4=7'b0000000;
			9:HEX4=7'b0010000;
		endcase
		case((key_count-key_count%10)/10)
			0:HEX5=7'b1000000;
			1:HEX5=7'b1111001;
			2:HEX5=7'b0100100;
			3:HEX5=7'b0110000;
			4:HEX5=7'b0011001;
			5:HEX5=7'b0010010;
			6:HEX5=7'b0000010;
			7:HEX5=7'b1111000;
			8:HEX5=7'b0000000;
			9:HEX5=7'b0010000;
		endcase
		end

endmodule