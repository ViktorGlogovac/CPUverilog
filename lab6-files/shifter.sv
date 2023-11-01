module shifter(input [15:0] shift_in, input [1:0] shift_op, output reg [15:0] shift_out);
  // your implementation here
  reg [15:0] shift_result;
  reg [15:0] temp;
  assign shift_out = shift_result;
  
  always_comb begin 
    temp = shift_in >> 1;
  end

  always_comb begin
    case(shift_op)
    2'b01: shift_result = shift_in << 1;
    2'b10: shift_result = shift_in >> 1;
    2'b11: shift_result = {shift_in[0], temp[14:0]};
    //2'b11: shift_result = shift_in >>> 1;
    default: shift_result = shift_in;
    endcase
  end
endmodule: shifter