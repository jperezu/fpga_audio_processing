@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 6fe248a97fef4921ac7e6026104f67fa -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot filtered_to_matlab_func_impl xil_defaultlib.filtered_to_matlab -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
