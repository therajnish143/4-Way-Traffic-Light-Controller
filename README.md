# 4-Way-Traffic-Light-Controller




## Overview
This project implements a **4-way intersection traffic light controller** using **Verilog HDL**. The controller dynamically adjusts the light signals based on **traffic density**, **emergency vehicle detection**, and **rule violations**. 

## Table of Contents
1. Project Structure  
2. Problem Statement  
3. System Architecture  
4. Input/Output Specifications  
5. Verilog Code
6. Testbench    
7. Results 
8. Future Improvements  
  

## Project Structure
```
traffic_light_controller/
│
├── src/
│   └── tlc.v       # Verilog design file
├── testbench/
│   └── tlc_tb.v         # Testbench to verify design
├── docs/
   └── README.md                  # Documentation (this file)

```

## Problem Statement
The problem revolves around **managing a busy 4-way intersection** by:
1. Ensuring smooth traffic flow with **dynamic signal switching**.
2. **Prioritizing emergency vehicles** over regular traffic.
3. **Detecting rule violations** and recording them via cameras.
4. Adapting traffic lights based on **real-time traffic density.**

## System Architecture
The intersection has **4 roads (A, B, C, D)**. Each road has:
- **Traffic density sensors** to detect congestion.
- **Emergency vehicle siren sensors** for prioritizing emergency vehicles.
- **Rule violation cameras** to record violations.

### Finite State Machine (FSM) Overview
The **FSM design** governs the signal logic with these states:
1. **IDLE:** No or light traffic.
2. **PRIORITY:** Emergency vehicle detected.
3. **TRAFFIC CONTROL:** Switching signals based on density.

## Input/Output Specifications
### Inputs:
```verilog
input a1, a2, a3;  // Traffic sensors for Road A
input b1, b2, b3;  // Traffic sensors for Road B
input c1, c2, c3;  // Traffic sensors for Road C
input d1, d2, d3;  // Traffic sensors for Road D

input ss1, ss2, ss3, ss4;  // Siren sensors for emergency vehicles
input rc1, rc2, rc3, rc4;  // Rule violation detectors
```

### Outputs:
```verilog
output reg [11:0] ID
// Signal states:  for example 12'b100100100100  Red light on every road
, 12'b100001100100 green light on road B , red light on road A,B,D ```

