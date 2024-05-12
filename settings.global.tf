## Global Ressource Settings
## =======================================================
## Pre-configured example settings for general resources, these settings are active while no specific settings are defined in the resource configuration

locals {
  global_settings = {

    ## Reguired: Default conventions for resources
    ## This pre-configured naming results in the following naming convention: "<resource_abbreviation>-<landing_zone>-<environment>-<workload_name>"
    default_naming = {

      ## Required: Name segments of naming convention
      ## These key are required in each name_segments map of each resource configuration name_config unless a more specific naming convention is defined in ressource settings
      required_name_segments = {

        ## Optional: name segment for region
        // region = {
        //   regex_requirements = "^[^-]+$" # Required
        //   nullable           = false     # Required
        // }

        ## Optional: name segment for organization
        // organization = {
        //   regex_requirements = "^[^-]+$" # Required
        //   nullable           = false     # Required
        // }

        ## Optional: name segment for landing zone
        landing_zone = {
          regex_requirements = "^[^-]+$" # Required
          nullable           = false     # Required
        }

        ## Optional: name segment for environment
        environment = {
          regex_requirements = "dev|tst|prod|qa" # Required
          nullable           = false             # Required
        }

        ## Optional: name segment for workload name
        workload_name = {
          regex_requirements = "^[^\\s]+$" # Required
          nullable           = true        # Required
        }

        ## Other name segments
        # (...)
      }

      ## Required: Order of name segments
      name_segment_order = [
        "resource_abbreviation", # Optional: Generally available
        //"region",        # Optional
        //"organization",  # Optional
        "landing_zone", # Optional
        "environment",  # Optional
        "workload_name" # Optional

        ## Other name segments
        # (...)
      ]

      ## Required: Delimiter between name segments
      delimiter = "-"
    }

    ## Required: Naming Convention for child resources
    ## This naming convention config is active when a resource is deployed as sub resource, e.g. if a nsg is deployed for a perticular subnet
    ## This pre-configured naming results in the following naming convention: "<resource_abbreviation>-<parent_name>"
    child_naming = {

      ## Required: Name segments of naming convention
      required_name_segments = {

        ## Optional: name segment for region
        // region = {
        //   regex_requirements = "^[^-]+$" # Required
        //   nullable           = false     # Required
        // }

        ## Optional: name segment for organization
        // organization = {
        //   regex_requirements = "^[^-]+$" # Required
        //   nullable           = false     # Required
        // }

        ## Optional: name segment for landing zone
        //landing_zone = {
        //  regex_requirements = "^[^-]+$" # Required
        //  nullable           = false     # Required
        //}

        ## Optional: name segment for environment
        # environment = {
        #   regex_requirements = "dev|test|prod|qa" # Required
        #   nullable           = false              # Required
        # }

        ## Optional: name segment for workload name
        workload_name = {
          regex_requirements = "^[^\\s]+$"
          nullable           = true
        }

        # Other name segments
        # (...)
      }

      name_segment_order = [
        "resource_abbreviation", # Optional: Generally available
        // "region",        # Optional
        // "organization",  # Optional
        // "landing_zone",  # Optional
        // "environment",   # Optional
        "parent_name", # Optional: Generally available
        #"workload_name" # Optional

        ## Other name segments
        # (...)
      ]

      ## Required: Delimiter between name segments
      delimiter = "-"
    }

    ## Required: Tagging Convention for resources 
    tagging = {

      ## Required: Default tags for resources
      default_tags = {
        "provisioned_by" = "terraform" # optional

        ## Other default tags
        # (...)
      }

      ## Required: Required tags for resources
      required_tags = [
        "hidden-title",             # optional
        "provisioned_by",           # optional
        "terraform_repository_uri", # optional
        // "terraform_version",        # optional

        ## Other required tags
        # (...)
      ]
    }

    ## Required: Configuration Convention for resources
    config = {

      ## Required: Default configuration for resources
      default_config = {
        location = "westeurope" # optional

        ## Other default configurations
        # (...)
      }

      ## Required: Required configuration for resources
      required_config = {
        #location = "westeurope" # optional

        ## Other required configurations
        # (...)
      }
    }
  }
}
