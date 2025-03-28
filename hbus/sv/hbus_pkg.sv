/*-----------------------------------------------------------------
File name     : hbus_pkg.sv
Developers    : Jacob Panov
Description   : HBUS UVC package for accelerated UVM
-----------------------------------------------------------------*/

package hbus_pkg;

 import uvm_pkg::*;
 `include "uvm_macros.svh"

  typedef uvm_config_db#(virtual hbus_if) hbus_vif_config;

  `include "hbus_transaction.sv"
  
  `include "hbus_monitor.sv"
  
  `include "hbus_master_sequencer.sv"
  `include "hbus_master_driver.sv"
  `include "hbus_master_agent.sv"
  `include "hbus_master_seqs.sv"
  
  `include "hbus_slave_sequencer.sv"
  `include "hbus_slave_driver.sv"
  `include "hbus_slave_agent.sv"
  `include "hbus_slave_seqs.sv"
  
  `include "hbus_env.sv"
  
  `include "hbus_reg_adapter.sv"

endpackage : hbus_pkg
