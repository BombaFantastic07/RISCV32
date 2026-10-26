module alu32(input [31:0] a, input [31:0] b, input [3:0] alu_ctrl, output reg [31:0] result);
always @(*) begin
 case (alu_ctrl)
  4'b0000: result = a + b;
  4'b0001: result = a - b;
  4'b0010: result = a & b;
  4'b0011: result = a | b;
  4'b0100: result = a ^ b;
  default: result = 32'b0;
 endcase
end
endmodule
