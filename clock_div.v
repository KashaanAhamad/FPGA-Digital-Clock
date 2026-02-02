`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2026 22:35:13
// Design Name: 
// Module Name: clock_div
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


module clock_div(
				input wire clk,		//100MHz
				input wire rst,
				output reg sec_tick	//1-cycle pulse every Second
    );
    parameter MAX_CNT=100_000_000;
    reg [26:0] count;	
    
    always@(posedge clk or negedge rst)begin
    	if(rst)begin
    		count<=0;
    		sec_tick<=1'b0;
    	end else begin
    		if(count ==MAX_CNT-1)begin
    			count<=0;
    			sec_tick<=1'b1;
    		end else begin
    			count<= count +1;
    			sec_tick<= 1'b0;
    		end
    	end
    end
endmodule
