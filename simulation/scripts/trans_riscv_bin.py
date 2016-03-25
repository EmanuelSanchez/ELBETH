#!/usr/bin/env python3

#-----------------------------------------------------------------------
#Exs of file ".asm":
#add 	r1, r2, r0
#lb 	r3, r7, 8
#-----------------------------------------------------------------------

import sys
import os


instructions_set = {
	'nop'	: {'type_inst' : 'R'},
	'add' 	: {'type_inst' : 'R', 'funct3' : '000', 'funct7' : '0000000'},
	'sub' 	: {'type_inst' : 'R', 'funct3' : '000', 'funct7' : '0100000'},
	'addi'	: {'type_inst' : 'I', 'funct3' : '000'},
	'and'	: {'type_inst' : 'R', 'funct3' : '111', 'funct7' : '0000000'},
	'or'	: {'type_inst' : 'R', 'funct3' : '110', 'funct7' : '0000000'},
	'xor'	: {'type_inst' : 'R', 'funct3' : '100', 'funct7' : '0000000'},
	'andi'	: {'type_inst' : 'I', 'funct3' : '111'},
	'ori'	: {'type_inst' : 'I', 'funct3' : '110'},
	'xori'	: {'type_inst' : 'I', 'funct3' : '100'},
	'sb'	: {'type_inst' : 'S', 'funct3' : '000'},
	'sh'	: {'type_inst' : 'S', 'funct3' : '001'},
	'sw'	: {'type_inst' : 'S', 'funct3' : '010'},
	'lb'	: {'type_inst' : 'I_LOAD', 'funct3' : '000'},
	'lh'	: {'type_inst' : 'I_LOAD', 'funct3' : '001'},
	'lw'	: {'type_inst' : 'I_LOAD', 'funct3' : '010'},
	'lbu'	: {'type_inst' : 'I_LOAD', 'funct3' : '100'},
	'lhu'	: {'type_inst' : 'I_LOAD', 'funct3' : '101'},
	'beq'	: {'type_inst' : 'SB', 'funct3' : '000'},
	'bne'	: {'type_inst' : 'SB', 'funct3' : '001'},
	'blt'	: {'type_inst' : 'SB', 'funct3' : '100'},
	'bge'	: {'type_inst' : 'SB', 'funct3' : '101'},
	'bltu'	: {'type_inst' : 'SB', 'funct3' : '110'},
	'bgeu'	: {'type_inst' : 'SB', 'funct3' : '111'},
	'jalr'	: {'type_inst' : 'I_JALR', 'funct3' : '000'},
	'jal'	: {'type_inst' : 'UJ_JAL'},
	'lui'	: {'type_inst' : 'U_LUI'},
	'auipc'	: {'type_inst' : 'U_AUIPC'}
}

opcodes = {
	'R'			: '0110011',
	'I'			: '0010011',
	'U_LUI'		: '0110111',
	'U_AUIPC'	: '0010111',
	'UJ_JAL'	: '1101111',
	'I_JALR'	: '1100111',
	'SB'		: '1100011',
	'I_LOAD'	: '0000011',
	'S'			: '0100011',
	'SYSYEM'	: '1110011'
}

registers = {
	'r0' : '00000',
	'r1' : '00001',
	'r2' : '00010',
	'r3' : '00011',
	'r4' : '00100',
	'r5' : '00101',
	'r6' : '00110',
	'r7' : '00111',
	'r8' : '01000',
	'r9' : '01001',
	'r10' : '01010',
	'r11' : '01011',
	'r12' : '01100',
	'r13' : '01101',
	'r14' : '01110',
	'r15' : '01111',
	'r16' : '10000',
	'r17' : '10001',
	'r18' : '10010',
	'r19' : '10011',
	'r20' : '10100',
	'r21' : '10101',
	'r22' : '10110',
	'r23' : '10111',
	'r24' : '11000',
	'r25' : '11001',
	'r26' : '11010',
	'r27' : '11011',
	'r28' : '11100',
	'r29' : '11101',
	'r30' : '11110',
	'r31' : '11111'
}


def check_arg():
	try:
		file_asm = sys.argv[1]
		if(not os.path.exists(os.getcwd()+"/"+file_asm)):
			print("\nError : assembler file doesn't exist: "+sys.argv[1]+"\nAbort.")
			sys.exit(1)
		if(file_asm[-4:]!=".asm"):
			print("\nError : assembler file extention no valid: "+file_asm[-5:-1]+"\nAbort.")
			sys.exit(1)
	except:
		print("\nError : fail opening asembler file: "+sys.argv[1]+"\nAbort.")
		sys.exit(1)
	return file_asm


