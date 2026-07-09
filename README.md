# Single Port RAM
A synthesizable single-port RAM module written in SystemVerilog

## 1. Overview

- **Type:** Single Port RAM
- **Operating Frequency:** 50 MHz
- **Data Width:** 8 bits
- **Depth:** 32 locations (address range: 0–31)
- **Read/Write:** Does **not** support concurrent read and write operations
- **Reset Behavior:** Active-low reset (`reset = 0`) puts the RAM in idle state — all inputs go to zero, `data_in` and `data_out` go to high impedance (`Z`)
- **Invalid Address Handling:**
  - Write with invalid address → no operation performed
  - Read with invalid address → `data_out` becomes `Z`

## 2. Pin Description

| Pin Name    | Direction | Width (bits) | Description                                        |
|-------------|-----------|--------------|----------------------------------------------------|
| `clk`       | Input     | 1            | Clock signal                                       |
| `reset`     | Input     | 1            | Active-low reset, initializes the RAM              |
| `write_enb` | Input     | 1            | Active-high write enable                           |
| `read_enb`  | Input     | 1            | Active-high read enable                            |
| `data_in`   | Input     | 8            | Data input                                         |
| `address`   | Input     | 5            | Memory address (0 to 31)                           |
| `data_out`  | Output    | 8            | Data output                                        |

## 3. Functional Description

### 3.1 Reset Operation
When `reset = 0`:
- `data_in` → high impedance (`Z`)
- `address` → `0`
- `data_out` → high impedance (`Z`)

### 3.2 Write Operation
On the positive edge of `clk`, when `reset = 1`, `write_enb = 1`, and `read_enb = 0`:
- `data_in` is written into `memory[address]`

### 3.3 Read Operation
On the positive edge of `clk`, when `reset = 1`, `write_enb = 0`, and `read_enb = 1`:
- `data_out` is driven with `memory[address]`

## 4. Module Port List

```systemverilog
module RAM(
    input  logic        clk,
    input  logic        reset,      // active-low
    input  logic [4:0]  address,
    input  logic [7:0]  data_in,
    input  logic        write_enb,
    input  logic        read_enb,
    output logic [7:0]  data_out
);
```

## 5. Known Issues in Current RTL (`ram.v_`)

>  These should be reviewed/fixed before sign-off:

1. **Line 41:** `memory[address] <= 8'bz;` on reset — driving a memory array element to `Z` on every reset cycle is unusual for a `reg` array (Z is not meaningfully storable in most simulators/synthesis for internal memory) and doesn't match the spec, which says `data_in` (not the memory array) goes to `Z` on reset.
2. **Line 54:** `data_out <= 8�bz;` — contains a non-ASCII/corrupted character in place of `'`. This is a syntax error and must be corrected to `data_out <= 8'bz;`.
3. **Concurrent read/write:** The spec states the RAM should not support concurrent read and write operations, but the current logic only disables write when `read_enb` is high (and vice versa) — no explicit check/warning for the case when both `write_enb` and `read_enb` are asserted simultaneously.
