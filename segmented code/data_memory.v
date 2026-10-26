module data_memory(input clk, input rst, input mem_read, input mem_write,
 input [31:0] addr, input [31:0] write_data, output reg [31:0] read_data);
reg [31:0] mem[0:63];
integer i;
always @(posedge clk) begin
 if(rst) begin for(i=0;i<64;i=i+1) mem[i] <= 0; end
 else if(mem_write) mem[addr[7:2]] <= write_data;
end
always @(*) begin
 if(mem_read) read_data=mem[addr[7:2]];
 else read_data=0;
end
endmodule
