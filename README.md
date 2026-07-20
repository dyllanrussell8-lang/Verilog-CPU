# 8-bit CPU in Verilog

A simple 8-bit processor built from scratch in Verilog, designed and 
verified through simulation. Built as an independent project to explore 
digital logic design beyond microcontroller/embedded work.

## Architecture

Four core components, wired together into a single CPU:
- **ALU** — performs ADD, SUB, AND, OR, SHIFT LEFT
- **Register File** — 4 general-purpose 8-bit registers
- **Program Counter** — tracks current instruction, supports jumps
- **Control Unit** — decodes instructions and drives the datapath

## Instruction Set

| Instruction | Opcode | Description |
|---|---|---|
| LOAD | 000 | Load immediate value into a register |
| ADD  | 001 | Add two registers |
| SUB  | 010 | Subtract two registers |
| JUMP | 011 | Jump to address |
| JZ   | 100 | Jump if last result was zero |

## What I Built and Verified

Ran a test program: loaded 5 and 3 into registers, added them (result: 8), 
jumped unconditionally to a target address, then triggered a conditional 
jump based on a zero result. All instructions verified via simulation logs.

## A Bug I Found and Fixed

The zero flag from the ALU is combinational — it reflects whatever 
instruction is currently loaded. Initially, my JZ instruction failed 
because by the time it executed, the ALU had already moved on to computing 
JZ's own (irrelevant) operation, overwriting the zero flag from the 
previous SUB. I fixed this by adding a register that "remembers" the zero 
flag from the last ADD/SUB, so JZ checks the correct historical value 
instead of a stale live signal.

## Files

- `alu.v` — arithmetic logic unit
- `reg_file.v` — 4-register register file
- `program_counter.v` — instruction pointer with jump support
- `control_unit.v` — instruction decoder
- `cpu.v` — top-level module wiring everything together
- `testbench.v` — simulation testbench

## What I'd Add Next

- More instructions (multiply, compare, subroutine calls)
- A simple assembler to convert human-readable code into instruction bits
- Pipelining
