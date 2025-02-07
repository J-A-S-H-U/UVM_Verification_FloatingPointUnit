import uvm_pkg::*;
`include "uvm_macros.svh"

class fpu_sequence_item extends uvm_sequence_item;
	`uvm_object_utils (fpu_sequence_item)
	
  rand logic reset;
  rand logic [1:0] cmd;
  rand logic [31:0] din1;
  rand logic [31:0] din2;
  rand logic valid;
  logic [31:0] result;
  logic ready; 

  
  
  function new(string name="fpu_sequence_item");
    super.new(name);
  endfunction

  constraint cmd_range{
    cmd inside {[1:3]};
  }

  constraint din1_range{
      din1>=32'd0;
   
  }

  constraint din2_range{
    din2[30:23]!=8'd255;
    din2[30:23]!=8'd0;
  }

endclass