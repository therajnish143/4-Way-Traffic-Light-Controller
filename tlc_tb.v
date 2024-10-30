`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 11:23:40
// Design Name: 
// Module Name: tlc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////





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





