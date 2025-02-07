import uvm_pkg::*;
`include "uvm_macros.svh"
class fpu_base_sequence extends uvm_sequence;
  `uvm_object_utils(fpu_base_sequence)
  fpu_sequence_item fpu_item;

  function new(string name="fpu_sequence");
      super.new(name);
  endfunction

endclass: fpu_base_sequence


class fpu_rst_seq extends fpu_base_sequence;

  `uvm_object_utils(fpu_rst_seq)
  fpu_sequence_item item;

  function new(string name="fpu_rst_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info("fpu_sequence","Running reset sequence...",UVM_HIGH);

    item=fpu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with { reset == 1;};
    finish_item(item);

  endtask
endclass


class fpu_main_seq extends fpu_base_sequence;

  `uvm_object_utils(fpu_main_seq)
  fpu_sequence_item item;

  function new(string name="fpu_main_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info("fpu_sequence","Running main sequence...",UVM_HIGH);

    item=fpu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with { reset == 0;
                            valid == 1;};
    finish_item(item);
  endtask

endclass
