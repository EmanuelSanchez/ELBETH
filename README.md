![logo](Documentation/logo/elbeth_logo.png)

This is a public project for the Elbeth Processor using the set of instuction RISCV.
Based in the Manuals RISCV and in the knolodge acquired in the Course of Computer Arquitecture of the Simon Bolivar University

##PROCESSOR DETAILS 
	
	-Processor of 3 Pipeline Stage with Forwarding Unit and Hazard Detection Unit
	-Hardward arquitecture codified in verilog language
	-A set of instruction of 49 User Mode instructions, the System Operations: 3 Privileged Mode instructions and 6 CSR instructions
	-No FENCE Operations 
	-No Floting Point Unit
	-No Cache.
	-No Hardware Multiplication 
	-No hardware Divition
	-Control Status Register Module for Interrupts, Exeptiosn, and User/Privileged mode.

The Elbeth Processor only execute the RISCV32I (Integer) Set of Instructions.

##Getting Started

In this repository you will find all the files needed to simulate the Elbeth Processor
    Processor Codification for Hardware.
    Simulation and Cosimulation Tools. 
    RAM Memory of 256 Kb.
    Scripts for simulation.

##Software Details

    The Software tool were used for create and design the Elbeth Processor are:
     -Icarus Verilog
     -GTKWave
     -Python 3
     -Myhdl for Python3

##Directory Layout

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
│   ├── elbeth_bridge_memory.v
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
##Simulation

There are different ways to test the ELBETH processor, one of them is using the cosimulation of myhdl library and other is running tests in verilog.

To compile and test the processor using the cosimulation use the run.py script in simulation folder, it has some options, to see the help run:

	./run.py -h

For others options or more information about test the pocessor or a module of it see the README file into simulation folder.s
