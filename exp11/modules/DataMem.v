module DataMem(
	input  [31:0] addr,
	output reg [31:0] dataout,
	input  [31:0] datain,
	input  rdclk,
	input  wrclk,
	input [2:0] memop,
	input we);

reg [31:0] mem[2048];
reg [7:0] dataoutb;
reg [15:0] dataouth;

always @(posedge rdclk) begin
	case (memop)
		3'b000: begin
			case (addr[1:0])
				0: dataoutb = mem[addr >> 2][7:0];
				1: dataoutb = mem[addr >> 2][15:8];
				2: dataoutb = mem[addr >> 2][23:16];
				3: dataoutb = mem[addr >> 2][31:24];
			endcase
			dataout[7:0] = dataoutb;
			dataout[31:8] = {24{dataoutb[7]}};
		end
		3'b001: begin
			case (addr[1])
				0: dataouth = mem[addr >> 2][15:0];
				1: dataouth = mem[addr >> 2][31:16];
			endcase
			dataout[16:0] = dataouth;
			dataout[31:16] = {16{dataouth[15]}};
		end
		3'b100: case (addr[1:0])
			0: dataout = mem[addr >> 2][7:0];
			1: dataout = mem[addr >> 2][15:8];
			2: dataout = mem[addr >> 2][23:16];
			3: dataout = mem[addr >> 2][31:24];
		endcase
		3'b101: case (addr[1])
			0: dataout = mem[addr >> 2][15:0];
			1: dataout = mem[addr >> 2][31:16];
		endcase
		3'b010: dataout = mem[addr >> 2];
		default: dataout = 0;
	endcase
end

always @(posedge wrclk) begin
	if(we) begin
		case (memop)
			3'b000: begin
				case (addr[1:0])
					0: mem[addr >> 2][7:0] = datain[7:0];
					1: mem[addr >> 2][15:8] = datain[7:0];
					2: mem[addr >> 2][23:16] = datain[7:0];
					3: mem[addr >> 2][31:24] = datain[7:0];
				endcase
			end
			3'b001: begin
				case (addr[1])
					0: mem[addr >> 2][15:0] = datain[15:0];
					1: mem[addr >> 2][31:16] = datain[15:0];
				endcase
			end
			3'b010: mem[addr >> 2] = datain;
		endcase
	end
end

endmodule