def imm_generate(imm_d, type_gen):
	bin_imm = bin(imm_d)[2:]
	if((len(bin_imm)>12)&((type_gen == 0)|(type_gen == 1))):
		print("\nError : immerdiate number is invalid\nAbort.")
		sys.exit(1)
	bin_imm_extended = '0'*(12-len(bin_imm))+bin_imm
	if(type_gen==1):
		return bin_imm_extended[-12]+bin_imm_extended[-10:-4]+bin_imm_extended[-4:]+bin_imm_extended[-11]
	elif(type_gen==2):
		return '0'*(20-len(bin_imm))+bin_imm
	elif(type_gen==3):
		return bin_imm_extended[-20]+bin_imm_extended[-10:-1]+bin_imm_extended[-11]+bin_imm_extended[-19:-12]
	else:
		return bin_imm_extended


def convert_hex(num_bin):
	num_hex = hex(int(str(num_bin),2))[2:]
	if(len(num_hex)<8):
		num_hex_extended = "0"*(8-len(num_hex))+num_hex
		print("\t"+num_hex_extended+"\n")
		return num_hex_extended
	print("\t"+num_hex+"\n")
	return num_hex

def trans_line(instruc):
	type_inst = instructions_set[instruc[0]]['type_inst']
	if (type_inst == 'R'):
		funct7 = instructions_set[instruc[0]]['funct7']
		rs2 = registers[instruc[3].strip(',')]
		rs1 = registers[instruc[2].strip(',')]
		funct3 = instructions_set[instruc[0]]['funct3']
		rd = registers[instruc[1].strip(',')]
		opcode = opcodes[type_inst]
		inst_bin = funct7 + rs2 + rs1 + funct3 + rd + opcode
		print("\t"+funct7 + "\t" + rs2 + "\t" + rs1 + "\t" + funct3 + "\t" + rd + "\t" + opcode)
		print("\t"+inst_bin)
		return convert_hex(inst_bin)
	if ((type_inst == 'I') | (type_inst == 'I_LOAD') | (type_inst == 'I_JALR')):
		imm = imm_generate(int(instruc[3]),0)
		rs1 = registers[instruc[2].strip(',')]
		funct3 = instructions_set[instruc[0]]['funct3']
		rd = registers[instruc[1].strip(',')]
		opcode = opcodes[type_inst]
		inst_bin = imm + rs1 + funct3 + rd + opcode
		print("\t" + imm + "\t" + rs1 + "\t" + funct3 + "\t" + rd + "\t" + opcode)
		print("\t"+inst_bin)
		return convert_hex(inst_bin)
	if (type_inst == 'SB'):
		imm = imm_generate(int(instruc[3]),1)
		rs2 = registers[instruc[2].strip(',')]
		rs1 = registers[instruc[1].strip(',')]
		funct3 = instructions_set[instruc[0]]['funct3']
		opcode = opcodes[type_inst]
		inst_bin = imm[:-5] + rs2 + rs1 + funct3 + imm[-5:] + opcode
		print("\t" + imm[:-5] + "\t" + rs2 + "\t" + rs1 + "\t" + funct3 + "\t" + imm[-5:] + "\t" + opcode)
		print("\t"+inst_bin)
		return convert_hex(inst_bin)
	if (type_inst == 'S'):
		imm = imm_generate(int(instruc[3]),0)
		rs2 = registers[instruc[2].strip(',')]
		rs1 = registers[instruc[1].strip(',')]
		funct3 = instructions_set[instruc[0]]['funct3']
		opcode = opcodes[type_inst]
		inst_bin = imm[:-5] + rs2 + rs1 + funct3 + imm[-5:] + opcode
		print("\t" + imm[:-5] + "\t" + rs2 + "\t" + rs1 + "\t" + funct3 + "\t" + imm[-5:] + "\t" + opcode)
		print("\t"+inst_bin)
		return convert_hex(inst_bin)
	if ((type_inst == 'U_LUI')|(type_inst == 'U_AUIPC')):
		imm = imm_generate(int(instruc[3]),2)
		rd = registers[instruc[1].strip(',')]
		opcode = opcodes[type_inst]
		inst_bin = imm + rd + opcode
		print("\t" + imm + "\t" + rd + "\t" + opcode)
		print("\t"+inst_bin)
		return convert_hex(inst_bin)
	if (type_inst == 'UJ_JAL'):
		imm = imm_generate(int(instruc[3]),3)
		rd = registers[instruc[1].strip(',')]
		opcode = opcodes[type_inst]
		inst_bin = imm + rd + opcode
		print("\t" + imm + "\t" + rd + "\t" + opcode)
		print("\t"+inst_bin)
		return convert_hex(inst_bin)		


def compiler():
	print("Translating...\n")
	asm_f = check_arg()
	hex_f = asm_f[:-4]+".hex"
	with open(asm_f, "r") as f:
		with open(hex_f, "w") as new_f:
			j=0
			for i in range(0,128):
				j+=1
				new_f.write("00000000\n")
			for line in f:
				j+=1
				print("\t"+line)
				new_f.write(trans_line(line.split())+"\n")
			for i in range (j, 256):
				new_f.write("00000033\n")
		new_f.close()
	f.close()

if __name__ == '__main__':
    compiler()
    print("Done.")