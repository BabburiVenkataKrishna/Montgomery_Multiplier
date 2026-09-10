`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2026 02:47:23 PM
// Design Name: 
// Module Name: PE_A
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


module PE_A(
input [15:0]X,
input [15:0]Y,
input [15:0]S,
input [15:0]M_p,
input CLK,
input rst_n,
output reg[15:0]X_out,
output reg[15:0]Y_out,
output reg[15:0]M_pout,
output reg[15:0]Q
    );
    
    reg [15:0]temp1;
    wire [15:0]temp2;
    wire [15:0]temp3;
    
    reg [15:0] M_p_stall[1:0];
    // reg [15:0] Y_stall[1:0];
    reg[15:0] Y_stall;
    
    // assign temp1 = X*Y;
    
    assign temp2 = temp1 + S;
    assign temp3 = temp2*M_p;
    
    always @(posedge CLK)
    begin
        if(!rst_n)    
        begin
            temp1 <= 16'b0;
            X_out <= 16'b0;
            Y_stall <= 16'b0;
            Y_out <= 16'b0;
            M_p_stall[0] <= 16'b0;
            M_p_stall[1] <= 16'b0;
            M_pout <= 16'b0;
            Q <= 16'b0;
        end 
        
        else 
        begin
            temp1 <= X*Y;
            X_out <= X;
            Y_stall <= Y;
            Y_out <= Y_stall;
            M_p_stall[0] <= M_p;
            M_p_stall[1] <= M_p_stall[0];
            M_pout <= M_p_stall[1];
            Q <= temp3;
        end
     
    end 
    
endmodule

