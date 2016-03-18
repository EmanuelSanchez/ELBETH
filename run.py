#!/usr/bin/python

import os
import sys
import shutil

root = os.getcwd()
src = root + '/src'
folder_tests = root + '/simulation/tests'
list_tests = os.listdir(folder_tests)

def verify():
	try:
		os.path.isdir(src)
	except:
		print("Directory does't exist:"+src)
		sys.exit(1)
	try:
		os.path.isdir(folder_tests)
	except:
		print("Directory does't exist:"+folder_tests)
		sys.exit(1)
	if not list_tests:
		print("Imposible to found tests"+folder_tests)
		sys.exit(1)

def mv_utils ():
	try:
		shutil.copyfile(root+'/simulation/core/core_test.py', src+'/core_test.py')
		shutil.copyfile(root+'/simulation/core/core_top.v', src+'/core_top.v')
		shutil.copyfile(root+'/simulation/core/myhdl.vpi', src+'/myhdl.vpi')
	except:
		print('File doesn`t exist in "/simulation/core": core_test.py, core_top.v or myhdl.vpi')
		sys.exit(1)

def mv_test (i):
	test = folder_tests+"/"+list_tests[i]
	dest = src+"/"+"memory.hex"
	try:
		shutil.copyfile(test, dest)
	except:
		print('Imposible to found test:'+list_tests[i])
		sys.exit(1)

def rm(i):
	dest = src+"/"+"memory.hex"
	os.remove(dest)
	os.remove(src+"/"+"core_test.py")
	os.remove(src+"/"+"core_top.v")
	os.remove(src+'/myhdl.vpi')
	os.remove('core.vcd')
	os.remove('core')

def test_all():
	verify()
	mv_utils()
	os.chdir(src)
	os.system("chmod +x core_test.py")
	i=0
	for file in list_tests:
		mv_test(i)
		try:
			print("Running test:"+list_tests[i])
			os.system("./core_test.py")
		except:
			print("\nFail in simulation: stop and exit...")
			rm()
			sys.exit(1)
		i+=1
	rm(i)

print("\nBegining Simulation...")

test_all()

print("\nDone.\n")
