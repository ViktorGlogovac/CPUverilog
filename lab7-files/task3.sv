module task3(input clk, input rst_n, input [7:0] start_pc, output[15:0] out);
// your implementation here
  reg [7:0] wire_ram_addr, ram_w_addr;
  reg [15:0] wire_ram_w_data, wire_ram_r_data;
  wire wire_ram_w_en;
  wire wire_Z, wire_V, wire_N;

  cpu cpu(.clk(clk), .rst_n(rst_n), .start_pc(start_pc), .ram_r_data(wire_ram_r_data),
           .N(wire_N), .V(wire_V), .Z(wire_Z), .ram_addr(wire_ram_addr), .ram_w_data(wire_ram_w_data), 
           .ram_w_en(wire_ram_w_en), .out(out));
  
  ram ram(.clk(clk), .ram_w_en(wire_ram_w_en), .ram_r_addr(wire_ram_addr), .ram_w_addr(wire_ram_addr),
           .ram_w_data(wire_ram_w_data), .ram_r_data(wire_ram_r_data));

endmodule: task3

/*********************************** controller ***********************************/
module controller(input clk, input rst_n,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output load_pc, output clear_pc, output load_ir, output load_addr,
                  output ram_w_en, output sel_addr,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);
                  
  // your implementation here
  //reg waiting_out;
  //assign waiting = waiting_out;*/

  reg [1:0] reg_sel_out;
  assign reg_sel = reg_sel_out;

  reg[1:0] wb_sel_out;
  assign wb_sel = wb_sel_out;

  reg w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out;
  assign {w_en, en_A, en_B, en_C, en_status, sel_A, sel_B} = {w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out};

  reg load_pc_out, clear_pc_out, load_ir_out, load_addr_out, ram_w_en_out, sel_addr_out;
  assign {load_pc, clear_pc, load_ir, load_addr, ram_w_en, sel_addr} = {load_pc_out, clear_pc_out, load_ir_out, load_addr_out, ram_w_en_out, sel_addr_out};

 enum reg [6:0] {
  clear_pc_state, load_pc_state, instruction_fetch_state, store_ir_state, //4 states for instruction fetch
  start_state, // start state, goes to different instructions based on Opcode and ALU_op
  HALT, 
  MOVimm1, 
  MOVreg1, MOVreg2, MOVreg3,
  ADD1, ADD2, ADD3, ADD4, 
  CMP1, CMP2, CMP3, 
  AND1, AND2, AND3, AND4, 
  MVN1, MVN2, MVN3,
  LDR1, LDR2, LDR3, LDR4, LDR5, LDR6,
  STR1, STR2, STR3, STR4, STR5, STR6, STR7, STR8
  }states;

always_ff @(posedge clk) begin
  if(~rst_n) begin
    states <= clear_pc_state;
  end else begin 
    case(states)
      clear_pc_state: states <= load_pc_state;
      load_pc_state: states <= instruction_fetch_state;
      instruction_fetch_state: states <= store_ir_state;
      store_ir_state: states <= start_state;
      start_state: case({opcode, ALU_op})
        {3'b110, 2'b10}: states <= MOVimm1;
        {3'b110, 2'b00}: states <= MOVreg1;
        {3'b101, 2'b00}: states <= ADD1;
        {3'b101, 2'b01}: states <= CMP1;
        {3'b101, 2'b10}: states <= AND1;
        {3'b101, 2'b11}: states <= MVN1;
        {3'b111, 2'b00}: states <= HALT;
        {3'b011, 2'b00}: states <= LDR1;
        {3'b100, 2'b00}: states <= STR1;
        default: states <= start_state;
      endcase
      //add new States
      MOVimm1: states <= load_pc_state;
      MOVreg1: states <= MOVreg2;
      MOVreg2: states <= MOVreg3;
      MOVreg3: states <= load_pc_state;
      ADD1: states <= ADD2;
      ADD2: states <= ADD3;
      ADD3: states <= ADD4;
      ADD4: states <= load_pc_state;
      CMP1: states <= CMP2;
      CMP2: states <= CMP3;
      CMP3: states <= load_pc_state;
      AND1: states <= AND2;
      AND2: states <= AND3;
      AND3: states <= AND4;
      AND4: states <= load_pc_state;
      MVN1: states <= MVN2;
      MVN2: states <= MVN3;
      MVN3: states <= load_pc_state;
      LDR1: states <= LDR2;
      LDR2: states <= LDR3;
      LDR3: states <= LDR4;
      LDR4: states <= LDR5;
      LDR5: states <= LDR6;
      LDR6: states <= load_pc_state;
      HALT: states <= HALT;
      STR1: states <= STR2;
      STR2: states <= STR3;
      STR3: states <= STR4;
      STR4: states <= STR5;
      STR5: states <= STR6;
      STR6: states <= STR7;
      STR7: states <= STR8;
      STR8: states <= load_pc_state;
      default: states <= clear_pc_state;
    endcase
    end
