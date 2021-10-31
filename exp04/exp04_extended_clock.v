module exp04_extended_clock(
	input clk,
	input stop, // SW[9]
	input stopwatch /* SW[8] */, set_alarm /* SW[6] */, alarm_on /* SW[5] */,
	input clearstopwatch /* SW[7] */,
	input modify_hour /* SW[2] */, keyh_n /* KEY[3] */,
	input modify_minute /* SW[1] */, keym_n /* KEY[2] */, keys_n /* KEY[1] */,
	input modify_second /* SW[0] */,


	
	output reg [6:0] hex_second0,
	output reg [6:0] hex_second1,
	output reg [6:0] hex_minute0,
	output reg [6:0] hex_minute1,
	output reg [6:0] hex_hour0,
	output reg [6:0] hex_hour1,
	output reg alarmlight
);
	
	
	
	reg [16:0] total, alarmtotal, stoptotal;
	reg [5:0] sec;
	reg [5:0] min;
	reg [5:0] hour;
	reg [3:0] low_bit_hour;
	reg [3:0] high_bit_hour;
	reg [3:0] low_bit_minute;
	reg [3:0] high_bit_minute;
	reg [3:0] low_bit_second;
	reg [3:0] high_bit_second;

reg [0:24] clk_count = 0;
reg clk_1s;
reg flag;

always @ (posedge clk) begin

	if (clk_count == 25000000) begin
		clk_count <= 0;
		clk_1s <= ~clk_1s;
	end
	
	else
		clk_count <= clk_count + 1;

end

