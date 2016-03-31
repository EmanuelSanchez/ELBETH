#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import mmap

directory = os.getcwd() + '/hex_algol'
directory_trans = os.getcwd() + '/hex_trans'
list_files = os.listdir(directory)

print("\nTranslating Files")	

i=0
for files in list_files:
	hex_file = directory+"/"+list_files[i]
	new_file = directory_trans+"/"+list_files[i]
	print("Reading file:" + hex_file)
	with open(hex_file, "r") as f:
		with open(new_file, "w") as new_f:
			for line in f:
				new_f.write(line[24:32]+'\n')
				new_f.write(line[16:24]+'\n')
				new_f.write(line[8:16]+'\n')
				new_f.write(line[0:8]+'\n')
		new_f.close()
	f.close()
	i+=1

print("\nDone.\n")
