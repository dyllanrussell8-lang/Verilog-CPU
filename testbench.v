module tb;
    reg clk, reset;
    reg [15:0] instruction;

    cpu uut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        $strobe("time=%0t | reg0=%d reg1=%d reg2=%d pc=%d",
                   $time, uut.rf.registers[0], uut.rf.registers[1], uut.rf.registers[2], uut.pc);
    end

    initial begin
        clk = 0;
        reset = 1;
        instruction = 16'b0;

        @(negedge clk); reset = 0;

        // LOAD 5 into register 0
        instruction = {3'b000, 2'b00, 2'b00, 8'd5, 1'b0};
        @(negedge clk);

        // LOAD 3 into register 1
        instruction = {3'b000, 2'b01, 2'b00, 8'd3, 1'b0};
        @(negedge clk);

        // ADD register 0 + register 1, store in register 2
        instruction = {3'b001, 2'b10, 2'b00, 8'b00000001, 1'b0};
        @(negedge clk);
        #10;

        // JUMP to address 50
        instruction = {3'b011, 2'b00, 2'b00, 8'd50, 1'b0};
        @(negedge clk);
        #10;

        // Reset PC, then test JZ
        reset = 1;
        @(negedge clk); reset = 0;

        // SUB register 0 - register 0 (always 0), triggers zero flag
        instruction = {3'b010, 2'b11, 2'b00, 8'b00000000, 1'b0};
        @(negedge clk);

        // JZ to address 75 (should fire since last result was zero)
        instruction = {3'b100, 2'b00, 2'b00, 8'd75, 1'b0};
        @(negedge clk);
        #10;

        $finish;
    end
endmodule
