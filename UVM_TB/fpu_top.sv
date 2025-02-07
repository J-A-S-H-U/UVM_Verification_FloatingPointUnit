`timescale 1ns/1ns

`include "fpu_def.sv"

import uvm_pkg::*;
`include "uvm_macros.svh"


module top;

    bit clk=0;

    fpu_if top_if(clk);

  fpu_top_RTL dut (
    	.clk(top_if.clk),
      .reset(top_if.reset),
      .din1(top_if.din1),
      .cmd(top_if.cmd),
      .din2(top_if.din2),
      .valid(top_if.valid),
      .result(top_if.result),
      .ready(top_if.ready));

//clock generation
    initial forever #1 clk=~clk;

 	initial begin
      uvm_config_db #(virtual fpu_if) :: set(null,"*","fpu_vif",top_if);
    end

    initial begin
      run_test("fpu_test");
    end
  
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;
  end

endmodule