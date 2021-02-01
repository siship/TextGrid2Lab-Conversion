#!/bin/bash

# Script to extract timestamps and corresponding transcription

# Author : Sishir Kalita (Armsoftech.air)
# Date: 22 Jan, 2021

main_path='/home/administrator/Works/CWorks/Raguvaran/Audio_Cut/TT_Out_20201217'

# Path of TextGrid files Folder | Directory where created lab files will be stored
path1=$main_path/TT_out

# Path of temporary files
path3='tmp'	       	

# Audio path | input
path_audio_i=$main_path/Ad_input

# Audio path | output
path_audio_o=$path_audio_i"_"split
mkdir -p $path_audio_o

rm -rf path_trans.csv

mkdir -p tmp

textPatt="item"

cd $path1

find $(pwd) -iname "*.TextGrid" > ../TextGrid_file_list

cd ..

whichItem=1
onee=1

while read line

	do	
		iconv -f utf16 -t utf8 $line -o temp
		fileName=$(echo $line | rev | cut -d'/' -f1 | rev | cut -d'.' -f1)

		iterNo1=$(expr "$whichItem" + "$onee")
		iterNo2=$(expr "$whichItem" + "$onee" + "$onee")

		iterNo1Val=$iterNo1""p
		iterNo2Val=$iterNo2""p

		#echo $iterNo1Val $iterNo2Val

		grep -n $textPatt temp |  cut -d':' -f1 > $path3/grepp.txt

		n1=$(cat $path3/grepp.txt | sed -n $iterNo1Val)
		n2=$(cat $path3/grepp.txt | sed -n $iterNo2Val)

		cat temp| sed -n "${n1},${n2}p" > $path3/mainn.txt


		cat $path3/mainn.txt | grep xmin | cut -d'=' -f2 | sed 's/""/silence/g'| sed 's/"//g'| tail -n+2 | sed 's/ //g' > $path3/temp_xmin.txt

		cat $path3/mainn.txt | grep xmax | cut -d'=' -f2 | sed 's/""/silence/g'| sed 's/"//g'| tail -n+2 | sed 's/ //g' > $path3/temp_xmax.txt

		cat $path3/mainn.txt | grep text | cut -d'=' -f2 | sed 's/""/silence/g'| sed 's/"//g'| tail -n+0 > $path3/temp_trans.txt

		while read -r -u1 line1; read -r -u2 line2; read -r -u3 line3;

			do

				echo $line1 $line2 $line3 >> $path3/output1.txt
				#echo $line1 $line2 $line3

		done 1<$path3/temp_xmin.txt 2<$path3/temp_xmax.txt 3<$path3/temp_trans.txt

		cat $path3/output1.txt | grep -v 'Unwanted\|Neutral\|unused\|neutral\|Unused\|silence' | sed 's/\r/ /g' >  "$path1/$fileName.lab"
		
		audiofile_count=1000
		audio_path_input=$path_audio_i/$fileName.wav
		while read line_lab
			do
				time1=$(echo $line_lab | cut -d' ' -f1)
				time2=$(echo $line_lab | cut -d' ' -f2)
				transcription=$(echo $line_lab | cut -d' ' -f3- | tr -s "()'.,;" " ")

				#echo $time1,$time2,$transcription

				audiofile_count=$(expr "$audiofile_count" + "$onee")

				audio_path_output=$path_audio_o/$fileName"_"$audiofile_count.wav
				sox $audio_path_input $audio_path_output trim $time1 =$time2 

				echo $audio_path_output,$transcription >> path_trans_temp.csv
		done < "$path1/$fileName.lab"

		rm -rf $path3/output1.txt

		echo "----------------------------------------------------------"
		echo "Converting $line -------------------->  $line.lab"
		echo "----------------------------------------------------------"

done < TextGrid_file_list


# Command to remove rows in the path_trans.csv, if the second field is empty
grep ,. path_trans_temp.csv > path_trans_main.csv

rm -rf path_trans_temp.csv

echo "------------------------ done -------------------------"

