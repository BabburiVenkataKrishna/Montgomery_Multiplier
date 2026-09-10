`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2026 10:57:43 AM
// Design Name: 
// Module Name: Systolic_Array
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


module Systolic_Array(
input [255:0]X,
input [255:0]Y,
input [255:0]M,
input [15:0]M_p,
input CLK,
//input rst_n,
output [271:0]out
    );
    
    wire rst_n;
    assign rst_n = 1'b1;
    
    wire [15:0]m [17:0][17:0];
    wire [15:0]y [17:0][18:0];
    wire [15:0]x [16:0][19:0];
    
    wire [15:0] m_p[17:0];
    wire [15:0] q[16:0][18:0];
    wire [15:0] s[17:0][18:0];
    wire [17:0] c[16:0][18:0];
    
    
    wire [271:0] tempout;
    wire [271:0] xpad;
    wire [287:0] ypad;
    wire [287:0] mpad;
    
    
    assign xpad = {16'b0,X};
    assign ypad = {32'b0,Y};
    assign mpad = {32'b0,M};
    
    genvar i,j;
    
    generate
        for(i=0; i<18; i=i+1)
        begin
            skew_ff #(.STAGES(i+1), .BITWIDTH(16)) ff_y (
                .D(ypad[16*i+15:16*i]),
                .CLK(CLK),
                .rst_n(rst_n),
                .Q(y[0][i+1])
            );
            skew_ff #(.STAGES(i+1), .BITWIDTH(16)) ff_m (
                .D(mpad[16*i+15:16*i]),
                .CLK(CLK),
                .rst_n(rst_n),
                .Q(m[0][i])
            );
        end
        
        assign x[0][0] = xpad[15:0];
        for(i=1; i<17; i=i+1)
        begin
            skew_ff #(.STAGES(i*3-1), .BITWIDTH(16)) ff_x (
                .D(xpad[16*i+15:16*i]),
                .CLK(CLK),
                .rst_n(rst_n),
                .Q(x[i][0])
            );
        end
        
        for(i=0; i<17; i=i+1)
        begin
            skew_ff #(.STAGES(16-i), .BITWIDTH(16)) ff_out (
                .D(s[17][i+1]),
                .CLK(CLK),
                .rst_n(rst_n),
                .Q(tempout[16*i+15:16*i])
            );
        end
    endgenerate
    
    
    
    
    generate
        assign m_p[0] = M_p;
        assign y[0][0] = Y[15:0];
        
        for(i=0; i<18; i=i+1)
        begin
            assign s[0][i] = 'b0;
            assign s[i][18] = 'b0;
        end
        

        for(i=0; i<17; i=i+1)
        begin
            assign c[i][0] = 'b0;
        end
        
    endgenerate
    
    generate
        for(i=0; i<17; i=i+1)
        begin
            PE_A A (
                .X(x[i][0]),
                .Y(y[i][0]),
                .S(s[i][1]),
                .M_p(m_p[i]),
                .CLK(CLK),
                .rst_n(rst_n),
                .X_out(x[i][1]),
                .Y_out(y[i+1][0]),
                .M_pout(m_p[i+1]),
                .Q(q[i][0])
            );
        end
    endgenerate
    
    generate
        for(i=0; i<17; i=i+1)
        begin
            for(j=1; j<19; j=j+1)
            begin
                PE_B B(
                    .X(x[i][j]),
                    .Y(y[i][j]),
                    .Q(q[i][j-1]),
                    .M(m[i][j-1]),
                    .S_in(s[i][j]),
                    .C_in(c[i][j-1]),
                    .CLK(CLK),
                    .rst_n(rst_n),
                    .X_out(x[i][j+1]),
                    .Y_out(y[i+1][j]),
                    .Q_out(q[i][j]),
                    .M_out(m[i+1][j-1]),
                    .S_out(s[i+1][j-1]),
                    .C_out(c[i][j])
                );
            end
        end
    endgenerate
    
    
    
    assign out = tempout;
endmodule
