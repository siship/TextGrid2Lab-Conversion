#!/bin/bash

# Script for extracting transcriptions from the TextGrid files
# Sishir Kalita
# Date: Jan 19, 2021
rm -r main.csv

folderName=/home/administrator/Works/CWorks/Raguvaran/TT_out

cd $folderName

find $(pwd) -iname "*.TextGrid" > ../list_files

cd ../

while read line;
do

echo $line

fileName=$(echo $line | rev | cut -d'/' -f1 | rev | cut -d'.' -f1)

echo $fileName

iconv -f utf16 -t utf8 $line -o temp

textString=$(cat temp | grep text | grep -v Unwanted | grep -v Neutral | grep -v unused | grep -v neutral | grep -v Unused | sed 's/\"//g'| sed 's/^ *//g'| cut -d ' ' -f3- | sed -r '/^\s*$/d' | sed 's/\r//g' | paste -sd " ")

echo $textString

echo $fileName,$line,$textString >> main.csv

#rm -r temp

done < list_files
