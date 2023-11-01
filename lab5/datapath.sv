module datapath(input clk, input [15:0] datapath_in, input wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
                output [15:0] datapath_out, output Z_out);
  // your implementation here
  // wires needed: w_data, r_data, 16'b0, {11'b0, datapath_in[4:0]}

  reg [15:0] w_data, r_data, A_out, B_out, shift_out, val_A, val_B, ALU_out;
  reg [15:0] zero = 16'b0;
  reg [15:0] c_datapath_in;
  reg wire_Z;
  assign c_datapath_in = {11'b0, datapath_in[4:0]}; 

  reg A, B, C, status;

  reg [15:0] datapath_result;
  assign datapath_out = datapath_result;
  
  reg Z_result;
  assign Z_out = Z_result;

  assign w_data = (wb_sel == 1) ? datapath_in : datapath_result;
  
  regfile myregfile ( .w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(r_data));

  always_ff @(posedge clk) begin
    if (en_A)
      A_out <= r_data;
    if (en_B)
      B_out <= r_data;
  end

  shifter myshifter(.shift_in (B_out), .shift_op (shift_op), .shift_out (shift_out));

  assign val_B = (sel_B == 1) ? c_datapath_in : shift_out;

  assign val_A = (sel_A == 1) ? zero : A_out;

  ALU myALU(.val_A (val_A), .val_B (val_B), .ALU_op (ALU_op), .ALU_out (ALU_out), .Z (wire_Z));
  
  always_ff @(posedge clk) begin
    if(en_C)
      datapath_result <= ALU_out;
    if(en_status)
      Z_result <= wire_Z;
  end
  
endmodule: datapath
