#!/usr/bin/env python3

#---------------------------------------------------------------------------------------
#   Name: elbeth_core cosimulation
#---------------------------------------------------------------------------------------
    
import os
from myhdl import Cosimulation
from myhdl import Simulation
from myhdl import Signal
from myhdl import delay
from myhdl import now
from myhdl import StopSimulation
from myhdl import instance
from myhdl import always_comb
from myhdl import always
from myhdl import modbv
from myhdl import Error

TICK_PERIOD = 10
TIMEOUT = 10000

def test_bench():
	
	clk = Signal(0)
	rst = Signal(False)
	imem_addr = Signal(modbv(0)[14:])
	imem_out_data = Signal(modbv(0)[32:])
	toHost = Signal(modbv(0)[32:])

	def core_compilation(clk, rst, imem_addr, imem_out_data, toHost):
		''' A Cosimulation object, used to simulate Verilog modules '''
		os.system('iverilog -o core core_top.v elbeth_core.v elbeth_memory.v')
		return Cosimulation('vvp -m ./myhdl.vpi core', clk=clk, rst=rst, imem_addr=imem_addr, imem_out_data=imem_out_data, toHost=toHost)

	@always(delay(int(TICK_PERIOD / 2)))
	def gen_clock():
		clk.next = not clk

	@always(toHost)
	def toHost_check():
		if toHost != 1:
			raise Error('Test failed. MTOHOST = {0}. Time = {1}'.format(toHost, now()))
		raise StopSimulation

	@instance
	def timeout():
		rst.next = True
		yield delay(5 * TICK_PERIOD)
		rst.next = False
		yield delay(TIMEOUT * TICK_PERIOD)
		raise Error("Test failed: Timeout")

	return gen_clock, timeout, toHost_check, core_compilation(clk, rst, imem_addr, imem_out_data, toHost)


def test_core():
	"""
	Core: Behavioral test for the RISCV core.
	"""
	sim = Simulation(test_bench())
	sim.run()


if __name__ == '__main__':
	test_core()