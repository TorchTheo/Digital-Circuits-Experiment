module exp06 (
	input clk,
	input [7:0] seed,
	input set,
	output reg [6:0] lowBit,
	output reg [6:0] highBit
);

reg [7:0] dout;


initial begin
	dout = 8'b00000001;
end

always @ (posedge clk) begin
	if(set)
		dout = seed;
	else
		if(dout == 0)
			dout = 8'b00000001;
		else
			dout = {dout[4] ^ dout[3] ^ dout[2] ^ dout[0], dout[7:1]};

end

always @ (*) begin

	case(dout[3:0])
	  0: lowBit = 7'b1000000;
	  1: lowBit = 7'b1111001;
	  2: lowBit = 7'b0100100;
	  3: lowBit = 7'b0110000;
	  4: lowBit = 7'b0011001;
	  5: lowBit = 7'b0010010;
	  6: lowBit = 7'b0000010;
	  7: lowBit = 7'b1111000;
	  8: lowBit = 7'b0000000;
     9: lowBit = 7'b0010000;
	  10:lowBit = 7'b0001000;
	  11:lowBit = 7'b0000011;
	  12:lowBit = 7'b1000110;
	  13:lowBit = 7'b0100001;
	  14:lowBit = 7'b0000110;
	  15:lowBit = 7'b0001110;
	
	endcase
	
	case(dout[7:4])
	  0: highBit = 7'b1000000;
	  1: highBit = 7'b1111001;
	  2: highBit = 7'b0100100;
	  3: highBit = 7'b0110000;
	  4: highBit = 7'b0011001;
	  5: highBit = 7'b0010010;
	  6: highBit = 7'b0000010;
	  7: highBit = 7'b1111000;
	  8: highBit = 7'b0000000;
     9: highBit = 7'b0010000;
	  10:highBit = 7'b0001000;
	  11:highBit = 7'b0000011;
	  12:highBit = 7'b1000110;
	  13:highBit = 7'b0100001;
	  14:highBit = 7'b0000110;
	  15:highBit = 7'b0001110;
	
	endcase

end


endmodule
