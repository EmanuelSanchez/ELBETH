![logo](Documentation/logo/elbeth.jpg)

This is a public project for the Elbeth Processor using the set of instuction RISCV.
Based in the Manuals RISCV and in the knolodge acquired in the Course of Computer Arquitecture of the Simon Bolivar University

#PROCESSOR DETAILS 
	
	-Processor of 3 Pipeline Stage
	-Hazard Detection Unit with Forwarding
	-Hardware arquitecture described in verilog HDL
	-Support for ISA RISCV32I
	-No FENCE Operations 
	-Support for User-Level and Machine-Level
	-32 general purpose registers
	-No Floting Point Unit
	-No hardware to Multiplication 
	-No hardware to Divition
	-Little Endian system
	-Support for 256 Kb of RAM memory
	-No Cache
	-Module for Interrupts and Exceptions Control

The Elbeth Processor only execute the RISCV32I (Integer) Set of Instructions.

#Getting Started

In this repository you will find all the files needed to simulate the Elbeth Processor.
    Hardware described in code.
    Simulation and Cosimulation Tools. 
    RAM Memory of 256 Kb.
    Scripts for simulation.
    Tests for simulations.

#Software Details

The Software tool were used for create and simulate the Elbeth Processor:

	-Icarus Verilog
	-GTKWave
	-Python 3
	-Myhdl for Python3

#Directory Layout

```
Elbeth
├── Documentation/
├── simulation/
│   ├── cosimulation/
│   │	├── alu/				:
│   │	├── core/				:
│   │	│   ├── core_test.py
│   │   │   ├── core_top.v
│   │   │   ├── myhdl.vpi
│   │	│   └── README.md
│   │	└── regfile/			:
│   ├── dump_tests/				:
│   ├── memory/
│   │	├── elbeth_memory.v/	:
│   │	└── README.md			:
│   ├── other tests/
│   │	├── my_tests/			:
│   │	├── verilog/ 			:
│   ├── scripts/
│   │	├── check_verilog.sh 	:
│   │   ├── testcore.py 		:
│	│   ├── testcore.sh 		:
│   │   ├── testv.sh 			:
│   │   └── trans_riscv_bin.py  :
│   ├── tests/                	:
│   ├── run.py 					:
│   └── README.md
├── src/
│   ├── elbeth_add4.v
│   ├── elbeth_alu.v
│   ├── elbeth_branch_unit.v
│   ├── elbeth_memory_bridge.v
│   ├── elbeth_control_unit.v
│   ├── elbeth_core.v
│   ├── elbeth_csr_register.v
│   ├── elbeth_decoder.v
│   ├── elbeth_definitions.v
│   ├── elbeth_hazard_unit.v
│   ├── elbeth_id_exs_register.v
│   ├── elbeth_if_id_register.v
│   ├── elbeth_memory.v
│   ├── elbeth_mux_2_to_1.v
│   ├── elbeth_mux_3_to_1.v
│   ├── elbeth_mux_4_to_1.v
│   ├── elbeth_pc_register.v
│   └── elbeth_reg_file.v
└── README.md
```
#Simulation

There are different ways to test the ELBETH processor, one of them is using the cosimulation of myhdl library and other is running tests in verilog.

To compile and test the processor using the cosimulation use the run.py script in simulation folder, it has some options, to see the help run:

	./run.py -h

For others options or more information about test the pocessor or a module of it see the README file into simulation folder.