module Shifter (
	input 			[31:0]	dataa,
	input 			[31:0] 	datab,
	input 					l_or_r,
	input 					a_or_h,
	output 	reg 	[31:0] 	result
);

always @(*) begin
	casex ({a_or_h, l_or_r})
		2'bx0: begin
			result = dataa << datab[4:0];
		end
		2'b01: begin
			result = (dataa >> datab[4:0]) | ({32{dataa[31]}} << (32 - datab[4:0]));
		end
		2'b11: begin
			result = dataa >> datab[4:0];
		end
		default: begin
			result = 32'bx;
		end	
	endcase
end

endmodule //Shifter