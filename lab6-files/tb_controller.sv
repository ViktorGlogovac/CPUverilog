module tb_controller(output err);
  // your implementation here
  reg clk, rst_n, start;
  reg [2:0] opcode; 
  reg [1:0] ALU_op;
  reg [1:0] shift_op;
  reg Z, N, V;
  reg waiting;
  reg [1:0] reg_sel;
  reg [1:0] wb_sel;
  reg w_en, en_A, en_B, en_C, en_status, sel_A, sel_B;
  reg error = 1'b0;
  assign err = error;

  integer num_passes = 0;
  integer num_fails = 0;

  controller dut(.clk, .rst_n, .start, .opcode, .ALU_op, 
                 .shift_op, .Z, .N, .V, .waiting, .reg_sel, .wb_sel, 
                 .w_en, .en_A, .en_B, .en_C, .en_status, .sel_A, .sel_B);

  initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
  end

  initial begin

    //test rstn
    rst_n = 1'b0;
    start = 1'b0;
    opcode = 3'b0;
    ALU_op = 2'b0;
    shift_op= 2'b0;
    #10;
    //state: wait
    assert(waiting === 1'b1) begin
      $display("[PASS]: wait_state after reset");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: wait_state after reset");
      num_fails = num_fails + 1;
    end
    
    //wait -> start if start = 1;
    rst_n = 1'b1;
    start = 1'b1;
    opcode = 3'b0;
    ALU_op = 2'b0;
    shift_op= 2'b0;
    #10;
    //state: start
    assert(waiting === 1'b0) begin
      $display("[PASS]: start after wait");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: start after wait");
      num_fails = num_fails + 1;
    end

    //start to MOVimm
    rst_n = 1'b1;
    start = 1'b0;
    opcode = 3'b110;
    ALU_op = 2'b10;
    shift_op= 2'b0;
    #10;
    //state: MOVimm
    assert(w_en === 1'b1) begin
      $display("[PASS]: MOVimm after start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: MOVimm after wait");
      num_fails = num_fails + 1;
    end

    //MOVimm to wait
    #10;
    //state: wait
   assert(waiting === 1'b1) begin
      $display("[PASS]: wait_state after reset");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: wait_state after reset");
      num_fails = num_fails + 1;
    end

    //wait -> start if start = 1;
    rst_n = 1'b1;
    start = 1'b1;
    opcode = 3'b0;
    ALU_op = 2'b0;
    shift_op= 2'b0;
    #10;
    //state: start
    assert(waiting === 1'b0) begin
      $display("[PASS]: start after wait");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: start after wait");
      num_fails = num_fails + 1;
    end
    
    
    rst_n = 1'b1;
    start = 1'b0;
    opcode = 3'b110;
    ALU_op = 2'b0;
    shift_op= 2'b0;
    #10;
    //state: MOVreg1
    assert(en_B === 1'b1) begin
      $display("[PASS]: MOVreg1 after start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: MOVreg1 after start");
      num_fails = num_fails + 1;
    end

    #10;
    //state: MOVreg2
    assert(en_C === 1'b1) begin
      $display("[PASS]: MOVreg2 after MOVreg1");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: MOVreg2 after MOVreg1");
      num_fails = num_fails + 1;
    end

    #10;
    //state: MOVreg2
    assert(w_en === 1'b1) begin
      $display("[PASS]: MOVreg3 after MOVreg2");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: MOVreg3 after MOVreg2");
      num_fails = num_fails + 1;
    end

    #10;
    //state: wait
   assert(waiting === 1'b1) begin
      $display("[PASS]: wait_state after MOVreg3");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: wait_state after MOVreg3");
      num_fails = num_fails + 1;
    end
    
    //wait -> start -> ADD1-> ADD2 -> ADD3 -> ADD4 -> wait
    rst_n = 1'b1;
    start = 1'b1;
    opcode = 3'b0;
    ALU_op = 2'b0;
    shift_op= 2'b0;
    #10;
    
    assert(waiting === 1'b0) begin
      $display("[PASS]: start after wait");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: start after wait");
      num_fails = num_fails + 1;
    end

    rst_n = 1'b1;
    start = 1'b0;
    opcode = 3'b101;
    ALU_op = 2'b00;
    shift_op= 2'b0;
    #10;

    assert(en_A === 1'b1) begin
      $display("[PASS]: Add1 after start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: Add1 after start");
      num_fails = num_fails + 1;
    end

    #10;
    assert(en_B === 1'b1) begin
      $display("[PASS]: ADD2 after ADD1");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: ADD2 after ADD1");
      num_fails = num_fails + 1;
    end

    #10;
    assert(en_C === 1'b1) begin
      $display("[PASS]: ADD3 after ADD2");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: ADD3 after ADD2");
      num_fails = num_fails + 1;
    end

    #10;
    assert(w_en === 1'b1) begin
      $display("[PASS]: ADD4 after ADD3");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: ADD4 after ADD3");
      num_fails = num_fails + 1;
    end

    #10;
    assert(waiting === 1'b1) begin
      $display("[PASS]: wait after ADD4");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: wait after ADD4");
      num_fails = num_fails + 1;
    end

    rst_n = 1'b1;
    start = 1'b1;
    opcode = 3'b0;
    ALU_op = 2'b0;
    shift_op= 2'b0;
    #10;
    
    assert(waiting === 1'b0) begin
      $display("[PASS]: start after wait");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: start after wait");
      num_fails = num_fails + 1;
    end

    rst_n = 1'b1;
    start = 1'b0;
    opcode = 3'b101;
    ALU_op = 2'b01;
    shift_op= 2'b0;
    #10;
    assert(en_A === 1'b1) begin
      $display("[PASS]: CMP1 after start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: CMP1 after start");
      num_fails = num_fails + 1;
    end
    #10;
    assert(en_B === 1'b1) begin
      $display("[PASS]: CMP2 after CMP1");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: CMP2 after CMP3");
      num_fails = num_fails + 1;
    end
    #10;
    assert(en_C === 1'b0) begin
      $display("[PASS]: CMP3 after CMP2");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: CMP3 after CMP2");
      num_fails = num_fails + 1;
    end
    #10;
    assert(waiting === 1'b1) begin
      $display("[PASS]: wait after CMP3");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: wait after CMP3");
      num_fails = num_fails + 1;
    end
    
    //wait -> start -> AND1 -> AND2 -> AND3 -> AND4 -> wait
    rst_n = 1'b1;
    start = 1'b1;
    opcode = 3'b0;
    ALU_op = 2'b0;
    shift_op= 2'b0;
    #10;

    assert(waiting === 1'b0) begin
      $display("[PASS]: start after wait");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: start after wait");
      num_fails = num_fails + 1;
    end

    rst_n = 1'b1;
    start = 1'b0;
    opcode = 3'b101;
    ALU_op = 2'b10;
    shift_op= 2'b0;
    #10;

    assert(en_A === 1'b1) begin
      $display("[PASS]: AND1 after start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: AND1 after start");
      num_fails = num_fails + 1;
    end

    #10;
    assert(en_B === 1'b1) begin
      $display("[PASS]: AND2 after AND1");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: AND2 after AND1");
      num_fails = num_fails + 1;
    end

    #10;
    assert(en_C === 1'b1) begin
      $display("[PASS]: AND3 after AND2");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: AND3 after AND2");
      num_fails = num_fails + 1;
    end

    #10;
    assert(w_en === 1'b1) begin
      $display("[PASS]: AND4 after AND3");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: AND4 after AND3");
      num_fails = num_fails + 1;
    end

    #10;
    assert(waiting === 1'b1) begin
      $display("[PASS]: wait after AND4");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: wait after AND4");
      num_fails = num_fails + 1;
    end

    //wait -> start -> MVN1 -> MVN2 -> MVN3
    rst_n = 1'b1;
    start = 1'b1;
    opcode = 3'b0;
    ALU_op = 2'b0;
    shift_op= 2'b0;
    #10;
    
    assert(waiting === 1'b0) begin
      $display("[PASS]: start after wait");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: start after wait");
      num_fails = num_fails + 1;
    end

    rst_n = 1'b1;
    start = 1'b0;
    opcode = 3'b101;
    ALU_op = 2'b11;
    shift_op= 2'b0;
    #10;

    assert(en_B === 1'b1) begin
      $display("[PASS]: MVN1 after start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: MVN1 after start");
      num_fails = num_fails + 1;
    end

    #10;

    assert(en_C === 1'b1) begin
      $display("[PASS]: MVN2 after MVN1");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: MVN2 after MVN2");
      num_fails = num_fails + 1;
    end

    #10;
    assert(w_en === 1'b1) begin
      $display("[PASS]: MVN3 after MVN2");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: MVN3 after MVN2");
      num_fails = num_fails + 1;
    end
    #10;
    assert(waiting === 1'b1) begin
      $display("[PASS]: wait after CMP3");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: wait after CMP3");
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

  
endmodule: tb_controller