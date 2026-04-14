## ============================================================================
## Basys 3 Constraints File — Digital Clock Project
## Board:  Digilent Basys 3  (Xilinx Artix-7, XC7A35TCPG236-1)
## ============================================================================

## ----------------------------------------------------------------------------
## Clock — 100 MHz on-board oscillator
## ----------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports {clk}]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}]

## ----------------------------------------------------------------------------
## Reset — Center push button (active-high)
## ----------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN U18  IOSTANDARD LVCMOS33 } [get_ports {rst}]

## ----------------------------------------------------------------------------
## Push Buttons
## ----------------------------------------------------------------------------
# MODE button — Left push button
set_property -dict { PACKAGE_PIN W19  IOSTANDARD LVCMOS33 } [get_ports {btn_mode}]

# INC button — Right push button
set_property -dict { PACKAGE_PIN T17  IOSTANDARD LVCMOS33 } [get_ports {btn_inc}]

# ALARM CLEAR button — Down push button
set_property -dict { PACKAGE_PIN U17  IOSTANDARD LVCMOS33 } [get_ports {btn_alarm_clear}]

## ----------------------------------------------------------------------------
## Slide Switches
## ----------------------------------------------------------------------------
# Alarm Enable — SW0
set_property -dict { PACKAGE_PIN V17  IOSTANDARD LVCMOS33 } [get_ports {sw_alarm_enable}]

## ----------------------------------------------------------------------------
## Seven-Segment Display — Cathodes (active-low)
##   seg[6] = CA  (segment a)
##   seg[5] = CB  (segment b)
##   seg[4] = CC  (segment c)
##   seg[3] = CD  (segment d)
##   seg[2] = CE  (segment e)
##   seg[1] = CF  (segment f)
##   seg[0] = CG  (segment g)
## ----------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports {seg[6]}]
set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports {seg[5]}]
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports {seg[4]}]
set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports {seg[3]}]
set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS33 } [get_ports {seg[2]}]
set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS33 } [get_ports {seg[1]}]
set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports {seg[0]}]

## ----------------------------------------------------------------------------
## Seven-Segment Display — Anodes (active-low)
##   an[3] = leftmost digit   (hour tens)
##   an[2]                    (hour ones)
##   an[1]                    (minute tens)
##   an[0] = rightmost digit  (minute ones)
## ----------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN U2   IOSTANDARD LVCMOS33 } [get_ports {an[0]}]
set_property -dict { PACKAGE_PIN U4   IOSTANDARD LVCMOS33 } [get_ports {an[1]}]
set_property -dict { PACKAGE_PIN V4   IOSTANDARD LVCMOS33 } [get_ports {an[2]}]
set_property -dict { PACKAGE_PIN W4   IOSTANDARD LVCMOS33 } [get_ports {an[3]}]

## ----------------------------------------------------------------------------
## LEDs
## ----------------------------------------------------------------------------
# Alarm LED — LD0
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports {alarm_led}]

## ----------------------------------------------------------------------------
## Configuration
## ----------------------------------------------------------------------------
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
