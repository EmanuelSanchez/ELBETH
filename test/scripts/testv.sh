#!/bin/bash

#-------------------------------------------------------------------------------
#
# File Name: testbench_verilog
#
# Author:
#             - Emanuel Sánchez <emanuelsab@gmail.com>
# Description:
#       Simulate the Test Bench with Icarus Verilog and use the GtkWave
#       Arguments:
#           1.- Input:  verilog module to simulate
#           2.- Input:  name of the test bench verilog module
#-------------------------------------------------------------------------------
# Instructions:
#       1- Open the terminal (Ctrl + Alt + T)
#       2- Go to test benche folder
#       3- Execute: sh testv.sh name_verilog_module name_verilog_test_bench
#       
#-------------------------------------------------------------------------------

###############################################################################
#                       Files names amd extentions 					          #
###############################################################################

file_verilog=$1.v
file_verilog_tb=$2.v
file_vvp=$2.vvp
file_vcd=$2.vcd

###############################################################################
#                       Check if filelist exist                               #
###############################################################################

if [ ! -e $file_verilog ]; then
    echo
    echo -e "ERROR:\t Verilog module file doesn't exist:  $file_verilog"
    echo
    exit 1
fi

if [ ! -e $file_verilog_tb ]; then
    echo
    echo -e "ERROR:\t Test bench file doesn't exist:  $file_verilog_tb"
    echo
    exit 1
fi

###############################################################################
#                       Compile verilog module                                #
###############################################################################

iverilog -o $file_vvp $file_verilog_tb $file_verilog

###############################################################################
#                       Check if module was compiled                          #
###############################################################################

if [ ! -e $file_vvp ]; then
    echo
    echo -e "ERROR:\t The vvp file was not create:  $file_vvp"
    echo
    exit 1
fi

###############################################################################
#                 ejecute the verilog compile file                            #
###############################################################################

vvp $file_vvp

###############################################################################
#                       Check if vcd file exist                               #
###############################################################################

if [ ! -e $file_vcd ]; then
    echo
    echo -e "ERROR:\t Imposible read vcd file\n\n\t Verify the vcd file name in the test bench:  $file_vcd"
    echo
    exit 1
fi

###############################################################################
#                       Simulating the verilog module                         #
###############################################################################

gtkwave $file_vcd