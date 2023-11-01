`define MOVimm1 16'b1101000000000000 //rn reg0
`define MOVimm2 16'b1101000100000001 //rm reg1
`define MOVimm3 16'b1101001100000010 //rn 2 reg3
`define MOVimm4 16'b1101010000000011 //rm 3 reg4
`define MOVimm5 16'b1101010100000100 //rn 4 reg5
`define MOVimm6 16'b1101011000000101 //rm 5 reg6
`define MOVimm7 16'b1101000001101001 //rm 105 reg0
`define MOVimm8 16'b1101001000001011 //rn 11 to reg2
`define ADDTest 16'b1010000001000001
`define CMPTest 16'b1010101000000011
`define ANDTest 16'b1011010111100110
`define MVNTest 16'b1011100000101000
`define MOVregTest 16'b1100000001100010
`define ADDMOVreg  16'b1010001110000000
`define ONE     16'b0000000000000001
`define FiveAndSix   16'b0000000000000100
`define MVN_Shift    16'b1111111100101101
`define MOVregOut 16'b0000000000001011

module tb_cpu(output err);
  // your implementation here
  reg clk, rst_n, load, start;
  reg [15:0] instr;
  reg waiting, N, V, Z;
  reg [15:0] out;
  
  reg error = 1'b0;
  assign err = error;

  integer num_passes = 0;
  integer num_fails = 0;

  cpu dut(.clk, .rst_n, .load, .start, .instr, .waiting, .out, .N, .V, .Z);
  
  initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
  end
  initial begin
  
  //set all input to zero and wait
  rst_n = 1'b0;
  load = 1'b0;
  start = 1'b0;
  instr = 16'b0;
  #10;

  //test 1: test ADD 0 + 1
  rst_n = 1'b1;

  //load 0 to reg Rn (000)
  instr = `MOVimm1;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #10; //start -> MOVimm1
  #10; //MOVimm1 -> wait

  //load 1 to reg Rm (001)
  instr = `MOVimm2;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #10; //start -> MOVimm1
  #10; //MOVimm1 -> wait

  //load and execute ADD instr.
  instr = `ADDTest;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #50;

  assert(out === `ONE) begin
    $display("[PASS]: ADDTEST");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: ADDTEST");
    num_fails = num_fails + 1;
  end
  
  //test 2: test CMP 2 - 3
  rst_n = 1'b1;

  //load 2 to reg Rn (011)
  instr = `MOVimm3;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #10; //start -> MOVimm1
  #10; //MOVimm1 -> wait

  //load 3 to reg Rm (100)
  instr = `MOVimm4;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #10; //start -> MOVimm1
  #10; //MOVimm1 -> wait
  
  //load and execute ADD instr.
  instr = `CMPTest;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #50;

  assert(N === 1'b1) begin
    $display("[PASS]: CMP N TEST");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: CMP V TEST");
    num_fails = num_fails + 1;
  end
  
  assert(Z === 1'b0) begin
    $display("[PASS]: CMP Z TEST");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: CMP Z TEST");
    num_fails = num_fails + 1;
  end
  assert(V === 1'b1) begin
    $display("[PASS]: CMP V TEST");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: CMP V TEST");
    num_fails = num_fails + 1;
  end

  //test 3: test CMP 4 & 5
  rst_n = 1'b1;

  //load 4 to reg Rn (101)
  instr = `MOVimm5;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #10; //start -> MOVimm1
  #10; //MOVimm1 -> wait

  //load 5 to reg Rm (110)
  instr = `MOVimm6;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #10; //start -> MOVimm1
  #10; //MOVimm1 -> wait
  
  //load and execute ADD instr.
  instr = `ANDTest;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #50;

  assert(out === `FiveAndSix) begin
    $display("[PASS]: ANDTEST");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: ANDTEST");
    num_fails = num_fails + 1;
  end

//test 4: test MVN ~105
  rst_n = 1'b1;

  //load 6 to reg Rm (000)
  instr = `MOVimm7;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #10; //start -> MOVimm1
  #10; //MOVimm1 -> wait
  
  //load and execute ADD instr.
  instr = `MVNTest;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #50;

  assert(out === `MVN_Shift) begin
    $display("[PASS]: MVNTEST");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: MVNTEST");
    num_fails = num_fails + 1;
  end

  //test 5: test MOV 11
  rst_n = 1'b1;

  //load 11 to reg Rm (010)
  instr = `MOVimm8;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #10; //start -> MOVimm1
  #10; //MOVimm1 -> wait

  //load 0 to reg Rn (000)
  instr = `MOVimm1;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #10; //start -> MOVimm1
  #10; //MOVimm1 -> wait
  
  //load and execute ADD instr.
  instr = `MOVregTest;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #50;

  //load and execute ADD instr.
  instr = `ADDMOVreg;
  load = 1'b1;
  #10;
  start = 1'b1;
  load = 1'b0;
  #10; //wait -> start
  start = 1'b0;
  #50;

  assert(out === `MOVregOut) begin
    $display("[PASS]: MOVREGTEST");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: MOVREGTEST");
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
  
endmodule: tb_cpu
