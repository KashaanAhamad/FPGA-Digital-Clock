`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2026 01:13:30
// Design Name: 
// Module Name: digital_clock_top
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


module digital_clock_top(
						input  wire clk,
						input  wire rst,
					
						input  wire btn_mode,
						input  wire btn_inc,
						input  wire btn_alarm_clear,
					
						input  wire sw_alarm_enable, 
					
						output wire [6:0] seg,
						output wire [3:0] an,
						output wire alarm_led
    );
    
	// 1 Hz tick
    wire sec_tick;

    // Current time
    wire [5:0] sec;
    wire [5:0] min;
    wire [3:0] hour;
    wire       am_pm;

// FSM control signals
    wire inc_hour;
    wire inc_min;
    wire inc_alarm_hour;
    wire inc_alarm_min;
    
 // Alarm
    wire alarm_on;
    wire [3:0] alarm_hour;
    wire [5:0] alarm_min;
    wire alarm_am_pm;
	
	// Button clean + pulse signals
    wire mode_clean, mode_pulse;
    wire inc_clean, inc_pulse;
    wire alarm_clear_clean, alarm_clear_pulse;
	
	
	
	clock_div u_clk1 (
						.clk(clk),
						.rst(rst),
						.sec_tick(sec_tick)
					);
					
	time_Counter u_time (
						.clk(clk),
						.rst(rst),
						.sec_tick(sec_tick),
						.sec(sec),
						.min(min),
						.hour(hour),
						.am_pm(am_pm)
					);
				
	// =========================================================
    // BUTTON HANDLING
    // Each button = debounce + pulse_gen
    // =========================================================

    // -------- MODE button --------
    Debounce u_db_mode (
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

    // -------- INC button --------
    Debounce u_db_inc (
        .clk(clk),
        .rst(rst),
        .noisy_btn(btn_inc),
        .clean_btn(inc_clean)
    );

    pulse_gen u_pg_inc (
        .clk(clk),
        .rst(rst),
        .level(inc_clean),
        .pulse(inc_pulse)
    );

    // -------- ALARM CLEAR button --------
    Debounce u_db_alarm_clear (
        .clk(clk),
        .rst(rst),
        .noisy_btn(btn_alarm_clear),
        .clean_btn(alarm_clear_clean)
    );

    pulse_gen u_pg_alarm_clear (
        .clk(clk),
        .rst(rst),
        .level(alarm_clear_clean),
        .pulse(alarm_clear_pulse)
    );


	fsm_Control u_fsm (
						.clk(clk),
						.rst(rst),
						.mode_btn(mode_pulse),
						.inc_btn(inc_pulse),
						.inc_hour(inc_hour),
						.inc_min(inc_min),
						.inc_alarm_hour(inc_alarm_hour),
						.inc_alarm_min(inc_alarm_min)
					);

	alarm u_alarm (
					.clk(clk),
					.rst(rst),
				
					.curr_hour(hour),
					.curr_min(min),
					.curr_sec(sec),
					.curr_am_pm(am_pm),
				
					.inc_alarm_hour(inc_alarm_hour),
					.inc_alarm_min(inc_alarm_min),
				
					.alarm_enable(sw_alarm_enable),
					.alarm_clear(alarm_clear_pulse),
				
					.alarm_on(alarm_on),
					.alarm_hour(alarm_hour),
					.alarm_min(alarm_min),
					.alarm_am_pm(alarm_am_pm)
				);
			
	seven_seg u_disp (
						.clk(clk),
						.rst(rst),
						.hour(hour),
						.min(min),
						.seg(seg),
						.an(an)
					);
	
	assign alarm_led = alarm_on;


endmodule
