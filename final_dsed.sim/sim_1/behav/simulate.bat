@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim dsed_audio_tb_behav -key {Behavioral:sim_1:Functional:dsed_audio_tb} -tclbatch dsed_audio_tb.tcl -view C:/Users/Jorge/Documents/VHDL/final_dsed/controlador_tb_behav.wcfg -view C:/Users/Jorge/Documents/VHDL/final_dsed/dsed_audio_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
