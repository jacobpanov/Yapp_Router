/*-----------------------------------------------------------------
File name     : clock_and_reset_env.sv
Developers    : Jacob Panov
Description   : Clock and Reset UVC environment for accelerated UVM
-----------------------------------------------------------------*/

class clock_and_reset_env extends uvm_env;

  `uvm_component_utils(clock_and_reset_env)

  clock_and_reset_agent                           agent;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = clock_and_reset_agent::type_id::create("agent", this);
  endfunction 
  
endclass
