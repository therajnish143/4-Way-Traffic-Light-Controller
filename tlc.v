

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2024 10:36:15
// Design Name: 
// Module Name: tlc
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



`define s0 5'd0
`define s1 5'd1
`define s2 5'd2
`define s3 5'd3
`define s4 5'd4
`define s5 5'd5
`define s6 5'd6
`define s7 5'd7
`define s8 5'd8
`define s9 5'd9
`define s10 5'd10
`define s11 5'd11
`define s12 5'd12
`define s13 5'd13
`define s14 5'd14
`define s15 5'd15
`define s16 5'd16
`define s17 5'd17
`define s18 5'd18
`define s19 5'd19
`define s20 5'd20
`define s21 5'd21
`define s22 5'd22
`define s23 5'd23
`define s24 5'd24
`define s25 5'd25
`define s26 5'd26

module tlc(
    input clock, clear, 
    input a1, a2, a3, b1, b2, b3, c1, c2, c3, d1, d2, d3,
    input rc1, rc2, rc3, rc4, ss1, ss2, ss3, ss4,
    output reg [11:0] ID,
    output reg camera,
    output reg [5:0] state, next_state,
    output reg [2:0] maxoutput
);

initial begin
    state = `s0;
    next_state = `s0;
    ID = 12'b100100100100;
    camera = 0;
end

always @(posedge clock) begin
    state <= next_state;
end

always @(state) begin
    case (state)
        `s0, `s1, `s2, `s3, `s4, `s5: ID = 12'b100100100100;
        `s6, `s7, `s8: ID = 12'b001100100100;
        `s9: ID = 12'b010100100100;
        `s10, `s11, `s12: ID = 12'b100001100100;
        `s13: ID = 12'b100010100100;
        `s14, `s15, `s16: ID = 12'b100100001100;
        `s17: ID = 12'b100100010100;
        `s18, `s19, `s20: ID = 12'b100100100001;
        `s21: ID = 12'b100100100010;
        default: ID = 12'b100100100100;
    endcase
end

always @(
    state, clear, a1, a2, a3, b1, b2, b3, c1, c2, c3, 
    d1, d2, d3, rc1, rc2, rc3, rc4, ss1, ss2, ss3, ss4
) begin
    if (clear)
        next_state = `s0;
    else begin
        camera = rc1 || rc2 || rc3 || rc4;
        case (state)
            `s0: 
                if (ss1 || ss2 || ss3 || ss4 || a1 || b1 || c1 || d1)
                    next_state = `s1;
                else 
                    next_state = `s0;

            `s1: begin
                maxof4(a1, a2, a3, b1, b2, b3, c1, c2, c3, d1, d2, d3, maxoutput);
                case (maxoutput)
                    3'd1: next_state = `s2;
                    3'd2: next_state = `s3;
                    3'd3: next_state = `s4;
                    3'd4: next_state = `s5;
                    default: next_state = `s1;
                endcase
            end

            `s2: next_state = (a1 && a2 && a3) ? `s8 : 
                              (a1 && a2 && ~a3) ? `s7 : `s6;

            `s3: next_state = (b1 && b2 && b3) ? `s12 : 
                              (b1 && b2 && ~b3) ? `s11 : `s10;

            `s4: next_state = (c1 && c2 && c3) ? `s16 : 
                              (c1 && c2 && ~c3) ? `s15 : `s14;

            `s5: next_state = (d1 && d2 && d3) ? `s20 : 
                              (d1 && d2 && ~d3) ? `s19 : `s18;

            `s9, `s13, `s17, `s21: next_state = `s0;

            default: next_state = `s0;
        endcase
    end
end

task maxof4(
    input a1, a2, a3, b1, b2, b3, c1, c2, c3, d1, d2, d3,
    output reg [2:0] max
);
    reg [2:0] a, b, c, d;
    begin
        a = {a1, a2, a3};
        b = {b1, b2, b3};
        c = {c1, c2, c3};
        d = {d1, d2, d3};

        if (a >= b && a >= c && a >= d)
            max = 3'd1;
        else if (b >= c && b >= d)
            max = 3'd2;
        else if (c >= d)
            max = 3'd3;
        else
            max = 3'd4;
    end
endtask

endmodule


