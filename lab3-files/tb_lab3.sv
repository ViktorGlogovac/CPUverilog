module tb_lab3();
    //inputs
    reg [3:0] SW;
    reg resetn_button;
    reg clk_button;
    //reg KEY[0] clk;
    //reg KEY[3] rstn;

    //output
    /*wire [6:0] HEX0, wire [6:0] HEX1, wire [6:0] HEX2,
    wire [6:0] HEX3, wire [6:0] HEX4, wire [6:0] HEX5,
    wire [9:0] LEDR;*/

    wire [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
    wire [9:0] LEDR;
    
    //instantiaing the tb_lab3 module
    tb_lab3 dut(
        .clk(~clk_button),
        .rstn(resetn_button),
        .switches(SW),
        .digit0(HEX0), .digit1(HEX1), .digit2(HEX2), .digit3(HEX3),
        .digit4(HEX4), .digit5(HEX5), .digit6(HEX6)

        /*
        .SW0(SW[0]), .SW1(SW[1]), .SW2(SW[2]), .SW3(SW[3]),
        .A0(HEX0[0]), .B0(HEX0[1]), .C0(HEX0[2]), .D0(HEX0[3]), .E0(HEX0[4]), .F0(HEX0[5]), .G0(HEX0[6]),
        .A1(HEX1[0]), .B1(HEX1[1]), .C1(HEX1[2]), .D1(HEX1[3]), .E1(HEX1[4]), .F1(HEX1[5]), .G1(HEX1[6]),
        .A2(HEX2[0]), .B2(HEX2[1]), .C2(HEX2[2]), .D2(HEX2[3]), .E2(HEX2[4]), .F2(HEX2[5]), .G2(HEX2[6]),
        .A3(HEX3[0]), .B3(HEX3[1]), .C3(HEX3[2]), .D3(HEX3[3]), .E3(HEX3[4]), .F3(HEX3[5]), .G3(HEX0[6]),
        .A4(HEX4[0]), .B4(HEX4[1]), .C4(HEX4[2]), .D4(HEX4[3]), .E4(HEX4[4]), .F4(HEX4[5]), .G4(HEX4[6]),
        .A5(HEX5[0]), .B5(HEX5[1]), .C5(HEX5[2]), .D5(HEX5[3]), .E5(HEX5[4]), .F5(HEX5[5]), .G5(HEX5[6]),
        .A6(HEX6[0]), .B6(HEX6[1]), .C6(HEX6[2]), .D6(HEX6[3]), .E6(HEX6[4]), .F6(HEX6[5]), .G6(HEX6[6]),
        */
    );   

    initial begin 
        clk_button = 1'b0;
        forever #5 clk_button = ~clk_button;
    end 

    initial begin
        //set clk and reset to "not-pushed"
        clk_button = 1'b1;
        resetn_button = 1'b1;

        // start out with our inputs being 0s
        SW = 4'b0;
        /*
        HEX0 = 7'b0000000;
        HEX1 = 7'b0000000;
        HEX2 = 7'b0000000;
        HEX3 = 7'b0000000;
        HEX4 = 7'b0000000;
        HEX5 = 7'b0000000;
        HEX6 = 7'b0000000;
        */

        // wait five simulation timesteps to allow those changes to happen
	    #5;

        // Test 1: If we hold reset and press clock, the output is nothing
        resetn_button = 1'b0;
        clk_button = 1'b0;

        assert(HEX0 === 7'b0 && HEX1 === 7'b0 && HEX2 === 7'b0 && HEX3 === 7'b0 && HEX4 === 7'b0 && HEX5 === 7'b0 && HEX6 === 7'b0) 
        $display("[PASS] nothing after reset");
        else $error("[FAIL]: nothing after reset");

        $stop();


    end
endmodule: tb_lab3
