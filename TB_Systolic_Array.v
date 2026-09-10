`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2026 01:57:25 PM
// Design Name: 
// Module Name: TB_Systolic_Array
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


module TB_Systolic_Array();

    // 1. Declare signals
    reg [255:0] X;
    reg [255:0] Y;
    reg [255:0] M;
    reg [15:0]  M_p;
    reg CLK;
//  reg rst_n;

    wire [271:0] out;

    // Track test failures
    integer error_count = 0;
    integer test_count = 0;

    // 2. Instantiate the Unit Under Test (UUT)
    Systolic_Array uut (
        .X(X),
        .Y(Y),
        .M(M),
        .M_p(M_p),
        .CLK(CLK),
//      .rst_n(rst_n),
        .out(out)
    );

    // 3. Clock Generation (100 MHz)
    always #5 CLK = ~CLK;

    // 4. Self-Checking Task (Latency independent)
    task apply_and_check;
        input [255:0] in_X;
        input [255:0] in_Y;
        input [255:0] in_M;
        input [15:0]  in_M_p;
        input [271:0] expected_out;
        begin
            // Drive inputs on the negative edge to ensure clean setup times
            @(negedge CLK);
            X = in_X;
            Y = in_Y;
            M = in_M;
            M_p = in_M_p;
            
            // Generic wait time without fixed latency parameter
            // Adjust this delay if your module still requires a specific number of cycles to process
            #1000; 
            
            // Compare expected vs actual
            test_count = test_count + 1;
            if (out === expected_out) begin
                $display("[PASS] Test %0d", test_count);
            end else begin
                $display("[FAIL] Test %0d", test_count);
                $display("       Expected : %h", expected_out);
                $display("       Actual   : %h", out);
                error_count = error_count + 1;
            end
        end
    endtask

    // 5. Stimulus Block
    initial begin
        $display("==================================================");
        $display("Starting Self-Checking Testbench for Systolic_Array (240-bit padded)");
        $display("==================================================");

        // Initialize Inputs
        CLK = 0;
//      rst_n = 0;
        X = 256'd0; 
        Y = 256'd0; 
        M = 256'd0; 
        M_p = 16'd0;

        // Release reset after a few clock cycles
        #25;
//      rst_n = 1;
        
        // ---------------------------------------------------------
        // INSERT YOUR TEST CASES HERE
        // Format: apply_and_check(X, Y, M, M_p, EXPECTED_OUT);
        // Replace the 256'h... placeholders with your Python results
        // ---------------------------------------------------------
        
        // Test Case 1: 240-bit data padded to 256-bit
        // The top 16 bits (4 hex digits) are zero-padded (0000), followed by 60 hex digits (240 bits)
        apply_and_check(
            256'hABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789, // X (240-bit + zero padded)
            256'h123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0, // Y (240-bit + zero padded)
            256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF43, // M (240-bit + zero padded)
            16'hFA95,                                                               // M_p (Replace with correct pre-computed value)
            256'h1415C53F5EE1998448D2C0B628891D5B773A66D79CDB4BDD504CB7A3BBD824FB  // Expected output (Replace with Python result)
        );
        
        // ---------------------------------------------------------
        // Final Summary
        // ---------------------------------------------------------
        $display("==================================================");
        if (error_count == 0) begin
            $display("SIMULATION PASSED! All %0d tests successful.", test_count);
        end else begin
            $display("SIMULATION FAILED! %0d out of %0d tests failed.", error_count, test_count);
        end
        $display("==================================================");
        
        $finish;
    end
endmodule