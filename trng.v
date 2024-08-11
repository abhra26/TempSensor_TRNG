/*
module top(
    input         CLK100MHZ,        // nexys clk signal
    inout         TMP_SDA,          // i2c sda on temp sensor - bidirectional
    output        TMP_SCL,          // i2c scl on temp sensor
    //output [6:0]  SEG,              // 7 segments of each display
    //output [7:0]  AN,               // 8 anodes of 8 displays
    output [11:0] LED               // nexys leds = binary temp in deg C or deg F
    );
*/

`timescale 1ns/1ps

//________________________________________________________________________________________________________________________________________________________________________
//__________________________________________________________________________________________________________________________________________________________________________

//MAIN

module TRNG(
    input SCLK,
    input En, 
    input RST,
    input LED,
    output [511:0] RANDOM_NUMBER,
    output VALID

);

parameter WIDTH = 512;
parameter COUNTER_BITS = 9;
parameter HOLD_STATE = 0;
parameter CALC_STATE = 1;

wire LOCAL_SCLK = SCLK | En;
reg [511:0] RESULT;
reg regVALID;

reg [WIDTH-1:0] mem;
reg [COUNTER_BITS-1:0] COUNTER;
reg STATE;

always @(posedge LOCAL_SCLK) begin
    
    if (RST) begin
        COUNTER <= 9'd0;
        STATE <= HOLD_STATE;
    end

    else begin

        if (COUNTER > 9'd511) begin

            COUNTER <= 9'd0;
            STATE <= CALC_STATE;
            
        end

        else begin

            STATE <= HOLD_STATE;
            COUNTER <= COUNTER+1;

        end
    end

end

always @(posedge LOCAL_SCLK) begin
    case(STATE)

        HOLD_STATE : begin

            regVALID <= 1'b0;
            mem <= {mem[WIDTH-2:0], LED};

        end

        CALC_STATE : begin

            regVALID <= 1'b1;
            RESULT <= mem;

        end

    endcase
end

assign VALID = regVALID;
assign RANDOM_NUMBER = RESULT;
assign RANDOM_NUMBER = (VALID) ? RESULT : 512'd0;

endmodule