end

always_comb begin
  casex (states)
    start_state: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'bx;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b1;
    end
      clear_pc_state: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b1;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
      load_pc_state: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b1;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    instruction_fetch_state: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'b01;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b1;
    end
    store_ir_state: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b1;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    MOVimm1: begin 
      reg_sel_out = 2'b10;
      wb_sel_out = 2'b10;
      w_en_out = 1'b1;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    MOVreg1: begin 
      reg_sel_out = 2'b00;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b1;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    MOVreg2: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b1;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    MOVreg3: begin
      reg_sel_out = 2'b01;
      wb_sel_out = 2'b00;
      w_en_out = 1'b1;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    ADD1: begin 
      reg_sel_out = 2'b10;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b1;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    ADD2: begin
      reg_sel_out = 2'b00;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b1;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    ADD3: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b1;
      en_status_out = 1'b0;
      sel_A_out = 1'b0;
      sel_B_out = 1'b0;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    ADD4: begin
      reg_sel_out = 2'b01;
      wb_sel_out = 2'b00;
      w_en_out = 1'b1;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    CMP1: begin
      reg_sel_out = 2'b10;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b1;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    CMP2:begin
      reg_sel_out = 2'b00;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b1;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    CMP3: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b1;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b1;
      sel_A_out = 1'b0;
      sel_B_out = 1'b0;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    AND1: begin
      reg_sel_out = 2'b10;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b1;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    AND2: begin
      reg_sel_out = 2'b00;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b1;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    AND3: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b1;
      en_status_out = 1'b0;
      sel_A_out = 1'b0;
      sel_B_out = 1'b0;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    AND4: begin
      reg_sel_out = 2'b01;
      wb_sel_out = 2'b00;
      w_en_out = 1'b1;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    MVN1: begin
      reg_sel_out = 2'b00;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b1;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    MVN2: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b1;
      en_status_out = 1'b0;
      sel_A_out = 1'b0;
      sel_B_out = 1'b0;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    MVN3: begin
      reg_sel_out = 2'b01;
      wb_sel_out = 2'b00;
      w_en_out = 1'b1;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0; 
    end
    HALT: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    LDR1: begin
      reg_sel_out = 2'b10;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    LDR2: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx; 
      w_en_out = 1'b0; 
      en_A_out = 1'b1;
      en_B_out = 1'b0; 
      en_C_out = 1'b0; 
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    LDR3: begin //A + B => C
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b1;
      en_status_out = 1'b0;
      sel_A_out = 1'b0;
      sel_B_out = 1'b1;
      load_pc_out = 1'b0; 
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0; 
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0; 
      sel_addr_out = 1'b0;
    end
    LDR4: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b1;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    LDR5: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b1;
      sel_addr_out = 1'b0;
    end
    LDR6: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'b00;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b1;
    end
    STR1: begin
      reg_sel_out = 2'b10;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    STR2: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b1;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    STR3: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b1;
      en_status_out = 1'b0;
      sel_A_out = 1'b0;
      sel_B_out = 1'b1;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    STR4: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b1;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    STR5: begin
      reg_sel_out = 2'b01;
      wb_sel_out = 2'b11;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    STR6: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b1;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'bx;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    STR7: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b1;
      en_status_out = 1'b0;
      sel_A_out = 1'b1;
      sel_B_out = 1'b0;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b0;
      sel_addr_out = 1'b0;
    end
    STR8: begin
      reg_sel_out = 2'bxx;
      wb_sel_out = 2'bxx;
      w_en_out = 1'b0;
      en_A_out = 1'b0;
      en_B_out = 1'b0;
      en_C_out = 1'b0;
      en_status_out = 1'b0;
      sel_A_out = 1'bx;
      sel_B_out = 1'bx;
      load_pc_out = 1'b0;
      clear_pc_out = 1'b0;
      load_ir_out = 1'b0;
      load_addr_out = 1'b0;
      ram_w_en_out = 1'b1;
      sel_addr_out = 1'b0;
    end
  endcase
