module riscv_cpu (
    input clk, input rst,
    output wire [31:0] pc,
    output wire [31:0] debug_x1, debug_x2, debug_x3, debug_x4, debug_x5
);
    wire [31:0] instr, imm, src_a, src_b, alu_result, next_pc, load_data;
    wire [3:0] alu_ctrl;
    wire reg_write, alu_src, mem_read, mem_write, mem_to_reg, branch, jump;
    wire branch_taken;

    instruction_rom u_rom(.pc(pc), .instr(instr));
    immediate_gen u_imm(.instr(instr), .imm(imm));
    decoder u_dec(.instr(instr), .reg_write(reg_write), .alu_src(alu_src),
        .mem_read(mem_read), .mem_write(mem_write), .mem_to_reg(mem_to_reg),
        .branch(branch), .jump(jump), .alu_ctrl(alu_ctrl));
    reg_file u_regs(.clk(clk), .rst(rst), .reg_write(reg_write),
        .rd(instr[11:7]), .write_data(jump ? pc + 32'd4 : (mem_to_reg ? load_data : alu_result)),
        .rs1(instr[19:15]), .rs2(instr[24:20]), .src_a(src_a), .src_b_raw(rs2_data),
        .debug_x1(debug_x1), .debug_x2(debug_x2), .debug_x3(debug_x3),
        .debug_x4(debug_x4), .debug_x5(debug_x5));
    wire [31:0] rs2_data;
    assign src_b = (alu_src || instr[6:0] == 7'b0110111) ? imm : rs2_data;

    alu32 u_alu(.a((instr[6:0] == 7'b0110111) ? 32'b0 : src_a),
        .b(src_b), .alu_ctrl(alu_ctrl), .result(alu_result));
    data_memory u_mem(.clk(clk), .rst(rst), .mem_read(mem_read), .mem_write(mem_write),
        .addr(alu_result), .write_data(rs2_data), .read_data(load_data));

    wire [31:0] pc_internal;
    program_counter u_pc(.clk(clk), .rst(rst), .next_pc(next_pc), .pc(pc));
    assign branch_taken = branch && (src_a == rs2_data);
    assign next_pc = jump ? pc + imm : (branch_taken ? pc + imm : pc + 32'd4);
endmodule
