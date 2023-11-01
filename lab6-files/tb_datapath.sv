`define ZERO 16'b0000000000000000
`define ONE 16'b0000000000000001
`define TWO 16'b0000000000000010
`define THREE 16'b0000000000000011
`define FOUR 16'b0000000000000100
`define FIVE 16'b0000000000000101
`define SIX 16'b0000000000000110
`define SEVEN 16'b0000000000000111
`define EIGHT  16'b0000000000001000
`define ELEVEN 16'b0000000000001011
`define nFIVE  16'b1111111111111011
`define FOURTEEN 16'b0000000000001110 
`define ONE_COMPLEMENT 16'b1111111111111111

module tb_datapath(output err);

// your implementation here
reg clk, w_en, en_A, en_B, sel_A, sel_B, en_C, en_status;
reg [1:0] wb_sel;
reg [15:0] mdata; 
reg [7:0] pc;
reg [2:0] wire_ZNV;
reg [15:0] sximm8, sximm5;
reg [15:0] w_data, r_data, A_out, B_out, shift_out, val_A, val_B, ALU_out;
reg [1:0] shift_op, ALU_op;
reg [2:0] w_addr, r_addr;
reg [15:0] datapath_out;
reg Z_out, N_out, V_out;

reg error = 1'b0;
assign err = error;

integer num_passes = 0;
integer num_fails = 0;

datapath dut(.clk, .mdata, .pc, .wb_sel,
                .w_addr, .w_en, .r_addr, .en_A,
                .en_B, .shift_op, .sel_A, .sel_B,
                .ALU_op, .en_C, .en_status, .sximm8, .sximm5,
                .datapath_out, .Z_out, .N_out, .V_out);

initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
end

initial begin 
  wb_sel = 2'b0;
  w_en = 1'b0;
  en_A = 1'b0;
  en_B = 1'b0;
  sel_A = 1'b0;
  en_C = 1'b0;
  en_status = 1'b0;
  Z_out = 1'b0;
  shift_op = 2'b0;
  ALU_op = 2'b0;
  w_addr = 3'b0;
  r_addr = 2'b0;
  sximm8 = 16'b0;
  datapath_out = 16'b0;
  #7;
  
  //test 1: A=d'1; B=d'2; datapath_out = 1; shifter_ op = 2'b0 (no shift); ALU_op = 2'b0 (ADD); datapath_out = d'3
  //use registers 0 and 1;
  //write 1 to the register A; we should see A <= 1;
  wb_sel = 2'b10;
  sximm8 = `ONE;
  en_A = 1'b1;
  en_B = 1'b0;
  w_addr = 3'b0;
  r_addr = 3'b0;
  w_en = 1'b1;
  #20;
  
  //write 2 to the register B; we should see B <= 1;
  sximm8 = `TWO;
  en_A = 1'b0;
  en_B = 1'b1;
  shift_op = 2'b0;
  w_addr = 3'b001;
  r_addr = 3'b001;
  w_en = 1'b1;
  #20;
  
  //ALU performs A + B = 1 + 2 = 3 
  en_A = 1'b0;
  en_B = 1'b0;
  w_en = 1'b0;
  sel_A = 1'b0;
  sel_B = 1'b0;
  ALU_op = 2'b0;
  en_C = 1'b1;
  en_status = 1'b1;
  #20;
  
  assert(datapath_out === `THREE) begin
  $display ("[PASS]: datapath_out is 3");
  num_passes = num_passes + 1;
  end
  else begin 
  $error ("[FAIL]: datapath_out is not 3");
  num_fails = num_fails + 1;
  end
  assert(Z_out === 1'b0) begin 
  $display("[PASS]: z_out is 0");
  num_passes = num_passes + 1;
  end
  else begin
  $error ("[FAIL]: z_out is not 0");
  num_fails = num_fails + 1;
  end

  //test 2: A=d'3; B=d'4; shifter_ op = 2'b01(LSL); ALU_op = 3'b01 (subtract); datapath_out = d'-5
  //use register 2 and 3
  //write 3 to the register A; we should see A <= 3;
  wb_sel = 2'b10;
  sximm8 = `THREE;
  en_A = 1'b1;
  en_B = 1'b0;
  w_addr = 3'b010;
  r_addr = 3'b010;
  w_en = 1'b1;
  en_C = 1'b0;
  #20;
  
  //write 4 to the register B; we should see B <= 4;
  sximm8 = `FOUR;
  en_A = 1'b0;
  en_B = 1'b1;
  w_addr = 3'b011;
  r_addr = 3'b011;
  w_en = 1'b1;
  #20;
  
  //shift B, val_B = d'8
  //ALU performs A + B = 3 - 8 = -5
  en_A = 1'b0;
  en_B = 1'b0;
  w_en = 1'b0;
  shift_op = 2'b01;
  sel_A = 1'b0;
  sel_B = 1'b0;
  ALU_op = 2'b01;
  en_C = 1'b1;
  en_status = 1'b1;
  #20;
  
  assert(datapath_out === `nFIVE) begin
  $display ("[PASS]: datapath_out is -5");
  num_passes = num_passes + 1;
  end
  else begin
  $error ("[FAIL]: datapath_out is not -5");
  num_fails = num_fails + 1;
  end
  assert(Z_out === 1'b0) begin 
  $display("[PASS]: z_out is 0");
  num_passes = num_passes + 1;
  end
  else begin
  $error ("[FAIL]: z_out is not 0");
  num_fails = num_fails + 1;
  end
  
  //test 3: A=d'5; B=d'6; shifter_ op = 2'b10(LSR); ALU_op = 2'b10 (bitwise AND); datapath_out = d'1
  //use register 4 and 5
  //write 5 to the register A; we should see A <= 3;
  wb_sel = 2'b10;
  sximm8 = `FIVE;
  en_A = 1'b1;
  en_B = 1'b0;
  w_addr = 3'b100;
  r_addr = 3'b100;
  w_en = 1'b1;
  en_C = 1'b0;
  #20;
  
  //write 6 to the register B; we should see B <= 4;
  sximm8 = `SIX;
  en_A = 1'b0;
  en_B = 1'b1;
  w_addr = 3'b101;
  r_addr = 3'b101;
  w_en = 1'b1;
  #20;
  
  //shift B, val_B = d'8
  //ALU performs A + B = 3 + 8 = 11
  en_A = 1'b0;
  en_B = 1'b0;
  w_en = 1'b0;
  shift_op = 2'b10;
  sel_A = 1'b0;
  sel_B = 1'b0;
  ALU_op = 2'b10;
  en_C = 1'b1;
  en_status = 1'b1;
  #20;
  
  assert(datapath_out === `ONE) begin 
  $display ("[PASS]: datapath_out is 1");
  num_passes = num_passes + 1;
  end
  else begin
  $error ("[FAIL]: datapath_out is not 1");
  num_fails = num_fails + 1;
  end
  assert(Z_out === 1'b0) begin
  $display("[PASS]: z_out is 0");
  num_passes = num_passes + 1;
  end
  else begin
  $error ("[FAIL]: z_out is not 0");
  num_fails = num_fails + 1;
  end

  //Test 4: bitwise negation & arithmetic shift
  //test 4: A=d'7; B=d'3; shifter_op = 2'b11(ASR); ALU_op = 2'b11; datapath_out = 16'b0111111111111110
  //use register 6 and 7
  //write 7 to the register A; we should see A <= 7;
  wb_sel = 2'b10;
  sximm8 = `SEVEN;
  en_A = 1'b1;
  en_B = 1'b0;
  w_addr = 3'b110;
  r_addr = 3'b110;
  w_en = 1'b1;
  en_C = 1'b0;
  #20;
  
  //write 4 to the register B; we should see B <= 4;
  sximm8 = `THREE;
  en_A = 1'b0;
  en_B = 1'b1;
  w_addr = 3'b111;
  r_addr = 3'b111;
  w_en = 1'b1;
  #20;
  
  //shift B, val_B = d'8
  en_A = 1'b0;
  en_B = 1'b0;
  w_en = 1'b0;
  shift_op = 2'b11;
  sel_A = 1'b0;
  sel_B = 1'b0;
  ALU_op = 2'b11;
  en_C = 1'b1;
  en_status = 1'b1;
  #20;
  
  assert(datapath_out === 16'b0111111111111110)begin
  $display ("[PASS]: datapath_out is 1");
  num_passes = num_passes + 1;
  end
  else begin
  $error ("[FAIL]: datapath_out is not 1");
  num_fails = num_fails + 1;
  end

  assert(Z_out === 1'b0)begin
  $display("[PASS]: z_out is 0");
  num_passes = num_passes + 1;
  end
  else begin
  $error ("[FAIL]: z_out is not 0");
  num_fails = num_fails + 1;
  end
  

  //Test 4: wb_sel = 2'b10; sximm8 = `ELEVEN
  //write 7 to the register A; we should see A <= 7;
  wb_sel = 2'b10;
  sximm8 = `ELEVEN;
  en_A = 1'b1;
  en_B = 1'b0;
  w_addr = 3'b110;
  r_addr = 3'b110;
  w_en = 1'b1;
  en_C = 1'b0;
  #20;

  en_A = 1'b0;
  en_B = 1'b0;
  en_C = 1'b1;
  sel_A = 1'b0;
  sel_B = 1'b1;
  sximm5 = `THREE;
  ALU_op = 2'b0;
  #20;

  assert(datapath_out === `FOURTEEN)begin
  $display ("[PASS]: datapath_out is 14");
  num_passes = num_passes + 1;
  end
  else begin
  $error ("[FAIL]: datapath_out is not 14");
  num_fails = num_fails + 1;
  end

  //Test 5: wb_sel: 1'b11; store mdata in A
  /*wb_sel = 2'b11;
  en_A = 1'b1;
  en_B = 1'b0;
  w_addr = 3'b110;
  r_addr = 3'b110;
  w_en = 1'b1;
  en_C = 1'b0;
  #20;

  //store {8'b0, pc} in B
  wb_sel = 2'b01;
  en_A = 1'b0;
  en_B = 1'b1;
  en_C = 1'b0;
  w_en = 1'b1;
  ALU_op = 2'b0;
  #20;
  
  //ALU_op = 2'b11
  en_A = 1'b0;
  en_B = 1'b0;
  en_C = 1'b1;
  sel_A = 1'b0;
  sel_B = 1'b0;
  ALU_op = 2'b0;
  shift_op = 2'b0;
  #20;

  assert(datapath_out === `ONE_COMPLEMENT)begin
  $display ("[PASS]: datapath_out is 1's complement");
  num_passes = num_passes + 1;
  end
  else begin
  $error ("[FAIL]: datapath_out is not 1's complement");
  num_fails = num_fails + 1;
  end*/

  if(num_fails > 0)
    error = 1'b1;
  
  #10;
  $display("TESTS PASSED: %-3d", num_passes);
  $display("TESTS FAILED: %-3d", num_fails);
  $display("All tests executed within time limit");
  $display("END OF TEST");

  $stop();
end


endmodule: tb_datapath
