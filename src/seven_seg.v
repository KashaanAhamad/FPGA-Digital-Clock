`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2026 01:02:04
// Design Name: 
// Module Name: seven_seg
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


module seven_seg(
				input wire clk,
				input wire rst,
				
				input wire [3:0] hour,
				input wire [5:0] min,
				
				output reg [6:0] seg,
				output reg [3:0] an
    );
    
reg [16:0] refresh_cnt;
reg [1:0]  digit_sel;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        refresh_cnt <= 0;
        digit_sel   <= 0;
    end else begin
        if (refresh_cnt == 17'd100_000) begin
            refresh_cnt <= 0;
            digit_sel   <= digit_sel + 1;
        end else begin
            refresh_cnt <= refresh_cnt + 1;
        end
    end
end

wire [3:0] hour_tens = hour / 10;
wire [3:0] hour_ones = hour % 10;

wire [3:0] min_tens  = min / 10;
wire [3:0] min_ones  = min % 10;


reg [3:0] digit;

always @(*) begin
    case (digit_sel)
        2'd0: begin
            an    = 4'b1110;
            digit = min_ones;
        end
        2'd1: begin
            an    = 4'b1101;
            digit = min_tens;
        end
        2'd2: begin
            an    = 4'b1011;
            digit = hour_ones;
        end
        2'd3: begin
            an    = 4'b0111;
            digit = hour_tens;
        end
    endcase
end

//Active low
always @(*) begin
    case (digit)
        4'd0: seg = 7'b1000000;
        4'd1: seg = 7'b1111001;
        4'd2: seg = 7'b0100100;
        4'd3: seg = 7'b0110000;
        4'd4: seg = 7'b0011001;
        4'd5: seg = 7'b0010010;
        4'd6: seg = 7'b0000010;
        4'd7: seg = 7'b1111000;
        4'd8: seg = 7'b0000000;
        4'd9: seg = 7'b0010000;
        default: seg = 7'b1111111;
    endcase
end

endmodule

/*Top Module integration
seven_seg u_disp (
    .clk(clk),
    .rst(rst),
    .hour(hour),
    .min(min),
    .seg(seg),
    .an(an)
);
*/
