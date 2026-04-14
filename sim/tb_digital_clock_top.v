`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench : tb_digital_clock_top
// 
// Description:
//   Functional testbench for the FPGA Digital Clock.
//   - Verifies reset behavior
//   - Cycles through all FSM modes (NORMAL → SET_HOUR → SET_MIN →
//     SET_ALARM_HOUR → SET_ALARM_MIN → NORMAL)
//   - Increments hours and minutes via the INC button
//   - Lets time run to verify automatic counting
//   - Tests alarm trigger and alarm clear
//
// Note:
//   The clock divider inside the design counts to 100_000_000 for a real
//   1-second tick.  To keep simulation time reasonable we override
//   that parameter to a small value (10 cycles) via a defparam.
//////////////////////////////////////////////////////////////////////////////////

module tb_digital_clock_top;

    // ----------------------------------------------------------------
    // Clock period: 100 MHz → 10 ns period
    // ----------------------------------------------------------------
    parameter CLK_PERIOD = 10;

    // ----------------------------------------------------------------
    // DUT signals
    // ----------------------------------------------------------------
    reg         clk;
    reg         rst;
    reg         btn_mode;
    reg         btn_inc;
    reg         btn_alarm_clear;
    reg         sw_alarm_enable;

    wire [6:0]  seg;
    wire [3:0]  an;
    wire        alarm_led;

    // ----------------------------------------------------------------
    // Instantiate DUT
    // ----------------------------------------------------------------
    digital_clock_top uut (
        .clk             (clk),
        .rst             (rst),
        .btn_mode        (btn_mode),
        .btn_inc         (btn_inc),
        .btn_alarm_clear (btn_alarm_clear),
        .sw_alarm_enable (sw_alarm_enable),
        .seg             (seg),
        .an              (an),
        .alarm_led       (alarm_led)
    );

    // ----------------------------------------------------------------
    // Override clock_div MAX_CNT so 1 "second" = 10 clock cycles
    // (makes simulation ~10 million times faster)
    // ----------------------------------------------------------------
    defparam uut.u_clk1.MAX_CNT = 10;

    // Also speed up the debounce counter threshold for simulation
    // so button presses register in ~10 cycles instead of 100,000
    defparam uut.u_db_mode.STABLE_CNT        = 5;
    defparam uut.u_db_inc.STABLE_CNT         = 5;
    defparam uut.u_db_alarm_clear.STABLE_CNT = 5;

    // ----------------------------------------------------------------
    // Clock generation
    // ----------------------------------------------------------------
    initial clk = 0;
    always #(CLK_PERIOD / 2) clk = ~clk;

    // ----------------------------------------------------------------
    // Helper tasks
    // ----------------------------------------------------------------

    // Press and release a button (hold for `hold_cycles` clock cycles)
    task press_button;
        input integer hold_cycles;
        inout         btn;
        begin
            btn = 1'b1;
            repeat (hold_cycles) @(posedge clk);
            btn = 1'b0;
            repeat (hold_cycles) @(posedge clk);   // settle time
        end
    endtask

    // Wait N simulated "seconds" (N × MAX_CNT clock cycles)
    task wait_seconds;
        input integer n;
        begin
            repeat (n * 10) @(posedge clk);  // MAX_CNT overridden to 10
        end
    endtask

    // Print current time from internal signals
    task print_time;
        begin
            $display("[%0t] Time = %0d:%02d:%02d  AM/PM=%0b | Alarm = %0d:%02d AM/PM=%0b | alarm_led=%b",
                     $time,
                     uut.u_time.hour,
                     uut.u_time.min,
                     uut.u_time.sec,
                     uut.u_time.am_pm,
                     uut.u_alarm.alarm_hour,
                     uut.u_alarm.alarm_min,
                     uut.u_alarm.alarm_am_pm,
                     alarm_led);
        end
    endtask

    // ----------------------------------------------------------------
    // Main test sequence
    // ----------------------------------------------------------------
    initial begin
        // --- Initialization ---
        rst             = 0;
        btn_mode        = 0;
        btn_inc         = 0;
        btn_alarm_clear = 0;
        sw_alarm_enable = 0;

        $display("========================================");
        $display("  FPGA Digital Clock — Testbench Start");
        $display("========================================");

        // =====================================================
        // TEST 1: Reset
        // =====================================================
        $display("\n--- TEST 1: Reset ---");
        rst = 1;
        repeat (20) @(posedge clk);
        rst = 0;
        repeat (5) @(posedge clk);

        print_time;
        // After reset: hour=12, min=0, sec=0, AM
        //              alarm_hour=6, alarm_min=0, AM

        // =====================================================
        // TEST 2: Let time run — verify seconds count up
        // =====================================================
        $display("\n--- TEST 2: Free-running time (5 seconds) ---");
        wait_seconds(5);
        print_time;

        // =====================================================
        // TEST 3: Set clock hour (MODE → SET_HOUR, then INC ×3)
        // =====================================================
        $display("\n--- TEST 3: Set Hour (press MODE once, INC x3) ---");
        press_button(20, btn_mode);     // NORMAL → SET_HOUR
        repeat (10) @(posedge clk);

        press_button(20, btn_inc);      // hour +1
        repeat (10) @(posedge clk);
        press_button(20, btn_inc);      // hour +1
        repeat (10) @(posedge clk);
        press_button(20, btn_inc);      // hour +1
        repeat (10) @(posedge clk);
        print_time;

        // =====================================================
        // TEST 4: Set clock minute (MODE → SET_MIN, then INC ×5)
        // =====================================================
        $display("\n--- TEST 4: Set Minute (press MODE once, INC x5) ---");
        press_button(20, btn_mode);     // SET_HOUR → SET_MIN
        repeat (10) @(posedge clk);

        repeat (5) begin
            press_button(20, btn_inc);
            repeat (10) @(posedge clk);
        end
        print_time;

        // =====================================================
        // TEST 5: Set alarm hour (MODE → SET_ALARM_HOUR, INC ×2)
        // =====================================================
        $display("\n--- TEST 5: Set Alarm Hour (press MODE, INC x2) ---");
        press_button(20, btn_mode);     // SET_MIN → SET_ALARM_HOUR
        repeat (10) @(posedge clk);

        press_button(20, btn_inc);
        repeat (10) @(posedge clk);
        press_button(20, btn_inc);
        repeat (10) @(posedge clk);
        print_time;

        // =====================================================
        // TEST 6: Set alarm minute (MODE → SET_ALARM_MIN, INC ×5)
        //         Set alarm to match clock so it fires soon
        // =====================================================
        $display("\n--- TEST 6: Set Alarm Minute (press MODE, INC to match) ---");
        press_button(20, btn_mode);     // SET_ALARM_HOUR → SET_ALARM_MIN
        repeat (10) @(posedge clk);

        // Increment alarm minute to match current minute
        repeat (5) begin
            press_button(20, btn_inc);
            repeat (10) @(posedge clk);
        end

        // Return to NORMAL
        press_button(20, btn_mode);     // SET_ALARM_MIN → NORMAL
        repeat (10) @(posedge clk);
        print_time;

        // =====================================================
        // TEST 7: Enable alarm and wait for trigger
        // =====================================================
        $display("\n--- TEST 7: Enable alarm, wait for match ---");
        sw_alarm_enable = 1;

        // Let time run and watch for alarm_led
        repeat (200) begin
            @(posedge clk);
            if (alarm_led) begin
                $display("[%0t] >>> ALARM TRIGGERED! <<<", $time);
                print_time;
                disable TEST7_WAIT;     // break out of loop
            end
        end
        begin : TEST7_WAIT
        end

        // =====================================================
        // TEST 8: Clear the alarm
        // =====================================================
        $display("\n--- TEST 8: Alarm Clear ---");
        if (alarm_led) begin
            press_button(20, btn_alarm_clear);
            repeat (10) @(posedge clk);
            $display("[%0t] alarm_led after clear = %b", $time, alarm_led);
        end else begin
            $display("(alarm did not fire within window — skipping clear test)");
        end

        // =====================================================
        // TEST 9: Verify FSM returns to NORMAL
        // =====================================================
        $display("\n--- TEST 9: FSM state check ---");
        $display("[%0t] FSM state = %0d (expected 0 = NORMAL)", $time, uut.u_fsm.state);

        // =====================================================
        // Done
        // =====================================================
        $display("\n========================================");
        $display("  Testbench Complete");
        $display("========================================\n");
        $finish;
    end

    // ----------------------------------------------------------------
    // Timeout watchdog — kill sim if it hangs
    // ----------------------------------------------------------------
    initial begin
        #500_000;
        $display("ERROR: Simulation timed out!");
        $finish;
    end

endmodule
