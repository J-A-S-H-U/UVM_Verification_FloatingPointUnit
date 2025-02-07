import uvm_pkg::*;
`include "uvm_macros.svh"

class fpu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fpu_scoreboard)
  
  uvm_analysis_imp #(fpu_sequence_item, fpu_scoreboard) scb_port;

  
  fpu_sequence_item item[$];
  fpu_sequence_item s_item;
  int test_cnt=0;
  int test_valid=0;
  int test_invalid=0;

  
  function new(string name = "fpu_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SCOREBOARD", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCOREBOARD", "Build Phase!", UVM_HIGH)
    scb_port=new("scb_port",this);

  endfunction: build_phase
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCOREBOARD", "Connect Phase!", UVM_HIGH)
   
  endfunction: connect_phase
  
  function void write (fpu_sequence_item rx_item);
    item.push_front(rx_item);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever  begin
      s_item=fpu_sequence_item::type_id::create("s_item");
      wait((item.size() != 0));
      s_item=item.pop_front();
      compare(s_item);
      test_cnt++;
    end
  endtask
  
  function void compare(fpu_sequence_item item);
    logic [31:0] ex_res;
    ex_res=floatOperations(item.din1,item.din2,item.cmd);
    if (ex_res==item.result) begin
      `uvm_info(get_name,$sformatf("[%0d/%0d] Test Passed",test_cnt,`TESTS),UVM_HIGH)
      test_valid++;
    end
    
    else begin
      `uvm_error(get_name,$sformatf("[%0d/%0d] Test faild",test_cnt,`TESTS))
      $display("--------------------------------------------------------------------------------");
      $display("din1 = %0h  din2 = %0h  cmd = %0h#######actual = %0h#######expected = %0h",item.din1,item.din2,item.cmd,item.result,ex_res);
      test_invalid++;
    end
  endfunction
  

function logic[31:0] floatOperations(input logic [31:0]op1, logic [31:0]op2, [1:0]cmd);
    shortreal floatOp1 = $bitstoshortreal(op1);
    shortreal floatOp2 = $bitstoshortreal(op2);
    shortreal floatResult;
	
	logic [31:0] floatout;

    case (cmd) 
        1: floatResult = floatOp1 + floatOp2;

			
        2: floatResult = floatOp1 * floatOp2;
            
			
        3: floatResult = floatOp1 / floatOp2;
    
			
        default:begin
            $display("Invalid command!");
			return 0;
			end
        endcase
	
	floatout = $shortrealtobits(floatResult); 
    return (floatout);
endfunction

function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_name(),$sformatf("Total tests: %0d",test_cnt),UVM_LOW)
    `uvm_info(get_name(),$sformatf("Passed: %0d",test_valid),UVM_LOW)
    `uvm_info(get_name(),$sformatf("Failed: %0d",test_invalid),UVM_LOW)
  endfunction
endclass