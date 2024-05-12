## Virtual Network Subnet Settings
## ==============================
## Pre-configured example settings for virtual network subnet resources

locals {
  virtual_network_subnet_settings = {
    abbreviation = "snet"

    ## Example special naming convention for subnets
    ## This pre-configured naming results in the following naming convention: "<resource_abbreviation>-<workload_name>"
    default_naming = {

      ## These key are required in each name_segments map of each virtual network subnet resource configuration name_config 
      required_name_segments = {

        ## workload_name must be provided in the name_segments map of the subnet configuration
        workload_name = {
          regex_requirements = "^[^\\s]+$"
          nullable           = true
        }
      }

      name_segment_order = [
        "resource_abbreviation",
        "workload_name"
      ]
    }
  }
}
