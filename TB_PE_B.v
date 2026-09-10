`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2026 05:47:30 PM
// Design Name: 
// Module Name: TB_PE_B
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


module TB_PE_B();

    // 1. Declare signals
    reg [15:0] X, Y, Q, M, S_in;
    reg [17:0] C_in;
    reg CLK, rst_n;

    wire [15:0] S_out;
    wire [17:0] C_out;

    // Track test failures
    integer error_count = 0;
    integer test_count = 0;

    // 2. Instantiate the Unit Under Test (UUT)
    PE_B uut (
        .X(X),
        .Y(Y),
        .Q(Q),
        .M(M),
        .S_in(S_in),
        .C_in(C_in),
        .CLK(CLK),
        .rst_n(rst_n),
        .S_out(S_out),
        .C_out(C_out)
    );

    // 3. Clock Generation (100 MHz)
    always #5 CLK = ~CLK;

    // 4. Self-Checking Task
    // This task applies inputs, calculates the expected result, waits for the 
    // clock edge so the internal DFFs update, and checks the output.
    task apply_and_check;
        input [15:0] in_X;
        input [15:0] in_Y;
        input [15:0] in_Q;
        input [15:0] in_M;
        input [15:0] in_S_in;
        input [17:0] in_C_in;
        
        reg [33:0] expected_total;
        begin
            // Drive inputs on the negative edge to ensure setup time is met
            @(negedge CLK);
            X = in_X;
            Y = in_Y;
            Q = in_Q;
            M = in_M;
            S_in = in_S_in;
            C_in = in_C_in;
            
            // Calculate the expected total internally.
            // We pad the 16-bit inputs with zeros to 34 bits to prevent Verilog 
            // from truncating the intermediate multiplication results.
            expected_total = ({18'd0, in_X} * {18'd0, in_Y}) + in_S_in + 
                             ({18'd0, in_Q} * {18'd0, in_M}) + in_C_in;
            
            // Wait for the next positive clock edge (when DFFs capture the data)
            @(posedge CLK);
            
            // Wait 1 time unit to account for DFF propagation delay
            #1; 
            
            // Compare expected vs actual
            test_count = test_count + 1;
            if ((S_out === expected_total[15:0]) && (C_out === expected_total[33:16])) begin
                $display("[PASS] Test %0d | Expected S_out: %0h, C_out: %0h | Got S_out: %0h, C_out: %0h", 
                         test_count, expected_total[15:0], expected_total[33:16], S_out, C_out);
            end else begin
                $display("[FAIL] Test %0d | Expected S_out: %0h, C_out: %0h | Got S_out: %0h, C_out: %0h", 
                         test_count, expected_total[15:0], expected_total[33:16], S_out, C_out);
                error_count = error_count + 1;
            end
        end
    endtask

    // 5. Stimulus Block
    initial begin
        $display("==================================================");
        $display("Starting Self-Checking Testbench for PE_B");
        $display("==================================================");

        // Initialize
        CLK = 0;
        rst_n = 0;
        X = 0; Y = 0; Q = 0; M = 0; S_in = 0; C_in = 0;

        // Release reset after a couple of clock cycles
        #15;
        rst_n = 1;
        
        // ---------------------------------------------------------
        // Test Cases using the task: (X, Y, Q, M, S_in, C_in)
        // ---------------------------------------------------------
        
        // Test 1: All Zeros
        apply_and_check(16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 18'd0);
        
        // Test 2: Small numbers (Output fits in 16-bit S_out, C_out should be 0)
        // (2*3) + (4*5) + 10 + 15 = 6 + 20 + 10 + 15 = 51 (0x33)
        apply_and_check(16'd2, 16'd3, 16'd4, 16'd5, 16'd10, 18'd15);
        
        // Test 3: Exact 16-bit boundary overflow 
        // 256 * 256 = 65,536 (0x10000). S_out = 0x0000, C_out = 0x00001
        apply_and_check(16'd256, 16'd256, 16'd0, 16'd0, 16'd0, 18'd0);
        
        // Test 4: Large numbers
        // (1000*1000) + 5000 + (2000*2000) + 10000 = 5,015,000 (0x4C85D8)
        // Expected: S_out = 0x85D8, C_out = 0x0004C
        apply_and_check(16'd1000, 16'd1000, 16'd2000, 16'd2000, 16'd5000, 18'd10000);
        
        // Test 5: Maximum possible values for all inputs
        // X, Y, Q, M = 16'hFFFF (65,535)
        // S_in = 16'hFFFF (65,535)
        // C_in = 18'h3FFFF (262,143)
        apply_and_check(16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF, 18'h3FFFF);
        
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