module exp05_reg_arm(

	// ram port
	input [3:0] addr, // SW[3:0]
	input clock,// KEY[0]
	input [3:0] data_in, // SW[7:4]
	input wr_en, // SW[8]
	output reg [6:0] ram_hex_low, // HEX0
	output reg [6:0] ram_hex_high,

	//reg port
	input wr_reg, // SW[9]
	output reg [6:0] reg_hex_low, // HEX1
	output reg [6:0] reg_hex_high
);

reg [7:0] regs[15:0];

wire [7:0] data_out;
reg [7:0] reg_out;


ram1port my_ram(
	.address(addr),
	.clock(clock),
	.data(data_in),
	.wren(wr_en),
	.q(data_out)
);

initial begin
	$readmemh("D:/Projects/GitHub/Digital-Design-Experiment/exp05_reg_arm/mem1.txt", regs, 0, 15);
end

always @ (addr) begin
	reg_out = regs[addr];
end

always @ (posedge clock) begin
	if(wr_reg) begin
		regs[addr] = data_in;
	end
end

always @ (reg_out) begin
    case (reg_out[3:0])
        0: reg_hex_low = 7'b1000000;
		1: reg_hex_low = 7'b1111001;
		2: reg_hex_low = 7'b0100100;
		3: reg_hex_low = 7'b0110000;
		4: reg_hex_low = 7'b0011001;
		5: reg_hex_low = 7'b0010010;
		6: reg_hex_low = 7'b0000010;
		7: reg_hex_low = 7'b1111000;
		8: reg_hex_low = 7'b0000000;
		9: reg_hex_low = 7'b0010000;
		10:reg_hex_low = 7'b0001000;
        11:reg_hex_low = 7'b0000011;
        12:reg_hex_low = 7'b1000110;
        13:reg_hex_low = 7'b0100001;
        14:reg_hex_low = 7'b0000110;
        15:reg_hex_low = 7'b0001110;
    endcase
	 case (reg_out[7:4])
        0: reg_hex_high = 7'b1000000;
		1: reg_hex_high = 7'b1111001;
		2: reg_hex_high = 7'b0100100;
		3: reg_hex_high = 7'b0110000;
		4: reg_hex_high = 7'b0011001;
		5: reg_hex_high = 7'b0010010;
		6: reg_hex_high = 7'b0000010;
		7: reg_hex_high = 7'b1111000;
		8: reg_hex_high = 7'b0000000;
		9: reg_hex_high = 7'b0010000;
		10:reg_hex_high = 7'b0001000;
        11:reg_hex_high = 7'b0000011;
        12:reg_hex_high = 7'b1000110;
        13:reg_hex_high = 7'b0100001;
        14:reg_hex_high = 7'b0000110;
        15:reg_hex_high = 7'b0001110;
    endcase
end

always @ (data_out) begin
    case (data_out[3:0])
        0: ram_hex_low = 7'b1000000;
		1: ram_hex_low = 7'b1111001;
		2: ram_hex_low = 7'b0100100;
		3: ram_hex_low = 7'b0110000;
		4: ram_hex_low = 7'b0011001;
		5: ram_hex_low = 7'b0010010;
		6: ram_hex_low = 7'b0000010;
		7: ram_hex_low = 7'b1111000;
		8: ram_hex_low = 7'b0000000;
		9: ram_hex_low = 7'b0010000;
		10:ram_hex_low = 7'b0001000;
        11:ram_hex_low = 7'b0000011;
        12:ram_hex_low = 7'b1000110;
        13:ram_hex_low = 7'b0100001;
        14:ram_hex_low = 7'b0000110;
        15:ram_hex_low = 7'b0001110;
    endcase
	 case (data_out[7:4])
        0: ram_hex_high = 7'b1000000;
		1: ram_hex_high = 7'b1111001;
		2: ram_hex_high = 7'b0100100;
		3: ram_hex_high = 7'b0110000;
		4: ram_hex_high = 7'b0011001;
		5: ram_hex_high = 7'b0010010;
		6: ram_hex_high = 7'b0000010;
		7: ram_hex_high = 7'b1111000;
		8: ram_hex_high = 7'b0000000;
		9: ram_hex_high = 7'b0010000;
		10:ram_hex_high = 7'b0001000;
        11:ram_hex_high = 7'b0000011;
        12:ram_hex_high = 7'b1000110;
        13:ram_hex_high = 7'b0100001;
        14:ram_hex_high = 7'b0000110;
        15:ram_hex_high = 7'b0001110;
    endcase
end

endmodule
