interface fpu_if(input logic clk);
    logic reset;
    logic [1:0] cmd;
    logic [31:0] din1;
    logic [31:0] din2;
    logic valid;
    logic [31:0] result;
    logic ready;
    
    modport dut (
    input reset,
          cmd,
          din1,
          din2,
          valid,
    output result,
           ready
    );
    
endinterface: fpu_if