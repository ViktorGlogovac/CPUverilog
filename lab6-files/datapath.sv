module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
		            input [15:0] sximm8, input [15:0] sximm5,
                output [15:0] datapath_out, output Z_out, output N_out, output V_out);
  // your implementation here

  reg [15:0] w_data, r_data, A_out, B_out, shift_out, val_A, val_B, ALU_out;
  reg [15:0] zero = 16'b0;

  reg [2:0] wire_ZNV;
  
  //reg A, B, C, status;

  reg [15:0] datapath_result;
  assign datapath_out = datapath_result;
  
  reg Z_result;
  assign Z_out = Z_result;

  reg N_result;
  assign N_out = N_result;

  reg V_result;
  assign V_out = V_result;

  //assign m_data = w_data;
  always_comb begin
        case(wb_sel)
           2'b00: w_data = datapath_result;
           2'b01: w_data = {8'b0, pc};
           2'b10: w_data = sximm8;      
           2'b11: w_data = mdata;
        endcase        
  end
  
  //assign w_data = (wb_sel == 1) ? datapath_in : datapath_result;
  regfile myregfile ( .w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(r_data));

  always_ff @(posedge clk) begin
    if (en_A)
      A_out <= r_data;
    if (en_B)
      B_out <= r_data;
  end

  shifter myshifter(.shift_in (B_out), .shift_op (shift_op), .shift_out (shift_out));

  assign val_B = (sel_B == 1) ? sximm5 : shift_out;

  assign val_A = (sel_A == 1) ? zero : A_out;

  ALU myALU(.val_A (val_A), .val_B (val_B), .ALU_op (ALU_op), .ALU_out (ALU_out), .ZNV(wire_ZNV));
  
  always_ff @(posedge clk) begin
    if(en_C)
      datapath_result <= ALU_out;
    if(en_status) begin
      Z_result <= wire_ZNV [2];
      N_result <= wire_ZNV [1];
      V_result <= wire_ZNV [0];
    end
  end
  

endmodule: datapath
