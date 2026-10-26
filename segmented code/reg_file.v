module reg_file(input clk, input rst, input reg_write, input [4:0] rd,
 input [31:0] write_data, input [4:0] rs1, input [4:0] rs2,
 output wire [31:0] src_a, output wire [31:0] src_b_raw,
 output wire [31:0] debug_x1, debug_x2, debug_x3, debug_x4, debug_x5);
reg [31:0] regs[0:31];
integer i;
always @(posedge clk) begin
 if(rst) begin for(i=0;i<32;i=i+1) regs[i] <= 0; end
 else if(reg_write && rd!=0) regs[rd] <= write_data;
end
assign src_a = (rs1==0) ? 32'b0 : regs[rs1];
assign src_b_raw = (rs2==0) ? 32'b0 : regs[rs2];
assign debug_x1=regs[1]; assign debug_x2=regs[2]; assign debug_x3=regs[3];
assign debug_x4=regs[4]; assign debug_x5=regs[5];
endmodule
