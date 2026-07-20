module control_unit (
    input [2:0] opcode,
    output reg [2:0] alu_op,
    output reg reg_write,
    output reg pc_load,
    output reg alu_src_imm
);
    always @(*) begin
        alu_op = 3'b000;
        reg_write = 0;
        pc_load = 0;
        alu_src_imm = 0;
        case (opcode)
            3'b000: begin reg_write = 1; alu_src_imm = 1; end
            3'b001: begin alu_op = 3'b000; reg_write = 1; end
            3'b010: begin alu_op = 3'b001; reg_write = 1; end
            3'b011: begin pc_load = 1; end
            3'b100: begin pc_load = 0; end
        endcase
    end
endmodule