always @ (posedge clk_1s) begin

	if(!stopwatch && !set_alarm) begin
		flag = ~flag;
		if(stop) begin
			sec = sec;
			min = min;
			hour = hour;
			total = total;
			high_bit_hour = hour / 10;
			low_bit_hour = hour % 10;
			high_bit_minute = min / 10;
			low_bit_minute = min % 10;
			high_bit_second = sec / 10;
			low_bit_second = sec % 10;
		end

		else if(modify_hour) begin
			if(keyh_n) begin
				hour = hour;
				min = min;
				sec = sec;
				total = total;
			end

			else begin
				total = (total + 3600) % 86400;
				hour = total / 3600;
				min = (total % 3600) / 60;
				sec = total % 60;
			end

			if(flag) begin
				high_bit_hour = 10;
				low_bit_hour = 10;
				high_bit_minute = min / 10;
				low_bit_minute = min % 10;
				high_bit_second = sec / 10;
				low_bit_second = sec % 10;
			end

			else begin
				high_bit_hour = hour / 10;
				low_bit_hour = hour % 10;
				high_bit_minute = min / 10;
				low_bit_minute = min % 10;
				high_bit_second = sec / 10;
				low_bit_second = sec % 10;
			end
		end

		else if(modify_minute) begin
			if(keym_n) begin
				hour = hour;
				min = min;
				sec = sec;
				total = total;
			end

			else begin
				total = (total + 60) % 86400;
				hour = total / 3600;
				min = (total % 3600) / 60;
				sec = total % 60;
			end

			if(flag) begin
				high_bit_hour = hour / 10;
				low_bit_hour = hour % 10;
				high_bit_minute = 10;
				low_bit_minute = 10;
				high_bit_second = sec / 10;
				low_bit_second = sec % 10;
			end

			else begin
				high_bit_hour = hour / 10;
				low_bit_hour = hour % 10;
				high_bit_minute = min / 10;
				low_bit_minute = min % 10;
				high_bit_second = sec / 10;
				low_bit_second = sec % 10;
			end
		end

		else if(modify_second) begin
			if(keys_n) begin
				hour = hour;
				min = min;
				sec = sec;
				total = total;
			end

			else begin
				total = (total + 1) % 86400;
				hour = total / 3600;
				min = (total % 3600) / 60;
				sec = total % 60;
			end

			if(flag) begin
				high_bit_hour = hour / 10;
				low_bit_hour = hour % 10;
				high_bit_minute = min / 10;
				low_bit_minute = min % 10;
				high_bit_second = 10;
				low_bit_second = 10;
			end

			else begin
				high_bit_hour = hour / 10;
				low_bit_hour = hour % 10;
				high_bit_minute = min / 10;
				low_bit_minute = min % 10;
				high_bit_second = sec / 10;
				low_bit_second = sec % 10;
			end
		end

		else begin
			total = (total + 1) % 86400;
			hour = total / 3600;
			min = (total % 3600) / 60;
			sec = total % 60;
			high_bit_hour = hour / 10;
			low_bit_hour = hour % 10;
			high_bit_minute = min / 10;
			low_bit_minute = min % 10;
			high_bit_second = sec / 10;
			low_bit_second = sec % 10;

			if(alarm_on && (total == alarmtotal))
				alarmlight = 1;
			else
				alarmlight = 0;
		end
	end
	else if(stopwatch) begin
		if(clearstopwatch) begin
			total = (total + 1) % 86400;
			stoptotal = 0;
			hour = stoptotal / 3600;
			min = (stoptotal % 3600) / 60;
			sec = stoptotal % 60;
			high_bit_hour = hour / 10;
			low_bit_hour = hour % 10;
			high_bit_minute = min / 10;
			low_bit_minute = min % 10;
			high_bit_second = sec / 10;
			low_bit_second = sec % 10;
		end

		else if(stop) begin
			hour = hour;
			min = min;
			sec = sec;
			stoptotal = stoptotal;
			total = (total + 1) % 86400;
			high_bit_hour = hour / 10;
			low_bit_hour = hour % 10;
			high_bit_minute = min / 10;
			low_bit_minute = min % 10;
			high_bit_second = sec / 10;
			low_bit_second = sec % 10;
		end

		else begin
			total = (total + 1) % 86400;
			stoptotal = (stoptotal + 1) % 86400;
			hour = stoptotal / 3600;
			min = (stoptotal % 3600) / 60;
			sec = stoptotal % 60;
			high_bit_hour = hour / 10;
			low_bit_hour = hour % 10;
			high_bit_minute = min / 10;
			low_bit_minute = min % 10;
			high_bit_second = sec / 10;
			low_bit_second = sec % 10;
		end
	end
	
	else begin
		flag = ~flag;
		total = (total + 1) % 86400;

		hour = alarmtotal / 3600;
		min = (alarmtotal % 3600) / 60;
		sec = alarmtotal % 60;

		if(modify_hour) begin
			if(keyh_n) begin
				hour = hour;
				min = min;
				sec = sec;
				alarmtotal = alarmtotal;
			end

			else begin
				alarmtotal = (alarmtotal + 3600) % 86400;
				hour = alarmtotal / 3600;
				min = (alarmtotal % 3600) / 60;
				sec = alarmtotal % 60;
			end

			if(flag) begin
				high_bit_hour = 10;
				low_bit_hour = 10;
				high_bit_minute = min / 10;
				low_bit_minute = min % 10;
				high_bit_second = sec / 10;
				low_bit_second = sec % 10;
			end

			else begin
				high_bit_hour = hour / 10;
				low_bit_hour = hour % 10;
				high_bit_minute = min / 10;
				low_bit_minute = min % 10;
				high_bit_second = sec / 10;
				low_bit_second = sec % 10;
			end
		end

		else if(modify_minute) begin
			if(keym_n) begin
				hour = hour;
				min = min;
				sec = sec;
				alarmtotal = alarmtotal;
			end

			else begin
				alarmtotal = (alarmtotal + 60) % 86400;
				hour = alarmtotal / 3600;
				min = (alarmtotal % 3600) / 60;
				sec = alarmtotal % 60;
			end

			if(flag) begin
				high_bit_hour = hour / 10;
				low_bit_hour = hour % 10;
				high_bit_minute = 10;
				low_bit_minute = 10;
				high_bit_second = sec / 10;
				low_bit_second = sec % 10;
			end

			else begin
				high_bit_hour = hour / 10;
				low_bit_hour = hour % 10;
				high_bit_minute = min / 10;
				low_bit_minute = min % 10;
				high_bit_second = sec / 10;
				low_bit_second = sec % 10;
			end
		end

		else if(modify_second) begin
			if(keys_n) begin
				hour = hour;
				min = min;
				sec = sec;
				alarmtotal = alarmtotal;
			end

			else begin
				alarmtotal = (alarmtotal + 1) % 86400;
				hour = alarmtotal / 3600;
				min = (alarmtotal % 3600) / 60;
				sec = alarmtotal % 60;
			end

			if(flag) begin
				high_bit_hour = hour / 10;
				low_bit_hour = hour % 10;
				high_bit_minute = min / 10;
				low_bit_minute = min % 10;
				high_bit_second = 10;
				low_bit_second = 10;
			end

			else begin
				high_bit_hour = hour / 10;
				low_bit_hour = hour % 10;
				high_bit_minute = min / 10;
				low_bit_minute = min % 10;
				high_bit_second = sec / 10;
				low_bit_second = sec % 10;
			end
		end

		else begin
			hour = hour;
			min = min;
			sec = sec;
			alarmtotal = alarmtotal;

			if(flag) begin
				high_bit_hour = 10;
				low_bit_hour = 10;
				high_bit_minute = 10;
				low_bit_minute = 10;
				high_bit_second = 10;
				low_bit_second = 10;
			end
		end

	end

	case(high_bit_hour)
		0: hex_hour1 = 7'b1000000;
		1: hex_hour1 = 7'b1111001;
		2: hex_hour1 = 7'b0100100;
		3: hex_hour1 = 7'b0110000;
		4: hex_hour1 = 7'b0011001;
		5: hex_hour1 = 7'b0010010;
		6: hex_hour1 = 7'b0000010;
		7: hex_hour1 = 7'b1111000;
		8: hex_hour1 = 7'b0000000;
		9: hex_hour1 = 7'b0010000;
		10:hex_hour1 = 7'b1111111;
	endcase

	case(low_bit_hour)
		0: hex_hour0 = 7'b1000000;
		1: hex_hour0 = 7'b1111001;
		2: hex_hour0 = 7'b0100100;
		3: hex_hour0 = 7'b0110000;
		4: hex_hour0 = 7'b0011001;
		5: hex_hour0 = 7'b0010010;
		6: hex_hour0 = 7'b0000010;
		7: hex_hour0 = 7'b1111000;
		8: hex_hour0 = 7'b0000000;
		9: hex_hour0 = 7'b0010000;
		10:hex_hour0 = 7'b1111111;
	endcase

	case(high_bit_minute)
		0: hex_minute1 = 7'b1000000;
		1: hex_minute1 = 7'b1111001;
		2: hex_minute1 = 7'b0100100;
		3: hex_minute1 = 7'b0110000;
		4: hex_minute1 = 7'b0011001;
		5: hex_minute1 = 7'b0010010;
		6: hex_minute1 = 7'b0000010;
		7: hex_minute1 = 7'b1111000;
		8: hex_minute1 = 7'b0000000;
		9: hex_minute1 = 7'b0010000;
		10:hex_minute1 = 7'b1111111;
	endcase

	case(low_bit_minute)
		0: hex_minute0 = 7'b1000000;
		1: hex_minute0 = 7'b1111001;
		2: hex_minute0 = 7'b0100100;
		3: hex_minute0 = 7'b0110000;
		4: hex_minute0 = 7'b0011001;
		5: hex_minute0 = 7'b0010010;
		6: hex_minute0 = 7'b0000010;
		7: hex_minute0 = 7'b1111000;
		8: hex_minute0 = 7'b0000000;
		9: hex_minute0 = 7'b0010000;
		10:hex_minute0 = 7'b1111111;
	endcase

	case(high_bit_second)
		0: hex_second1 = 7'b1000000;
		1: hex_second1 = 7'b1111001;
		2: hex_second1 = 7'b0100100;
		3: hex_second1 = 7'b0110000;
		4: hex_second1 = 7'b0011001;
		5: hex_second1 = 7'b0010010;
		6: hex_second1 = 7'b0000010;
		7: hex_second1 = 7'b1111000;
		8: hex_second1 = 7'b0000000;
		9: hex_second1 = 7'b0010000;
		10:hex_second1 = 7'b1111111;
	endcase

	case(low_bit_second)
		0: hex_second0 = 7'b1000000;
		1: hex_second0 = 7'b1111001;
		2: hex_second0 = 7'b0100100;
		3: hex_second0 = 7'b0110000;
		4: hex_second0 = 7'b0011001;
		5: hex_second0 = 7'b0010010;
		6: hex_second0 = 7'b0000010;
		7: hex_second0 = 7'b1111000;
		8: hex_second0 = 7'b0000000;
		9: hex_second0 = 7'b0010000;
		10:hex_second0 = 7'b1111111;
	endcase

end

endmodule
