`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2026 00:27:27
// Design Name: 
// Module Name: Debounce
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


module Debounce(
				input wire clk,
				input wire rst,
				input wire noisy_btn,
				output reg clean_btn
    );
    reg [16:0] count; //~1ms at 100MHz
    reg btn_sync;
    
    always @(posedge clk or posedge rst)begin
    	if(rst)begin
    		count<=0;
    		clean_btn<=0;
    		btn_sync<=0;
    	end else begin
    		btn_sync<= noisy_btn;
    		
    		if(btn_sync == clean_btn)begin
    			count <=0;
    		end else begin
    			count <=count +1;
    			if(count == 17'd100_000)begin
    				clean_btn <= btn_sync;
    				count <=0;
    			end
    		end
    	end
    	
    end
endmodule
