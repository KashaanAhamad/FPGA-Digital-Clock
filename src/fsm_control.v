`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2026 23:31:39
// Design Name: 
// Module Name: fsm_Control
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


module fsm_Control(
					input wire clk,
					input wire rst,
					
					input wire mode_btn,
					input wire inc_btn,
					
					output reg [2:0] state,
					
					output wire inc_hour,
					output wire inc_min,
					output wire inc_alarm_min,
					output wire inc_alarm_hour 
					);
parameter NORMAL=3'd0, SET_HOUR=3'd1, SET_MIN=3'd2 ,
		  SET_ALARM_HOUR=3'd3 , SET_ALARM_MIN=3'd4;
		  
reg [2:0] next_state;

always @(posedge clk or posedge rst)begin
	if(rst)
		state<= NORMAL;
	else
		state<=next_state;
end	
	
always@(*)begin
	next_state=state;
		case(state)
			NORMAL:
					if(mode_btn) next_state=SET_HOUR;
			SET_HOUR:
					if(mode_btn) next_state=SET_MIN;
			SET_MIN:
					if(mode_btn) next_state=SET_ALARM_HOUR;
			SET_ALARM_HOUR:
					if(mode_btn) next_state=SET_ALARM_MIN;
			SET_ALARM_MIN:
					if(mode_btn) next_state=NORMAL;
			default: 
					next_state =NORMAL;
		endcase	
end

assign inc_hour		  =(state == SET_HOUR) && inc_btn;
assign inc_min		  =(state == SET_MIN) && inc_btn;
assign inc_alarm_hour =(state == SET_ALARM_HOUR) && inc_btn;
assign inc_alarm_min  =(state == SET_ALARM_MIN) && inc_btn;
endmodule
