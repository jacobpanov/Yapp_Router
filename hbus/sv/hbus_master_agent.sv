/*-----------------------------------------------------------------
File name     : hbus_master_agent.sv
Developers    : Jacob Panov
Description   : HBUS UVC master agent for accelerated UVM
-------------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: hbus_master_agent
//
//------------------------------------------------------------------------------

class hbus_master_agent extends uvm_agent;

  // This field determines whether an agent is active or passive.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  // Master's id
  protected int master_id;

  hbus_monitor          monitor;
  hbus_master_driver    driver;
  hbus_master_sequencer sequencer;
  
  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(hbus_master_agent)
    `uvm_field_object(monitor, UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(master_id, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //monitor = hbus_monitor::type_id::create("monitor", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = hbus_master_sequencer::type_id::create("sequencer", this);
      driver = hbus_master_driver::type_id::create("driver", this);
    end
  endfunction : build_phase
   
  // connect_phase
  virtual function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds the driver to the sequencer using consumer-producer interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign the id of the agent's children
  function void set_master_id(int i);
    if (is_active == UVM_ACTIVE) begin
      sequencer.master_id = i;
      driver.master_id = i;
    end
  endfunction

endclass : hbus_master_agent
