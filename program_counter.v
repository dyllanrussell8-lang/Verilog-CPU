module program_counter (
    input clk,
    input reset,
    input load,
    input [7:0] load_value,
    output reg [7:0] pc
);
    always @(posedge clk) begin
        if (reset)
            pc <= 8'b0;
        else if (load)
            pc <= load_value;
        else
            pc <= pc + 1;
    end
endmodule
