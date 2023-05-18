module alu(output [7:0] alu_out,input [7:0] accum,input [7:0] data,input [2:0] opcode,output zero,input clk,input reset);

// modeling your design here !!
    
    reg[7:0] alu_outr;
    
    assign zero = !accum;
    assign alu_out = alu_outr;
    
    always @(posedge clk) begin
        if (reset) begin
            alu_outr <= 0;
        end
        case (opcode)
            3'b000:alu_outr = accum;
            3'b001:alu_outr = accum + data;
            3'b010:alu_outr = accum - data;
            3'b011:alu_outr = accum & data;
            3'b100:alu_outr = accum ^ data;
            3'b101:alu_outr = (accum[7]) ? -accum : accum;
            3'b110:alu_outr = -accum; 
            3'b111:alu_outr = data;
            default:alu_outr = 0;
        endcase
    end



endmodule
