module decoder(input [31:0] instr, output reg reg_write, alu_src, mem_read, mem_write,
 output reg mem_to_reg, branch, jump, output reg [3:0] alu_ctrl);
always @(*) begin
 reg_write=0; alu_src=0; mem_read=0; mem_write=0; mem_to_reg=0; branch=0; jump=0; alu_ctrl=0;
 case(instr[6:0])
  7'b0110011: begin
   reg_write=1;
   case(instr[14:12])
    3'b000: alu_ctrl=(instr[31:25]==7'b0100000)?4'b0001:4'b0000;
    3'b111: alu_ctrl=4'b0010;
    3'b110: alu_ctrl=4'b0011;
    3'b100: alu_ctrl=4'b0100;
    default: alu_ctrl=0;
   endcase
  end
  7'b0010011: begin reg_write=1; alu_src=1; end
  7'b0000011: begin reg_write=1; alu_src=1; mem_read=1; mem_to_reg=1; end
  7'b0100011: begin alu_src=1; mem_write=1; end
  7'b1100011: begin branch=1; alu_ctrl=4'b0001; end
  7'b0110111: begin reg_write=1; alu_src=1; end
  7'b1101111: begin reg_write=1; jump=1; end
  default: ;
 endcase
end
endmodule
