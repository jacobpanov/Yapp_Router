// Jacob Panov  
// UVM Reference Implementation for Router
// router_reference.sv

class router_reference extends uvm_component;
  
  `uvm_analysis_imp_decl(_yapp)
  `uvm_analysis_imp_decl(_hbus)

  uvm_analysis_imp_yapp #(yapp_packet, router_reference) yapp_in; 
  uvm_analysis_imp_hbus #(hbus_packet, router_reference) hbus_in;

  uvm_analysis_port #(yapp_packet) sb_add_out;

  // Monitor Statistics
   int packets_dropped   = 0;
   int packets_forwarded = 0;
   int jumbo_packets     = 0;
   int bad_addr_packets  = 0;
 
   `uvm_component_utils(router_reference)
  
   function new (string name = "", uvm_component parent = null);
     super.new(name, parent);
     hbus_in  = new("hbus_in",  this);
     yapp_in  = new("yapp_in",  this);
     sb_add_out    = new("sb_add_out", this);
   endfunction: new

  // HBUS transaction TLM write implementation
  function void write_hbus(hbus_transaction hbus_cmd);
    `uvm_info(get_type_name(),
      $sformatf("Received HBUS Transaction: \n%s", hbus_cmd.sprint()), UVM_MEDIUM)
    // For now - capture the max_pktsize_reg and router_enable_reg
    // values whenever a hbus transaction is written
    if (hbus_cmd.hwr_rd == HBUS_WRITE)
      case (hbus_cmd.haddr)
        'h1000 : max_pktsize_reg = hbus_cmd.hdata;
        'h1001 : router_enable_reg = hbus_cmd.hdata;
      endcase
  endfunction

  // YAPP transaction TLM write implementation
  function void write_yapp(yapp_packet packet);
    `uvm_info(get_type_name(),
      $sformatf("Received Input YAPP Packet: \n%s", packet.sprint()), UVM_LOW)
      
    // Check if router is enabled and  packet has "valid size" before 
    // sending to scoreboard
    if (packet.addr == 3) begin
      bad_addr_packets++;
      packets_dropped++;
      `uvm_info(get_type_name(), "YAPP Packet Dropped [BAD ADDRESS]", UVM_LOW)
    end
    else if ((router_enable_reg != 0) && (packet.length <= max_pktsize_reg)) begin
      // Send packet to Scoreboard via TLM port
      sb_add_out.write(packet);
      packets_forwarded++;
      `uvm_info(get_type_name(), "Sent YAPP Packet to Scoreboard", UVM_LOW)
    end
    else if ((router_enable_reg != 0) && (packet.length > max_pktsize_reg)) begin
      jumbo_packets++;
      packets_dropped++;
      `uvm_info(get_type_name(), $sformatf("YAPP Packet Dropped [OVERSIZED] - pkt size %h max size %h",packet.length, max_pktsize_reg), UVM_LOW)
    end
    else if (router_enable_reg == 0) begin
      packets_dropped++;
      `uvm_info(get_type_name(), "YAPP Packet Dropped [DISABLED]", UVM_LOW)
    end
         
  endfunction

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report:\n   Router Reference: Packet Statistics \n     Packets Dropped:   %0d\n     Packets Forwarded: %0d\n     Oversized Packets: %0d\n", packets_dropped, packets_forwarded, jumbo_packets ), UVM_LOW)
  endfunction : report_phase

endclass : router_reference