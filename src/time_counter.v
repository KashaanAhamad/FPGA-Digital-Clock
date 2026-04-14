`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2026 22:46:37
// Design Name: 
// Module Name: time_Counter
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


module time_Counter(
					input wire clk,
					input wire rst,
					input wire sec_tick,
					output reg [5:0] sec,
					output reg [5:0] min,
					output reg [3:0] hour,
					output reg 		 am_pm
    );
    
    always @(posedge clk or posedge rst)begin
    	if(rst)begin
    		sec<=0;
    		min<=0;
    		hour<=4'd12;
    		am_pm<= 0;	//AM	
    	end else if(sec_tick) begin
    		//Second
    		if(sec ==6'd59)begin
    			sec <=0;
    			
    		//Minute
    		if(min == 6'd59)begin
    			min<=0;
    			
    		//Hour
    		if(hour ==4'd11)begin
    			hour <=4'd12;
    			am_pm <=~am_pm;	
    		end else if(hour == 4'd12)begin
    			hour <= 4'd1;
    		end else begin
    			hour <=hour +1;
    		end
    	end else begin
    		min = min +1;
    	end
    
    end else begin
    	sec<=sec +1;
   end
   end
end
endmodule