## Verilog Design Concepts
### FSM Implementation:
Below is the **FSM logic for handling traffic signals**:
```verilog
module tlc(
    input clock, clear, 
    input a1, a2, a3, b1, b2, b3, c1, c2, c3, d1, d2, d3,
    input rc1, rc2, rc3, rc4, ss1, ss2, ss3, ss4,
    output reg [11:0] ID,
    output reg camera,
    output reg [5:0] state, next_state,
    output reg [2:0] maxoutput
);

// Initialization block to set default values at the start
initial begin
    state = `s0;              // Initial state set to s0
    next_state = `s0;          // Initialize next_state to s0
    ID = 12'b100100100100;     // Default ID value
    camera = 0;                // Initialize camera to 0 (no rule violation detected)
end

// State transition logic triggered by the rising edge of the clock
always @(posedge clock) begin
    state <= next_state;       // Update the current state with the next state
end

// ID assignment logic based on the current state
always @(state) begin
    case (state)
        `s0, `s1, `s2, `s3, `s4, `s5: ID = 12'b100100100100;   // Default ID
        `s6, `s7, `s8: ID = 12'b001100100100;                   // Different state block
        `s9: ID = 12'b010100100100;                             // State s9-specific ID
        `s10, `s11, `s12: ID = 12'b100001100100;                // Another ID block
        `s13: ID = 12'b100010100100;                            // State s13-specific ID
        `s14, `s15, `s16: ID = 12'b100100001100;                // Another set of states
        `s17: ID = 12'b100100010100;                            // State s17-specific ID
        `s18, `s19, `s20: ID = 12'b100100100001;                // Another group of states
        `s21: ID = 12'b100100100010;                            // State s21-specific ID
        default: ID = 12'b100100100100;                         // Fallback ID
    endcase
end

// Logic to determine the next state based on inputs and conditions
always @(
    state, clear, a1, a2, a3, b1, b2, b3, c1, c2, c3, 
    d1, d2, d3, rc1, rc2, rc3, rc4, ss1, ss2, ss3, ss4
) begin
    if (clear)                      // If the system is reset/cleared
        next_state = `s0;            // Return to initial state
    else begin
        camera = rc1 || rc2 || rc3 || rc4;  // Activate camera if any rule violation is detected

        // State transition logic based on traffic inputs and emergency signals
        case (state)
            `s0: 
                if (ss1 || ss2 || ss3 || ss4 || a1 || b1 || c1 || d1) // Detect emergency or high priority traffic
                    next_state = `s1;  // Move to decision state
                else 
                    next_state = `s0;  // Stay in the initial state

            `s1: begin  // Determine the road with the highest traffic density
                maxof4(a1, a2, a3, b1, b2, b3, c1, c2, c3, d1, d2, d3, maxoutput);
                case (maxoutput)  // Transition based on the road with max traffic
                    3'd1: next_state = `s2;
                    3'd2: next_state = `s3;
                    3'd3: next_state = `s4;
                    3'd4: next_state = `s5;
                    default: next_state = `s1;  // Stay in the decision state if unresolved
                endcase
            end

            // Transition based on traffic density levels for each road
            `s2: next_state = (a1 && a2 && a3) ? `s8 : 
                              (a1 && a2 && ~a3) ? `s7 : `s6;

            `s3: next_state = (b1 && b2 && b3) ? `s12 : 
                              (b1 && b2 && ~b3) ? `s11 : `s10;

            `s4: next_state = (c1 && c2 && c3) ? `s16 : 
                              (c1 && c2 && ~c3) ? `s15 : `s14;

            `s5: next_state = (d1 && d2 && d3) ? `s20 : 
                              (d1 && d2 && ~d3) ? `s19 : `s18;

            // Reset to initial state from terminal states
            `s9, `s13, `s17, `s21: next_state = `s0;

            default: next_state = `s0;  // Fallback to the initial state
        endcase
    end
end

// Task to determine the road with the highest traffic density
task maxof4(
    input a1, a2, a3, b1, b2, b3, c1, c2, c3, d1, d2, d3,
    output reg [2:0] max
);
    reg [2:0] a, b, c, d;  // Registers to hold the density values
    begin
        a = {a1, a2, a3};  // Concatenate traffic values for road A
        b = {b1, b2, b3};  // Concatenate traffic values for road B
        c = {c1, c2, c3};  // Concatenate traffic values for road C
        d = {d1, d2, d3};  // Concatenate traffic values for road D

        // Determine the maximum traffic road
        if (a >= b && a >= c && a >= d)
            max = 3'd1;  // Road A has the highest traffic
        else if (b >= c && b >= d)
            max = 3'd2;  // Road B has the highest traffic
        else if (c >= d)
            max = 3'd3;  // Road C has the highest traffic
        else
            max = 3'd4;  // Road D has the highest traffic
    end
endtask

endmodule

```

