set design_name "Nexys4Joystick"

# read design sources (add one line for each file)
read_vhdl {"../ER_1OCTET/er_1octet.vhd" "All7Segments.vhd" "dec7seg.vhd" "diviseurClk.vhd" "MasterJoystick.vhd" "Nexys4Joystick.vhd"}

# read constraints
read_xdc "Nexys4Joystick.xdc"
#read_xdc "Nexys4Joystick_DDR.xdc"

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
