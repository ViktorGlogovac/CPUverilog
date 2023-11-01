`define TEST 16'b1111000011001111
`define LSHIFT 16'b1110000110011110
`define RSHIFT 16'b0111100001100111
`define ARSHIFT 16'b1111100001100111

module tb_shifter(output err);
  // your implementation here
  
  //inputs 
  reg [15:0] shift_in;
  reg [1:0] shift_op;
  //output
  reg[15:0] shift_out;

  reg error = 1'b0;
  assign err = error;
  integer num_passes = 0;
  integer num_fails = 0;
  
  shifter dut(.shift_in, .shift_op, .shift_out);

  initial begin
  //test 1: no shift (shift_op = 2'b00)
  //input = 1111000011001111; output = 1111000011001111

  shift_in = `TEST;
  shift_op = 2'b00;
  #10;
  
  assert(shift_out === `TEST) begin 
    $display ("[PASS]: The shift_out value is 1111000011001111");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The shift_out value is 1111000011001111");
    num_fails = num_fails + 1;
  end

  //test 2: shift left by 1 (shift_op = 2'b01)
  //input = 1111000011001111; output = 1110000110011110
  shift_in = `TEST;
  shift_op = 2'b01;
  #10;
  
  assert(shift_out === `LSHIFT) begin
    $display ("[PASS]: The shift_out value is 1110000110011110");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The shift_out value is 1110000110011110");
    num_fails = num_fails + 1;
  end

  //test 3: shift right by 1 (shift_op = 2'b10)
  //input = 1111000011001111; output = 0111100001100111
  shift_in = `TEST;
  shift_op = 2'b10;
  #10;
  
  assert(shift_out === `RSHIFT) begin
    $display ("[PASS]: The shift_out value is 0111100001100111");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The shift_out value is 0111100001100111");
    num_fails = num_fails + 1;
  end

  //test 4: arithmetic shift right by 1 (shift_op = 2'b11)
  //input: 1111000011001111; output = 1111100001100111
  shift_in = `TEST;
  shift_op = 2'b11;
  #10;
  
  assert(shift_out === `ARSHIFT) begin
    $display ("[PASS]: The shift_out value is 1111100001100111");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The shift_out value is 1111100001100111");
    num_fails = num_fails + 1;
  end

  if(num_fails > 0)
    error = 1'b1;
  
  #10;
  
  //test 5: arithmetic shift right by 1 (shift_op = 2'b11)
  //input: 0000000000000011; output = 1000000000000001
  shift_in = 16'b0000000000000011;
  shift_op = 2'b11;
  #10;
  
  assert(shift_out === 16'b1000000000000001) begin
    $display ("[PASS]: The shift_out value is 1000000000000001");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The shift_out value is 1000000000000001");
    num_fails = num_fails + 1;
  end

  if(num_fails > 0)
    error = 1'b1;
  
  #10;
  $display("TESTS PASSED: %-3d", num_passes);
  $display("TESTS FAILED: %-3d", num_fails);
  $display("All tests executed within time limit");
  $display("END OF TEST");

  $stop();

  end
endmodule: tb_shifter
