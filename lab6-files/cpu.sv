module cpu(input clk, input rst_n, input load, input start, input [15:0] instr,
           output waiting, output [15:0] out, output N, output V, output Z);
// your implementation here

//wire connecting iregister to idecoder
reg [15:0] instr_reg_dec;

//wires connecting idecoder to datapath
wire [1:0] shift_op;
wire [15:0] sximm5;
wire [15:0] sximm8;
wire [2:0] r_addr;               
wire [2:0] w_addr;

//wires connecting idecoder to controller
wire [2:0] opcode; 
wire [1:0] ALU_op;

//wires connecting  controller to datapath
wire w_en, en_A, en_B, en_C, en_status, sel_A, sel_B;
wire [1:0] wb_sel;

//wires connecting  controller to idecoder
wire [1:0] reg_sel;

//wires connecting  datapath to controller
wire Z_wire, N_wire, V_wire;

reg [15:0] mdata = 16'b0;
reg [7:0] pc = 8'b0;

reg instruction;

always_ff @(posedge clk) begin
  if (load)
    instr_reg_dec <= instr;
end

idecoder instruction_decoder (.ir(instr_reg_dec), .reg_sel(reg_sel), .opcode(opcode), .ALU_op(ALU_op), 
                              .shift_op(shift_op), .sximm5(sximm5), .sximm8(sximm8), 
                              .r_addr(r_addr), .w_addr(w_addr));

controller controller_fsm (.clk(clk), .rst_n(rst_n), .start(start), .opcode(opcode), .ALU_op(ALU_op), 
                          .shift_op(shift_op), .Z(Z_wire), .N(N_wire), .V(V_wire), .waiting(waiting), 
                          .reg_sel(reg_sel), .wb_sel(wb_sel), .w_en(w_en), .en_A(en_A), .en_B(en_B), .en_C(en_C), 
                          .en_status(en_status), .sel_A(sel_A), .sel_B(sel_B));

datapath modified_datapath(.clk(clk), .mdata(mdata), .pc(pc), .wb_sel(wb_sel), .w_addr(w_addr), .w_en(w_en), 
                           .r_addr(r_addr), .en_A(en_A), .en_B(en_B), .shift_op(shift_op), .sel_A(sel_A), 
                           .sel_B(sel_B), .ALU_op(ALU_op), .en_C(en_C), .en_status(en_status), .sximm8(sximm8),
                           .sximm5(sximm5), .datapath_out(out), .Z_out(Z), .N_out(N), 
                           .V_out(V));
  
endmodule: cpu
