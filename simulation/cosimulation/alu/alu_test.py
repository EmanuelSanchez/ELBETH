#!/usr/bin/env python3

#---------------------------------------------------------------------------------------
#   TEST ALU
#---------------------------------------------------------------------------------------


import os
import random
from myhdl import Cosimulation, Simulation, Signal, delay, now, StopSimulation, instance, always_comb, modbv

class ALUOp:
    """
    List of ALU opcodes.
    """
    OP_ADD     = 0
    OP_SUB     = 1
    OP_AND     = 2
    OP_OR      = 3
    OP_XOR     = 4
    OP_SLT     = 5
    OP_SLTU    = 6
    OP_SLL     = 7
    OP_SRL     = 8
    OP_SRA     = 9

def alu(data_a, data_b, operation, result):
    ''' A Cosimulation object, used to simulate Verilog modules '''
    os.system('iverilog -o alu alu.v alu_top.v')
    return Cosimulation('vvp -m ./myhdl.vpi alu', data_a=data_a, data_b=data_b, operation=operation, result=result)

def checker(data_a, data_b, result):
    ''' Checker which prints the value of counter at posedge '''
    @always_comb
    def check():
        print('Time=', now(), 'a=', data_a, 'b=', data_b, ' resultado=', result)

    return check

def _testbench(data_a, data_b, operation, result):
    """
    Testbech for the ALU module
    """

    @instance
    def stimulus():
        # Execute 1000 tests.
        for j in range(1000):
            data_a.next = random.randrange(0, 2**32)
            data_b.next = random.randrange(0, 2**32)
            a = data_a
            b = data_b

            # Test each function
            for i in range(16):
                operation.next = i
                yield delay(1)
                shamt =data_b[5:0]

                if i == ALUOp.OP_ADD:
                    assert result == modbv(a + b)[32:], "Error ADD"
                elif i == ALUOp.OP_SLL:
                    assert result == modbv(a << shamt)[32:], "Error SLL"
                elif i == ALUOp.OP_XOR:
                    assert result == a ^ b, "Error XOR"
                elif i == ALUOp.OP_SRL:
                    assert result == a >> shamt, "Error SRL"
                elif i == ALUOp.OP_OR:
                    assert result == a | b, "Error OR"
                elif i == ALUOp.OP_AND:
                    assert result == a & b, "Error AND"
                elif i == ALUOp.OP_SUB:
                    assert result == modbv(a - b)[32:], "Error SUB"
                elif i == ALUOp.OP_SRA:
                    assert result == modbv(a.signed() >> shamt)[32:], "Error SRA"
                elif i == ALUOp.OP_SLT:
                    assert result == modbv(a.signed() < b.signed())[32:], "Error SLT"
                elif i == ALUOp.OP_SLTU:
                    assert result == modbv(abs(a) < b)[32:], "Error SLTU"
                else:
                    assert result == 0, "Error UNDEFINED OP"

        raise StopSimulation

    return stimulus

def test_alu():
    """
    ALU: Test behavioral.
    """
    data_a = Signal(modbv(0)[32:])
    data_b = Signal(modbv(0)[32:])
    operation = Signal(modbv(0)[4:])
    result = Signal(0)

    tb_inst = _testbench(data_a, data_b, operation, result)
    alu_inst = alu(data_a, data_b, operation, result)
    #checker_inst = checker(data_a, data_b, result)

    sim = Simulation(tb_inst, alu_inst)
    sim.run()


test_alu()


# Local Variables:
# flycheck-flake8-maximum-line-length: 120
# flycheck-flake8rc: ".flake8rc"
# End:
