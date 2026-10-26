
module tb;

    reg clk, rst;
    wire [31:0] pc;
    wire [31:0] x1, x2, x3, x4, x5;

    riscv_cpu dut (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .debug_x1(x1),
        .debug_x2(x2),
        .debug_x3(x3),
        .debug_x4(x4),
        .debug_x5(x5)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;

        repeat (2) @(negedge clk);
        rst = 0;

        // Allow the program to execute
        repeat (12) @(negedge clk);

        $display("x1 = %0d", x1);
        $display("x2 = %0d", x2);
        $display("x3 = %0d", x3);
        $display("x4 = %0d", x4);
        $display("x5 = %0d", x5);
        $display("PC = %h", pc);

        if (x1 == 5 &&
            x2 == 7 &&
            x3 == 12 &&
            x4 == 12 &&
            x5 == 42)
            $display("RISCV CPU TEST PASS");
        else
            $display("RISCV CPU TEST FAIL");

        $finish;
    end

endmodule
