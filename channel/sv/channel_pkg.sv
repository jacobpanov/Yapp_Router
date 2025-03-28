/*-----------------------------------------------------------------
File name     : channel_pkg.sv
Developers    : Jacob Panov
Description   : Channel UVC package for accelerated UVM
-------------------------------------------------------------------*/

package channel_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"


typedef uvm_config_db#(virtual channel_if) channel_vif_config;

//import yapp_pkt_pkg::*;
`include "channel_packet.sv"
`include "channel_resp.sv"

`include "channel_rx_monitor.sv"
`include "channel_rx_sequencer.sv"
`include "channel_rx_driver.sv"
`include "channel_rx_agent.sv"
`include "channel_rx_seqs.sv"

`include "channel_env.sv"

endpackage : channel_pkg
