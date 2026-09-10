`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2026 03:38:26 PM
// Design Name: 
// Module Name: PE_B
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


module PE_B(
input [15:0]X,
input [15:0]Y,
input [15:0]Q,
input [15:0]M,
input [15:0]S_in,
input [17:0]C_in,
input CLK,
input rst_n,
output reg[15:0]Q_out,
output reg[15:0]X_out,
output reg[15:0]Y_out,
output reg[15:0]M_out,
output reg[15:0]S_out,
output reg[17:0]C_out
);
    
    wire [31:0]t1;
    wire [32:0]t2;
    
    wire [31:0]t3;
    wire [32:0]t4;
    
    wire [33:0]total;
    
    
    reg [15:0] Y_stall[1:0];
    reg [15:0] M_stall[1:0];

    reg [15:0] S_in_stall;
    
    assign t1 = X*Y;
    assign t2 = t1 + S_in_stall;
    
    assign t3 = Q*M;
    assign t4 = t3 + C_in; 
    
    assign total = t2 + t4;
    
    always@(posedge CLK)
    begin
        if(!rst_n)
        begin 
            Q_out <= 16'b0;
            X_out <= 16'b0;
            Y_stall[0] <= 16'b0;
            Y_stall[1] <= 16'b0;
            Y_out <= 16'b0;
            M_stall[0] <= 16'b0;
            M_stall[1] <= 16'b0;
            S_in_stall <= 16'b0;
            M_out <= 16'b0;
            S_out <= 16'b0;
            C_out <= 18'b0;
        end
    
        else
        begin
            S_in_stall <= S_in;
            Q_out <= Q;
            X_out <= X;
            Y_stall[0] <= Y;
            Y_stall[1] <= Y_stall[0];
            Y_out <= Y_stall[1];
            M_stall[0] <= M;
            M_stall[1] <= M_stall[0];
            M_out <= M_stall[1];
            S_out <= total[15:0];
            C_out <= total[33:16];
        end
    
    end
   
   
endmodule
