#!/bin/bash
#-------------------------------------------------------------------------------
# Copyright (C) 2016 Emanuel Sánchez <emanuelsab@gmail.com>
#-------------------------------------------------------------------------------
#
# File Name: check_verilog
#
# Author:
#             - Emanuel Sánchez <emanuelsab@gmail.com>
# Description:
#       Check syntax.
#       Arguments:
#           1.- Input:  File to check syntax
#           2.- Input:  Address folder
#-------------------------------------------------------------------------------

###############################################################################
#                       Sets Folders                                          #
###############################################################################

cd ../..
ROOT_FOLDER="$(pwd)"
FILE_FOLDER=$ROOT_FOLDER/$2
ADDR_FILE=$FILE_FOLDER/$1.v

###############################################################################
#                       Set Files and extentions                              #
###############################################################################

file_check=$1.v

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
#                       Check if filelist exist                               #
###############################################################################
if [ ! -e $FILE_FOLDER ]; then
    echo
    echo -e "ERROR:\t Folder doesn't exist:  $FILE_FOLDER"
    echo
    exit 1
fi

if [ ! -e $ADDR_FILE ]; then
    echo
    echo -e "ERROR:\tFile doesn't exist: $1"
    echo
    exit 1
fi

cd $FILE_FOLDER

if !(iverilog $file_check -W all) then
    echo
    echo -e "ERROR:\tCheck error."
    echo
    exit 1
fi

echo -e "--------------------------------------------------------------------------"
echo -e "INFO:\tCheck syntax: OK."
echo -e "--------------------------------------------------------------------------"
