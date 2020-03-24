#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Script to extract timestamps and corresponding transcription
# Give tierNumber as the input

# Author : Sishir Kalita (Armsoftech.air)
# email id: sisiitg@gmail.com
# Date: 22 March, 2020


import re
import glob
from itertools import islice

tierNo = input("Enter the tier number: ") 
numberTier = []


filepath = '/home/administrator/Works/Data-Arm/telegu_transcription/python-based/textGrid'
files = [f for f in glob.glob(filepath + "/*.TextGrid")]

for file in files:
    
    writePath = re.sub('.TextGrid','',file)
    writePath = writePath + '.lab'
    
    with open(file) as fp:
        for num, line in enumerate(fp, 1):
            if 'item' in line:
                print ("found at line:", num)
                numberTier.append(num)
   
    with open(file) as fp, open(writePath, 'w') as fw:
        subLines = islice(fp, numberTier[int(tierNo)], numberTier[int(tierNo)+1]-1)
        for line in subLines:
            line = re.sub('\n','',line)
            line = re.sub('^ *','',line)
            linepair = line.split(' = ')
            if linepair[0] == 'xmin':
                xmin = linepair[1]
            if linepair[0] == 'xmax':
                xmax = linepair[1]
            if linepair[0] == 'text':
                text = linepair[1]
                text = re.sub('"','',text)
                labwrite = xmin + '\t' + xmax + '\t' + text + '\n'
                fw.write(labwrite)

fp.close()
fw.close()
