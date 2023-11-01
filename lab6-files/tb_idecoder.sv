module tb_idecoder(output err);

  // your implementation here
  
  reg [15:0] ir;
  reg [1:0] reg_sel;
  reg [2:0] opcode;
  reg [1:0] ALU_op;
  reg [1:0] shift_op;
  reg [15:0] sximm5;
  reg [15:0] sximm8;
  reg [2:0] r_addr;
  reg [2:0] w_addr;

  reg[15:0] Test1;
  assign Test1 = 16'b1101000100001000;

  reg[15:0] Test2;
  assign Test2 = 16'b1100000001000011;

  reg[15:0] Test3;
  assign Test3 = 16'b1010010010101111;

  reg[15:0] Test4;
  assign Test4 = 16'b1010100000010001;

  reg[15:0] Test5;
  assign Test5 = 16'b1011001001111100;

  reg [15:0] Test6;
  assign Test6 = 16'b1011100010100110;

  reg error = 1'b0;
  assign err = error;

  integer num_passes = 0;
  integer num_fails = 0;

  idecoder dut(.ir, .reg_sel, .opcode, .ALU_op, .shift_op, .sximm5, .sximm8, .r_addr, .w_addr);
  

  //ALU:ADD
initial begin

  ir = 16'b0;
  reg_sel = 2'b0;
  opcode = 3'b0;
  ALU_op = 2'b0;
  shift_op = 2'b0;
  sximm5 = 16'b0;
  sximm8 = 16'b0;
  r_addr = 3'b0;
  w_addr = 3'b0;
  #10;

  //1: MOV instruction w/ immediate operand
  ir = Test1;
  reg_sel = 2'b10;
  #10;
  
  //Test opcode value
  assert (opcode === Test1[15:13]) begin 
    $display ("[PASS]: The opcode value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The opcode value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test ALU_op
  assert (ALU_op === Test1[12:11]) begin 
    $display ("[PASS]: The ALU_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The ALU_op value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test shift_op
  assert (shift_op === Test1[4:3]) begin 
    $display ("[PASS]: The shift_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The shift_op value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test sximm8
  assert (sximm8 === Test1[7:0]) begin 
    $display ("[PASS]: The sximm8 value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The sximm8 value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //test r_addr
  assert (r_addr === Test1[10:8]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  //Test w_addr 
  assert (w_addr === Test1[10:8]) begin 
    $display ("[PASS]: The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //2: MOV instruction w/o immediate operand
  ir = Test2;
  reg_sel = 2'b01;
  #10;
  
  //Test opcode value
  assert (opcode === Test2[15:13]) begin 
    $display ("[PASS]: The opcode value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The opcode value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test ALU_op
  assert (ALU_op === Test2[12:11]) begin 
    $display ("[PASS]: The ALU_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The ALU_op value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test shift_op
  assert (shift_op === Test2[4:3]) begin 
    $display ("[PASS]: The shift_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The shift_op value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //test r_addr
  assert (r_addr === Test2[7:5]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  //Test w_addr

    assert (w_addr === Test2[7:5]) begin 
    $display ("[PASS]w The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end

  reg_sel = 2'b00;
  #10;
  //test r_addr
  assert (r_addr === Test2[2:0]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  //Test w_addr

    assert (w_addr === Test2[2:0]) begin 
    $display ("[PASS]w The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //3: ADD Rd Rn Rm; sh_op = 2'b01
  ir = Test3;
  reg_sel = 2'b10;
  #10;
  
  //Test opcode value
  assert (opcode === Test3[15:13]) begin 
    $display ("[PASS]: The opcode value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The opcode value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test ALU_op
  assert (ALU_op === Test3[12:11]) begin 
    $display ("[PASS]: The ALU_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The ALU_op value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test shift_op
  assert (shift_op === Test3[4:3]) begin 
    $display ("[PASS]: The shift_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The shift_op value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test Rn
  //test r_addr
  assert (r_addr === Test3[10:8]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test w_addr 
  assert (w_addr === Test3[10:8]) begin 
    $display ("[PASS]: The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test Rd
  reg_sel = 2'b01;
  #10;
  //test r_addr
  assert (r_addr === Test3[7:5]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  //Test w_addr
  assert (w_addr === Test3[7:5]) begin 
    $display ("[PASS]: The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test Rm
  reg_sel = 2'b00;
  #10;
  //test r_addr
  assert (r_addr === Test3[2:0]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  //Test w_addr

    assert (w_addr === Test3[2:0]) begin 
    $display ("[PASS]: The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //4: CMP Rn, Rm{,<sh.p>}
  ir = Test4;
  reg_sel = 2'b10;
  #10;
  
  //Test opcode value
  assert (opcode === Test4[15:13]) begin 
    $display ("[PASS]: The opcode value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The opcode value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test ALU_op
  assert (ALU_op === Test4[12:11]) begin 
    $display ("[PASS]: The ALU_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The ALU_op value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test shift_op
  assert (shift_op === Test4[4:3]) begin 
    $display ("[PASS]: The shift_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The shift_op value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test Rn
  //test r_addr
  assert (r_addr === Test4[10:8]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test w_addr 
  assert (w_addr === Test4[10:8]) begin 
    $display ("[PASS]: The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test Rm
  reg_sel = 2'b00;
  #10;
  //test r_addr
  assert (r_addr === Test4[2:0]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  //Test w_addr

    assert (w_addr === Test4[2:0]) begin 
    $display ("[PASS]: The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //5: AND Rn, Rm{,<sh_op>}
  ir = Test5;
  reg_sel = 2'b10; //Rn
  #10;
  
  //Test opcode value
  assert (opcode === Test5[15:13]) begin 
    $display ("[PASS]: The opcode value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The opcode value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test ALU_op
  assert (ALU_op === Test5[12:11]) begin 
    $display ("[PASS]: The ALU_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The ALU_op value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test shift_op
  assert (shift_op === Test5[4:3]) begin 
    $display ("[PASS]: The shift_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The shift_op value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test Rn
  //test r_addr
  assert (r_addr === Test5[10:8]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test w_addr 
  assert (w_addr === Test5[10:8]) begin 
    $display ("[PASS]: The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test Rd
  reg_sel = 2'b01;
  #10;
  //test r_addr
  assert (r_addr === Test5[7:5]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  //Test w_addr
  assert (w_addr === Test5[7:5]) begin 
    $display ("[PASS]: The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test Rm
  reg_sel = 2'b00;
  #10;
  //test r_addr
  assert (r_addr === Test5[2:0]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  //Test w_addr

    assert (w_addr === Test5[2:0]) begin 
    $display ("[PASS]: The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end

//6: MVN rd, rm{,<sh.op>}
  ir = Test6;
  reg_sel = 2'b01;
  #10;
  
  //Test opcode value
  assert (opcode === Test6[15:13]) begin 
    $display ("[PASS]: The opcode value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The opcode value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test ALU_op
  assert (ALU_op === Test6[12:11]) begin 
    $display ("[PASS]: The ALU_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The ALU_op value is INCORRECT");
    num_fails = num_fails + 1;
  end

  //Test shift_op
  assert (shift_op === Test6[4:3]) begin 
    $display ("[PASS]: The shift_op value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The shift_op value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test Rn
  //test r_addr
  assert (r_addr === Test6[7:5]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test w_addr 
  assert (w_addr === Test6[7:5]) begin 
    $display ("[PASS]: The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr is INCORRECT");
    num_fails = num_fails + 1;
  end
  
  //Test Rm
  reg_sel = 2'b00;
  #10;
  //test r_addr
  assert (r_addr === Test6[2:0]) begin 
    $display ("[PASS]: The r_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The r_addr value is INCORRECT");
    num_fails = num_fails + 1;
  end
  //Test w_addr

    assert (w_addr === Test6[2:0]) begin 
    $display ("[PASS]: The w_addr value is CORRECT");
    num_passes = num_passes + 1;
  end else begin
    $error("[FAIL]: The w_addr value is INCORRECT");
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

endmodule: tb_idecoder
