module tb_task3(output err);
  // your implementation here
   // your implementation here
  //Add the PC, implement the instruction fetch operation, and add the HALT instruction.

  reg clk, rst_n;
  reg [2:0] opcode;
  reg [1:0] ALU_op;
  reg [1:0] shift_op;
  reg Z, N, V;
  reg waiting;
  reg [1:0] reg_sel;
  reg [1:0] wb_sel;
  reg w_en, en_A, en_B, en_C, en_status, sel_A, sel_B;
  reg error = 1'b0;
  reg load_pc, clear_pc, load_ir, load_addr, ram_w_en, sel_addr;
  assign err = error;

  integer num_passes = 0;
  integer num_fails = 0;

  controller dut(.clk, .rst_n, .opcode, .ALU_op, .shift_op, .Z, .N, .V, 
                 .load_pc, .clear_pc, .load_ir, .load_addr,
                 .ram_w_en, .sel_addr, .reg_sel, .wb_sel, .w_en,
                 .en_A, .en_B, .en_C, .en_status, .sel_A, .sel_B);

  initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
  end

  initial begin
    //clear_pc_state, load_pc_state, instruction_fetch_state, store_ir_state
  
    //test rstn
    rst_n = 1'b0;
    opcode = 3'b0;
    ALU_op = 2'b0;
    shift_op= 2'b0;
    #10;
    //state: clear_pc_state
    assert(clear_pc === 1'b1) begin
      $display("[PASS]: clear_pc_state after reset");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: clear_pc_state after reset");
      num_fails = num_fails + 1;
    end
    
    //clear_pc_state -> load_pc
    rst_n = 1'b1;
    #10;
    assert(load_pc === 1'b1) begin
      $display("[PASS]: clear_pc_state -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: clear_pc_state -> load_pc");
      num_fails = num_fails + 1;
    end

    //load_pc -> instruction_fetch_state
    #10;
    assert(wb_sel === 2'b01) begin
      $display("[PASS]: load_pc -> instruction_fetch_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: load_pc -> instruction_fetch_state");
      num_fails = num_fails + 1;
    end

    //instruction_fetch_state -> store_ir_state
    #10;
    assert(load_ir === 1'b1) begin
      $display("[PASS]: clear_pc_state -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: clear_pc_state -> load_pc");
      num_fails = num_fails + 1;
    end

    //store_ir_state to start
    #10;
    assert(load_ir === 1'b0) begin
      $display("[PASS]: clear_pc_state -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: clear_pc_state -> load_pc");
      num_fails = num_fails + 1;
    end

    //start to MOVimm
    rst_n = 1'b1;
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

    //MOVimm -> load_pc
    rst_n = 1'b1;
    #10;
    //state: start
    assert(load_pc === 1'b1) begin
      $display("[PASS]: clear_pc_state -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: clear_pc_state -> load_pc");
      num_fails = num_fails + 1;
    end

    //load_pc -> instruction_fetch_state
    #10;
    assert(wb_sel === 2'b01) begin
      $display("[PASS]: load_pc -> instruction_fetch_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: load_pc -> instruction_fetch_state");
      num_fails = num_fails + 1;
    end

    //instruction_fetch_state -> store_ir_state
    #10;
    assert(load_ir === 1'b1) begin
      $display("[PASS]: instruction_fetch_state -> store_ir_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: instruction_fetch_state -> store_ir_state");
      num_fails = num_fails + 1;
    end

    //store_ir_state -> start
    #10;
    assert(load_ir === 1'b0) begin
      $display("[PASS]: store_ir_state -> start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: store_ir_state -> start");
      num_fails = num_fails + 1;
    end
    
    //start -> MOVreg1
    rst_n = 1'b1;
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
    //state: MOVreg3
    assert(w_en === 1'b1) begin
      $display("[PASS]: MOVreg3 after MOVreg2");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: MOVreg3 after MOVreg2");
      num_fails = num_fails + 1;
    end

    //MOVreg3 -> load_pc
    rst_n = 1'b1;
    #10;
    //state: start
    assert(load_pc === 1'b1) begin
      $display("[PASS]: MOVreg3 -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: MOVreg3 -> load_pc");
      num_fails = num_fails + 1;
    end

    //load_pc -> instruction_fetch_state
    #10;
    assert(wb_sel === 2'b01) begin
      $display("[PASS]: load_pc -> instruction_fetch_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: load_pc -> instruction_fetch_state");
      num_fails = num_fails + 1;
    end

    //instruction_fetch_state -> store_ir_state
    #10;
    assert(load_ir === 1'b1) begin
      $display("[PASS]: instruction_fetch_state -> store_ir_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: instruction_fetch_state -> store_ir_state");
      num_fails = num_fails + 1;
    end

    //store_ir_state -> start
    #10;
    assert(load_ir === 1'b0) begin
      $display("[PASS]: store_ir_state -> start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: store_ir_state -> start");
      num_fails = num_fails + 1;
    end
    
    //wait -> start -> ADD1-> ADD2 -> ADD3 -> ADD4
    rst_n = 1'b1;
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

    //ADD4 -> load_pc 
    rst_n = 1'b1;
    #10;
    //state: start
    assert(load_pc === 1'b1) begin
      $display("[PASS]: ADD4 -> load_pc ");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: ADD4 -> load_pc ");
      num_fails = num_fails + 1;
    end

    //load_pc -> instruction_fetch_state
    #10;
    assert(wb_sel === 2'b01) begin
      $display("[PASS]: load_pc -> instruction_fetch_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: load_pc -> instruction_fetch_state");
      num_fails = num_fails + 1;
    end

    //instruction_fetch_state -> store_ir_state
    #10;
    assert(load_ir === 1'b1) begin
      $display("[PASS]: instruction_fetch_state -> store_ir_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: instruction_fetch_state -> store_ir_state");
      num_fails = num_fails + 1;
    end

    //store_ir_state -> start
    #10;
    assert(load_ir === 1'b0) begin
      $display("[PASS]: store_ir_state -> start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: store_ir_state -> start");
      num_fails = num_fails + 1;
    end
    
    //start -> CMP1
    rst_n = 1'b1;
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

    //CMP3 -> load_pc
    rst_n = 1'b1;
    #10;
    //state: start
    assert(load_pc === 1'b1) begin
      $display("[PASS]: CMP3 -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: CMP3 -> load_pc");
      num_fails = num_fails + 1;
    end

    //load_pc -> instruction_fetch_state
    #10;
    assert(wb_sel === 2'b01) begin
      $display("[PASS]: load_pc -> instruction_fetch_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: load_pc -> instruction_fetch_state");
      num_fails = num_fails + 1;
    end

    //instruction_fetch_state -> store_ir_state
    #10;
    assert(load_ir === 1'b1) begin
      $display("[PASS]: instruction_fetch_state -> store_ir_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: instruction_fetch_state -> store_ir_state");
      num_fails = num_fails + 1;
    end

    //store_ir_state -> start
    #10;
    assert(load_ir === 1'b0) begin
      $display("[PASS]: store_ir_state -> start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: store_ir_state -> start");
      num_fails = num_fails + 1;
    end
    
    
    //start -> AND1 -> AND2 -> AND3 -> AND4 -> wait
    rst_n = 1'b1;
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

    //AND4 -> load_pc
    rst_n = 1'b1;
    #10;
    //state: start
    assert(load_pc === 1'b1) begin
      $display("[PASS]: AND4 -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: CMP3 -> load_pc");
      num_fails = num_fails + 1;
    end

    //load_pc -> instruction_fetch_state
    #10;
    assert(wb_sel === 2'b01) begin
      $display("[PASS]: load_pc -> instruction_fetch_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: load_pc -> instruction_fetch_state");
      num_fails = num_fails + 1;
    end

    //instruction_fetch_state -> store_ir_state
    #10;
    assert(load_ir === 1'b1) begin
      $display("[PASS]: instruction_fetch_state -> store_ir_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: instruction_fetch_state -> store_ir_state");
      num_fails = num_fails + 1;
    end

    //store_ir_state -> start
    #10;
    assert(load_ir === 1'b0) begin
      $display("[PASS]: store_ir_state -> start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: store_ir_state -> start");
      num_fails = num_fails + 1;
    end
   
    //start -> MVN1 -> MVN2 -> MVN3
    rst_n = 1'b1;
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

    //MVN3 -> load_pc
    rst_n = 1'b1;
    #10;
    //state: start
    assert(load_pc === 1'b1) begin
      $display("[PASS]: MVN3 -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: MVN3 -> load_pc");
      num_fails = num_fails + 1;
    end

    //load_pc -> instruction_fetch_state
    #10;
    assert(wb_sel === 2'b01) begin
      $display("[PASS]: load_pc -> instruction_fetch_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: load_pc -> instruction_fetch_state");
      num_fails = num_fails + 1;
    end

    //instruction_fetch_state -> store_ir_state
    #10;
    assert(load_ir === 1'b1) begin
      $display("[PASS]: instruction_fetch_state -> store_ir_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: instruction_fetch_state -> store_ir_state");
      num_fails = num_fails + 1;
    end

    //store_ir_state -> start
    #10;
    assert(load_ir === 1'b0) begin
      $display("[PASS]: store_ir_state -> start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: store_ir_state -> start");
      num_fails = num_fails + 1;
    end

    //Test HALT
    rst_n = 1'b1;
    opcode = 3'b111;
    ALU_op = 2'b00;
    shift_op= 2'b0;
    #10;

    assert(en_C === 1'b0) begin
      $display("[PASS]: HALT after start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: HALT after start");
      num_fails = num_fails + 1;
    end
    
    #10;
    assert(en_C === 1'b0) begin
      $display("[PASS]: STAY AT HALT");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: STAY AT HALT");
      num_fails = num_fails + 1;
    end

    //HALT -> clear_pc
    rst_n = 1'b0;
    #10;
    assert(clear_pc === 1'b1) begin
      $display("[PASS]: HALT -> clear_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: HALT -> clear_pc");
      num_fails = num_fails + 1;
    end
    
    //clear_pc_state -> load_pc
    rst_n = 1'b1;
    #10;
    assert(load_pc === 1'b1) begin
      $display("[PASS]: clear_pc_state -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: clear_pc_state -> load_pc");
      num_fails = num_fails + 1;
    end

    //load_pc -> instruction_fetch_state
    #10;
    assert(wb_sel === 2'b01) begin
      $display("[PASS]: load_pc -> instruction_fetch_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: load_pc -> instruction_fetch_state");
      num_fails = num_fails + 1;
    end

    //instruction_fetch_state -> store_ir_state
    #10;
    assert(load_ir === 1'b1) begin
      $display("[PASS]: clear_pc_state -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: clear_pc_state -> load_pc");
      num_fails = num_fails + 1;
    end

    //store_ir_state to start
    #10;
    assert(load_ir === 1'b0) begin
      $display("[PASS]: clear_pc_state -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: clear_pc_state -> load_pc");
      num_fails = num_fails + 1;
    end

    //start -> LDR1
    rst_n = 1'b1;
    opcode = 3'b011;
    ALU_op = 2'b00;
    shift_op= 2'b0;
    #10;
    assert(en_B === 1'b0) begin
      $display("[PASS]: start -> LDR1");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: start -> LDR1");
      num_fails = num_fails + 1;
    end
    #10;
    //LDR1->LDR2
    assert(en_A === 1'b1) begin
      $display("[PASS]: LDR1 -> LDR2");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: LDR1 -> LDR2");
      num_fails = num_fails + 1;
    end
    #10;
    //LDR2->LDR3
    assert(sel_B === 1'b1) begin
      $display("[PASS]: LDR2 -> LDR3");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: LDR2 -> LDR3");
      num_fails = num_fails + 1;
    end
    #10;
    //LDR3->LDR4
    assert(load_addr === 1'b1) begin
      $display("[PASS]: LDR3 -> LDR4");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: LDR3 -> LDR4");
      num_fails = num_fails + 1;
    end
    #10;
    //LDR4->LDR5
    assert(ram_w_en === 1'b1) begin
      $display("[PASS]: LDR4 -> LDR5");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: LDR4 -> LDR5");
      num_fails = num_fails + 1;
    end
    #10;
    //LDR5->LDR6
    assert(load_ir === 1'b0) begin
      $display("[PASS]: LDR5 -> LDR6");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: LDR5 -> LDR6");
      num_fails = num_fails + 1;
    end
    
    //LDR6 -> load_pc
    rst_n = 1'b1;
    #10;
    assert(load_pc === 1'b1) begin
      $display("[PASS]: LDR6 -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: LDR6 -> load_pc");
      num_fails = num_fails + 1;
    end
    //load_pc -> inst_fetch
    #10;
    assert(wb_sel === 2'b01) begin
      $display("[PASS]: load_pc -> inst_fetch");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: load_pc -> inst_fetch");
      num_fails = num_fails + 1;
    end

    //instruction_fetch_state -> store_ir_state
    #10;
    assert(load_ir === 1'b1) begin
      $display("[PASS]: inst_fetch_state -> store_ir_state");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: inst_fetch_state -> store_ir_state");
      num_fails = num_fails + 1;
    end

    //store_ir_state to start
    #10;
    assert(load_ir === 1'b0) begin
      $display("[PASS]: store_ir_state to start");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: store_ir_state to start");
      num_fails = num_fails + 1;
    end

    //start -> STR1
    rst_n = 1'b1;
    opcode = 3'b100;
    ALU_op = 2'b00;
    shift_op= 2'b0;
    #10;
    assert(reg_sel === 2'b10) begin
      $display("[PASS]: start -> STR1");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: start -> STR1");
      num_fails = num_fails + 1;
    end

    #10;
    assert(en_A === 1'b1) begin
      $display("[PASS]: STR1 -> STR2");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: STR1 -> STR2");
      num_fails = num_fails + 1;
    end

    #10;
    assert(en_C === 1'b1) begin
      $display("[PASS]: STR2 -> STR3");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: STR2 -> STR3");
      num_fails = num_fails + 1;
    end

    #10;
    assert(load_addr === 1'b1) begin
      $display("[PASS]: STR3 -> STR4");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: STR3 -> STR4");
      num_fails = num_fails + 1;
    end

    #10;
    assert(wb_sel === 2'b11) begin
      $display("[PASS]: STR4 -> STR5");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: STR4 -> STR5");
      num_fails = num_fails + 1;
    end

    #10;
    assert(en_B === 1'b1) begin
      $display("[PASS]: STR5 -> STR6");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: STR5 -> STR6");
      num_fails = num_fails + 1;
    end

    #10;
    assert(sel_A === 1'b1) begin
      $display("[PASS]: STR6 -> STR7");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: STR6 -> STR7");
      num_fails = num_fails + 1;
    end

    #10;
    assert(ram_w_en == 1'b1) begin
      $display("[PASS]: STR7 -> STR8");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: STR7 -> STR8");
      num_fails = num_fails + 1;
    end

    #10;
    assert(load_pc === 1'b1) begin
      $display("[PASS]: STR8 -> load_pc");
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL]: STR8 -> load_pc");
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
endmodule: tb_task3
