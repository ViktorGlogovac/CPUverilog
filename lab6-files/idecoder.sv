module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);
  // your implementation here

reg [2:0] opcode_result;
assign opcode = opcode_result;
assign opcode_result = ir [15:13];

reg [1:0] op_result;
assign ALU_op = op_result;
assign op_result = ir [12:11];

reg [15:0] sximm5_result;
assign sximm5 = sximm5_result;

reg [15:0] sximm8_result;
assign sximm8 = sximm8_result;

reg [1:0] shift_op_result;
assign shift_op = shift_op_result;
assign shift_op_result = ir [4:3];

reg [2:0] r_addr_result;
assign r_addr = r_addr_result;

reg [2:0] w_addr_result;
assign w_addr = w_addr_result;

always_comb begin
        if (ir[4] == 1'b0)
                sximm5_result = {11'b0, ir[4:0]};
        else
                sximm5_result = {11'b1, ir[4:0]};

        if (ir[7] == 1'b0)
                sximm8_result = {8'b0, ir[7:0]};
        else
                sximm8_result = {8'b1, ir[7:0]};
        
        case (reg_sel)
                2'b00: begin 
                        r_addr_result = ir [2:0];
                        w_addr_result = ir [2:0];
                end
                2'b01: begin 
                        r_addr_result = ir [7:5];
                        w_addr_result = ir [7:5];
                end
                2'b10: begin 
                        r_addr_result = ir [10:8];
                        w_addr_result = ir [10:8];
                end
                default: begin 
                        r_addr_result = ir [2:0];
                        w_addr_result = ir [2:0];
                end
        endcase
end

endmodule: idecoder
