module show_keycode(
	input [7:0]out,
	output reg [6:0]HEX0,
	output reg [6:0]HEX1
);
	always @ (out)
		begin
		if(out==8'h00)
			begin
			HEX0=7'b1111111;
			HEX1=7'b1111111;
			end
		else
			begin
			case(out%16)
				0:HEX0=7'b1000000;
				1:HEX0=7'b1111001;
				2:HEX0=7'b0100100;
				3:HEX0=7'b0110000;
				4:HEX0=7'b0011001;
				5:HEX0=7'b0010010;
				6:HEX0=7'b0000010;
				7:HEX0=7'b1111000;
				8:HEX0=7'b0000000;
				9:HEX0=7'b0010000;
				10:HEX0=7'b0001000;
				11:HEX0=7'b0000011;
				12:HEX0=7'b1000110;
				13:HEX0=7'b0100001;
				14:HEX0=7'b0000110;
				15:HEX0=7'b0001110;
				default:HEX0=7'b1111111;
			endcase
			case((out-(out%16))/16)
				0:HEX1=7'b1000000;
				1:HEX1=7'b1111001;
				2:HEX1=7'b0100100;
				3:HEX1=7'b0110000;
				4:HEX1=7'b0011001;
				5:HEX1=7'b0010010;
				6:HEX1=7'b0000010;
				7:HEX1=7'b1111000;
				8:HEX1=7'b0000000;
				9:HEX1=7'b0010000;
				10:HEX1=7'b0001000;
				11:HEX1=7'b0000011;
				12:HEX1=7'b1000110;
				13:HEX1=7'b0100001;
				14:HEX1=7'b0000110;
				15:HEX1=7'b0001110;
				default:HEX1=7'b1111111;
			endcase
			end
		end

endmodule