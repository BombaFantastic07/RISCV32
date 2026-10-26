module instruction_rom(input [31:0] pc, output reg [31:0] instr);
always @(*) begin
 case(pc)
  32'd0: instr=32'h00500093;
  32'd4: instr=32'h00700113;
  32'd8: instr=32'h002081B3;
  32'd12: instr=32'h00302023;
  32'd16: instr=32'h00002203;
  32'd20: instr=32'h00418463;
  32'd24: instr=32'h06300293;
  32'd28: instr=32'h02A00293;
  32'd32: instr=32'h0000006F;
  default: instr=32'h00000013;
 endcase
end
endmodule
