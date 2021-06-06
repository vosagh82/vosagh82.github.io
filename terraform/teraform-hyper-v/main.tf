terraform {
  required_providers {
    hyperv = {
      source = "taliesins/hyperv"
      version = "1.0.3"
    }
  }
}


# Configure HyperV
provider "hyperv" {
  #user            = "administrator"
  password        = "12345678"
  host            = "127.0.0.1"
  port            = 5985
  https           = false
  #insecure        = false
  #use_ntlm        = true
  #tls_server_name = ""
  #cacert_path     = ""
  #cert_path       = ""
  #key_path        = ""
  #script_path     = "C:/Temp/terraform_%RAND%.cmd"
  #timeout         = "30s"
}

# Create a switch
#resource "hyperv_network_switch" "default" {
#  name = "DMZ"
#  notes = ""
# allow_management_os = true
#  enable_embedded_teaming = false
#  enable_iov = false
#  enable_packet_direct = false
#  minimum_bandwidth_mode = "None"
#  switch_type = "Internal"
#  net_adapter_names = []
#  default_flow_minimum_bandwidth_absolute = 0
#  default_flow_minimum_bandwidth_weight = 0
#  default_queue_vmmq_enabled = false
#  default_queue_vmmq_queue_pairs = 16
#  default_queue_vrss_enabled = false
#}
# Create a vhd
resource "hyperv_vhd" "web_server_vhd" {
  path = "D:\\Hyper-V\\terraform\\web_server\\Virtual Hard Disks\\MobyLinuxVM.vhdx"
  #source = ""
  #source_vm = ""
  #source_disk = 0
  vhd_type = "Dynamic"
  #parent_path = ""
  size = 11474836480
  #block_size = 0
  #logical_sector_size = 0
  #physical_sector_size = 0
}

# Create a machine
resource "hyperv_machine_instance" "default" {
  name = "WebServer"
  generation = 2
  automatic_critical_error_action = "Pause"
  automatic_critical_error_action_timeout = 30
  automatic_start_action = "StartIfRunning"
  automatic_start_delay = 0
  automatic_stop_action = "Save"
  #checkpoint_type = "Production"
  #dynamic_memory = false
  guest_controlled_cache_types = false
  high_memory_mapped_io_space = 536870912
  lock_on_disconnect = "Off"
  low_memory_mapped_io_space = 134217728
  memory_maximum_bytes = 1099511627776
  memory_minimum_bytes = 536870912
  memory_startup_bytes = 536870912
  notes = ""
  processor_count = 1
  smart_paging_file_path = "D:\\Hyper-V\\terraform\\web_server"
  snapshot_file_location = "D:\\Hyper-V\\terraform\\web_server"
  static_memory = true
  #state = "Running"
  state = "Off"

  # Configure integration services
  #integration_services {
  #}

  # Create a network adaptor
  #network_adaptors {
  #}

  # Create dvd drive
  #dvd_drives {
  #}
  dvd_drives {
    #controller_type = "Scsi"
    controller_number = "0"
    controller_location = "1"
    path = "D:\\soft\\iso\\linux\\debian-10.0.0-amd64-netinst.iso"
   # resource_pool_name = ""
   }

  # Create a hard disk drive
  #hard_disk_drives {
  #}
   hard_disk_drives {
    controller_type = "Scsi"
    controller_number = "0"
    controller_location = "0"
    path = "D:\\Hyper-V\\terraform\\web_server\\Virtual Hard Disks\\MobyLinuxVM.vhdx"
    #disk_number = 4294967295
    #resource_pool_name = "Primordial"
    #support_persistent_reservations = false
    #maximum_iops = 0
    #minimum_iops = 0
    #qos_policy_id = "00000000-0000-0000-0000-000000000000"
    #override_cache_attributes = "Default"
  }
  # disable secure boot
  vm_firmware {
    enable_secure_boot = "Off"
      }
  network_adaptors {
     name = "Network Adapter"
     switch_name = "Internet"
        }
}
