# DMA Engine Lab
This repository contains the RTL design of a simple AXI-based DMA engine (memory-to-memory transfer) designed as part of Lab 4 (Week 4).

## Lab Details
- **Objective:** Complete the implementation of a Direct Memory Access (DMA) Finite State Machine (FSM) controller by filling in the missing code sections. The DMA FSM is responsible for managing data transfers between memory-mapped peripherals and system memory without CPU intervention.
- **Components:**
  - `dma_fsm.v`: Verilog module implementing the DMA finite state machine. It handles states such as IDLE, READ, WAIT_READ, WRITE, WAIT_WRITE, INC_ADDR, and DONE. It controls read/write requests and address increments.
  - `dma_engine.v`: The top-level DMA engine module that integrates the `dma_fsm` with memory interface logic. It manages source and destination address registers, transfer counts, status registers (busy, done, error), and interrupt generation on transfer completion (Task 2).
  - `dma_fsm_tb.v`: Verilog testbench file used to verify the correct functioning of the FSM over multiple transfer operations.

## Simulation and Waveforms
To simulate this design, you can use any standard Verilog simulator (e.g., ModelSim, Vivado Simulator, or Icarus Verilog). The testbench includes a `vcd` dump which can be visualized using tools like GTKWave.

### DMA Transfer Waveforms:
![Waveform 1](waveform_1.png)
![Waveform 2](waveform_2.png)

## Important Note
The provided source code is for educational evaluation. Code is expected to be pushed to the provided GitHub repository for final submission.
