`define ZERO 16'b0000000000000000
`define ONE 16'b0000000000000001
`define TWO 16'b0000000000000010
`define THREE 16'b0000000000000011
`define FOUR 16'b0000000000000100
`define FIVE 16'b0000000000000101
`define SIX 16'b0000000000000110
`define SEVEN 16'b0000000000000111
`define EIGHT 16'b0000000000001000

module tb_regfile(output err);
  // your implementation here
  reg [15:0] w_data, r_data;
  reg [2:0] w_addr, r_addr;
  reg [15:0] m[0:7];
  reg w_en, clk;

  reg error = 1'b0;
  assign err = error;

  integer num_passes = 0;
  integer num_fails = 0;

  regfile dut(.w_data, .w_addr, .r_addr, .w_en, .clk, .r_data);

  initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
  end

  initial begin
  clk = 1'b0;
  w_en = 1'b0;
  w_data = 16'b0;
  r_data = 16'b0;
  w_addr = 3'b0;
  r_addr = 3'b0;
  #7;

  //test reading the registers

  //w_addr = 0; w_data = 1; test whether r_data = 1
  //if enable is zero, check whether the data can be written
  w_addr = 3'b000;
  r_addr = 3'b000;
  w_data = `ONE;
  w_en = 1'b0;
  #20;

  assert(r_data !== w_data) begin
  $display("[PASS]: cannot write to R0 if enable is off ");
  num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: cannot write to R0 if enable is off");
    num_fails = num_fails + 1;
  end
  //w_addr = 0; w_data = 1; test whether r_data = 1
  w_addr = 3'b000;
  r_addr = 3'b000;
  w_data = `ONE;
  w_en = 1'b1;
  #20;

  assert(r_data === w_data) begin 
    $display("[PASS]: The value in R0 is read");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The value in R0 is read");
    num_fails = num_fails + 1;
  end

  //w_addr = 1; w_data = 2; test whether r_data = 2
  w_addr = 3'b001;
  r_addr = 3'b001;
  w_data = `TWO;
  w_en = 1'b1;
  #20;

  assert(r_data === w_data) begin 
    $display("[PASS]: The value in R1 is read");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The value in R1 is read");
    num_fails = num_fails + 1;
  end

  //w_addr = 2; w_data = 3; test whether r_data = 3
  w_addr = 3'b010;
  r_addr = 3'b010;
  w_data = `THREE;
  w_en = 1'b1;
  #20;

  assert(r_data === w_data) begin 
    $display("[PASS]: The value in R2 is read");
    num_passes = num_passes + 1;
  end else begin 
    $error("[FAIL]: The value in R2 is read");
    num_fails = num_fails + 1;
  end

  //w_addr = 3; w_data = 4; test whether r_data = 4
  w_addr = 3'b011;
  r_addr = 3'b011;
  w_data = `FOUR;
  w_en = 1'b1;
  #20;

  assert(r_data === w_data) begin 
    $display("[PASS]: The value in R3 is read");
    num_passes = num_passes + 1;
  end else begin 
    $error("[FAIL]: The value in R3 is read");
    num_fails = num_fails + 1;
  end
  
  //w_addr = 4; w_data = 5; test whether r_data = 5
  w_addr = 3'b100;
  r_addr = 3'b100;
  w_data = `FIVE;
  w_en = 1'b1;
  #20;

  assert(r_data === w_data) begin 
    $display("[PASS]: The value in R4 is read");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The value in R4 is read");
    num_fails = num_fails + 1;
  end

  //w_addr = 5; w_data = 6; test whether r_data = 6
  w_addr = 3'b101;
  r_addr = 3'b101;
  w_data = `SIX;
  w_en = 1'b1;
  #20;

  assert(r_data === w_data) begin $display("[PASS]: The value in R5 is read");
  num_passes = num_passes + 1;
  end else begin 
    $error("[FAIL]: The value in R5 is read");
    num_fails = num_fails + 1;
  end
  //w_addr = 6; w_data = 7; test whether r_data = 7
  w_addr = 3'b110;
  r_addr = 3'b110;
  w_data = `SEVEN;
  w_en = 1'b1;
  #20;

  assert(r_data === w_data) begin $display("[PASS]: The value in R6 is read"); 
  num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The value in R6 is read");
    num_fails = num_fails + 1;
  end
  //w_addr = 7; w_data = 8; test whether r_data = 8
  w_addr = 3'b111;
  r_addr = 3'b111;
  w_data = `EIGHT;
  w_en = 1'b1;
  #20;

  assert(r_data === w_data) begin $display("[PASS]: The value in R7 is read");
  num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The value in R7 is read");
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
endmodule: tb_regfile
