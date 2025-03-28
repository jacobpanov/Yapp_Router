# YAPP Router Verification Project

## Overview
This project involves developing a comprehensive UVM-based verification environment to validate the functionality of a YAPP (Yet Another Packet Protocol) router. The YAPP router receives packets on a single input port and routes them to one of three output channels based on a specified protocol. This README provides details about the YAPP router's specifications, verification methodology, and implemented features.

![image](https://github.com/user-attachments/assets/68bc7c14-0101-49be-8f32-8270ef0c4879)

## Router Specifications

### Packet Structure
Each packet includes:
- **Header Byte**: 2-bit address and 6-bit length.
  - Address defines the target output channel (0, 1, or 2).
  - An address of 3 is considered illegal.
- **Payload**: 1–63 bytes of data.
- **Parity Byte**: Even-bit parity calculated over the header and payload bytes.

![image](https://github.com/user-attachments/assets/93db5d4b-9815-4dfc-bf9d-2ffb9ae8dca2)

### Input Port Protocol
The input port operates with active-high signals driven on the clock's falling edge. The protocol is as follows:
- **in_data_vld** is asserted with the header byte, indicating the packet's target output channel.
- After the last payload byte, the **parity byte** is driven, and **in_data_vld** is de-asserted.
- The **in_suspend** signal, when active, pauses input data, signaling a full FIFO buffer.
- An **error** signal is asserted if a packet contains bad parity, with a 1–10 cycle response time.

### Output Port Protocol
Each output channel has:
- A 16-byte FIFO buffer.
- Signals **data_vld_x** and **suspend_x** for data validity and read status.
- The **data_x** bus, where new packet bytes are driven with each rising clock edge.

### Host Interface (HBUS)
The router’s registers are programmed via a synchronous HBUS host interface:
- **Write Operation**: One clock cycle, with **hwr_rd** and **hen** active.
- **Read Operation**: Two cycles, with data tri-stated after reading.

### Registers and Counters
- **ctrl_reg** (0x1000): Sets the max packet size.
- **en_reg** (0x1001): Enables router and error counting.
- **Counters**: Track packet errors, oversize packets, and packet address counts.

## Verification Approach
The verification environment is developed using the UVM framework to simulate and verify all functional requirements of the YAPP router. The environment covers scenarios such as:
- Valid and invalid packet routing.
- FIFO buffer handling for each output channel.
- Host interface read/write operations and register programming.
- Parity and length error detection and response validation.

![image](https://github.com/user-attachments/assets/41edc67c-2816-4993-87a9-0aeebc43fc86)

### Testbench Architecture Diagram
The diagram above shows the UVM testbench architecture used in this project. Key components include:
- **YAPP UVC** and **HBUS UVC** for generating packet sequences and controlling host interface interactions.
- **Scoreboard UVC** to track data and validate correct routing across channels.
- **Channel UVC** instances to simulate each output channel's FIFO buffer.
- **Register Model** for handling the YAPP router's configuration settings.

## Key Features
- **Comprehensive Test Coverage**: Validates routing, error detection, and register configurations.
- **UVM Components**: Includes sequencers, drivers, monitors, and checkers to ensure modular and reusable testbench architecture.
- **Scoreboarding**: Verifies data integrity across channels and checks error handling for invalid packets.