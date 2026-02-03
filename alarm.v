`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2026 00:44:46
// Design Name: 
// Module Name: alarm
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


module alarm(
			input wire clk,
			input wire rst,
			
			input wire [3:0] curr_hour,
			input wire [5:0] curr_min,
			input wire [5:0] curr_sec,
			input wire 		curr_am_pm,
			
			input wire inc_alarm_hour,
			input wire inc_alarm_min,
			
			input wire alarm_enable,
			input wire alarm_clear,
			
			output reg alarm_on,
			output reg [3:0] alarm_hour,
			output reg [5:0] alarm_min,
			output reg 		alarm_am_pm			
    );
    
always @(posedge clk or posedge rst) begin
	if(rst)begin
		alarm_hour <= 4'd6;		//default 6:00 AM
		alarm_min <= 6'd0;
		alarm_am_pm <= 1'b0;
	end else begin
		if(inc_alarm_hour)begin
			if (alarm_hour == 4'd11) begin
                alarm_hour  <= 4'd12;
                alarm_am_pm <= ~alarm_am_pm;
            end else if(alarm_hour == 4'd12)begin
            	alarm_hour <=4'd1;
            end else begin
            	alarm_hour <= alarm_hour + 1;
            end
		end
		
		if (inc_alarm_min) begin
            alarm_min <= (alarm_min == 6'd59) ? 0 : alarm_min + 1;
        end
	end
end

//ALARM Core Working
always @(posedge clk or posedge rst) begin
    if (rst) begin
        alarm_on <= 1'b0;
    end else begin
        if (alarm_clear) begin
            alarm_on <= 1'b0;
        end else if (alarm_enable &&
                     curr_hour  == alarm_hour &&
                     curr_min   == alarm_min  &&
                     curr_sec   == 6'd0       &&
                     curr_am_pm == alarm_am_pm) begin
            alarm_on <= 1'b1;
        end
    end
end

endmodule

//Top module instantiation
/*
alarm u_alarm (
    .clk(clk),
    .rst(rst),

    .cur_hour(hour),
    .cur_min(min),
    .cur_sec(sec),
    .cur_am_pm(am_pm),

    .inc_alarm_hour(inc_alarm_hour),
    .inc_alarm_min(inc_alarm_min),

    .alarm_enable(sw_alarm_enable),
    .alarm_clear(btn_alarm_clear),

    .alarm_on(alarm_on),
    .alarm_hour(alarm_hour),
    .alarm_min(alarm_min),
    .alarm_am_pm(alarm_am_pm)
);
*/
