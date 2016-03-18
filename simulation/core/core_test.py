#!/usr/bin/env python3

#---------------------------------------------------------------------------------------
#   Name: elbeth_core cosimulation
#---------------------------------------------------------------------------------------
    
import os
import random
from myhdl import Cosimulation, Simulation, Signal, delay, now, StopSimulation, instance, always_comb, always, modbv

#imem_en, imem_ready, imem_addr, imem_out_data, dmem_en, dmem_ready, dmem_rw, dmem_addr, dmem_out_data
#, imem_en=imem_en, imem_ready=imem_ready, imem_addr=imem_ready, imem_out_data=imem_out_data, dmem_en=dmem_en, dmem_ready=dmem_ready, dmem_rw=dmem_rw, dmem_addr=dmem_addr, dmem_out_data=dmem_out_data

def core_compilation(file_mem, clk, rst, imem_addr, imem_out_data, toHost):
	''' A Cosimulation object, used to simulate Verilog modules '''
	os.system('iverilog -o core elbeth_memory.v core_top.v elbeth_core.v')
	return Cosimulation('vvp -m ./myhdl.vpi core', clk=clk, rst=rst, imem_addr=imem_addr, imem_out_data=imem_out_data, toHost=toHost)

def clk_driver(clk, period=10):
	''' Clock driver '''
	@always(delay(period//2))
	def driver():
		clk.next = not clk

	return driver


def test_bench(rst):
	"""
	Testbech for the ALU module
	"""

	@instance
	def stimulus():
		yield delay(5)
		rst.next = True 
		yield delay(10)
		rst.next = False 

	return stimulus


def test_core():
	"""
	ALU: Test behavioral.
	"""
	clk = Signal(0)
	rst = Signal(False)
	imem_addr = Signal(modbv(0)[8:])
	imem_out_data = Signal(modbv(0)[32:])
	toHost = Signal(modbv(0)[32:])
	clk_generator = clk_driver(clk)
	test_bench_inst = test_bench(rst)
	file_mem='memory_hex1.txt'
	core_compilation_inst = core_compilation(file_mem, clk, rst, imem_addr, imem_out_data, toHost)
	print(toHost)
	sim = Simulation(clk_generator, test_bench_inst, core_compilation_inst)
	sim.run(100)

test_core()