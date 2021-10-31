module exp08(
   input clk,
	input reset,
	output [7:0] VGA_R,
	output [7:0] VGA_G,
	output [7:0] VGA_B,
	output VGA_HS,VGA_VS,
	output VGA_CLK,
	output VGA_BLANK_N,
	output VGA_SYNC_N
);

assign VGA_SYNC_N = 0;
		
				
clkgen #(25000000) vgaclks(clk,reset,1'b1,VGA_CLK);

wire [9:0] h_addr;
wire [9:0] v_addr;
wire [3:0] r,g,b;

ram ram({h_addr,v_addr[8:0]},VGA_CLK,r,g,b);
	
	
vga_ctrl VGA(VGA_CLK,reset,{r,4'b0000,g,4'b0000,b,4'b0000},h_addr,v_addr,VGA_HS,VGA_VS,VGA_BLANK_N,VGA_R,VGA_G,VGA_B);	


endmodule 