#!/bin/bash

# Script to extract timestamps and corresponding transcription
# Uses: ./textGrid2Lab.sh $tierNumber
# If the required segmentation markings are in the tier 1. Then, 
# ./textGrid2Lab.sh 1

# Author : Sishir Kalita (Armsoftech.air)
# email id: sisiitg@gmail.com
# Date: 12 March, 2020

# Path of TextGrid files Folder
path1='/home/administrator/Works/Data-Arm/telegu_transcription/textGrid'  

# Directory where created lab files will be stored
path2='/home/administrator/Works/Data-Arm/telegu_transcription/textGridLab'     	

# Path of temporary files
path3='/home/administrator/Works/Data-Arm/telegu_transcription/tmp'	       	

textPatt="item"

cd $path1

ls *.TextGrid > $path3/TextGrid_list.txt

cd ..

cat $path3/TextGrid_list.txt | sed 's/.TextGrid//g' > $path3/TextGrid_list1.txt

whichItem=$1
onee=1

while read line

do

iterNo1=$(expr "$whichItem" + "$onee")
iterNo2=$(expr "$whichItem" + "$onee" + "$onee")

iterNo1Val=$iterNo1""p
iterNo2Val=$iterNo2""p

echo $iterNo1Val

grep -n $textPatt "$path1/$line.TextGrid" |  cut -d':' -f1 > $path3/grepp.txt

n1=$(cat $path3/grepp.txt | sed -n $iterNo1Val)
n2=$(cat $path3/grepp.txt | sed -n $iterNo2Val)

#echo $n1 $n2 > $path3/new.txt

cat "$path1/$line.TextGrid" | sed -n "${n1},${n2}p" > $path3/mainn.txt

# This part is written by Abhishek Dey

cat $path3/mainn.txt | grep xmin | cut -d'=' -f2 | sed 's/""/sil/g'| sed 's/"//g'| tail -n+2 | sed 's/ //g' > $path3/temp_xmin.txt

cat $path3/mainn.txt | grep xmax | cut -d'=' -f2 | sed 's/""/sil/g'| sed 's/"//g'| tail -n+2 | sed 's/ //g' > $path3/temp_xmax.txt

cat $path3/mainn.txt | grep text | cut -d'=' -f2 | sed 's/""/sil/g'| sed 's/"//g'| tail -n+0 > $path3/temp_trans.txt

while read -r -u1 line1; read -r -u2 line2; read -r -u3 line3;

do

echo $line1 $line2 $line3 >> $path3/output1.txt

done 1<$path3/temp_xmin.txt 2<$path3/temp_xmax.txt 3<$path3/temp_trans.txt

cat $path3/output1.txt | sed 's/\r/\t/g' >  "$path2/$line.lab"

rm -rf $path3/output1.txt

echo "----------------------------------------------------------"
echo "Converting $line.TextGrid -------------------->  $line.lab"
echo "----------------------------------------------------------"

done < $path3/TextGrid_list1.txt


echo "-----------------------------Done-------------------------"