end
  
endmodule: controller
/*********************************** controller ***********************************/

/*********************************** idecoder ***********************************/
module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		            output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);
  // your implementation here

reg [2:0] opcode_result;
assign opcode = opcode_result;
assign opcode_result = ir [15:13];

reg [1:0] op_result;
assign ALU_op = op_result;
assign op_result = ir [12:11];

reg [15:0] sximm5_result;
assign sximm5 = sximm5_result;

reg [15:0] sximm8_result;
assign sximm8 = sximm8_result;

reg [1:0] shift_op_result;
assign shift_op = shift_op_result;
assign shift_op_result = ir [4:3];

reg [2:0] r_addr_result;
assign r_addr = r_addr_result;

reg [2:0] w_addr_result;
assign w_addr = w_addr_result;

always_comb begin
        if (ir[4] == 1'b0)
                sximm5_result = {11'b0, ir[4:0]};
        else
                sximm5_result = {11'b1, ir[4:0]};

        if (ir[7] == 1'b0)
                sximm8_result = {8'b0, ir[7:0]};
        else
                sximm8_result = {8'b1, ir[7:0]};
        
        case (reg_sel)
                2'b00: begin 
                        r_addr_result = ir [2:0];
                        w_addr_result = ir [2:0];
                end
                2'b01: begin 
                        r_addr_result = ir [7:5];
                        w_addr_result = ir [7:5];
                end
                2'b10: begin 
                        r_addr_result = ir [10:8];
                        w_addr_result = ir [10:8];
                end
                default: begin 
                        r_addr_result = ir [2:0];
                        w_addr_result = ir [2:0];
                end
        endcase
end

endmodule: idecoder
/*********************************** idecoder ***********************************/

/*********************************** datapath ***********************************/
module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
		            input [15:0] sximm8, input [15:0] sximm5,
                output [15:0] datapath_out, output Z_out, output N_out, output V_out);
  // your implementation here

  reg [15:0] w_data, r_data, A_out, B_out, shift_out, val_A, val_B, ALU_out;
  reg [15:0] zero = 16'b0;

  reg [2:0] wire_ZNV;
  
  //reg A, B, C, status;

  reg [15:0] datapath_result;
  assign datapath_out = datapath_result;
  
  reg Z_result;
  assign Z_out = Z_result;

  reg N_result;
  assign N_out = N_result;

  reg V_result;
  assign V_out = V_result;

  //assign m_data = w_data;
  always_comb begin
        case(wb_sel)
           2'b00: w_data = datapath_result;
           2'b01: w_data = {8'b0, pc};
           2'b10: w_data = sximm8;      
           2'b11: w_data = mdata;
        endcase        
  end
  
  //assign w_data = (wb_sel == 1) ? datapath_in : datapath_result;
  regfile myregfile ( .w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(r_data));

  always_ff @(posedge clk) begin
    if (en_A)
      A_out <= r_data;
    if (en_B)
      B_out <= r_data;
  end

  shifter myshifter(.shift_in (B_out), .shift_op (shift_op), .shift_out (shift_out));

  assign val_B = (sel_B == 1) ? sximm5 : shift_out;

  assign val_A = (sel_A == 1) ? zero : A_out;

  ALU myALU(.val_A (val_A), .val_B (val_B), .ALU_op (ALU_op), .ALU_out (ALU_out), .ZNV(wire_ZNV));
  
  always_ff @(posedge clk) begin
    if(en_C)
      datapath_result <= ALU_out;
    if(en_status) begin
      Z_result <= wire_ZNV [2];
      N_result <= wire_ZNV [1];
      V_result <= wire_ZNV [0];
    end
  end
  

endmodule: datapath
/*********************************** datapath ***********************************/

/*********************************** ALU ***********************************/
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
/*********************************** ALU ***********************************/

/*********************************** shifter ***********************************/
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
/*********************************** shifter ***********************************/

/*********************************** cpu ***********************************/
module cpu(input clk, input rst_n, input [7:0] start_pc, input [15:0] ram_r_data,
           output N, output V, output Z, output [7:0] ram_addr, output [15:0] ram_w_data, 
           output ram_w_en, output [15:0] out);
// your implementation here

//wire connecting iregister to idecoder
reg [15:0] instr_reg_dec;

//wires connecting idecoder to datapath
wire [1:0] shift_op;
wire [15:0] sximm5;
wire [15:0] sximm8;
wire [2:0] r_addr;               
wire [2:0] w_addr;

//wires connecting idecoder to controller
wire [2:0] opcode; 
wire [1:0] ALU_op;

//wires connecting  controller to datapath
wire w_en, en_A, en_B, en_C, en_status, sel_A, sel_B;
wire [1:0] wb_sel;

//wires connecting  controller to idecoder
wire [1:0] reg_sel;

//wires connecting  datapath to controller
wire Z_wire, N_wire, V_wire;

//wires connecting controller to program counter
wire wire_load_pc, wire_clear_pc;

//wires connecting controller to DAR
wire wire_sel_addr, wire_load_addr;

//Controller to IR
wire wire_load_ir;

reg [7:0] wire_pc;

reg instruction;

always_ff @(posedge clk) begin
  if (wire_load_ir)
    instr_reg_dec <= ram_r_data;
end

idecoder instruction_decoder (.ir(instr_reg_dec), .reg_sel(reg_sel), .opcode(opcode), .ALU_op(ALU_op), 
                              .shift_op(shift_op), .sximm5(sximm5), .sximm8(sximm8), 
                              .r_addr(r_addr), .w_addr(w_addr));

controller controller_fsm (.clk(clk), .rst_n(rst_n), .opcode(opcode), .ALU_op(ALU_op), 
                          .shift_op(shift_op), .Z(Z_wire), .N(N_wire), .V(V_wire), .load_pc(wire_load_pc), .clear_pc(wire_clear_pc), 
                          .load_ir(wire_load_ir), .load_addr(wire_load_addr),
                          .ram_w_en(ram_w_en),  .sel_addr(wire_sel_addr), 
                          .reg_sel(reg_sel), .wb_sel(wb_sel), .w_en(w_en), .en_A(en_A), .en_B(en_B), .en_C(en_C), 
                          .en_status(en_status), .sel_A(sel_A), .sel_B(sel_B));

datapath modified_datapath(.clk(clk), .mdata(ram_r_data), .pc(wire_pc), .wb_sel(wb_sel), .w_addr(w_addr), .w_en(w_en), 
                           .r_addr(r_addr), .en_A(en_A), .en_B(en_B), .shift_op(shift_op), .sel_A(sel_A), 
                           .sel_B(sel_B), .ALU_op(ALU_op), .en_C(en_C), .en_status(en_status), .sximm8(sximm8),
                           .sximm5(sximm5), .datapath_out(out), .Z_out(Z), .N_out(N),
                           .V_out(V));

  reg [15:0] wire_ram_w_data;
  assign wire_ram_w_data = out;
  assign ram_w_data = wire_ram_w_data;
  reg[7:0] wire_DAR_out;

  //Program Counter and DAR
  reg [7:0] next_pc;
  
  //mux: clear_pc determines output of start_pc ot out_result + 1'b1
  assign next_pc = (wire_clear_pc == 1'b1) ? start_pc : wire_pc + 1'b1;

  always_ff @(posedge clk) begin
    if (wire_load_pc)
        wire_pc <= next_pc;
  end

  always_ff @(posedge clk) begin
    if(wire_load_addr)
      wire_DAR_out <= wire_ram_w_data[7:0];
  end
    
  assign ram_addr = (wire_sel_addr == 1'b1) ? wire_pc : wire_DAR_out;
  
endmodule: cpu
/*********************************** cpu ***********************************/

