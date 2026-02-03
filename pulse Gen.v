`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2026 00:33:47
// Design Name: 
// Module Name: pulse_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pulse_gen(
				input wire clk,
				input wire rst,
				input wire level,
				output reg pulse
	);
	
	reg level_d;
	
	always @(posedge clk or posedge rst)begin
		if(rst) begin
			level_d<=0;
			pulse <=0;
		end else begin
			pulse <= level & ~level_d;
			level_d <= level;
		end
	end
endmodule


/*
wire mode_clean, mode_pulse;

debounce u_db_mode (
    .clk(clk),
    .rst(rst),
    .noisy_btn(btn_mode),
    .clean_btn(mode_clean)
);

pulse_gen u_pg_mode (
    .clk(clk),
    .rst(rst),
    .level(mode_clean),
    .pulse(mode_pulse)
);
*/
