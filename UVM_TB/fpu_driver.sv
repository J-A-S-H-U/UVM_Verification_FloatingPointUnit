import uvm_pkg::*;
`include "uvm_macros.svh"

class fpu_driver extends uvm_driver #(fpu_sequence_item);
  `uvm_component_utils(fpu_driver)
  virtual fpu_if vif;
  fpu_sequence_item drv_pkt;

  function new(string name="fpu_driver",uvm_component parent);
      super.new(name,parent);
      `uvm_info("fpu_driver", "Inside constructor of fpu_driver", UVM_HIGH)
      
  endfunction

  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("fpu_driver", "Inside build phase", UVM_HIGH)

    if(!(uvm_config_db #(virtual fpu_if)::get(this,"*","fpu_vif",vif)))
          `uvm_error(get_name(), "Faild to get Virtual interface")

  endfunction: build_phase

  task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info("fpu_driver", "Inside run phase", UVM_HIGH)
    
    repeat(2) begin
      drv_pkt=fpu_sequence_item::type_id::create("drv_pkt");
      seq_item_port.get_next_item(drv_pkt);
      init_drive(drv_pkt);
      seq_item_port.item_done();   
    end

    forever begin
      drv_pkt=fpu_sequence_item::type_id::create("drv_pkt");
      seq_item_port.get_next_item(drv_pkt);
      drive(drv_pkt);
      seq_item_port.item_done();
    end
  endtask


task drive(fpu_sequence_item drv_pkt);
  `uvm_info(get_name(),"Drive...",UVM_HIGH)
  @(posedge vif.ready);
  vif.reset<=drv_pkt.reset;
  vif.cmd<=drv_pkt.cmd;
  vif.din1<=drv_pkt.din1;
  vif.din2<=drv_pkt.din2;
  vif.valid<=drv_pkt.valid;
endtask

task init_drive(fpu_sequence_item drv_item);
  `uvm_info(get_name(),"Init Drive...",UVM_HIGH)
  @(negedge vif.clk);
  vif.reset<=drv_item.reset;
  vif.cmd<=drv_item.cmd;
  vif.din1<=drv_item.din1;
  vif.din2<=drv_item.din2;
  vif.valid<=drv_item.valid;
endtask

endclass: fpu_driver