module exp04(clk,en,stop,clear,endone,seg0,seg1);
	input clk;
	input en;
	input stop;
	input clear;
	output reg endone;
	output reg [6:0] seg0;
	output reg [6:0] seg1;
	reg [3:0] highBit;
	reg [3:0] lowBit;
	reg [6:0] counter;
	reg clk_1s;
	reg [24:0]count_clk;
	
	initial
	begin
	counter=0;
	highBit=0;
	lowBit=0;
	count_clk=0;
	clk_1s=0;
	end
	
	always@(posedge clk)
		if(count_clk==25000000)
			begin
				count_clk<=0;
				clk_1s<=~clk_1s;
			end
		else
			count_clk<=count_clk+1;
	
	always@(posedge clk_1s)
	begin
		if(!en)
			begin
				highBit=0;
				lowBit=0;
				counter=0;
				seg0=7'b1111111;
				seg1=7'b1111111;
			end
		else
			begin
				
				endone=0;
				
				if(clear)
					begin
					highBit=0;
					lowBit=0;
					counter=0;
					end
				
				else if(stop)
					begin
					highBit=highBit;
					lowBit=lowBit;
					counter=counter;
					end
				
				else
					begin
						if(counter==99)
							begin
							counter=(counter+1)%100;
							endone=1;
							end
						else
							begin
							counter=(counter+1)%100;
							endone=0;
							end
					end
				
				if(counter<100)
					begin
					lowBit=counter%10;
					highBit=(counter-(counter%10))/10;
					end
				else
					begin
					lowBit=0;
					highBit=0;
					end
			
				case(highBit)
				0: seg1 = 7'b1000000;
				1: seg1 = 7'b1111001;
				2: seg1 = 7'b0100100;
				3: seg1 = 7'b0110000;
				4: seg1 = 7'b0011001;
				5: seg1 = 7'b0010010;
				6: seg1 = 7'b0000010;
				7: seg1 = 7'b1111000;
				8: seg1 = 7'b0000000;
				9: seg1 = 7'b0010000;
				endcase
				case(lowBit)
				0: seg0 = 7'b1000000;
				1: seg0 = 7'b1111001;
				2: seg0 = 7'b0100100;
				3: seg0 = 7'b0110000;
				4: seg0 = 7'b0011001;
				5: seg0 = 7'b0010010;
				6: seg0 = 7'b0000010;
				7: seg0 = 7'b1111000;
				8: seg0 = 7'b0000000;
				9: seg0 = 7'b0010000;
				endcase
				
			end
	end
	
	
endmodule
