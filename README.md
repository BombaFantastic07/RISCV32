# 32-bit RISC-V CPU Design Using Verilog

A simple 32-bit RISC-V processor implemented in Verilog HDL, featuring instruction decoding, immediate generation, a register file, an ALU, data memory, and program counter logic. The project includes RTL simulation, gate-level synthesis artifacts, and physical-design outputs for exploration.

## Overview

This project demonstrates the design and implementation of a basic RISC-V CPU using Verilog. The processor executes a small hardcoded demonstration program and exposes selected registers for debugging.

The design is intended for learning digital design, computer architecture, RTL coding, logic synthesis, and VLSI implementation workflows.

## Features

- 32-bit processor datapath
- Instruction ROM containing a demonstration program
- Immediate generator for I, S, B, U, and J instruction formats
- 32 × 32-bit general-purpose register file
- 32-bit arithmetic and logic unit (ALU)
- 64 × 32-bit data memory
- Instruction decoder and control logic
- Program counter with sequential, branch, and jump handling
- Reset support
- Debug outputs for registers `x1` through `x5`
- RTL simulation testbench
- Synthesized gate-level Verilog netlist
- Layout images and a GDS output file

## Architecture

The processor consists of the following main components:

| Module | Description |
|---|---|
| `instruction_rom` | Supplies instructions based on the program counter |
| `immediate_gen` | Extracts and extends instruction immediate values |
| `decoder` | Generates control signals from the instruction |
| `reg_file` | Stores general-purpose registers and provides read ports |
| `alu32` | Performs arithmetic and logical operations |
| `data_memory` | Supports load and store operations |
| `program_counter` | Maintains and updates the instruction address |
| `riscv_cpu` | Integrates the processor components |

## Demonstration Program

The built-in program illustrates the following operations:

| PC | Instruction | Operation |
|---:|---|---|
| 0 | `ADDI x1, x0, 5` | Load the value 5 into `x1` |
| 4 | `ADDI x2, x0, 7` | Load the value 7 into `x2` |
| 8 | `ADD x3, x1, x2` | Add `x1` and `x2` |
| 12 | `SW x3, 0(x0)` | Store the result in data memory |
| 16 | `LW x4, 0(x0)` | Load the stored value into `x4` |
| 20 | `BEQ x3, x4, +8` | Branch if the values are equal |
| 24 | `ADDI x5, x0, 99` | Set `x5` to 99 if reached |
| 28 | `ADDI x5, x0, 42` | Set `x5` to 42 |
| 32 | `JAL x0, 0` | Loop indefinitely |

The intended final register values are:

- `x1 = 5`
- `x2 = 7`
- `x3 = 12`
- `x4 = 12`
- `x5 = 42`

These are the expected results for the demonstration program; run the supplied testbench to verify the behavior of the particular RTL version.

## Project Structure

```text
fpga_project/
├── complete_code.v
├── tb_complete_code.v
├── netlist_using_chipverify.v
├── riscv_cpu.gds
├── segmented codes/
│   ├── riscv_cpu.v
│   ├── instruction_rom.v
│   ├── immediate_gen.v
│   ├── decoder.v
│   ├── reg_file.v
│   ├── alu32.v
│   ├── data_memory.v
│   └── program_counter.v
├── gate level/
│   ├── complete_gatelevel.png
│   ├── GATE LEVEL MODELING.pdf
│   └── overall_RISCV_modeling.pdf
├── layout/
│   ├── layout1.png
│   ├── layout2.png
│   ├── layout3.png
│   ├── layout4.png
│   ├── layout5.png
│   └── layout6.png
└── results/
    ├── endpoints_using_synthexplorer.png
    ├── fanout_using_synthexplorer.png
    ├── overview_using_synthexplorer.png
    ├── riscv_rtl_simulation_using_chipverify.png
    └── rtl_successful.png
```

## Tools Used

- **Verilog HDL** — RTL design
- **ChipVerify** — Online RTL simulation and synthesis workflow
- **RapidRTL** — Online synthesis and schematic exploration
- **Synthesis Explorer** — Netlist and synthesis-report inspection
- **SkyWater SKY130** — Standard-cell technology associated with the supplied gate-level artifacts

Tool versions, synthesis settings, and physical-design settings may affect the generated results.

## Run the RTL Simulation

If Icarus Verilog is installed, open a terminal in the project directory and run:

1. Compile the RTL and testbench:

   ```bash
   iverilog -g2012 -s tb -o sim.out complete_code.v tb_complete_code.v
   ```

2. Run the simulation:

   ```bash
   vvp sim.out
   ```

3. Inspect the register values and the testbench result printed in the terminal.

If compilation or simulation fails, check the module names and ensure that the testbench matches the selected RTL implementation.

## Gate-Level Synthesis

The project includes `netlist_using_chipverify.v`, which contains a synthesized gate-level representation.

To explore the design:

1. Open the netlist in a compatible Verilog viewer or synthesis tool.
2. Select the correct top module.
3. Inspect the mapped logic cells and connectivity.
4. Review the gate-level schematic and synthesis reports, if supported.

Large designs may exceed the rendering limits of browser-based schematic visualizers. In that case, inspect individual modules or use a viewer that supports hierarchical designs.

## Layout and GDS

The `layout/` directory contains layout screenshots, while `riscv_cpu.gds` is a GDS-format layout artifact.

These files are provided for design exploration. Their inclusion does not by itself establish that the design has passed physical verification, such as design-rule checking (DRC), layout-versus-schematic checking (LVS), or timing closure.

## Learning Objectives

This project can help demonstrate:

- RISC-V instruction execution
- Datapath and control-unit design
- Verilog RTL modeling
- Synchronous and combinational logic
- Register-file and memory implementation
- Logic synthesis and gate-level netlists
- Standard-cell layout artifacts

## Limitations

This is a simplified educational processor, not a complete implementation of the RISC-V ISA. It supports only a limited set of instructions and uses a hardcoded instruction sequence. It does not include a complete exception-handling system, interrupt controller, or full privileged architecture.

The supplied RTL, netlist, and physical-design artifacts may represent different stages or revisions of the project; verify their consistency before treating them as a single validated implementation.

## Future Improvements

- Add support for more RISC-V instructions
- Improve verification with self-checking testbenches
- Add waveform generation and debugging
- Optimize register-file and memory implementations
- Evaluate area, timing, and power after synthesis
- Perform physical verification of the layout

## License

Choose a license before distributing or reusing this project. For example, the MIT License may be suitable if you intend to permit reuse with attribution.

---

**Note:** This project is intended for educational and research purposes. Verify the RTL and generated implementation before using it in hardware.
