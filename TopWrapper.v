`timescale 1ns/1ps

module Wrapper(
    input SCLK,
    input En, RST,
    input VALID,
    input [511:0] RANDOM_NUMBER,
    output [31:0] READ_RESULT,
    output reg SYS_VALID
);

parameter HOLD = 0;
parameter STORE = 1;
parameter READ = 2;

parameter ADDR1 = 4'h0;
parameter ADDR2 = 4'h1;
parameter ADDR3 = 4'h2;
parameter ADDR4 = 4'h3;
parameter ADDR5 = 4'h4;
parameter ADDR6 = 4'h5;
parameter ADDR7 = 4'h6;
parameter ADDR8 = 4'h7;
parameter ADDR9 = 4'h8;
parameter ADDR10 = 4'h9;
parameter ADDR11 = 4'hA;
parameter ADDR12 = 4'hB;
parameter ADDR13 = 4'hC;
parameter ADDR14 = 4'hD;
parameter ADDR15 = 4'hE;
parameter ADDR16 = 4'hF;

wire LOCAL_CLK = SCLK | En;
reg [31:0] mem [0:15];
reg STATE;
reg [3:0] COUNTER;
reg [31:0] OUTPUT;

always @(posedge LOCAL_CLK) begin
    if (RST) begin
        COUNTER <= 4'd0;
        STATE <= HOLD;
    end

    else begin

        if (VALID) begin
            STATE <= HOLD;

        end
        else begin
            STATE <= STORE;
        end
 
    end
end 

always @(posedge LOCAL_CLK) begin
    
    case(STATE)

        HOLD : begin

            SYS_VALID = 1'b0;

        end

        STORE : begin
            
            SYS_VALID = 1'b0;

            mem[ADDR1]  <= RANDOM_NUMBER[511:480];
            mem[ADDR2]  <= RANDOM_NUMBER[479:448];
            mem[ADDR3]  <= RANDOM_NUMBER[447:416];
            mem[ADDR4]  <= RANDOM_NUMBER[415:384];
            mem[ADDR5]  <= RANDOM_NUMBER[383:352];
            mem[ADDR6]  <= RANDOM_NUMBER[351:320];
            mem[ADDR7]  <= RANDOM_NUMBER[319:288];
            mem[ADDR8]  <= RANDOM_NUMBER[287:256];
            mem[ADDR9]  <= RANDOM_NUMBER[255:224];
            mem[ADDR10]  <= RANDOM_NUMBER[223:192];
            mem[ADDR11] <= RANDOM_NUMBER[191:160];
            mem[ADDR12] <= RANDOM_NUMBER[159:128];
            mem[ADDR13] <= RANDOM_NUMBER[127:96];
            mem[ADDR14] <= RANDOM_NUMBER[95:64];
            mem[ADDR15] <= RANDOM_NUMBER[63:32];
            mem[ADDR16] <= RANDOM_NUMBER[31:0];

            STATE <= READ;

        end

        READ : begin 

            if (COUNTER <= 4'd15) begin
                // It takes 16 clock cycles to read complete result
                OUTPUT <= mem[COUNTER];
                COUNTER <= COUNTER + 1;
                SYS_VALID <= 1'b1;
            end
            else begin
                COUNTER <= 4'd0;
                SYS_VALID <= 1'b0;
                STATE <= HOLD;
            end
        end 

    endcase

end

assign READ_RESULT = OUTPUT;

endmodule