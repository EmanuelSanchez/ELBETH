#!/usr/bin/env python

import os
import random
from myhdl import Cosimulation, Simulation, Signal, delay, now, StopSimulation, instance, always_comb, modbv


def reg_file(clk, a_addr, b_addr, w_data, w_addr, w_en, a_data, b_data):
    ''' A Cosimulation object, used to simulate Verilog modules '''
    os.system('iverilog -o reg_file elbeth_register_file.v regfile_top.v')
    return Cosimulation('vvp -m ./myhdl.vpi reg_file', clk=clk, id_rs1_addr=a_addr, id_rs2_addr=b_addr, exs_rd_data=w_data, exs_rd_addr=w_addr, reg_file_w_en=w_en, id_rs1_data_gpr=a_data, id_rs2_data_gpr=b_data)


def _testbench(clk, a_addr, b_addr, w_data, w_addr, w_en, a_data, b_data):
    '''
    Write 32 random values, and read those values.
    Compare the data from portA and portB with the values
    stored in a temporal list. Print error in case of mismatch.
    '''

    values = [random.randrange(0, 2**32) for _ in range(32)]  # random values. Used as reference.

    @instance
    def stimulus():
        # write random data
        for i in range(32):
            w_addr.next = i
            w_data.next = values[i]
            w_en.next = 1
            clk.next = 1
            yield delay(5)
            w_en.next = 0
            clk.next = 0
            yield delay(5)

        # read data, port A
        for i in range(32):
            a_addr.next = i
            clk.next = 1
            yield delay(5)
            clk.next = 0
            # Check if the value is ok
            condition = (i == 0 and a_data == 0) or (i != 0 and a_data == values[i])
            assert condition, "ERROR at reg {0:02}: Value = {1}.\tRef = {1}".format(i, a_data, values[i])
            yield delay(5)

        # read data, port B
        for i in range(32):
            b_addr.next = i
            clk.next = 1
            yield delay(5)
            clk.next = 0
            # Check if the value is ok
            condition = (i == 0 and b_data == 0) or (i != 0 and b_data == values[i])
            assert condition, "ERROR at reg {0:02}: Value = {1}.\tRef = {1}".format(i, b_data, values[i])
            yield delay(5)

        raise StopSimulation

    return stimulus


def test_regfile():
    """
    Regfile: Test behavioral.
    """
    clk = Signal(False)
    a_addr = Signal(modbv(0)[5:])
    a_data = Signal(modbv(0)[32:])
    b_addr = Signal(modbv(0)[5:])
    b_data = Signal(modbv(0)[32:])
    w_addr = Signal(modbv(0)[5:])
    w_data = Signal(modbv(0)[32:])
    w_en = Signal(False)

    tb = _testbench(clk, a_addr, b_addr, w_data, w_addr, w_en, a_data, b_data)
    reg_file_simulation = reg_file(clk, a_addr, b_addr, w_data, w_addr, w_en, a_data, b_data)

    sim = Simulation(tb, reg_file_simulation)
    sim.run()

test_regfile()

# Local Variables:
# flycheck-flake8-maximum-line-length: 120
# flycheck-flake8rc: ".flake8rc"
# End:
