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
EXPECTED_ARGS=2
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
SIMULATING_FOLDER=$TESTS_FOLDER/$2
cd ../
ROOT_FOLDER="$(pwd)"
SOURCES_FOLDER=$ROOT_FOLDER/src

###############################################################################
#                       Set Files and extentions                              #
###############################################################################

file_verilog_tb=$SIMULATING_FOLDER/$1.v
file_vvp=$1.vvp
file_vcd=$1.vcd

###############################################################################
#                       Check if filelist exist                               #
###############################################################################

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

cp $SIMULATING_FOLDER/$1.v $SOURCES_FOLDER/$1.v
cd $SOURCES_FOLDER
iverilog -o $file_vvp $file_verilog_tb
rm $SOURCES_FOLDER/$1.v 

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

vvp $file_vvp
rm $SOURCES_FOLDER/$file_vvp

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
mv $SOURCES_FOLDER/$1.vcd $SIMULATING_FOLDER/$1.vcd