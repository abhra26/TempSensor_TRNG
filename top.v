`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer: David J. Marion
// 
// Create Date: 07/19/2022 9:00:00 PM
// Design Name: Nexys A7 Temp Sensor1
// Module Name: top
// Project Name: Thermometer
// Target Devices: Nexys A7-50T
// Tool Versions: Vivado 2021.2
// Description: I2C communication with ADT7420 temp sensor aboard Nexys A7
//              - temperature read out on 8 LEDs and 7 Segment Displays
//             
// Comments: Improved design featuring Celsius and Fahrenheit temperture displays.
//////////////////////////////////////////////////////////////////////////////////

/*
In the C file we need to pass the random number through SHA256
*/

`timescale 1ns/1ps

module top(
    input         CLK100MHZ, 
    input         En, RST,     
    inout         TMP_SDA,          
    output        TMP_SCL,          
    output [31:0] READ_RESULT,
    output READ_VALID        
    );
    
    wire w_200KHz;           // 200kHz SCL
    wire [11:0] c_data;     // 12 bits of Celsius temperature data
    reg VALID;                  // Internal syncing valid bit
    reg [511:0] RANDOM_NUMBER;  // Internal Random Bit stream      
                                

    // Instantiate i2c master
    i2c_master i2cmaster(
        .clk_200KHz(w_200KHz),
        .temp_data(c_data),
        .SDA(TMP_SDA),
        .SCL(TMP_SCL)
    );
    
    // Instantiate 200kHz clock generator
    clkgen_200KHz clkgen(
        .clk_100MHz(CLK100MHZ),
        .clk_200KHz(w_200KHz)
    );
    
    //Instantiating TRNG
    TRNG (
        .SCLK(CLK100MHZ),
        .En(En),
        .RST(RST),
        .LED(c_data[0]),
        .RANDOM_NUMBER(RANDOM_NUMBER),
        .VALID(VALID)   
    );
    
    // Instantiating TopWrapper
    Wrapper (
        .SCLK(CLK100MHZ),
        .En(En),
        .RST(RST),
        .VALID(VALID),
        .RANDOM_NUMBER(RANDOM_NUMBER),
        .READ_RESULT(READ_RESULT),
        .SYS_VALID(SYS_VALID)
    );

endmodule