## Testbench
Here is the **testbench** to verify the functionality:
```verilog
module tlc_tb;  // Testbench module

  // Testbench Signals
  reg clock, clear;
  reg a1, a2, a3, b1, b2, b3, c1, c2, c3, d1, d2, d3;
  reg rc1, rc2, rc3, rc4;
  reg ss1, ss2, ss3, ss4;

  wire [11:0] ID;
  wire camera;
  wire [5:0] state, next_state;
  wire [2:0] maxoutput;

  // Instantiate the tlc module
  tlc uut (
    .ID(ID),
    .camera(camera),
    .state(state),
    .next_state(next_state),
    .maxoutput(maxoutput),
    .clock(clock),
    .clear(clear),
    .a1(a1), .a2(a2), .a3(a3),
    .b1(b1), .b2(b2), .b3(b3),
    .c1(c1), .c2(c2), .c3(c3),
    .d1(d1), .d2(d2), .d3(d3),
    .rc1(rc1), .rc2(rc2), .rc3(rc3), .rc4(rc4),
    .ss1(ss1), .ss2(ss2), .ss3(ss3), .ss4(ss4)
  );

  // Clock generation: 50 MHz clock (20 ns period)
  initial begin
    clock = 0;
    forever #10 clock = ~clock;  // Toggle clock every 10 ns
  end

  // Test sequence
  initial begin
    // Initialize Inputs
    clear =1;
     a1 = 0; a2 = 0; a3 = 0;
    b1 = 0; b2 = 0; b3 = 0;
    c1 = 0; c2 = 0; c3 = 0;
    d1 = 0; d2 = 0; d3 = 0;
    rc1 = 0; rc2 = 0; rc3 = 0; rc4 = 0;
    ss1 = 0; ss2 = 0; ss3 = 0; ss4 = 0;


    
    clear =0;
    a1 = 1; a2 = 0; a3 = 0;
    b1 = 1; b2 = 0; b3 = 0;
    c1 = 1; c2 = 0; c3 = 0;
    d1 = 1; d2 = 0; d3 = 0;
    #30;
    
    
  
    a1 = 1; a2 = 0; a3 = 0;
    b1 = 1; b2 = 1; b3 = 0;
    c1 = 1; c2 = 0; c3 = 0;
    d1 = 1; d2 = 0; d3 = 0;
    #30;
    
    a1 = 1; a2 = 0; a3 = 0;
    b1 = 1; b2 = 1; b3 = 0;
    c1 = 1; c2 = 1; c3 = 1;
    d1 = 1; d2 = 0; d3 = 0;
   #30;

    
    a1 = 1; a2 = 1; a3 = 1;
    b1 = 1; b2 = 1; b3 = 0;
    c1 = 0; c2 = 0; c3 = 0;
    d1 = 0; d2 = 0; d3 = 0;
    #30;

    
    a1 = 0; a2 = 0; a3 = 0;
    b1 = 1; b2 = 0; b3 = 0;
    c1 = 1; c2 = 1; c3 = 0;
    d1 = 1; d2 = 1; d3 = 1;
   #30;

   
    ss2 = 1;
    #30;

 
    ss1 = 0; ss2 = 0; ss3 = 0; 
     ss4 = 1;
    #30;

    
    ss1 = 1; ss3 = 1; ss2 = 0;  ss4 = 0;
    #30;

    
    rc1 = 1; 
    a1 = 1; a2 = 1; a3 = 1;
    b1 = 1; b2 = 1; b3 = 0;
    c1 = 0; c2 = 0; c3 = 0;
    d1 = 0; d2 = 0; d3 = 0;
    #30;

   
    rc1 = 0; 
    a1 = 1; a2 = 1; a3 = 0;
    b1 = 1; b2 = 1; b3 = 0;
    c1 = 0; c2 = 0; c3 = 0;
    d1 = 0; d2 = 0; d3 = 0;
    #30;
    
    a1 = 1; a2 = 0; a3 = 0;
    b1 = 1; b2 = 1; b3 = 0;
    c1 = 0; c2 = 0; c3 = 0;
    d1 = 0; d2 = 0; d3 = 0;
    #30;
    
    

    a1 = 1; a2 = 1; a3 = 1;
    b1 = 1; b2 = 1; b3 = 1;
    c1 = 1; c2 = 1; c3 = 1;
    d1 = 1; d2 = 1; d3 = 1;
    #30;




    
    a1 = 0; a2 = 0; a3 = 0;
    b1 = 0; b2 = 0; b3 = 0;
    c1 = 0; c2 = 0; c3 = 0;
    d1 = 0; d2 = 0; d3 = 0;
    ss1 = 0; ss2 = 0; ss3 = 0; ss4 = 0;
    rc1 = 0; rc2 = 0; rc3 = 0; rc4 = 0;
    #30;


    $finish;
  end
endmodule

```



## Results
- **Emergency vehicles** get top priority.
- **Heavy traffic** roads get green signals when no emergencies occur.
- **Default state** is red when no traffic is detected.

## Future Improvements
1. **Adaptive signal timing** based on traffic patterns.
2. **IoT integration** for real-time monitoring.
3. **Pedestrian management** features.


