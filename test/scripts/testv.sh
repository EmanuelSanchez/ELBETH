#!/bin/bash

#-------------------------------------------------------------------------------
#
# File Name: testbench_verilog
# Created On    : Mon Jan  31 09:46:00 2016
# Last Modified : 2016-02-24 09:31:26
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
#                            Parameter Check                                  #
###############################################################################
EXPECTED_ARGS=3
if [ $# -ne $EXPECTED_ARGS ]; then
    echo
    echo -e "ERROR\t: wrong number of arguments"
    echo
    exit 1
fi

###############################################################################
#                       Sets Folders                                          #
###############################################################################

SCRIPT_FOLDER="$(pwd)"
cd ../
TESTS_FOLDER="$(pwd)"
SIMULATING_FOLDER=$TESTS_FOLDER/$3

cd ../
ROOT_FOLDER="$(pwd)"
cd src
SOURCES_FOLDER=$ROOT_FOLDER/src

###############################################################################
#                       Set Files and extentions                              #
###############################################################################

file_verilog=$SOURCES_FOLDER/$1.v
file_verilog_tb=$SIMULATING_FOLDER/$2.v
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

if [ ! -e $SIMULATING_FOLDER ]; then
    echo
    echo -e "ERROR:\t Test folder doesn't exist:  $SIMULATING_FOLDER"
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
    echo -e "ERROR:\t The files file was not compled:  $file_vvp"
    echo
    exit 1
fi

###############################################################################
#                 ejecute the verilog compile file                            #
###############################################################################

cd /$SIMULATING_FOLDER
mv /$SOURCES_FOLDER/$file_vvp /$SIMULATING_FOLDER
vvp $file_vvp
rm /$SIMULATING_FOLDER/$file_vvp

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