// Jacob Panov
// YAPP Input Port Agent
// yapp_tx_agent.sv

class yapp_tx_agent extends uvm_agent;

    yapp_tx_monitor monitor;
    yapp_tx_sequencer sequencer;
    yapp_tx_driver driver;
    
    
    `uvm_component_utils_begin(yapp_tx_agent)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = yapp_tx_monitor::type_id::create("monitor", this);;
        if (is_active == UVM_ACTIVE) begin
            sequencer = yapp_tx_sequencer::type_id::create("sequencer", this);
            driver = yapp_tx_driver::type_id::create("driver", this);
        end
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        if(is_active == UVM_ACTIVE) driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction : connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"\nstart of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction : start_of_simulation_phase

    function void assign_vi(virtual interface yapp_if vif);
    monitor.vif = vif;
    if (is_active == UVM_ACTIVE) 
      driver.vif = vif;
  endfunction : assign_vi

endclass : yapp_tx_agent