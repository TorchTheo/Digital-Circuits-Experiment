module ALU(
	input [31:0] dataa,
	input [31:0] datab,
	input [3:0]  ALUctr,
	output less,
	output zero,
	output reg [31:0] aluresult);

//add your code here
	reg l = 0;
	reg z = 0;
	reg [31:0] temp[1:0];
	always @ (*) begin
		temp[0] = 32'b0;
		temp[1] = 32'b11111111111111111111111111111111;
		if(ALUctr == 4'b0)
			aluresult = dataa + datab;
		else if(ALUctr == 4'b1000)
			aluresult = dataa - datab;
		else if(ALUctr[2:0] == 3'b001)
			aluresult = dataa << datab[4:0];
		else if(ALUctr == 4'b0010) begin
			z = dataa == datab ? 1 : 0;
			if(dataa[31] == datab[31])
				aluresult = dataa < datab;
			else 
				aluresult = dataa > datab;
			l = aluresult[0];
		end
		else if(ALUctr == 4'b1010) begin
			z = dataa == datab ? 1 : 0;
			aluresult = dataa < datab;
			l = aluresult[0];
		end
		else if(ALUctr[2:0] == 3'b011)
			aluresult = datab;
		else if(ALUctr[2:0] == 3'b100)
			aluresult = dataa ^ datab;
		else if(ALUctr == 4'b0101)
			aluresult = dataa >> datab[4:0];
		else if(ALUctr == 4'b1101)
			aluresult = (dataa >> datab[4:0]) + (temp[dataa[31]] << (32 - datab[4:0]));
		else if(ALUctr[2:0] == 3'b110)
			aluresult = dataa | datab;
		else if(ALUctr[2:0] == 3'b111)
			aluresult = dataa & datab;
		if(ALUctr != 4'b0010 && ALUctr != 4'b1010)
			z = aluresult == 0 ? 1 : 0;
	end
	assign zero = z;
	assign less = l;

endmodule //ALU