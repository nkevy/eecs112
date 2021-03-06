


#!/bin/bash
$source/setup.csh
$source/pre_compile.csh
vlog -64 -sv -f $design/rtl.cfg
vlog -64 -sv -f $verif/tb.cfg -work work
vopt -64 tb_top -o tb_top_opt +acc -work work
vsim -64 -c tb_top_opt -do sim.do
vsim -64 -gui -view waveform.wlf &
echo "Compiled"
