set design_name "Nexys4"

# read design sources (add one line for each file)
read_vhdl {"clkUnit.vhd" "diviseurClk10Hz.vhd" "Nexys4.vhd" "diviseurClk.vhd"}

# read constraints
read_xdc "Nexys4_DDR.xdc"

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
