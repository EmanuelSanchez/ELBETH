#!/usr/bin/env python3
import sys
import os

instructions_set = {
	'add' 	: {'type_inst' : 'R'},
	'sub' 	: {'type_inst' : 'R'},
	'addi'	: {'type_inst' : 'I'},
	'and'	: {'type_inst' : 'R'},
	'or'	: {'type_inst' : 'R'},
	'xor'	: {'type_inst' : 'R'},
	'andi'	: {'type_inst' : 'I'},
	'ori'	: {'type_inst' : 'I'},
	'xori'	: {'type_inst' : 'I'},
	'sb'	: {'type_inst' : 'SB'},
	'sh'	: {'type_inst' : 'SH'},
	'sw'	: {'type_inst' : 'SW'},
	'lb'	: {'type_inst' : 'LB'},
	'lh'	: {'type_inst' : 'LH'},
	'lw'	: {'type_inst' : 'LW'},
	'lbu'	: {'type_inst' : 'LBU'},
	'lhu'	: {'type_inst' : 'LHU'}
}

def check_arg():
	try:
		file_asm = sys.argv[1]
		if(not os.path.exists(os.getcwd()+"/"+file_asm)):
			print("\nError : assembler file doesn't exist: "+file_asm+"\nAbort.")
			sys.exit(1)
		if(file_asm[-4:]!=".asm"):
			print("\nError : assembler file extention no valid: "+file_asm[-5:-1]+"\nAbort.")
			sys.exit(1)
	except:
		print("\nError : fail opening asembler file: "+sys.argv[1]+"\nAbort.")
		sys.exit(1)
	return file_asm


def trans_line(instruc):
	if (instructions_set[instruc[0]]['type_inst'] == 'R'):
	if (instructions_set[instruc[0]]['type_inst'] == 'I'):
	if (instructions_set[instruc[0]]['type_inst'] == 'SB'):
	if (instructions_set[instruc[0]]['type_inst'] == 'SH'):
	if (instructions_set[instruc[0]]['type_inst'] == 'SW'):
	if (instructions_set[instruc[0]]['type_inst'] == 'LB'):
	if (instructions_set[instruc[0]]['type_inst'] == 'LH'):
	if (instructions_set[instruc[0]]['type_inst'] == 'LW'):
	if (instructions_set[instruc[0]]['type_inst'] == 'LBU'):
	if (instructions_set[instruc[0]]['type_inst'] == 'LHU'):


def compiler():
	asm_f = check_arg()
	hex_f = asm_f[:-4]+".hex"
	with open(asm_f, "r") as f:
		with open(hex_f, "w") as new_f:
			for line in f:
				trans_line(line.split())
		new_f.close()
	f.close()

if __name__ == '__main__':
    compiler()
