#!/usr/bin/python

import os
import sys
import shutil

os.chdir(os.getcwd()+"/../..")
root = os.getcwd()
src = root + '/src'
folder_utils = root + '/simulation/cosimulation/core'

def verify():
	try:
		os.path.isdir(src)
	except:
		print("Directory does't exist:"+src)
		sys.exit(1)
	try:
		os.path.isdir(folder_utils)
	except:
		print("Directory does't exist:"+folder_utils)
		sys.exit(1)

def mv_utils ():
	try:
		shutil.copyfile(folder_utils+'/core_test.py', src+'/core_test.py')
		shutil.copyfile(folder_utils+'/core_top.v', src+'/core_top.v')
		shutil.copyfile(folder_utils+'/myhdl.vpi', src+'/myhdl.vpi')
	except:
		print('File doesn`t exist in "/simulation/core": core_test.py, core_top.v or myhdl.vpi')
		sys.exit(1)

def mv_test ():
	try:
		test = folder_utils+"/"+sys.argv[1]
	except:
		print("\nERROR: Wrong arument.")
		print("Abort.\n")
	dest = src+"/"+"memory.hex"
	try:
		shutil.copyfile(test, dest)
	except:
		print('Imposible to found test:'+"memory_hex.hex")
		sys.exit(1)

def rm():
	os.remove(src+"/"+"memory.hex")
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
	mv_test()
	try:
		print("Running test...")
		os.system("./core_test.py")
	except:
		print("\nFail in simulation.")
		print("Abort.\n")
		rm()
		sys.exit(1)
	print("\nOpenning GTKWAVE\n")
	os.system("gtkwave core.vcd")
	rm()

print("\nBegining Simulation...")

test_all()

print("\nDone.\n")
