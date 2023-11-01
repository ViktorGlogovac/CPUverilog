module controller(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);
    
  // your implementation here
  reg waiting_out;
  assign waiting = waiting_out;

  reg [1:0] reg_sel_out;
  assign reg_sel = reg_sel_out;

  reg[1:0] wb_sel_out;
  assign wb_sel = wb_sel_out;

  reg w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out;
  assign {w_en, en_A, en_B, en_C, en_status, sel_A, sel_B} = {w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out};

 enum reg [5:0] {
  wait_state, start_state, MOVimm1, MOVreg1, MOVreg2, MOVreg3,
  ADD1, ADD2, ADD3, ADD4, CMP1, 
  CMP2, CMP3, AND1, AND2, AND3, 
  AND4, MVN1, MVN2, MVN3
 }states;

always_ff @(posedge clk) begin
  if(~rst_n) begin
    states <= wait_state;
  end else begin 
    case(states)
      wait_state: case(start)
        1'b1: states <= start_state;
        default: states <= wait_state;
      endcase
      start_state: case({opcode, ALU_op})
        {3'b110, 2'b10}: states <= MOVimm1;
        {3'b110, 2'b00}: states <= MOVreg1;
        {3'b101, 2'b00}: states <= ADD1;
        {3'b101, 2'b01}: states <= CMP1;
        {3'b101, 2'b10}: states <= AND1;
        {3'b101, 2'b11}: states <= MVN1;
        default: states <= wait_state;
      endcase
      MOVimm1: states <= wait_state;
      MOVreg1: states <= MOVreg2;
      MOVreg2: states <= MOVreg3;
      MOVreg3: states <= wait_state;
      ADD1: states <= ADD2;
      ADD2: states <= ADD3;
      ADD3: states <= ADD4;
      ADD4: states <= wait_state;
      CMP1: states <= CMP2;
      CMP2: states <= CMP3;
      CMP3: states <= wait_state;
      AND1: states <= AND2;
      AND2: states <= AND3;
      AND3: states <= AND4;
      AND4: states <= wait_state;
      MVN1: states <= MVN2;
      MVN2: states <= MVN3;
      MVN3: states <= wait_state;
    endcase
    end
end

always_comb begin
  casex (states)
    wait_state: begin
      waiting_out = 1'b1;
      {reg_sel_out, wb_sel_out} = {2'bxx, 2'bxx};
      {w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    start_state: begin
      waiting_out = 1'b0;
      {reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {2'bxx, 2'bxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    MOVimm1: begin 
      waiting_out = 1'b0;
      {reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {2'b10, 2'b10, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    MOVreg1: begin 
      waiting_out = 1'b0;
       {reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {2'b00, 2'bxx, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    MOVreg2: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'bxx, 2'bxx, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx};
    end
    MOVreg3: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'b01, 2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    ADD1: begin 
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'b10, 2'bxx, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    ADD2: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'b0, 2'bxx, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    ADD3: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'bxx, 2'bxx, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
    end
    ADD4: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'b01, 2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    CMP1: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'b10, 2'bxx, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    CMP2:begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'b00, 2'bxx, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    CMP3: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'bxx, 2'bxx, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
    end
    AND1: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'b10, 2'bxx, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    AND2: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'b00, 2'bxx, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    AND3: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'bxx, 2'bxx, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
    end
    AND4: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'b01, 2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    MVN1: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'b00, 2'bxx, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx};
    end
    MVN2: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'bxx, 2'bxx, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
    end
    MVN3: begin
      {waiting_out, reg_sel_out, wb_sel_out, w_en_out, en_A_out, en_B_out, en_C_out, en_status_out, sel_A_out, sel_B_out} = {1'b0, 2'b01, 2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx};
    end
  endcase
end
  
endmodule: controller