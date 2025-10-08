#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/mnt/n7fs/applications/2025/vivado-2019/Vivado/2019.2/ids_lite/ISE/bin/lin64:/mnt/n7fs/applications/2025/vivado-2019/Vivado/2019.2/bin
else
  PATH=/mnt/n7fs/applications/2025/vivado-2019/Vivado/2019.2/ids_lite/ISE/bin/lin64:/mnt/n7fs/applications/2025/vivado-2019/Vivado/2019.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/ave9761/git_perso/2a/archi/vivado/diviseur_clk/diviseur_clk.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .init_design.begin.rst
EAStep vivado -log Nexys4.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source Nexys4.tcl -notrace


