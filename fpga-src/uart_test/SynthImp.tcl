#-----------------------------------------------------------
# Vivado v2018.2 (64-bit)
# SW Build 2258646 on Thu Jun 14 20:02:38 MDT 2018
# IP Build 2256618 on Thu Jun 14 22:10:49 MDT 2018
# Start of session at: Tue Nov 20 15:33:10 2018
# Process ID: 9419
# Current directory: /home/johndoe/gitdir/capstone/uart-branch/fpga-src
# Command line: vivado
# Log file: /home/johndoe/gitdir/capstone/uart-branch/fpga-src/vivado.log
# Journal file: /home/johndoe/gitdir/capstone/uart-branch/fpga-src/vivado.jou
#-----------------------------------------------------------
open_project /home/johndoe/gitdir/capstone/joint-uart-branch/fpga-src/cmoda7-gpio-test/vivado_proj/Cmod-A7-35T-GPIO.xpr
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs synth_1 -jobs 2
wait_on_run synth_1
launch_runs impl_1 -jobs 2
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 2
wait_on_run impl_1
