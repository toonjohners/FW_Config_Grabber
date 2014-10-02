#!/bin/bash
#Author: John McCormack
#Date: 01/10/2014
#
################################################################################################
#
# Description:
# - This script will compare two configuration directories and find any differences between them
# - If there are differences found it will save the outputs to files in a directory named as 
# - {day_month_year.hour.min} 
# - In this directory, you will find a diff file with a list of differneces + the files
#
# 
#
# Arguments:
# - First and second 
# Revision History
# Version 1.0
# - John McCormack
#
###############################################################################################

## date format ##
NOW=`date +"%d_%b_%Y.%H.%M"`
TIME=`date '+DATE: %d/%m/%y TIME:%H:%M:%S'`

#######################
# Get the Name of the 2 Diirectory files to compare
######################

echo "Please enter the name of the FIRST configuration directory"
read FIRST

echo "Please enter the name of the SECOND configuration directory"
read SECOND



#################### Check to see if there is a difference found
if [[ -n $(diff -r $FIRST $SECOND) ]]; then
        FILES=`diff -r $FIRST $SECOND | grep diff | awk '{print $3}'`
        echo > .diff
        echo "Difference found"
        mkdir $NOW | echo "The Directory "$NOW" has been created with the files"
else
    echo "No Diff Found!"
fi


IFS=$'\n'


################## If there is a difference create the files and diff file

if [ -d $NOW ]
    then
                for i in `diff -r $FIRST $SECOND | grep diff | awk '{print $3,$4}'`; do
                        echo "sdiff $i" >> .diff
                done

                for a in `cat .diff` ; do
                        FILE=`echo $a  | awk -F "/" '{print $NF}'`
                        BEFORE=`echo $a | awk '{print $2}'`
                        AFTER=`echo $a | awk '{print $3}'`
                        mkdir $NOW/$FILE
                        eval $a > $NOW/$FILE/$FILE.diff
                        cp $BEFORE $NOW/$FILE/$FILE.first
                        cp $AFTER $NOW/$FILE/$FILE.second
                done

fi

if [ -e .diff ]
then
        mv .diff ./$NOW/List_of_Diffs
fi
exit 0

