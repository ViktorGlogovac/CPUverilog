`define TRUE 1'b1
`define FALSE 1'b0
`define ZERO 16'b0
`define ONE 16'b0000000000000001
`define TWO 16'b0000000000000010
`define THREE 16'b0000000000000000
`define nONE 16'b1111111111111110


module tb_ALU(output err);
  // your implementation here
  reg [15:0] val_A, val_B;
  reg [1:0] ALU_op;
  //outputs
  reg [15:0] ALU_out;
  reg Z;

  reg error = 1'b0;
  assign err = error;

  integer num_passes = 0;
  integer num_fails = 0;

  ALU dut(.val_A, .val_B, .ALU_op, .ALU_out, .Z);
  
  initial begin
  //test 1:check the Z output
  ALU_op = 2'b00;
  val_A = `ZERO;
  val_B = `ZERO;
  #10;
  
  assert(Z === `TRUE) begin 
    $display("[PASS]: The Z value is 1");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL] The Z value is not 1");
    num_fails = num_fails + 1;
  end
  
  
  //test 2: output = 1+1 =2
  ALU_op = 2'b00;
  val_A = `ONE;
  val_B = `ONE;
  #10;

  assert(ALU_out === `TWO) begin
    $display("[PASS]: The output value is 2");
    num_passes = num_passes + 1;
  end else begin $error("[FAIL] The output value is not 2");
   num_fails = num_fails + 1;
  end
  
  assert(Z === `FALSE) begin 
    $display("[PASS]: The Z value is 0");
    num_passes = num_passes + 1;
  end else begin 
    $error("[FAIL] The Z value is not 0");
    num_fails = num_fails + 1;
  end
  
  //test 3: out = 2-1 = 1
  ALU_op = 2'b01;
  val_A = `TWO;
  val_B = `ONE;
  #10;

  assert(ALU_out === `ONE) begin 
    $display("[PASS]: The output value is 1");
    num_passes = num_passes + 1;
  end else begin $error("[FAIL] The output value is not 1");
    num_fails = num_fails + 1;
    end
  
  assert(Z === `FALSE) begin 
    $display("[PASS]: The Z value is 0");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL] The Z value is not 0");
    num_fails = num_fails + 1;
  end
  

  //test 4: out = 2 & 1 = 0
  ALU_op = 2'b10;
  val_A = `TWO;
  val_B = `ONE;
  #10;
  
  assert(ALU_out === `ZERO) begin
    $display("[PASS]: The output value is 0");
    num_passes = num_passes + 1;
  end else begin $error("[FAIL] The output value is not 0");
   num_fails = num_fails + 1;
  end

  assert(Z === `TRUE) begin 
    $display("[PASS]: The Z value is 1");
    num_passes = num_passes + 1;
  end else begin 
    $error("[FAIL] The Z value is not 1");
    num_fails = num_fails + 1;
  end


  //test 5: out = ~1
  ALU_op = 2'b11;
  val_B = `ONE;
  #10;
  
  assert(ALU_out === `nONE) begin
    $display("[PASS]: The output value is -1");
    num_passes = num_passes + 1;
  end else begin $error("[FAIL] The output value is not -1");
   num_fails = num_fails + 1;
  end
  
  assert(Z === `FALSE) begin 
    $display("[PASS]: The Z value is 0");
    num_passes = num_passes + 1;
  end else begin 
    $error("[FAIL] The Z value is not 0");
    num_fails = num_fails + 1;
  end
  

  if(num_fails > 0)
   error = 1'b1;
  #20;
  
  $display("TESTS PASSED: %-3d", num_passes);
  $display("TESTS FAILED: %-3d", num_fails);
  $display("All tests executed within time limit");
  $display("END OF TEST");

  $stop();
  end
endmodule: tb_ALU
