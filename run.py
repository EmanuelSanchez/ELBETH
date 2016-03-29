#!/usr/bin/python

import os
import sys
import glob
import pytest
import shutil
import argparse
import subprocess

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
		shutil.copyfile(root+'/simulation/cosimulation/core/core_test.py', src+'/core_test.py')
		shutil.copyfile(root+'/simulation/cosimulation/core/core_top.v', src+'/core_top.v')
		shutil.copyfile(root+'/simulation/cosimulation/core/myhdl.vpi', src+'/myhdl.vpi')
	except:
		print('File doesn`t exist in "/simulation/core": core_test.py, core_top.v or myhdl.vpi')
		sys.exit(1)

def mv_test (test_name):
	test = folder_tests+"/"+test_name
	dest = src+"/"+"memory.hex"
	try:
		shutil.copyfile(test, dest)
	except:
		print('Imposible to found test:'+test_name)
		sys.exit(1)

def rm():
	dest = src+"/"+"memory.hex"
	os.remove(dest)
	os.remove(src+"/"+"core_test.py")
	os.remove(src+"/"+"core_top.v")
	os.remove(src+'/myhdl.vpi')
	os.remove('core.vcd')
	os.remove('core')
	os.remove('log')

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


def run_simulation(args):
	os.chdir(src)
	if args.list:
		list_module_test()
	elif args.step:
		mv_utils()
		for test in list_tests:
			mv_test(test)
			print("------------------------------------------------------------")
			print("\tRunning:  " +test)
			print("------------------------------------------------------------")
			pytest.main(['--resultlog=./log', '--tb=no', src+'/core_test.py'])
			menu(test[:-4])
		rm()
	elif args.all:
		mv_utils()
		l = []
		i = 0
		j = 0
		for test in list_tests:
			mv_test(test)
			pytest.main(['--resultlog=./log', '--tb=no', src+'/core_test.py'])
			with open('log', 'r') as f:
				l1 = f.readline().split()
				l2 = f.readline().split()

				if len(test) < 16:  tab = '\t\t'
				else:               tab = '\t'

				if((l1[0] == '.') & ( l2[0]== '.')):
					l.append(test + tab + '\033[92m' + 'OK' + '\033[0m')
					i+=1
				else:
					l.append(test + tab + '\033[91m' + 'FAILED' + '\033[0m')
					j+=1
			f.close()
		rm()
		for item in l:
			print (item)
		print ("------------------------------------------------------------")
		print ("\tRESUMEN:")
		print ("\tTotal tests: {0}.\n\tFailed tests: {1}. \n\tSucces tests: {2}.").format(i+j,j,i)
		print ("------------------------------------------------------------")
	else:
		mv_utils()
		mv_test(args.file)
		pytest.main([src+'/core_test.py'])
		print("Runned test:"+args.file)
		menu(args.file[:-4])
		rm()


def list_module_test():
    print("List of unit tests for ELBETH:")
    cwd = os.getcwd()
    tests = glob.glob(cwd + "/simulation/tests/*.hex")
    if len(tests) == 0:
        print("No available tests: {0}".format(cwd))
    else:
        print("------------------------------------------------------------")
        for test in tests:
            print(test)
        print("------------------------------------------------------------")


def menu(test,ext='.dump'):
	print("\n\n============================================================")
	print("\t\t*********** MENU ***********")
	print("============================================================")
	print("\n\tOptions:")
	print("  \t0 - Exit")
	print("  \t1 - Run next test")
	print("  \t2 - Open the assembler test")
	print("  \t3 - Open the simulation in GTKWave")
	print("  \t4 - To Open test and simulation")
	opt = input("\n\tSelect:   ")
	if(opt==0):
		rm()
		sys.exit(1)
	elif(opt==1):
		return
	elif(opt==2):
		os.system("gedit "+root+"/simulation/dump_tests/"+test+ext)
		menu(test)
		return
	elif(opt==3):
		os.system("gtkwave core.vcd")
		return
	elif(opt==4):
		os.system("subl "+root+"/simulation/dump_tests/"+test+ext)
		os.system("gtkwave core.vcd")
		return
	else:
		print("\tError: option incorrect.\n\tAbort.")
		rm()
		sys.exit(1)


def main():
    """
    Set arguments, parse, and call the required function
    """
    parser = argparse.ArgumentParser(description='ELBETH (RISC-V processor). Main simulation script.')
    subparsers = parser.add_subparsers(title='Sub-commands',
                                       description='Available functions',
                                       help='Description')

    # Core simulation
    parser_core = subparsers.add_parser('core', help='Run assembler tests in the RV32 processor')
    group_core1 = parser_core.add_mutually_exclusive_group(required=True)
    group_core1.add_argument('-l', '--list', help='List tests', action='store_true')
    group_core1.add_argument('-f', '--file', help='Run a specific test')
    group_core1.add_argument('-s', '--step', help='Run step to step all tests', action='store_true')
    group_core1.add_argument('-a', '--all', help='Run all tests', action='store_true')
    parser_core.set_defaults(func=run_simulation)

    args = parser.parse_args()
    args.func(args)


if __name__ == '__main__':
	main()

print("\nDone.\n")