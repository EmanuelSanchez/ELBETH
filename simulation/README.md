#SIMULATION

##Files and folders to simulations

```
ELBETH
├── src/
│   ├── elbeth_add4.v
│   ├── elbeth_alu.v
│   ├── elbeth_branch_unit.v
│   ├── elbeth_bridge_memory.v
│   ├── elbeth_control_unit.v
│   ├── elbeth_core.v
│   ├── elbeth_csr_register.v
│   ├── elbeth_decoder.v
│   ├── elbeth_definitions.v
│   ├── elbeth_hazard_unit.v
│   ├── elbeth_id_exs_register.v
│   ├── elbeth_if_id_register.v
│   ├── elbeth_mux_2_to_1.v
│   ├── elbeth_mux_3_to_1.v
│   ├── elbeth_mux4b_2_to_1.v
│   ├── elbeth_mux_4_to_1.v
│   ├── elbeth_pc_register.v
│   └── elbeth_reg_file.v
└── simulation/
    ├── cosimulation/
    │	└── core/
    │	    ├── core_test.py/
    │	    ├── core_top.v
    │	    └── myhdl.vpi
    ├── tests
    │	└── all tests (*.hex)
    ├── memory
    │	└── elbeth_memory.v
    └── run.py
```

#SOFTWARE TOOLS

	-GTKWave
	-iverilog
	-python3
	-myHdl for python3

#TESTING PROCESSOR

## run.py script

To test the processor you must use:
	
	./run.py

ELBETH (RISC-V processor). Main simulation script.

optional arguments:
  -h, --help  show help message and exit

Sub-commands:
  Available functions

  {core}      Description
    core      Run assembler tests in the RV32 processor

optional arguments:
  -h, --help            show help message and exit
  -l, --list            List tests
  -f FILE, --file FILE  Run a specific test
  -s, --step            Run step to step all tests
  -a, --all             Run all tests


###Examples:

To run tests step to step:

	./run.py core -s

To run all tests:

	./run.py core -a

To run a specific test:

	./run.py core -f name_file.hex

##Verilog test bench
