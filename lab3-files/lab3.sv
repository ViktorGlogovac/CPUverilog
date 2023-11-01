module lab3(input [9:0] SW, input [3:0] KEY,
            output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2,
            output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5,
            output [9:0] LEDR);
    wire clk = ~KEY[0]; // this is your clock
    wire rst_n = KEY[3]; // this is your reset; your reset should be synchronous and active-low

    //last 6 digits of student number: 667390

    reg [6:0] dig0, dig1, dig2, dig3, dig4, dig5;

    assign {HEX0, HEX1, HEX2, HEX3, HEX4, HEX5} = {dig0, dig1, dig2, dig3, dig4, dig5};


    enum reg[3:0] {
        N = 4'b0, SIX = 4'b0001, SIX_2 = 4'b0010, SEVEN = 4'b0011, THREE = 4'b0100, NINE = 4'b0101, OPEN = 4'b0110,
        DC1 = 4'b0111, DC2 = 4'b1000, DC3 = 4'b1001, DC4 = 4'b1010, DC5 = 4'b1011, CLOSED = 4'b1100} r_state;

    // YOUR SOLUTION HERE
    always_ff @(posedge clk) begin
        if(~rst_n) begin
            r_state <= N;
        end else begin 
            casex (r_state)
                //If the state is SIX
                N : casex (SW)
                    10'bxxxxxx0110 : r_state <= SIX;
                    default : r_state <= DC1;
                    endcase
                SIX : casex (SW)
                    10'bxxxxxx0110 : r_state <= SIX_2;
                    default : r_state <= DC2;
                    endcase
                SIX_2 : casex (SW)
                    10'bxxxxxx0111 : r_state <= SEVEN;
                    default : r_state <= DC3;
                    endcase
                SEVEN : casex(SW)
                    10'bxxxxxx0011 : r_state <= THREE;
                    default : r_state <= DC4;
                    endcase
                THREE : casex(SW)
                    10'bxxxxxx1001 : r_state <= NINE;
                    default : r_state <= DC5;
                    endcase
                NINE : casex(SW)
                    10'bxxxxxx0000 : r_state <= OPEN;
                    default : r_state <= CLOSED;
                    endcase
                
                OPEN : r_state <= OPEN;
                CLOSED : r_state <= CLOSED;

                DC1 : r_state <= DC2;
                DC2 : r_state <= DC3;
                DC3 : r_state <= DC4;
                DC4 : r_state <= DC5;
                DC5 : r_state <= CLOSED;
            endcase
        end
    end
    
    always @(*) begin
        case (r_state)
            OPEN:   begin
                    dig0 = 7'b1001000; //n
                    dig1 = 7'b0001100; //e
                    dig2 = 7'b0000110; //p
                    dig3 = 7'b1000000; //o
                    dig4 = 7'b1111111; //nothing
                    dig5 = 7'b1111111; //nothing
                    end
                    
            CLOSED: begin 
                    dig0 = 7'b0010001;
                    dig1 = 7'b0000110;
                    dig2 = 7'b0010010;
                    dig3 = 7'b1000000;
                    dig4 = 7'b0011100;  
                    dig5 = 7'b1000110;
                    end
                    
            default: case(SW)
            10'b0000000000 : begin 
                            dig0 = 7'b1000000; //display 0
                            dig1 = 7'b1111111; //display nothing
                            dig2 = 7'b1111111; //display nothing
                            dig3 = 7'b1111111; //display nothing
                            dig4 = 7'b1111111; //display nothing
                            dig5 = 7'b1111111; //display nothing
                            end
            10'b0000000001 : begin
                            dig0 = 7'b1001111; //display 1
                            dig1 = 7'b1111111; //display nothing
                            dig2 = 7'b1111111; //display nothing
                            dig3 = 7'b1111111; //display nothing
                            dig4 = 7'b1111111; //display nothing
                            dig5 = 7'b1111111; //display nothing
                            end
            10'b0000000010 : begin
                            dig0 = 7'b0100100; //display 2
                            dig1 = 7'b1111111; //display nothing
                            dig2 = 7'b1111111; //display nothing
                            dig3 = 7'b1111111; //display nothing
                            dig4 = 7'b1111111; //display nothing
                            dig5 = 7'b1111111; //display nothing
                            end
                            
            10'b0000000011 : begin
                            dig0 = 7'b0110000; //display 3
                            dig1 = 7'b1111111; //display nothing
                            dig2 = 7'b1111111; //display nothing
                            dig3 = 7'b1111111; //display nothing
                            dig4 = 7'b1111111; //display nothing
                            dig5 = 7'b1111111; //display nothing
                            end
            10'b0000000100 : begin
                            dig0 = 7'b0011001; //display 4
                            dig1 = 7'b1111111; //display nothing
                            dig2 = 7'b1111111; //display nothing
                            dig3 = 7'b1111111; //display nothing
                            dig4 = 7'b1111111; //display nothing
                            dig5 = 7'b1111111; //display nothing
                            end
            10'b0000000101 : begin
                            dig0 = 7'b0010010; //display 5
                            dig1 = 7'b1111111; //display nothing
                            dig2 = 7'b1111111; //display nothing
                            dig3 = 7'b1111111; //display nothing
                            dig4 = 7'b1111111; //display nothing
                            dig5 = 7'b1111111; //display nothing
                            end
            
            10'b0000000110 : begin
                            dig0 = 7'b0000010; //display 6
                            dig1 = 7'b1111111; //display nothing
                            dig2 = 7'b1111111; //display nothing
                            dig3 = 7'b1111111; //display nothing
                            dig4 = 7'b1111111; //display nothing
                            dig5 = 7'b1111111; //display nothing
                            end
            10'b0000000111 : begin
                            dig0 = 7'b1111000; //display 7
                            dig1 = 7'b1111111; //display nothing
                            dig2 = 7'b1111111; //display nothing
                            dig3 = 7'b1111111; //display nothing
                            dig4 = 7'b1111111; //display nothing
                            dig5 = 7'b1111111; //display nothing
                            end
            10'b0000001000 : begin
                            dig0 = 7'b0000000; //display 8
                            dig1 = 7'b1111111; //display nothing
                            dig2 = 7'b1111111; //display nothing
                            dig3 = 7'b1111111; //display nothing
                            dig4 = 7'b1111111; //display nothing
                            dig5 = 7'b1111111; //display nothing
                            end
            10'b0000001001 : begin
                            dig0 = 7'b0010000; //display 9  
                            dig1 = 7'b1111111; //display nothing
                            dig2 = 7'b1111111; //display nothing
                            dig3 = 7'b1111111; //display nothing
                            dig4 = 7'b1111111; //display nothing
                            dig5 = 7'b1111111; //display nothing
                            end
            default : begin
                            dig0 = 7'b0101111;//r
                            dig1 = 7'b0100011;//o
                            dig2 = 7'b0101111;//r
                            dig3 = 7'b0101111;//r
                            dig4 = 7'b0000110;//E
                            dig5 = 7'b1111111;//nothing
                        end
            
            
            endcase       
        endcase
        //if the SW represent a decimal number larger than 9, the output shows 'Error'
        
        
    end

endmodule: lab3
