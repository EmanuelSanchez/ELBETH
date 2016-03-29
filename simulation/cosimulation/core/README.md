# Cosimulation myHdl (python) and verilog

DIADRAM
=======


                           +--------------+ 
                           |              |
               ------------|  core_top.v  |------------------------------
               |           |              |                             |
               |           +--------------+                             |
               |                           \                            |
               |                            \                           |
               |                             \                          |
               |                              \                         |
               |                               \                        |
               V                                V                       V
    +-------------------------+      +------------------+      +----------------+
    |       core_test.py      |      |                  |      |                |
    |-------------------------|      |  elbeth_memory.v \      \  elbeth_core.v |
    | +------------------+    |      |                  |      |                |
    | | core_compilation |    |      +------------------+      +----------------+
    | +------------------+    |		       |			|
    |                         |		       |			|
    |          +------------+ |		       |			|
    |          | clk_driver | |		       |			V
    |          +------------+ |		       V	      +--------------------+	
    |                         |         +------------+	      | elbeth cpu modules |
    | +-----------+           |         | memory.hex |        +--------------------+
    | | test_bech |           |         +------------+
    | +-----------+           |
    +-------------------------+


USAGE
======

Using the script and the system folder:

Simulation
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
│   ├── elbeth_memory.v
│   ├── elbeth_mux_2_to_1.v
│   ├── elbeth_mux_3_to_1.v
│   ├── elbeth_mux4b_2_to_1.v
│   ├── elbeth_mux_4_to_1.v
│   ├── elbeth_pc_register.v
│   ├── elbeth_reg_file.v
│   └── elbeth_zero_signed_extend.v
└── simulation/
    ├── cosimulation/
    │	└── core/
    │	    ├── core_test.py/
    │	    ├── core_top.v
    │	    ├── myhdl.vpi
    │	    └── memory file to load (To specifications of memory file, view README.md of memory "ELBETH/simulation/memory")
    └── scripts/
    	└── testcore.py/
```

Open the terminal and go to the folder "ELBETH/simulation/scripts", then,
set execute permission on your script:

    chmod +x testcore.py
     
Run de testcore.py script with the following command:

    ./testcore.py name_memory_file (To specifications of memory file, view README.md of memory "ELBETH/simulation/memory")

Example:
    
    ./testcore.py memory.hex


