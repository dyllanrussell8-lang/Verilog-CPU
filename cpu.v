module cpu (
    input clk,
    input reset,
    input [15:0] instruction
);

    wire [2:0] opcode   = instruction[15:13];
    wire [1:0] rd        = instruction[12:11];
    wire [1:0] rs1        = instruction[10:9];
    wire [7:0] rs2_imm    = instruction[8:1];

    wire [2:0] alu_op;
    wire reg_write, pc_load, alu_src_imm;

    control_unit cu (
        .opcode(opcode),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .pc_load(pc_load),
        .alu_src_imm(alu_src_imm)
    );

    wire [7:0] read_data1, read_data2;
    wire [7:0] alu_result;
    wire zero;

    // Remember the zero flag from the last ADD/SUB, since it would
    // otherwise change before a JZ instruction gets to check it
    reg zero_flag;
    always @(posedge clk) begin
        if (opcode == 3'b001 || opcode == 3'b010)
            zero_flag <= zero;
    end

    wire [7:0] write_data = (opcode == 3'b000) ? rs2_imm : alu_result;

    reg_file rf (
        .clk(clk),
        .write_enable(reg_write),
        .write_addr(rd),
        .write_data(write_data),
        .read_addr1(rs1),
        .read_addr2(rs2_imm[1:0]),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    wire [7:0] alu_b = alu_src_imm ? rs2_imm : read_data2;

    alu a (
        .a(read_data1),
        .b(alu_b),
        .opcode(alu_op),
        .result(alu_result),
        .zero(zero)
    );

    wire [7:0] pc;
    program_counter pcu (
        .clk(clk),
        .reset(reset),
        .load(pc_load || (opcode == 3'b100 && zero_flag)),
        .load_value(rs2_imm),
        .pc(pc)
    );

endmodule
