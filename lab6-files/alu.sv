module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output [2:0] ZNV);
  reg [15:0] out;
  reg [2:0] ZNV_out;

  assign ALU_out = out;
  assign ZNV = ZNV_out;

  // your implementation here
  always_comb begin
    case(ALU_op)
      2'b00: out = val_A + val_B;
      2'b01: out = val_A - val_B;
      2'b10: out = val_A & val_B;
      2'b11: out = ~val_B;
    endcase
    if (out == 16'b0)
      ZNV_out[2] = 1'b1;
    else 
      ZNV_out[2] = 1'b0;
  end

  always_comb begin
    if (out[15] == 1'b1)
      ZNV_out[1] = 1'b1;
    else 
      ZNV_out[1] = 1'b0;
  end

  always_comb begin 
    if ((val_A[15] == 1'b0 && val_B[15] == 1'b0 && out[15] == 1'b1) || (val_A[15] == 1'b1 && val_B[15] == 1'b1 && out[15] == 1'b0))
      ZNV_out[0] = 1'b1; //overflow or underflow
    else
      ZNV_out[0] = 1'b0;
  end
  
endmodule: ALU