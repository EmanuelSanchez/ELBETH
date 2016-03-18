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
│   ├── all elbeth modules
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


