`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2026 06:19:29 PM
// Design Name: 
// Module Name: skew_ff
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


module skew_ff#(parameter STAGES=16,
		parameter BITWIDTH=16)

(
input [BITWIDTH-1:0]D,
input CLK,
input rst_n,
output [BITWIDTH-1:0]Q
    );
    
    wire [BITWIDTH-1:0]temp[STAGES:0];
    assign temp[0] = D; 
    
    genvar i;
    
    generate 
        for(i=0; i<STAGES; i=i+1) begin
            DFF #(.BITWIDTH(BITWIDTH)) dff (.D(temp[i]), .CLK(CLK) , .rst_n(rst_n),.Q(temp[i+1]));
        end
    endgenerate
    
    assign Q = temp[STAGES];
    
endmodule


module DFF #(parameter BITWIDTH = 16)(

input [BITWIDTH-1:0]D,
input CLK,
input rst_n,
output reg[BITWIDTH-1:0]Q

);
 
 always@(posedge CLK)
 begin 
    if(!rst_n) Q <= 'b0;
    else Q <= D;
 end

endmodule