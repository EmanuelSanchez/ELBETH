#!/usr/bin/env python3

#---------------------------------------------------------------------------------------
#   TEST ALU
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

def checker(data_a, data_b, mult_result, result_ready):
    ''' Checker which prints the value of counter at posedge '''
    @always_comb
    def check():
        if(result_ready):
            print('Time=', now(), 'a=', data_a, 'b=', data_b, ' resultado=', result)

    return check

def test_bench():
    """
    Testbech for the MULT module
    """
    clk = Signal(0)
    rst = Signal(False)
    mult_en = Signal(False)
    data_a = Signal(modbv(0)[32:])
    data_b = Signal(modbv(0)[32:])
    hilo_select = Signal(0)
    result_ready = Signal(0)
    mult_result = Signal(modbv(0)[32:])

    def mult_compilation(clk, rst, mult_en, data_a, data_b, hilo_select, result_ready, mult_result):
        ''' A Cosimulation object, used to simulate Verilog modules '''
        os.system('iverilog -o mult mult.v mult_top.v')
        return Cosimulation('vvp -m ./myhdl.vpi mult', clk=clk, rst=rst, mult_en=mult_en, data_a=data_a, data_b=data_b, hilo_select=hilo_select, result_ready=result_ready, mult_result=mult_result)

    @always(delay(int(TICK_PERIOD / 2)))
    def gen_clock():
        clk.next = not clk

    @instance
    def timeout():
        rst.next = True
        yield delay(5 * TICK_PERIOD)
        rst.next = False
        yield delay(5 * TICK_PERIOD)
        data_a.next = 6
        data_b.next = 2
        hilo_select.next = 0
        mult_en.next = True       
        yield delay(TIMEOUT * TICK_PERIOD)
        raise Error("Test failed: Timeout")

    return gen_clock, timeout, mult_compilation(clk, rst, mult_en, data_a, data_b, hilo_select, result_ready, mult_result)


def test_mult():
    """
    Core: Behavioral test for the RISCV core.
    """
    sim = Simulation(test_bench())
    sim.run()

if __name__ == '__main__':
    test_mult()

# Local Variables:
# flycheck-flake8-maximum-line-length: 120
# flycheck-flake8rc: ".flake8rc"
# End:
