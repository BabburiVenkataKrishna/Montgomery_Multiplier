`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2026 04:08:59 PM
// Design Name: 
// Module Name: TB_PE_A
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


module TB_PE_A();

    // Testbench inputs (reg type to drive values)
    reg  [15:0] X;
    reg  [15:0] Y;
    reg  [15:0] S;
    reg  [15:0] M_p;

    // Testbench outputs (wire type to observe outputs)
    wire [15:0] Q;

    // Instantiate the Unit Under Test (UUT)
    PE_A uut (
        .X(X),
        .Y(Y),
        .S(S),
        .M_p(M_p),
        .Q(Q)
    );

    initial begin
        // Monitor changes and display them in the simulation console
        $monitor("Time = %0t | X = %d, Y = %d, S = %d, M_p = %d || Q = %d", 
                 $time, X, Y, S, M_p, Q);

        // --- Test Case 1: Simple small numbers ---
        // Expected: (2 * 3 + 4) * 5 = (6 + 4) * 5 = 50
        X   = 16'd2;
        Y   = 16'd3;
        S   = 16'd4;
        M_p = 16'd5;
        #10;

        // --- Test Case 2: Identity / Zero behavior ---
        // Expected: (10 * 0 + 15) * 1 = (0 + 15) * 1 = 15
        X   = 16'd10;
        Y   = 16'd0;
        S   = 16'd15;
        M_p = 16'd1;
        #10;

        // --- Test Case 3: Testing addition only (M_p = 1, Y = 1) ---
        // Expected: (25 * 1 + 100) * 1 = 125
        X   = 16'd25;
        Y   = 16'd1;
        S   = 16'd100;
        M_p = 16'd1;
        #10;

        // --- Test Case 4: Larger numbers (observing 16-bit truncation) ---
        // Note: 16-bit multiplication can easily overflow 65,535 (16'hFFFF)
        X   = 16'd100;
        Y   = 16'd10;
        S   = 16'd50;
        M_p = 16'd2;
        #10;

        // End simulation
        $finish;
    end

endmodule