`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/13 14:15:20
// Design Name: 
// Module Name: mmult
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


module mmult(
    input clk ,                  // Clock signal.
    input reset_n ,              // Reset signal (negative logic
    input enable,                // Activation signal for matrix
                                 // multiplication (tells the circuit
                                 // that A and B are ready for
    input [0:9*8-1] A_mat ,      // A matrix.
    input [0:9*8-1] B_mat ,      // B matrix.
    output valid,                // Signals that the output isvalid
                                 //to read.
    output reg [0:9*17-1] C_mat  // The result of A x B.
    );
    
    integer id = 0;
    integer idc;
    reg result=0;
    
    assign valid = result;
    
    always @(posedge clk) begin
        if(enable) begin
            for (idc = 0; idc < 3; idc = idc + 1) 
            begin
                C_mat[id*51+idc*17 +: 17]= A_mat[id * 24 +: 8] * B_mat[idc*8 +: 8] +
                                       A_mat[8+id*24 +: 8] * B_mat[24+idc*8 +: 8] +
                                       A_mat[16+id*24 +: 8] * B_mat[48+idc*8 +: 8];
            end
            id = id + 1;
        end
        if(id == 3) begin
            result <= 1;
        end
    end        
endmodule
