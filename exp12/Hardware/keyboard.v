module keyboard(input clk,
	input clrn,
	input ps2_clk,
	input ps2_data,
	// output reg [7:0] key_count,
	output reg [7:0] cur_key,
	output [7:0] ascii_key,
//	output ready,
//	output overflow,
	// output [7:0] dbg
//    output reg [1:0] state
	output valid
	);

	wire ready, overflow;
	
wire [7:0] data;
reg nextdata_n;
reg [1:0] state;

reg shift_on_off, cap_on_off;

parameter S0 = 0;
parameter S1 = 1;
parameter S2 = 2;
parameter S3 = 3;

//scancode to ascii conversion
scancode_ram scancode_r(clk, cur_key, {cap_on_off, shift_on_off}, ascii_key);
//PS2 interface
ps2_keyboard ps2_kb(clk, clrn, ps2_clk, ps2_data, data, ready, nextdata_n, overflow, sampling);

// assign dbg[4:0] = {cap_on_off, shift_on_off, state[1:0], nextdata_n};
assign valid = ~state[0] & ready;

initial begin
//	key_count = 0;
	cur_key = 8'bz;
	nextdata_n = 1;
	state = S1;
	shift_on_off = 0;
	cap_on_off = 0;
end

always @ (negedge clk) begin
    if(clrn == 0) begin
        state <= S1;
        nextdata_n <= 1;
//        key_count <= 0;
        cur_key <= 0;
		  shift_on_off <= 0;
		  cap_on_off <= 0;
    end
    else if(ready && !overflow) begin
        nextdata_n <= 0;

        case(state)
        S1: if(data != 8'hF0) begin
                state <= S0;
//                key_count <= key_count + 1;
                cur_key <= data;
					 if(data == 8'h58) begin
						cap_on_off <= ~cap_on_off;
					 end
					 if(data == 8'h12 || data == 8'h59) begin
						shift_on_off <= 1;
					 end
            end 
            else begin
                state <= S3;
//                cur_key <= 0;
            end
        S0: if(data == 8'hF0) begin
                state <= S3;
//                cur_key <= 0;
            end 
            else begin
                state <= S2;
                cur_key <= data;
            end
        S2: if(data == 8'hF0) begin
                state <= S3;
//                cur_key <= 0;
            end 
            else begin
                state <= S2;
                cur_key <= data;
            end
        S3: if(data != 8'hF0) begin
                state <= S1;
//                cur_key <= 0;
					if(data == 8'h12 || data == 8'h59) begin
						shift_on_off <= 0;
					 end
            end 
            else begin
                state <= S3;
//                cur_key <= 0;
            end
        endcase

    end
    else begin
        nextdata_n <= 1;
    end
end

//always @ (*) begin
//	if(ready) begin
//		nextdata_n = 0;
//		cur_key = data;
//	end
//	else begin
//		nextdata_n = 1;
//	end
//end

endmodule
