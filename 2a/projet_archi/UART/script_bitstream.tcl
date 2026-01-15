set design_name "UART_FPGA_N4"

# read design sources (add one line for each file)
read_vhdl {"../clkUnit/clkUnit.vhd" "UART_FPGA_N4.vhd" "../clkUnit/diviseurClk.vhd" "compteur16.vhd" "controleReception.vhd" "ctrlUnit.vhd" "echoUnit.vhd" "RxUnit.vhd" "UART.vhd" "../TxUnit/TxUnit.vhd"}

# read constraints
read_xdc "UART_FPGA_N4_DDR.xdc"

# DO NOT TOUCH BELOW THIS LINE
set fpga_part "xc7a100tcsg324-1"

# synth
synth_design -top "${design_name}" -part "${fpga_part}"

# place and route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force "${design_name}.bit"

# exit batch mode
exit