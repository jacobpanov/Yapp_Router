/*-----------------------------------------------------------------
File name     : clock_and_reset_config.sv
Developers    : Jacob Panov
Description   : Clock and Reset UVC configuration for accelerated UVM
-----------------------------------------------------------------*/

class clock_and_reset_config extends uvm_object;

  string agent_names[$];

  `uvm_object_utils_begin(clock_and_reset_config)
    `uvm_field_queue_string(agent_names, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "clock_and_reset_config");
    super.new(name);
  endfunction

endclass 
