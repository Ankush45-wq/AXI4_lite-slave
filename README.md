# AXI4_lite-slave
# AXI4-Lite Slave Interface Design

## Overview
This project implements a basic AXI4-Lite Slave Interface using SystemVerilog. The design supports communication through AXI4-Lite read and write channels and provides access to an internal memory-mapped register bank.

The project is intended to understand AXI4-Lite protocol fundamentals, channel handshaking, register operations, and RTL design.

## Key Features
- AXI4-Lite Write Address Channel (AW)
- AXI4-Lite Write Data Channel (W)
- AXI4-Lite Write Response Channel (B)
- AXI4-Lite Read Address Channel (AR)
- AXI4-Lite Read Data Channel (R)
- Memory-mapped register bank
- Byte-enable write support using WSTRB
- Read response handling for valid and invalid addresses
- Synchronous reset support

## Register Map

| Address | Register | Access |
|---|---|---|
| 0x00 | Control Register | Read/Write |
| 0x04 | Status Register | Read |
| 0x08 | GPIO Output Register | Read/Write |
| 0x0C | GPIO Input Register | Read |
| 0x10 | Version Register | Read |
| 0x14 | IRQ Enable Register | Read/Write |
| 0x18 | IRQ Status Register | Read |
| 0x1C | Scratch Register | Read/Write |

## Design Architecture

The design consists of four main modules:

1. **axi_write:** Handles AXI write address, write data, and write response channels.
2. **register_bank:** Implements memory-mapped registers and byte-enable write operations.
3. **axi_read:** Handles AXI read address and read data response channels.
4. **axi_slave_top:** Top-level module connecting all internal blocks.

## Tools & Technologies
- SystemVerilog
- RTL Design
- AXI4-Lite Protocol
- Digital Design and Verification

## Verification Plan
The planned verification activities include:
- Register read and write operations
- Independent AW and W channel handshakes
- Byte strobe testing
- Valid and invalid address testing
- Read and write response handling
- Back-to-back transactions
- Reset operation

## Project Status
RTL implementation is in progress. Compilation, debugging, and self-checking testbench development are planned as the next steps.

## Learning Objectives
- Understand AXI4-Lite protocol operation.
- Learn independent read and write channel handshaking.
- Understand memory-mapped register interfaces.
- Develop practical SystemVerilog RTL design and verification skills.
