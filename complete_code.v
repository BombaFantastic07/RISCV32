
module riscv_cpu (
    input clk,
    input rst,
    output reg [31:0] pc,
    output [31:0] debug_x1,
    output [31:0] debug_x2,
    output [31:0] debug_x3,
    output [31:0] debug_x4,
    output [31:0] debug_x5
);

    reg [31:0] regs [0:31];
    reg [31:0] data_mem [0:63];

    reg [31:0] instr;
    reg [31:0] imm;
    reg [31:0] src_a, src_b, alu_result;
    reg [31:0] next_pc;
    reg [3:0] alu_ctrl;

    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];
    wire [4:0] rd  = instr[11:7];

    reg reg_write, alu_src, mem_read, mem_write;
    reg mem_to_reg, branch, jump;
    reg branch_taken;
    reg [31:0] load_data;
    integer i;

    // Small instruction ROM: demonstration program
    always @(*) begin
        case (pc)
            32'd0:  instr = 32'h00500093; // ADDI x1,x0,5
            32'd4:  instr = 32'h00700113; // ADDI x2,x0,7
            32'd8:  instr = 32'h002081B3; // ADD x3,x1,x2
            32'd12: instr = 32'h00302023; // SW x3,0(x0)
            32'd16: instr = 32'h00002203; // LW x4,0(x0)
            32'd20: instr = 32'h00418463; // BEQ x3,x4,+8
            32'd24: instr = 32'h06300293; // ADDI x5,x0,99
            32'd28: instr = 32'h02A00293; // ADDI x5,x0,42
            32'd32: instr = 32'h0000006F; // JAL x0,0
            default: instr = 32'h00000013; // NOP (ADDI x0,x0,0)
        endcase
    end

    // Immediate generator
    always @(*) begin
        case (opcode)
            7'b0010011, 7'b0000011:
                imm = {{20{instr[31]}}, instr[31:20]};

            7'b0100011:
                imm = {{20{instr[31]}},
                       instr[31:25], instr[11:7]};

            7'b1100011:
                imm = {{19{instr[31]}}, instr[31],
                       instr[7], instr[30:25],
                       instr[11:8], 1'b0};

            7'b0110111:
                imm = {instr[31:12], 12'b0};

            7'b1101111:
                imm = {{11{instr[31]}}, instr[31],
                       instr[19:12], instr[20],
                       instr[30:21], 1'b0};

            default: imm = 32'b0;
        endcase
    end

    // Instruction decoder
    always @(*) begin
        reg_write = 0;
        alu_src = 0;
        mem_read = 0;
        mem_write = 0;
        mem_to_reg = 0;
        branch = 0;
        jump = 0;
        alu_ctrl = 4'b0000;

        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1;
                case (funct3)
                    3'b000:
                        alu_ctrl = (funct7 == 7'b0100000)
                                 ? 4'b0001 : 4'b0000;
                    3'b111: alu_ctrl = 4'b0010;
                    3'b110: alu_ctrl = 4'b0011;
                    3'b100: alu_ctrl = 4'b0100;
                    default: alu_ctrl = 4'b0000;
                endcase
            end

            7'b0010011: begin // ADDI
                reg_write = 1;
                alu_src = 1;
            end

            7'b0000011: begin // LW
                reg_write = 1;
                alu_src = 1;
                mem_read = 1;
                mem_to_reg = 1;
            end

            7'b0100011: begin // SW
                alu_src = 1;
                mem_write = 1;
            end

            7'b1100011: begin // BEQ
                branch = 1;
                alu_ctrl = 4'b0001;
            end

            7'b0110111: begin // LUI
                reg_write = 1;
                alu_src = 1;
            end

            7'b1101111: begin // JAL
                reg_write = 1;
                jump = 1;
            end

            default: begin
            end
        endcase
    end

    // Register file reads
    always @(*) begin
        src_a = (rs1 == 0) ? 32'b0 : regs[rs1];

        if (opcode == 7'b0110111)
            src_b = imm;
        else if (alu_src)
            src_b = imm;
        else
            src_b = (rs2 == 0) ? 32'b0 : regs[rs2];
    end

    // ALU
    always @(*) begin
        case (alu_ctrl)
            4'b0000: alu_result = src_a + src_b;
            4'b0001: alu_result = src_a - src_b;
            4'b0010: alu_result = src_a & src_b;
            4'b0011: alu_result = src_a | src_b;
            4'b0100: alu_result = src_a ^ src_b;
            default: alu_result = 32'b0;
        endcase
    end

    // Branch decision and next PC
    always @(*) begin
        branch_taken = branch &&
                       (regs[rs1] == regs[rs2]);

        next_pc = pc + 32'd4;

        if (branch_taken)
            next_pc = pc + imm;

        if (jump)
            next_pc = pc + imm;
    end

    // Data memory read
    always @(*) begin
        load_data = 32'b0;
        if (mem_read)
            load_data = data_mem[alu_result[7:2]];
    end

    // Sequential processor state
    always @(posedge clk) begin
        if (rst) begin
            pc <= 32'b0;

            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;

            for (i = 0; i < 64; i = i + 1)
                data_mem[i] <= 32'b0;
        end
        else begin
            pc <= next_pc;

            if (mem_write)
                data_mem[alu_result[7:2]] <=
                    (rs2 == 0) ? 32'b0 : regs[rs2];

            if (reg_write && rd != 0) begin
                if (jump)
                    regs[rd] <= pc + 32'd4;
                else if (mem_to_reg)
                    regs[rd] <= load_data;
                else
                    regs[rd] <= alu_result;
            end

            regs[0] <= 32'b0;
        end
    end

    assign debug_x1 = regs[1];
    assign debug_x2 = regs[2];
    assign debug_x3 = regs[3];
    assign debug_x4 = regs[4];
    assign debug_x5 = regs[5];

endmodule
